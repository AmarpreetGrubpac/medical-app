import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/dashboard/controller/dashboard_controller.dart';
import 'package:grubpac_driver/screens/help_section/help/view/help_screen.dart';

import '../fixtures/test_data_fixtures.dart';
import '../pages/dashboard_page.dart';
import '../pages/login_page.dart';
import '../pages/settings_page.dart';
import '../support/e2e_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final harness = E2ETestHarness();

  setUp(() async {
    await harness.setUp(isLoggedIn: true);
  });

  group('Critical Journey 3: Dashboard Navigation, Settings & Logout Lifecycle (E2E)', () {
    testWidgets('3.1 Bottom navigation transitions smoothly between Home, Settings, and Help tabs',
        (tester) async {
      harness.mockApiClient.setGetHandler('boxes', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.emptyBoxList);
      });
      harness.mockApiClient.setGetHandler('profile', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.driverProfile);
      });

      await harness.pumpApp(tester, initialRoute: RouteHelper.dashboard);
      await harness.settleWithSafePump(tester);

      final dashboardPage = DashboardPage(tester);
      final settingsPage = SettingsPage(tester);
      final dashCtrl = Get.find<DashboardController>();

      dashboardPage.verifyVisible();
      expect(dashCtrl.selectedIndex, 0);

      // Navigate to Settings tab
      await dashboardPage.selectSettingsTab();
      await harness.settleWithSafePump(tester);
      expect(dashCtrl.selectedIndex, 1);
      settingsPage.verifyVisible();

      // Navigate to Help tab
      await dashboardPage.selectHelpTab();
      await harness.settleWithSafePump(tester);
      expect(dashCtrl.selectedIndex, 2);
      expect(find.byType(HelpScreen), findsOneWidget);

      // Return to Home tab
      await dashboardPage.selectHomeTab();
      await harness.settleWithSafePump(tester);
      expect(dashCtrl.selectedIndex, 0);

      await harness.tearDown(tester);
    });

    testWidgets('3.2 Connected box displays live status, temperature, and controls',
        (tester) async {
      // Mock user possessing a connected box
      harness.mockApiClient.setGetHandler('boxes', (uri, query) {
        return Response(
          statusCode: 200,
          body: TestDataFixtures.singleConnectedBox,
        );
      });
      harness.mockApiClient.setGetHandler('profile', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.driverProfile);
      });

      await harness.pumpApp(tester, initialRoute: RouteHelper.dashboard);
      await harness.settleWithSafePump(tester);

      final dashboardPage = DashboardPage(tester);
      dashboardPage.verifyVisible();

      // Should display ConnectedView instead of empty state
      dashboardPage.verifyConnectedBoxState();
      expect(dashboardPage.emptyWelcomeFinder, findsNothing);

      await harness.tearDown(tester);
    });

    testWidgets('3.3 Theme toggle switches look between Light and Dark mode',
        (tester) async {
      harness.mockApiClient.setGetHandler('boxes', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.emptyBoxList);
      });
      harness.mockApiClient.setGetHandler('profile', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.driverProfile);
      });

      await harness.pumpApp(tester, initialRoute: RouteHelper.dashboard);
      await harness.settleWithSafePump(tester);

      final dashboardPage = DashboardPage(tester);
      final settingsPage = SettingsPage(tester);

      await dashboardPage.selectSettingsTab();
      await harness.settleWithSafePump(tester);

      final initialDark = AppTheme.isDark;

      // Toggle Theme
      await settingsPage.tapThemeToggle();
      await harness.settleWithSafePump(tester);

      // Verify theme state updated
      expect(AppTheme.isDark, !initialDark);

      // Revert theme for test cleanliness
      await settingsPage.tapThemeToggle();
      await harness.settleWithSafePump(tester);
      expect(AppTheme.isDark, initialDark);

      await harness.tearDown(tester);
    });

    testWidgets(
        '3.4 Complete Logout lifecycle: triggers logout API, clears token/session and redirects to Login',
        (tester) async {
      harness.mockApiClient.setGetHandler('boxes', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.emptyBoxList);
      });
      harness.mockApiClient.setGetHandler('profile', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.driverProfile);
      });
      harness.mockApiClient.setPostHandler('logout', (uri, body) {
        return const Response(statusCode: 200, body: {"success": true});
      });

      await harness.pumpApp(tester, initialRoute: RouteHelper.dashboard);
      await harness.settleWithSafePump(tester);

      final dashboardPage = DashboardPage(tester);
      final settingsPage = SettingsPage(tester);
      final loginPage = LoginPage(tester);

      // Go to settings
      await dashboardPage.selectSettingsTab();
      await harness.settleWithSafePump(tester);
      settingsPage.verifyVisible();

      // Ensure tokens were present initially
      expect(harness.tokenStore.hasAccessToken, isTrue);

      // Tap Logout
      await settingsPage.tapLogout();
      await harness.settleWithSafePump(tester);

      // Verify user is redirected to LoginScreen
      loginPage.verifyVisible();

      // Verify tokens and session have been cleared
      expect(harness.tokenStore.accessToken, isNull);
      expect(harness.tokenStore.refreshToken, isNull);
      expect(harness.sessionManager.persona, isEmpty);

      await harness.tearDown(tester);
    });
  });
}
