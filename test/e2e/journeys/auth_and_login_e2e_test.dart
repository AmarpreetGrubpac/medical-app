import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/helper/route_helper.dart';

import '../fixtures/test_data_fixtures.dart';
import '../pages/dashboard_page.dart';
import '../pages/existing_user_page.dart';
import '../pages/login_page.dart';
import '../support/e2e_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final harness = E2ETestHarness();

  setUp(() async {
    await harness.setUp(isLoggedIn: false);
  });

  tearDown(() async {
    // Teardown harness
  });

  group('Critical Journey 1: Authentication & Login Flow (E2E)', () {
    testWidgets('1.1 Input validation keeps Continue button disabled until valid',
        (tester) async {
      await harness.pumpApp(tester, initialRoute: RouteHelper.login);
      final loginPage = LoginPage(tester);
      loginPage.verifyVisible();

      // Initially disabled with empty input
      loginPage.assertContinueDisabled();

      // Incomplete/invalid phone
      await loginPage.enterIdentifier('1234');
      loginPage.assertContinueDisabled();

      // Incomplete email
      await loginPage.enterIdentifier('invalid-email@');
      loginPage.assertContinueDisabled();

      // Valid email enables button
      await loginPage.enterIdentifier(TestDataFixtures.driverUser['auth']!);
      loginPage.assertContinueEnabled();

      await harness.tearDown(tester);
    });

    testWidgets('1.2 Demo Mode toggle autofills sandbox credentials and enables Continue',
        (tester) async {
      await harness.pumpApp(tester, initialRoute: RouteHelper.login);
      final loginPage = LoginPage(tester);

      loginPage.assertDemoModeInactive();

      // Tap Explore Demo Mode
      await loginPage.toggleDemoMode();
      loginPage.assertDemoModeActive();
      loginPage.assertContinueEnabled();

      expect(find.text('demo@grubpac.com'), findsOneWidget);

      await harness.tearDown(tester);
    });

    testWidgets(
        '1.3 Full Happy Path: Login -> ExistingUser -> Dashboard & Session Persistence',
        (tester) async {
      final user = TestDataFixtures.driverUser;

      // Mock check-account
      harness.mockApiClient.setPostHandler('check-account', (uri, body) {
        return Response(
          statusCode: 200,
          body: {
            "success": true,
            "is_account_found": true,
            "is_password_set": true,
            "persona": user['persona'],
            "api_prefix": user['api_prefix'],
            "client_id": user['client_id'],
          },
        );
      });

      // Mock login endpoint
      harness.mockApiClient.setPostHandler('login', (uri, body) {
        return Response(
          statusCode: 200,
          body: {
            "success": true,
            "persona": user['persona'],
            "api_prefix": user['api_prefix'],
            "data": {
              "auth_token": user['token'],
              "refresh_token": user['refresh_token'],
              "persona": user['persona'],
              "api_prefix": user['api_prefix'],
              "id": user['user_id'],
            }
          },
        );
      });

      // Mock profile and boxes for dashboard arrival
      harness.mockApiClient.setGetHandler('profile', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.driverProfile);
      });
      harness.mockApiClient.setGetHandler('boxes', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.emptyBoxList);
      });

      await harness.pumpApp(tester, initialRoute: RouteHelper.login);
      final loginPage = LoginPage(tester);
      final existingUserPage = ExistingUserPage(tester);
      final dashboardPage = DashboardPage(tester);

      // Step 1: Enter email and submit
      await loginPage.enterIdentifier(user['auth']!);
      await loginPage.tapContinue();
      await harness.settleWithSafePump(tester);

      // Step 2: Landed on ExistingUser screen
      existingUserPage.verifyVisible();

      // Step 3: Enter password and login
      await existingUserPage.enterPassword(user['password']!);
      await existingUserPage.tapContinue();
      await harness.settleWithSafePump(tester);

      // Step 4: Verify arrival at Dashboard
      dashboardPage.verifyVisible();

      // Step 5: Verify TokenStore & SessionManager state
      expect(harness.tokenStore.accessToken, user['token']);
      expect(harness.sessionManager.persona, user['persona']);
      expect(harness.sessionManager.apiPrefix, user['api_prefix']);

      await harness.tearDown(tester);
    });

    testWidgets('1.4 Negative Path: Incorrect password displays error and remains on screen',
        (tester) async {
      final user = TestDataFixtures.driverUser;

      harness.mockApiClient.setPostHandler('check-account', (uri, body) {
        return Response(
          statusCode: 200,
          body: {
            "success": true,
            "is_account_found": true,
            "is_password_set": true,
            "persona": user['persona'],
            "api_prefix": user['api_prefix'],
          },
        );
      });

      // Mock login failure (401 Invalid Credentials)
      harness.mockApiClient.setPostHandler('login', (uri, body) {
        return const Response(
          statusCode: 401,
          body: {
            "success": false,
            "error": "Invalid username or password"
          },
        );
      });

      await harness.pumpApp(tester, initialRoute: RouteHelper.login);
      final loginPage = LoginPage(tester);
      final existingUserPage = ExistingUserPage(tester);
      final dashboardPage = DashboardPage(tester);

      await loginPage.enterIdentifier(user['auth']!);
      await loginPage.tapContinue();
      await harness.settleWithSafePump(tester);

      existingUserPage.verifyVisible();

      // Enter wrong password
      await existingUserPage.enterPassword('WrongPassword999!');
      await existingUserPage.tapContinue();
      await harness.settleWithSafePump(tester);

      // Must remain on ExistingUser screen, dashboard should NOT be visible
      existingUserPage.verifyVisible();
      expect(dashboardPage.dashboardFinder, findsNothing);

      // Tokens should not be stored
      expect(harness.tokenStore.accessToken, isNull);

      await harness.tearDown(tester);
    });
  });
}
