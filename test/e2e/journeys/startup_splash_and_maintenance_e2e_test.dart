import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/fallback_screens/maintance_screen.dart';
import 'package:grubpac_driver/screens/fallback_screens/update_screen.dart';
import 'package:grubpac_driver/screens/splash/view/splash_screen.dart';

import '../fixtures/test_data_fixtures.dart';
import '../pages/dashboard_page.dart';
import '../pages/login_page.dart';
import '../support/e2e_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final harness = E2ETestHarness();

  group('Critical Journey 4: App Startup, Splash, Maintenance & Auto-Login (E2E)', () {
    testWidgets('4.1 Unauthenticated startup loads config and routes to LoginScreen',
        (tester) async {
      await harness.setUp(isLoggedIn: false);

      harness.mockApiClient.setGetHandler('config', (uri, query) {
        return Response(
          statusCode: 200,
          body: TestDataFixtures.standardConfig(maintenanceMode: 'false'),
        );
      });

      await harness.pumpApp(tester, initialRoute: RouteHelper.splash);
      expect(find.byType(SplashScreen), findsOneWidget);

      // Advance time for splash delay and network
      await tester.pump(const Duration(seconds: 2));
      await harness.settleWithSafePump(tester);

      final loginPage = LoginPage(tester);
      loginPage.verifyVisible();

      await harness.tearDown(tester);
    });

    testWidgets('4.2 Maintenance mode interception routes immediately to MaintenanceScreen',
        (tester) async {
      await harness.setUp(isLoggedIn: false);

      // Return maintenanceMode: "true"
      harness.mockApiClient.setGetHandler('config', (uri, query) {
        return Response(
          statusCode: 200,
          body: TestDataFixtures.standardConfig(maintenanceMode: 'true'),
        );
      });

      await harness.pumpApp(tester, initialRoute: RouteHelper.splash);
      await tester.pump(const Duration(seconds: 2));
      await harness.settleWithSafePump(tester);

      // Must navigate to MaintenanceScreen and not proceed to Login
      expect(find.byType(MaintenanceScreen), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);

      await harness.tearDown(tester);
    });

    testWidgets('4.3 Outdated app version forces redirection to UpdateScreen',
        (tester) async {
      await harness.setUp(isLoggedIn: false);

      // Return high minimum required version across platforms
      harness.mockApiClient.setGetHandler('config', (uri, query) {
        return Response(
          statusCode: 200,
          body: TestDataFixtures.standardConfig(
            minAndroidVersion: '99.0.0',
            minIosVersion: '99.0.0',
          ),
        );
      });

      await harness.pumpApp(tester, initialRoute: RouteHelper.splash);
      await tester.pump(const Duration(seconds: 2));
      await harness.settleWithSafePump(tester);

      // Must navigate to UpdateScreen
      expect(find.byType(UpdateScreen), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);

      await harness.tearDown(tester);
    });

    testWidgets('4.4 Authenticated startup automatically auto-logs in and opens Dashboard',
        (tester) async {
      // Set up with valid session and tokens
      await harness.setUp(
        isLoggedIn: true,
        token: TestDataFixtures.driverUser['token'],
        persona: TestDataFixtures.driverUser['persona'],
        apiPrefix: TestDataFixtures.driverUser['api_prefix'],
      );

      harness.mockApiClient.setGetHandler('config', (uri, query) {
        return Response(
          statusCode: 200,
          body: TestDataFixtures.standardConfig(maintenanceMode: 'false'),
        );
      });
      harness.mockApiClient.setGetHandler('profile', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.driverProfile);
      });
      harness.mockApiClient.setGetHandler('boxes', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.singleConnectedBox);
      });

      await harness.pumpApp(tester, initialRoute: RouteHelper.splash);
      await tester.pump(const Duration(seconds: 2));
      await harness.settleWithSafePump(tester);

      final dashboardPage = DashboardPage(tester);
      dashboardPage.verifyVisible();

      await harness.tearDown(tester);
    });
  });
}
