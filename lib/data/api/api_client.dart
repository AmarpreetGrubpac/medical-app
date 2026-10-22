import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/flavor/app_flavor_config.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/data/auth/session_manager.dart';
import 'package:grubpac_driver/data/auth/token_store.dart';
import 'package:grubpac_driver/data/mock/mock_data_provider.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _RefreshResult { success, rejected, transientFailure }

class ApiClient extends GetxService {
  ApiClient({
    required this.appBaseUrl,
    required this.tokenStore,
    required this.sharedPreferences,
    required this.sessionManager,
  }) {
    token = tokenStore.accessToken;
  }

  final String appBaseUrl;
  final TokenStore tokenStore;
  final SharedPreferences sharedPreferences;
  final SessionManager sessionManager;
  final int timeoutInSeconds = 30;

  /// Demo mode: intercept all API calls with mock data.
  bool get isDemoMode {
    final hasTestMode = AppFlavorConfig.isInitialized
        ? AppFlavorConfig.current.hasTestMode
        : true;
    if (!hasTestMode) return false;
    return sharedPreferences.getBool(AppConstants.isDemoMode) ?? false;
  }

  static const String noInternetMessage =
      'Connection to API server failed due to internet connection';

  String? token;
  bool _isHandlingUnauthorized = false;
  Future<_RefreshResult>? _refreshFuture;

  bool get hasToken => token?.isNotEmpty == true;

  void updateHeader(String? value) => token = value;

  Uri _buildUri(String path, Map<String, dynamic>? query) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      final uri = Uri.parse(path);
      return _applyQuery(uri, query);
    }

    String base = appBaseUrl;
    if (!base.endsWith('/')) {
      base = '$base/';
    }

    String cleanPath = path.startsWith('/') ? path.substring(1) : path;

    String finalUrl;
    if (cleanPath.startsWith('medical-mobile/auth/') ||
        cleanPath.startsWith('simulator/') ||
        cleanPath.startsWith('medical-mobile/owner/') ||
        cleanPath.startsWith('medical-mobile/driver/')) {
      finalUrl = '$base$cleanPath';
    } else {
      final prefix = sessionManager.normalizedApiPrefix;
      finalUrl = '$base$prefix$cleanPath';
    }

    final uri = Uri.parse(finalUrl);
    return _applyQuery(uri, query);
  }

  Uri _applyQuery(Uri uri, Map<String, dynamic>? query) {
    if (query == null || query.isEmpty) return uri;
    final parameters = <String, String>{...uri.queryParameters};
    query.forEach((key, value) {
      if (value != null) parameters[key] = value.toString();
    });
    return uri.replace(queryParameters: parameters);
  }

  Map<String, String> _headers({
    required bool authenticated,
    Map<String, String>? headers,
    bool multipart = false,
  }) {
    final result = <String, String>{
      if (!multipart) 'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      ...?headers,
    };
    if (authenticated && hasToken) {
      result['Authorization'] = 'Bearer $token';
    } else {
      result.remove('Authorization');
    }
    if (multipart) result.remove('Content-Type');
    return result;
  }

  void _log(String method, String path, [int? status]) {
    if (!kDebugMode) return;
    debugPrint(
      status == null ? 'API $method $path' : 'API $method $path -> $status',
    );
  }

  Future<Response> getData(
    String uri, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool authenticated = true,
    bool allowRefresh = true,
  }) async {
    if (isDemoMode) {
      debugPrint('====> [DEMO MODE] Intercepted GET: $uri');
      final mockRes = MockDataProvider.getMockResponse(uri, 'GET');
      if (mockRes != null) return mockRes;
    }
    try {
      _log('GET', uri);
      final response = await http
          .get(
            _buildUri(uri, query),
            headers: _headers(authenticated: authenticated, headers: headers),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(
        response,
        uri,
        authenticated: authenticated,
        allowRefresh: allowRefresh,
        retryCallback: () => getData(
          uri,
          query: query,
          headers: headers,
          authenticated: authenticated,
          allowRefresh: false,
        ),
      );
    } catch (_) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
    bool authenticated = true,
    bool allowRefresh = true,
  }) =>
      _sendJson(
        'POST',
        uri,
        body,
        headers: headers,
        authenticated: authenticated,
        allowRefresh: allowRefresh,
      );

  Future<Response> patchData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
    bool authenticated = true,
    bool allowRefresh = true,
  }) =>
      _sendJson(
        'PATCH',
        uri,
        body,
        headers: headers,
        authenticated: authenticated,
        allowRefresh: allowRefresh,
      );

  Future<Response> putData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
    bool authenticated = true,
    bool allowRefresh = true,
  }) =>
      _sendJson(
        'PUT',
        uri,
        body,
        headers: headers,
        authenticated: authenticated,
        allowRefresh: allowRefresh,
      );

  Future<Response> deleteData(
    String uri, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    bool authenticated = true,
    bool allowRefresh = true,
  }) =>
      _sendJson(
        'DELETE',
        uri,
        body,
        headers: headers,
        authenticated: authenticated,
        allowRefresh: allowRefresh,
      );

  Future<Response> _sendJson(
    String method,
    String uri,
    dynamic body, {
    Map<String, String>? headers,
    required bool authenticated,
    required bool allowRefresh,
  }) async {
    if (isDemoMode) {
      debugPrint('====> [DEMO MODE] Intercepted $method: $uri');
      final mockRes = MockDataProvider.getMockResponse(uri, method, body: body);
      if (mockRes != null) return mockRes;
    }
    try {
      _log(method, uri);
      final request = http.Request(method, _buildUri(uri, null))
        ..headers.addAll(
          _headers(authenticated: authenticated, headers: headers),
        );
      if (body != null) request.body = jsonEncode(body);
      final streamed =
          await request.send().timeout(Duration(seconds: timeoutInSeconds));
      final response = await http.Response.fromStream(streamed);
      return handleResponse(
        response,
        uri,
        authenticated: authenticated,
        allowRefresh: allowRefresh,
        retryCallback: () => _sendJson(
          method,
          uri,
          body,
          headers: headers,
          authenticated: authenticated,
          allowRefresh: false,
        ),
      );
    } catch (_) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(
    String uri,
    Map<String, String> body,
    List<MultipartBody> multipartBody, {
    Map<String, String>? headers,
    bool authenticated = true,
    bool allowRefresh = true,
  }) =>
      _sendMultipart(
        'POST',
        uri,
        body,
        multipartBody,
        headers: headers,
        authenticated: authenticated,
        allowRefresh: allowRefresh,
      );

  Future<Response> patchMultipartData(
    String uri,
    Map<String, String> body,
    List<MultipartBody> multipartBody, {
    Map<String, String>? headers,
    bool authenticated = true,
    bool allowRefresh = true,
  }) =>
      _sendMultipart(
        'PATCH',
        uri,
        body,
        multipartBody,
        headers: headers,
        authenticated: authenticated,
        allowRefresh: allowRefresh,
      );

  Future<Response> _sendMultipart(
    String method,
    String uri,
    Map<String, String> body,
    List<MultipartBody> multipartBody, {
    Map<String, String>? headers,
    required bool authenticated,
    required bool allowRefresh,
  }) async {
    if (isDemoMode) {
      debugPrint('====> [DEMO MODE] Intercepted MULTIPART $method: $uri');
      final mockRes = MockDataProvider.getMockResponse(uri, method, body: body);
      if (mockRes != null) return mockRes;
    }
    try {
      _log(method, uri);
      final request = http.MultipartRequest(method, _buildUri(uri, null));
      request.headers.addAll(
        _headers(
          authenticated: authenticated,
          headers: headers,
          multipart: true,
        ),
      );
      request.fields.addAll(body);

      for (final multipart in multipartBody) {
        final file = multipart.file;
        final key = multipart.key;
        if (file == null || key == null) continue;

        if (kIsWeb) {
          final Uint8List bytes = await file.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            key,
            bytes,
            filename: basename(file.path),
            contentType: _mediaType(multipart.mimeType),
          ));
        } else {
          request.files.add(await http.MultipartFile.fromPath(
            key,
            File(file.path).path,
            contentType: _mediaType(multipart.mimeType),
          ));
        }
      }

      final streamed =
          await request.send().timeout(Duration(seconds: timeoutInSeconds));
      final response = await http.Response.fromStream(streamed);
      return handleResponse(
        response,
        uri,
        authenticated: authenticated,
        allowRefresh: allowRefresh,
        retryCallback: () => _sendMultipart(
          method,
          uri,
          body,
          multipartBody,
          headers: headers,
          authenticated: authenticated,
          allowRefresh: false,
        ),
      );
    } catch (_) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  MediaType? _mediaType(String mimeType) {
    final parts = mimeType.split('/');
    return parts.length == 2 ? MediaType(parts.first, parts.last) : null;
  }

  Future<_RefreshResult> _attemptTokenRefresh() async {
    if (_refreshFuture != null) return _refreshFuture!;
    _refreshFuture = _performTokenRefresh();
    try {
      return await _refreshFuture!;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<_RefreshResult> _performTokenRefresh() async {
    final refreshToken = tokenStore.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      return _RefreshResult.rejected;
    }

    try {
      final response = await http
          .post(
            _buildUri(AppConstants.refreshTokenApi, null),
            body: jsonEncode({'refresh_token': refreshToken}),
            headers: _headers(authenticated: false),
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      if (response.statusCode == 401 || response.statusCode == 403) {
        return _RefreshResult.rejected;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return _RefreshResult.transientFailure;
      }

      final decoded = jsonDecode(response.body);
      final data = decoded is Map<String, dynamic> ? decoded['data'] : null;
      final newAccess =
          data is Map<String, dynamic> ? data['auth_token'] as String? : null;
      final newRefresh = data is Map<String, dynamic>
          ? data['refresh_token'] as String?
          : null;
      if (newAccess == null || newAccess.isEmpty) {
        return _RefreshResult.transientFailure;
      }

      await tokenStore.writeAccessToken(newAccess);
      if (newRefresh?.isNotEmpty == true) {
        await tokenStore.writeRefreshToken(newRefresh!);
      }
      updateHeader(newAccess);
      return _RefreshResult.success;
    } on FormatException {
      return _RefreshResult.transientFailure;
    } catch (_) {
      return _RefreshResult.transientFailure;
    }
  }

  Future<Response> handleResponse(
    http.Response response,
    String uri, {
    required bool authenticated,
    required bool allowRefresh,
    Future<Response> Function()? retryCallback,
  }) async {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = response.body;
    }

    final normalized = Response(
      body: body,
      bodyString: response.body,
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: _statusText(body, response.reasonPhrase),
    );
    _log('RESPONSE', uri, response.statusCode);

    if (response.statusCode == 401 && authenticated) {
      if (!allowRefresh) {
        await _forceLogout();
        return normalized;
      }

      final refreshResult = await _attemptTokenRefresh();
      if (refreshResult == _RefreshResult.success && retryCallback != null) {
        return retryCallback();
      }
      if (refreshResult == _RefreshResult.rejected) {
        await _forceLogout();
      }
    }

    return normalized;
  }

  String? _statusText(dynamic body, String? fallback) {
    if (body is Map) {
      for (final key in const [
        'error_toast_description',
        'error',
        'message',
      ]) {
        final value = body[key];
        if (value is String && value.trim().isNotEmpty) return value;
      }
      final errors = body['errors'];
      if (errors is List && errors.isNotEmpty && errors.first is Map) {
        final message = errors.first['message'];
        if (message is String && message.isNotEmpty) return message;
      }
    }
    return fallback;
  }

  Future<void> _forceLogout() async {
    if (_isHandlingUnauthorized) return;
    _isHandlingUnauthorized = true;
    try {
      token = null;
      await tokenStore.clear();
      await sessionManager.clearSession();
      AppToast.showError(message: AppString.sessionExpired);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      Navigation.replaceAll(RouteHelper.login);
    } finally {
      _isHandlingUnauthorized = false;
    }
  }
}

class MultipartBody {
  MultipartBody(this.key, this.file, this.mimeType);

  final String? key;
  final XFile? file;
  final String mimeType;
}
