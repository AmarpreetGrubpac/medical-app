import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/screens/box_details/controller/box_details_controller.dart';
import 'package:grubpac_driver/screens/box_details/view/trackLocation_screem.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/controller/alerts_controller.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/model/alert_model.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';
import 'e2e/support/e2e_test_harness.dart';

void main() {
  testWidgets(
      'driver OTP route failure shows an error without a requested-success toast',
      (tester) async {
    final harness = E2ETestHarness();
    await harness.setUp();
    await harness.sessionManager
        .saveSession(persona: 'driver', apiPrefix: 'medical-mobile/driver/');
    harness.mockApiClient
        .setPostHandler('otp-lock', (_, __) => const Response(statusCode: 404));
    await tester
        .pumpWidget(harness.buildApp(home: const Scaffold(body: SizedBox())));
    final controller = Get.find<BoxManagementController>();
    controller.boxes.assignAll(
        [BoxInfo(id: 'box-1', boxDisplayId: 'BOX-1', isLocked: true)]);
    await controller.onLockTap(tester.element(find.byType(Scaffold)), 'box-1');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(
        find.text(
            'Box access verification is currently unavailable. Contact your facility.'),
        findsOneWidget);
    expect(find.textContaining('OTP requested'), findsNothing);
    expect(controller.isLoading, isFalse);
    await harness.tearDown(tester);
  });

  testWidgets(
      'tracking missing GPS offers no map or share action and no live claim',
      (tester) async {
    final harness = E2ETestHarness();
    await harness.setUp();
    harness.mockApiClient.setGetHandler(
        'boxes/box-1',
        (_, __) => const Response(statusCode: 200, body: {
              'data': {
                'id': 'box-1',
                'display_id': 'BOX-1',
                'gps_available': true,
                'latitude': null,
                'longitude': null
              }
            }));
    await tester.pumpWidget(
        harness.buildApp(home: const TracklocationScreeen(boxId: 'box-1')));
    await tester.pump();
    expect(find.text('Box location unavailable'), findsOneWidget);
    expect(find.textContaining('You are tracking live'), findsNothing);
    final buttons = tester.widgetList<FilledButton>(find.byType(FilledButton));
    expect(buttons.every((button) => button.onPressed == null), isTrue);
    await harness.tearDown(tester);
  });

  testWidgets(
      'Logs filters by stable box ID even if names collide; reset restores all',
      (tester) async {
    final harness = E2ETestHarness();
    await harness.setUp();
    final controller = AlertsController(alertRepo: harness.alertRepo);
    controller.alerts.assignAll([
      AlertModel.fromJson(
          {'id': 'a', 'box_id': 'box-1', 'box_name': 'Same name'}),
      AlertModel.fromJson(
          {'id': 'b', 'box_id': 'box-2', 'box_name': 'Same name'}),
    ]);
    controller.selectedBoxId = 'box-1';
    expect(controller.filteredAlerts.map((alert) => alert.id), ['a']);
    controller.resetFilters();
    expect(controller.filteredAlerts.length, 2);
    await harness.tearDown(tester);
  });
  testWidgets(
      'rejected target command does not write telemetry and restores prior target',
      (tester) async {
    final harness = E2ETestHarness();
    await harness.setUp();
    await tester
        .pumpWidget(harness.buildApp(home: const Scaffold(body: SizedBox())));
    final controller = BoxDetailsController()..boxId = 'box-1';
    controller.boxInfo = BoxInfo.fromJson({
      'id': 'box-1',
      'zone_1_temp': 24,
      'settings': {'zone_1_target_temp': 4, 'zone_2_target_temp': 6}
    });
    controller.firstBattery = 4;
    controller.secondBattery = 6;
    harness.mockApiClient.setPatchHandler(
        'settings',
        (_, __) => const Response(
            statusCode: 400, body: {'message': 'Unsupported target setting'}));
    controller.onSelectTempButtons(8);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();
    final request = harness.mockApiClient.recordedRequests
        .lastWhere((r) => r.method == 'PATCH');
    expect(request.body, {'zone_1_target_temp': 8});
    expect(controller.firstBattery, 4);
    expect(controller.boxInfo!.zone1Temp, 24);
    controller.onClose();
    await harness.tearDown(tester);
  });

  testWidgets('out-of-range temperature issues no command', (tester) async {
    final harness = E2ETestHarness();
    await harness.setUp();
    await tester
        .pumpWidget(harness.buildApp(home: const Scaffold(body: SizedBox())));
    final controller = BoxDetailsController()..boxId = 'box-1';
    controller.firstBattery = 4;
    controller.onSelectTempButtons(999);
    await tester.pump(const Duration(milliseconds: 600));
    expect(
        harness.mockApiClient.recordedRequests
            .where((r) => r.method == 'PATCH'),
        isEmpty);
    expect(controller.firstBattery, 4);
    controller.onClose();
    await harness.tearDown(tester);
  });

  testWidgets('rejected zone power command restores the previous state',
      (tester) async {
    final harness = E2ETestHarness();
    await harness.setUp();
    await tester
        .pumpWidget(harness.buildApp(home: const Scaffold(body: SizedBox())));
    final controller = BoxDetailsController()..boxId = 'box-1';
    harness.mockApiClient.setPatchHandler(
        'settings',
        (_, __) => const Response(
            statusCode: 400, body: {'message': 'Unsupported setting'}));
    controller.zoneBox1Switch = true;
    controller.toggleZoneBox1();
    await tester.pump();
    expect(controller.zoneBox1Switch, isTrue);
    expect(
        harness.mockApiClient.recordedRequests
            .lastWhere((r) => r.method == 'PATCH')
            .body,
        {'zone_1_status': false});
    controller.onClose();
    await harness.tearDown(tester);
  });

  testWidgets(
      'bulk unlock failure does not issue an unreliable per-box fallback',
      (tester) async {
    final harness = E2ETestHarness();
    await harness.setUp();
    harness.mockApiClient.setPatchHandler(
        'emergency_unlock', (_, __) => const Response(statusCode: 503));
    final response = await harness.boxRepo.setBoxLock('box-1', 'unlock');
    expect(response.statusCode, 503);
    expect(
        harness.mockApiClient.recordedRequests
            .where((r) => r.method == 'PATCH')
            .length,
        1);
    await harness.tearDown(tester);
  });
}
