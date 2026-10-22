import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/flavor/app_flavor_config.dart';
import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/data/api/api_client.dart';
import 'package:grubpac_driver/data/auth/session_manager.dart';
import 'package:grubpac_driver/data/auth/token_store.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/auth/controller/existing_user_controller.dart';
import 'package:grubpac_driver/screens/auth/controller/login_controller.dart';
import 'package:grubpac_driver/screens/auth/controller/set_password_controller.dart';
import 'package:grubpac_driver/screens/auth/controller/verify_otp_controller.dart';
import 'package:grubpac_driver/screens/auth/repo/auth_repo.dart';
import 'package:grubpac_driver/screens/dashboard/controller/dashboard_controller.dart';
import 'package:grubpac_driver/screens/help_section/help/controller/help_controller.dart';
import 'package:grubpac_driver/screens/help_section/help_faq_list/controller/help_faq_list_controller.dart';
import 'package:grubpac_driver/screens/help_section/help_faq_list/controller/help_repo.dart';
import 'package:grubpac_driver/screens/home_section/home/controller/home_controller.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/controller/alert_repo.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/controller/alerts_controller.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_repo.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_details_controller.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_repo.dart';
import 'package:grubpac_driver/screens/settings_section/setting/controller/setting_controller.dart';
import 'package:grubpac_driver/screens/splash/controller/splash_controller.dart';
import 'package:grubpac_driver/screens/splash/repo/splash_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'mock_api_client.dart';

/// E2E Test Harness configuring clean architecture dependencies,
/// isolated storage, and responsive screen emulation for widget test journeys.
class E2ETestHarness {
  late SharedPreferences prefs;
  late TokenStore tokenStore;
  late SessionManager sessionManager;
  late MockApiClient mockApiClient;
  late AuthRepo authRepo;
  late BoxManagementRepo boxRepo;
  late SplashRepo splashRepo;
  late ProfileRepo profileRepo;
  late AlertRepo alertRepo;
  late HelpRepo helpRepo;

  Future<void> setUp({
    Map<String, Object> initialPrefs = const {},
    bool isLoggedIn = false,
    String? persona,
    String? apiPrefix,
    String? token,
  }) async {
    Get.reset();
    SharedPreferences.setMockInitialValues(initialPrefs);
    FlutterSecureStorage.setMockInitialValues({});
    await AppPreference.initMySharedPreferences();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.steenbakker.mobile_scanner/scanner/method'),
      (call) async {
        if (call.method == 'state') return 1;
        if (call.method == 'start') {
          return {'textureId': 1, 'width': 300.0, 'height': 300.0};
        }
        return null;
      },
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/connectivity'),
      (call) async {
        if (call.method == 'check') {
          return <String>['wifi'];
        }
        return null;
      },
    );

    if (!AppFlavorConfig.isInitialized) {
      AppFlavorConfig.init(AppFlavorConfig.dev);
    }

    prefs = await SharedPreferences.getInstance();
    tokenStore = TokenStore(legacyPreferences: prefs);
    await tokenStore.initialize();

    sessionManager = SessionManager(prefs: prefs);
    sessionManager.initialize();

    if (isLoggedIn) {
      final effectiveToken = token ?? 'mock-valid-jwt-token';
      await tokenStore.writeAccessToken(effectiveToken);
      await tokenStore.writeRefreshToken('mock-valid-refresh-token');
      await sessionManager.saveSession(
        persona: persona ?? 'driver',
        apiPrefix: apiPrefix ?? 'medical-mobile/driver/',
        clientId: 'client-test-id',
        userId: 'user-test-id',
      );
    }

    mockApiClient = MockApiClient(
      tokenStore: tokenStore,
      sharedPreferences: prefs,
      sessionManager: sessionManager,
    );

    // Repositories
    boxRepo = BoxManagementRepo(
      apiClient: mockApiClient,
      sharedPreferences: prefs,
    );
    authRepo = AuthRepo(
      apiClient: mockApiClient,
      tokenStore: tokenStore,
      sessionManager: sessionManager,
    );
    splashRepo = SplashRepo(apiClient: mockApiClient);
    profileRepo = ProfileRepo(
      apiClient: mockApiClient,
      sharedPreferences: prefs,
    );
    alertRepo = AlertRepo(
      apiClient: mockApiClient,
      sharedPreferences: prefs,
    );
    helpRepo = HelpRepo(
      apiClient: mockApiClient,
      sharedPreferences: prefs,
    );

    // Register into Get DI
    Get.put<SharedPreferences>(prefs, permanent: true);
    Get.put<TokenStore>(tokenStore, permanent: true);
    Get.put<SessionManager>(sessionManager, permanent: true);
    Get.put<ApiClient>(mockApiClient, permanent: true);
    Get.put<MockApiClient>(mockApiClient, permanent: true);

    Get.put<BoxManagementRepo>(boxRepo, permanent: true);
    Get.put<AuthRepo>(authRepo, permanent: true);
    Get.put<SplashRepo>(splashRepo, permanent: true);
    Get.put<ProfileRepo>(profileRepo, permanent: true);
    Get.put<AlertRepo>(alertRepo, permanent: true);
    Get.put<HelpRepo>(helpRepo, permanent: true);

    // Controllers
    Get.put(SplashController(splashRepo: splashRepo), permanent: true);
    Get.put(LoginController(authRepo: authRepo), permanent: true);
    Get.put(VerifyOtpController(authRepo: authRepo), permanent: true);
    Get.put(SetPasswordController(authRepo: authRepo), permanent: true);
    Get.put(ExistingUserController(authRepo: authRepo), permanent: true);
    Get.put(BoxManagementController(boxRepo: boxRepo), permanent: true);
    Get.put(ProfileDetailsController(profileRepo: profileRepo),
        permanent: true);
    Get.put(DashboardController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(SettingController(), permanent: true);
    Get.put(AlertsController(alertRepo: alertRepo), permanent: true);
    Get.put(HelpController(helpRepo: helpRepo), permanent: true);
    Get.put(HelpFaqListController(helpRepo: helpRepo), permanent: true);
  }

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
  }

  Widget buildApp({
    String? initialRoute,
    Widget? home,
  }) {
    return ToastificationWrapper(
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          initialRoute:
              home == null ? (initialRoute ?? RouteHelper.splash) : null,
          home: home,
          getPages: RouteHelper.pages,
        ),
      ),
    );
  }

  Future<void> pumpApp(
    WidgetTester tester, {
    String? initialRoute,
    Widget? home,
  }) async {
    configureViewport(tester);
    await tester.pumpWidget(buildApp(initialRoute: initialRoute, home: home));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> settleWithSafePump(WidgetTester tester) async {
    // Repeated pump with small step to allow GetX transitions and UI rebuilds
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> drainToastTimers(WidgetTester tester) async {
    // Toastification uses 3-4s timers for auto dismissal
    await tester.pump(const Duration(seconds: 4));
  }

  Future<void> tearDown(WidgetTester tester) async {
    if (Get.isRegistered<BoxManagementController>()) {
      Get.find<BoxManagementController>().onClose();
    }
    await drainToastTimers(tester);
    // Unmount any active screen widgets to trigger their dispose() and cancel state timers
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    Get.reset();
  }
}
