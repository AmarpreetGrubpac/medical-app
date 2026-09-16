import 'package:flutter/foundation.dart';

class AppConstants {
  static const String appName = 'GrubPac Medical';
  static const String appUrl = 'GrubPac Medical';
  static const String appversion = '1.0.4';

  static const String baseUrl = "https://preprod.43.204.34.10.nip.io/api/v1";
  //     String.fromEnvironment('API_BASE_URL');
  // static String get baseUrl {
  //   if (_configuredBaseUrl.isNotEmpty) return _configuredBaseUrl;
  //   if (kDebugMode) return 'https://43.204.34.10/api/v1';
  //   throw StateError('API_BASE_URL is required for release builds.');
  // }

  static const String medicalOwnerPath = '/medical-mobile/owner';
  static const String configApi = '$medicalOwnerPath/config';
  static const String checkAccountApi = '$medicalOwnerPath/auth/check-account';
  static const String ExistingUserApi = '$medicalOwnerPath/auth/login';
  static const String loginApi = '$medicalOwnerPath/auth/send-otp';
  static const String resendOtpApi = '$medicalOwnerPath/auth/resend-otp';
  static const String verifyOtpApi = '$medicalOwnerPath/auth/verify-otp';
  static const String setPassword = '$medicalOwnerPath/auth/set-password';
  static const String refreshTokenApi = '$medicalOwnerPath/auth/refresh';

  /// forgt password urlsp
  static const String forgotPasswordUrl =
      '$medicalOwnerPath/auth/forget-password/otp/send';
  static const String resendForgotPasswordUrl =
      '$medicalOwnerPath/auth/forget-password/otp/resend';
  static const String verifyforgotPasswordotp =
      '$medicalOwnerPath/auth/forget-password/otp/verify';
  static const String setNewPasswordApi =
      '$medicalOwnerPath/auth/forget-password/set-password';

  // profile apis
  static const String getProfile = '$medicalOwnerPath/profile';
  static const String updateProfile = '$medicalOwnerPath/account';

  //Box apis
  static const String getAllBoxes = '$medicalOwnerPath/boxes';
  static const String claimBox = '$medicalOwnerPath/boxes/claim';
  static const String removebox = '$medicalOwnerPath/boxes/:box_id';
  static const String updatebox = '$medicalOwnerPath/boxes/:box_id/settings';
  static const String connectBox = '$medicalOwnerPath/boxes/:box_id/connection';
  static const String disconnectBox =
      '$medicalOwnerPath/boxes/:box_id/connection';
  static const String lockBox = '$medicalOwnerPath/boxes/:box_id/lock';

  // auth apis

  static const String logoutApi = '$medicalOwnerPath/auth/logout';
  static const String deleteAccount = '$medicalOwnerPath/account';
  static const String changePasswordApi = '$medicalOwnerPath/account';

// categories
  static const String categoryApi = '$medicalOwnerPath/support/category';
  static const String subCategoryApi = '$medicalOwnerPath/support/faq';

  /// notification
  static const String alertList = '$medicalOwnerPath/support/faq';

  /// alerts
  static const String getAlerts = '$medicalOwnerPath/notification';

  static String privacyPolicyR = 'https://www.grubpac.com/privacypolicy';
  // 'https://www.lenskart.com/eyeglasses/gender/all-men-eyeglasses.html';

  // Get.find<SplashController>().configData?.data?.config?.privacyPolicyR ??
  //     'https://www.grubpac.com/privacypolicy';

  static String termsNConditionsR = "https://www.grubpac.com/toc";
  // 'https://www.lenskart.com/eyeglasses/gender/all-women-eyeglasses.html';

  // Get.find<SplashController>()
  //         .configData
  //         ?.data
  //         ?.config
  //         ?.termsNConditionsR ??
  //     'https://www.grubpac.com/toc';

  /// IMAGE URLS
  static String helpImageUrls =
      'https://grubpac.s3.ap-south-1.amazonaws.com/icons/';
  static String custmImageuRl =
      'https://images.unsplash.com/photo-1771681278369-e2a5480b8c29?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

  // SHARED PREFRENCES
  static const String token = 'TOKEN';
  static const String refreshToken = 'RefreshToken';
  static const String androidAppVersion = "5.0";
  static const String iosAppVersion = "13.0";
}
