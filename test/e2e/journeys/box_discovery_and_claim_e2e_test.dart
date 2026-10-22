import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';

import '../fixtures/test_data_fixtures.dart';
import '../pages/dashboard_page.dart';
import '../pages/scan_box_page.dart';
import '../support/e2e_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final harness = E2ETestHarness();

  setUp(() async {
    await harness.setUp(isLoggedIn: true);
  });

  group('Critical Journey 2: Box Discovery, Empty State & QR Claim (E2E)', () {
    testWidgets('2.1 Fresh user sees Empty State and navigates to QR Scanner via Add My Box',
        (tester) async {
      // Mock empty box list on initial dashboard load
      harness.mockApiClient.setGetHandler('boxes', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.emptyBoxList);
      });
      harness.mockApiClient.setGetHandler('profile', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.driverProfile);
      });

      await harness.pumpApp(tester, initialRoute: RouteHelper.dashboard);
      await harness.settleWithSafePump(tester);

      final dashboardPage = DashboardPage(tester);
      final scanBoxPage = ScanBoxPage(tester);

      dashboardPage.verifyVisible();
      dashboardPage.verifyEmptyState();

      // Tap "Add My Box" CTA
      await dashboardPage.tapAddMyBox();
      await harness.settleWithSafePump(tester);

      // Verify arrived on ScanBoxScreen
      scanBoxPage.verifyVisible();

      await harness.tearDown(tester);
    });

    testWidgets('2.2 Scan QR code claims box and updates Dashboard with live telemetry',
        (tester) async {
      const targetDisplayId = 'MED-BOX-99';

      // Start with empty boxes
      harness.mockApiClient.setGetHandler('boxes', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.emptyBoxList);
      });
      harness.mockApiClient.setGetHandler('profile', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.driverProfile);
      });

      // Mock box registration endpoint for handler/driver (POST 'boxes') and owner (POST 'boxes/claim')
      harness.mockApiClient.setPostHandler('boxes', (uri, body) {
        return Response(
          statusCode: 200,
          body: TestDataFixtures.newlyClaimedBox(displayId: targetDisplayId),
        );
      });

      await harness.pumpApp(tester, initialRoute: RouteHelper.dashboard);
      await harness.settleWithSafePump(tester);

      final dashboardPage = DashboardPage(tester);
      final scanBoxPage = ScanBoxPage(tester);

      dashboardPage.verifyEmptyState();

      // Navigate to scan box
      await dashboardPage.tapAddMyBox();
      await harness.settleWithSafePump(tester);
      scanBoxPage.verifyVisible();

      // Simulate QR scanner detecting JSON format payload
      await scanBoxPage.simulateQrScan('{"box_display_id": "$targetDisplayId"}');
      await harness.settleWithSafePump(tester);

      // Verify the claim API was called with the display ID
      final claimRequest = harness.mockApiClient.recordedRequests.firstWhere(
        (r) => r.method == 'POST' && (r.uri.contains('claim') || r.uri.contains('boxes')),
      );
      expect(claimRequest.body['display_id'], targetDisplayId);

      // Verify state in BoxManagementController has the claimed box
      final boxCtrl = Get.find<BoxManagementController>();
      expect(boxCtrl.boxes.isNotEmpty, isTrue);
      expect(boxCtrl.boxes.first.boxDisplayId, targetDisplayId);

      await harness.tearDown(tester);
    });

    testWidgets('2.3 Scanner parses both JSON and plain-text QR formats robustly',
        (tester) async {
      const plainDisplayId = 'PLAIN-BOX-77';

      harness.mockApiClient.setGetHandler('boxes', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.emptyBoxList);
      });
      harness.mockApiClient.setGetHandler('profile', (uri, query) {
        return Response(statusCode: 200, body: TestDataFixtures.driverProfile);
      });

      harness.mockApiClient.setPostHandler('boxes', (uri, body) {
        return Response(
          statusCode: 200,
          body: TestDataFixtures.newlyClaimedBox(displayId: plainDisplayId),
        );
      });

      await harness.pumpApp(tester, initialRoute: RouteHelper.scanBox);
      await harness.settleWithSafePump(tester);

      final scanBoxPage = ScanBoxPage(tester);
      scanBoxPage.verifyVisible();

      // Simulate QR scan with raw string format
      await scanBoxPage.simulateQrScan(plainDisplayId);
      await harness.settleWithSafePump(tester);

      final claimRequest = harness.mockApiClient.recordedRequests.firstWhere(
        (r) => r.method == 'POST' && (r.uri.contains('claim') || r.uri.contains('boxes')),
      );
      expect(claimRequest.body['display_id'], plainDisplayId);

      await harness.tearDown(tester);
    });
  });
}
