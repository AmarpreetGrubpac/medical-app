import 'package:get/get.dart';
import 'package:grubpac_driver/data/api/api_client.dart';
import 'package:grubpac_driver/data/mock/mock_data_provider.dart';

class RecordedRequest {
  final String method;
  final String uri;
  final dynamic body;
  final Map<String, dynamic>? query;

  RecordedRequest({
    required this.method,
    required this.uri,
    this.body,
    this.query,
  });
}

/// Fully deterministic Mock API Client for E2E tests.
/// Implements Pattern 4 (Network Mocking and Interception) from E2E testing playbook.
class MockApiClient extends ApiClient {
  MockApiClient({
    required super.tokenStore,
    required super.sharedPreferences,
    required super.sessionManager,
  }) : super(
          appBaseUrl: 'https://test.grubpac.com/api/v1/',
        );

  final List<RecordedRequest> recordedRequests = [];

  final Map<String, Response Function(String uri, Map<String, dynamic>? query)>
      _getOverrides = {};
  final Map<String, Response Function(String uri, dynamic body)>
      _postOverrides = {};
  final Map<String, Response Function(String uri, dynamic body)>
      _patchOverrides = {};
  final Map<String, Response Function(String uri, dynamic body)>
      _deleteOverrides = {};

  void setGetHandler(String pattern,
      Response Function(String uri, Map<String, dynamic>? query) handler) {
    _getOverrides[pattern] = handler;
  }

  void setPostHandler(
      String pattern, Response Function(String uri, dynamic body) handler) {
    _postOverrides[pattern] = handler;
  }

  void setPatchHandler(
      String pattern, Response Function(String uri, dynamic body) handler) {
    _patchOverrides[pattern] = handler;
  }

  void setDeleteHandler(
      String pattern, Response Function(String uri, dynamic body) handler) {
    _deleteOverrides[pattern] = handler;
  }

  void resetOverrides() {
    _getOverrides.clear();
    _postOverrides.clear();
    _patchOverrides.clear();
    _deleteOverrides.clear();
    recordedRequests.clear();
  }

  @override
  Future<Response> getData(
    String uri, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool authenticated = true,
    bool allowRefresh = true,
  }) async {
    recordedRequests.add(
        RecordedRequest(method: 'GET', uri: uri, query: query));

    for (var entry in _getOverrides.entries) {
      if (uri.contains(entry.key)) {
        return entry.value(uri, query);
      }
    }

    if (uri.contains('health')) {
      return const Response(
        statusCode: 200,
        body: {
          'success': true,
          'data': {
            'id': 'box-med-101',
            'display_id': 'MED-BOX-101',
            'name': 'Smart Med Carrier 01',
            'is_connected': true,
            'is_locked': false,
            'battery_level': 90,
            'zone1_temp': 4,
            'zone2_temp': 18,
            'ext_temp': 24,
            'connection_status': 'ONLINE',
            'health_status': 'GOOD',
            'power_status': 'ON'
          }
        },
      );
    }

    // Fallback to MockDataProvider
    final mockRes = MockDataProvider.getMockResponse(uri, 'GET');
    if (mockRes != null) return mockRes;

    return const Response(statusCode: 200, body: {'success': true, 'data': {}});
  }

  @override
  Future<Response> postData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
    bool authenticated = true,
    bool allowRefresh = true,
  }) async {
    recordedRequests.add(
        RecordedRequest(method: 'POST', uri: uri, body: body));

    for (var entry in _postOverrides.entries) {
      if (uri.contains(entry.key)) {
        return entry.value(uri, body);
      }
    }

    final mockRes = MockDataProvider.getMockResponse(uri, 'POST', body: body);
    if (mockRes != null) return mockRes;

    return const Response(statusCode: 200, body: {'success': true, 'data': {}});
  }

  @override
  Future<Response> patchData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
    bool authenticated = true,
    bool allowRefresh = true,
  }) async {
    recordedRequests.add(
        RecordedRequest(method: 'PATCH', uri: uri, body: body));

    for (var entry in _patchOverrides.entries) {
      if (uri.contains(entry.key)) {
        return entry.value(uri, body);
      }
    }

    final mockRes = MockDataProvider.getMockResponse(uri, 'PATCH', body: body);
    if (mockRes != null) return mockRes;

    return const Response(statusCode: 200, body: {'success': true, 'data': {}});
  }

  @override
  Future<Response> deleteData(
    String uri, {
    dynamic body,
    Map<String, String>? headers,
    bool authenticated = true,
    bool allowRefresh = true,
  }) async {
    recordedRequests.add(
        RecordedRequest(method: 'DELETE', uri: uri, body: body));

    for (var entry in _deleteOverrides.entries) {
      if (uri.contains(entry.key)) {
        return entry.value(uri, body);
      }
    }

    final mockRes = MockDataProvider.getMockResponse(uri, 'DELETE', body: body);
    if (mockRes != null) return mockRes;

    return const Response(statusCode: 200, body: {'success': true, 'data': {}});
  }
}
