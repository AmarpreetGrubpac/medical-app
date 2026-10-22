import 'package:get/get.dart';
import 'package:grubpac_driver/core/exceptions/failure.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/data/api/api_client.dart';
import 'package:grubpac_driver/data/auth/session_manager.dart';
import 'package:grubpac_driver/data/auth/token_store.dart';

class AuthRepo {
  final TokenStore tokenStore;
  final ApiClient apiClient;
  final SessionManager sessionManager;

  AuthRepo({
    required this.apiClient,
    required this.tokenStore,
    required this.sessionManager,
  });

  Future<Response> onLogin(String type, String emailOrPhone) async {
    final body = {"type": type, "body": emailOrPhone};

    return await apiClient.postData(
      AppConstants.loginApi,
      body,
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      authenticated: false,
    );
  }

  Future<Response> checkAccountApi(
      String type, String bodyEmailOrNumber) async {
    final body = {
      "type": type,
      "body": bodyEmailOrNumber,
    };

    return await apiClient.postData(
      AppConstants.checkAccountApi,
      body,
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      authenticated: false,
    );
  }

  Future<Response> resendOtp(String type, String phoneOrEmail) async {
    Map<String, String> body = {
      "type": type,
      "body": phoneOrEmail,
    };

    return await apiClient.postData(
      AppConstants.resendOtpApi,
      body,
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      authenticated: false,
    );
  }

  Future<Response> loginExistingUser(
      String type, String body, String password) async {
    return await apiClient.postData(
      AppConstants.ExistingUserApi,
      {"type": type, "body": body, "password": password},
      authenticated: false,
    );
  }

  Future<Response> verifyOtp(
      String type, String phoneOREmail, String otp) async {
    Map<String, String> body = {
      "type": type,
      "body": phoneOREmail,
      "otp": otp,
    };

    return await apiClient.postData(
      AppConstants.verifyOtpApi,
      body,
      headers: {"Content-Type": "application/json"},
      authenticated: false,
    );
  }

  Future<Response> forgotPassword(
    String type,
    String phoneOREmail,
  ) async {
    return await apiClient.postData(
      AppConstants.forgotPasswordUrl,
      {"type": type, "body": phoneOREmail},
      authenticated: false,
    );
  }

  Future<Response> resendForgotPasswordEmail(String email) async {
    final body = {
      "email": email,
    };

    return await apiClient.postData(
      AppConstants.resendForgotPasswordUrl,
      body,
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      authenticated: false,
    );
  }

  Future<Response> verifyforgotPasswordotp(
      String type, String phoneOREmail, String otp) async {
    Map<String, String> body = {
      "type": type,
      "body": phoneOREmail,
      "otp": otp,
    };

    return await apiClient.postData(
      AppConstants.verifyforgotPasswordotp,
      body,
      headers: {"Content-Type": "application/json"},
      authenticated: false,
    );
  }

  Future<Response> setNewPassword(
      String type, String phoneOREmail, String password, String token) async {
    Map<String, String> body = {
      "type": type,
      "body": phoneOREmail,
      "password": password,
      "confirm_password": password,
      "auth_token": token,
    };

    return await apiClient.postData(
      AppConstants.setNewPasswordApi,
      body,
      headers: {"Content-Type": "application/json"},
      authenticated: false,
    );
  }

  Future<Response> setPassword(
      String type, String phoneOREmail, String password, String token) async {
    Map<String, String> body = {
      "type": type,
      "body": phoneOREmail,
      "password": password,
      "confirm_password": password,
      "auth_token": token,
    };

    return await apiClient.postData(
      AppConstants.setPassword,
      body,
      headers: {"Content-Type": "application/json"},
      authenticated: false,
    );
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    await tokenStore.writeAccessToken(token);
    return true;
  }

  Future<bool> saveUserRefreshToken(String refreshToken) async {
    await tokenStore.writeRefreshToken(refreshToken);
    return true;
  }

  String getUserToken() {
    return tokenStore.accessToken ?? "";
  }

  Future<void> onUpdateToken(String token) async {
    await tokenStore.writeAccessToken(token);
    apiClient.updateHeader(token);
  }

  bool isLoginIn() {
    return tokenStore.hasAccessToken;
  }

  Future<void> saveUserSession({
    required String persona,
    required String apiPrefix,
    String? clientId,
    String? userId,
  }) async {
    await sessionManager.saveSession(
      persona: persona,
      apiPrefix: apiPrefix,
      clientId: clientId,
      userId: userId,
    );
  }

  Future<bool> clearSharedPrefrences() async {
    await sessionManager.clearSession();
    await tokenStore.clear();
    apiClient.updateHeader(null);
    return true;
  }

  Future<Response> logoutAccount() async {
    Response response;
    try {
      response = await apiClient.postData(AppConstants.logoutApi, '');
      return response;
    } catch (e) {
      throw Failure();
    }

    // return Response(
    //     statusCode: 200,
    //     body: {"status": true, "message": "Logout successfully", "data": null});
  }

  Future<Response> deleteAccount(String password) async {
    return await apiClient.deleteData(
      AppConstants.deleteAccount,
      body: {"password": password},
    );
  }

  Future<Response> changePassword(
      String oldPassword, String newPassword) async {
    return await apiClient.putData(AppConstants.changePasswordApi,
        {'old_password': oldPassword, 'new_password': newPassword});
  }
}
