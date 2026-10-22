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

  static const String ownerPrefix = 'medical-mobile/owner/';
  static const String driverPrefix = 'medical-mobile/driver/';
  static const String unifiedAuthPath = 'medical-mobile/auth';

  // Unified auth endpoints
  static const String checkAccountApi = '$unifiedAuthPath/check-account';
  static const String ExistingUserApi = '$unifiedAuthPath/login';
  static const String loginApi = '$unifiedAuthPath/send-otp';
  static const String resendOtpApi = '$unifiedAuthPath/resend-otp';
  static const String verifyOtpApi = '$unifiedAuthPath/verify-otp';
  static const String setPassword = '$unifiedAuthPath/set-password';
  static const String refreshTokenApi = '$unifiedAuthPath/refresh';

  /// Forgot password urls
  static const String forgotPasswordUrl =
      '$unifiedAuthPath/forget-password/otp/send';
  static const String resendForgotPasswordUrl =
      '$unifiedAuthPath/forget-password/otp/resend';
  static const String verifyforgotPasswordotp =
      '$unifiedAuthPath/forget-password/otp/verify';
  static const String setNewPasswordApi =
      '$unifiedAuthPath/forget-password/set-password';

  // Config & Profile apis (relative to session.apiPrefix)
  static const String configApi = 'config';
  static const String getProfile = 'profile';
  static const String updateProfile = 'account';

  // Box apis (relative to session.apiPrefix)
  static const String getAllBoxes = 'boxes';
  static const String claimBox = 'boxes/claim';
  static const String registerQrBox = 'boxes';
  static const String removebox = 'boxes/:box_id';
  static const String updatebox = 'boxes/:box_id/settings';
  static const String connectBox = 'boxes/:box_id/connection';
  static const String disconnectBox = 'boxes/:box_id/connection';
  static const String lockBox = 'boxes/:box_id/lock';
  static const String emergencyUnlockGrublock = 'grublock/emergency_unlock';
  static const String lockGrublock = 'grublock/lock';
  static const String emergencyAlert = 'emergency/alert';

  // Auth & Account apis (relative to session.apiPrefix)
  static const String logoutApi = 'auth/logout';
  static const String deleteAccount = 'account';
  static const String changePasswordApi = 'account';

  // Support & Notification apis (relative to session.apiPrefix)
  static const String categoryApi = 'support/category';
  static const String subCategoryApi = 'support/faq';
  static const String alertList = 'support/faq';
  static const String getAlerts = 'notification';

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
  static const String isDemoMode = 'IS_DEMO_MODE';
  static const String androidAppVersion = "5.0";
  static const String iosAppVersion = "13.0";
}
