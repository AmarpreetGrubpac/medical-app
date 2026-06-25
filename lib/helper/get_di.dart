import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/data/api/api_client.dart';
import 'package:grubpac_driver/screens/auth/repo/auth_repo.dart';
import 'package:grubpac_driver/screens/auth/controller/login_controller.dart';
import 'package:grubpac_driver/screens/auth/controller/verify_otp_controller.dart';
import 'package:grubpac_driver/screens/help_section/help/controller/help_controller.dart';
import 'package:grubpac_driver/screens/help_section/help_faq_list/controller/help_repo.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/controller/alert_repo.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/controller/alerts_controller.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_repo.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_repo.dart';
import 'package:grubpac_driver/screens/settings_section/setting/controller/setting_controller.dart';
import 'package:grubpac_driver/screens/splash/controller/splash_controller.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/screens/splash/repo/splash_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/auth/controller/existing_user_controller.dart';
import '../screens/auth/controller/set_password_controller.dart';
import '../screens/help_section/help_faq_list/controller/help_faq_list_controller.dart';
import '../screens/settings_section/profile/change_pass/controller/change_password_controller.dart';
import '../screens/settings_section/profile/profile_details/controller/profile_details_controller.dart';

Future<void> init() async {
  //core
  // final sharedPreferences = await SharedPreferences.getInstance();
  // Get.lazyPut(() => sharedPreferences);
  final sharedPreferences = await SharedPreferences.getInstance();

  // // Mock Token Injection for Testing
  // await sharedPreferences.setString(
  //   AppConstants.token,
  //   "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7InJvbGUiOiJhZG1pbiIsImlkIjoiMDFLUERCN0ZBNTRaTTBZRUZISk5QNU5GTjMifSwiaWF0IjoxNzgyMjExMDMwfQ.n_DPU5DrI-v-lTWl7EX0XcN6jxrzYTR8y47pnBX7y08",
  // );
  // ✅ IMPORTANT: use Get.put, not lazyPut
  Get.put<SharedPreferences>(sharedPreferences, permanent: true);
  Get.lazyPut(
      () => ApiClient(
          appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()),
      fenix: true);

  Get.lazyPut(
      () => BoxManagementRepo(
          apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);

  //repository
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);
  Get.lazyPut(() => SplashRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(
      () => HelpRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);
  Get.lazyPut(
      () => ProfileRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);
  Get.lazyPut(
      () => AlertRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);

  //controller
  Get.lazyPut(
      () => SplashController(
            splashRepo: Get.find(),
          ),
      fenix: true);
  Get.lazyPut(() => LoginController(authRepo: Get.find()), fenix: true);
  Get.lazyPut(
      () => VerifyOtpController(
            authRepo: Get.find(),
          ),
      fenix: true);
  Get.lazyPut(() => SetPasswordController(authRepo: Get.find()), fenix: true);
  Get.lazyPut(() => ExistingUserController(authRepo: Get.find()), fenix: true);
  Get.lazyPut(() => BoxManagementController(boxRepo: Get.find()), fenix: true);
  Get.lazyPut(() => ProfileDetailsController(profileRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => SettingController(), fenix: true);
  Get.lazyPut(() => ChangePasswordController(authRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => HelpFaqListController(helpRepo: Get.find()), fenix: true);
  Get.lazyPut(() => HelpController(helpRepo: Get.find()), fenix: true);
  Get.lazyPut(() => AlertsController(alertRepo: Get.find()), fenix: true);
}
