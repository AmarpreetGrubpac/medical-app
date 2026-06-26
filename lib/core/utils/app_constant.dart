import 'package:get/get.dart';
import 'package:grubpac_driver/screens/splash/controller/splash_controller.dart';

class AppConstants {
  static const String appName = 'Grubpac driver';
  static const String appUrl = 'Grubpac driver';
  static const String appversion = '1.0.4';

  // config
  // static const String baseUrl = 'https://grubpac-api-dev.sqaby.org/api/v1';
  static const String baseUrl = 'https://43.204.34.10/api/v1';
  // static const String baseUrl =
  //     'https://nktbq7k7-8000.inc1.devtunnels.ms/api/v1';

  static const String configApi = '/delivery-mobile/config';
  static const String checkAccountApi = '/delivery-mobile/auth/check-account';
  static const String ExistingUserApi = '/delivery-mobile/auth/login';
  static const String loginApi = '/delivery-mobile/auth/send-otp';
  static const String resendOtpApi = '/delivery-mobile/auth/send-otp';
  static const String verifyOtpApi = '/delivery-mobile/auth/verify-otp';
  static const String setPassword = '/delivery-mobile/auth/set-password';

  /// forgt password urls
  static const String forgotPasswordUrl =
      '/delivery-mobile/auth/forget-password/otp/send';
  static const String resendForgotPasswordUrl =
      '/delivery-mobile/auth/forget-password/otp/send';
  static const String verifyforgotPasswordotp =
      '/delivery-mobile/auth/forget-password/otp/verify';
  static const String setNewPasswordApi =
      '/delivery-mobile/auth/forget-password/set-password';

  // profile apis
  static const String getProfile = '/delivery-mobile/profile';
  static const String updateProfile = '/delivery-mobile/account';

  //Box apis
  static const String getAllBoxes = '/delivery-mobile/boxes';
  static const String registerBox = '/delivery-mobile/boxes';
  static const String removebox = '/delivery-mobile/boxes/:box_id';
  static const String updatebox = '/delivery-mobile/boxes/:box_id/settings';
  static const String connectBox = '/delivery-mobile/boxes/:box_id/connection';
  static const String disconnectBox =
      '/delivery-mobile/boxes/:box_id/connection';
  static const String reqLockOtp = '/delivery-mobile/boxes/:box_id/lock/otp';
  static const String verifyLockOtp =
      '/delivery-mobile/boxes/:box_id/lock/verify';

  // auth apis

  static const String logoutApi = '/delivery-mobile/auth/logout';
  static const String deleteAccount = '/delivery-mobile/account';
  static const String changePasswordApi = '/delivery-mobile/account';

// categories
  static const String categoryApi = '/delivery/support/category';
  static const String subCategoryApi = '/delivery/support/faq?category_id';

  /// notification
  static const String alertList = '/delivery/support/faq?category_id';

  static String privacyPolicyR =
      // 'https://www.lenskart.com/eyeglasses/gender/all-men-eyeglasses.html';

      Get.find<SplashController>().configData?.data?.config?.privacyPolicyR ??
          'https://www.lenskart.com/eyeglasses/gender/all-women-eyeglasses.html';

  static String termsNConditionsR =
      // 'https://www.lenskart.com/eyeglasses/gender/all-women-eyeglasses.html';

      Get.find<SplashController>()
              .configData
              ?.data
              ?.config
              ?.termsNConditionsR ??
          'https://www.lenskart.com/eyeglasses/gender/all-women-eyeglasses.html';

  /// IMAGE URLS
  static String helpImageUrls =
      'https://grubpac.s3.ap-south-1.amazonaws.com/icons/';
  static String custmImageuRl =
      'https://images.unsplash.com/photo-1771681278369-e2a5480b8c29?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

  // SHARED PREFRENCES
  static const String token = 'TOKEN';
  static const String androidAppVersion = "5.0";
  static const String iosAppVersion = "13.0";
}
