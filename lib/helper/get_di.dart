import 'package:grubpac_driver/core/flavor/app_flavor_config.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/data/api/api_client.dart';
import 'package:grubpac_driver/data/auth/session_manager.dart';
import 'package:grubpac_driver/data/auth/token_store.dart';
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
  final tokenStore = TokenStore(legacyPreferences: sharedPreferences);
  await tokenStore.initialize();

  final sessionManager = SessionManager(prefs: sharedPreferences);
  sessionManager.initialize();

  Get.put<SharedPreferences>(sharedPreferences, permanent: true);
  Get.put<TokenStore>(tokenStore, permanent: true);
  Get.put<SessionManager>(sessionManager, permanent: true);

  Get.lazyPut(
      () => ApiClient(
            appBaseUrl: AppFlavorConfig.isInitialized
                ? AppFlavorConfig.current.baseUrl
                : AppConstants.baseUrl,
            tokenStore: Get.find(),
            sharedPreferences: Get.find(),
            sessionManager: Get.find(),
          ),
      fenix: true);

  Get.lazyPut(
      () => BoxManagementRepo(
          apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);

  //repository
  Get.lazyPut(
      () => AuthRepo(
            apiClient: Get.find(),
            tokenStore: Get.find(),
            sessionManager: Get.find(),
          ),
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

  Get.put(BoxManagementController(boxRepo: Get.find()), permanent: true);
  Get.put(ProfileDetailsController(profileRepo: Get.find()), permanent: true);
  Get.lazyPut(() => SettingController(), fenix: true);
  Get.lazyPut(() => ChangePasswordController(authRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => HelpFaqListController(helpRepo: Get.find()), fenix: true);
  Get.lazyPut(() => HelpController(helpRepo: Get.find()), fenix: true);
  Get.lazyPut(() => AlertsController(alertRepo: Get.find()), fenix: true);
}
