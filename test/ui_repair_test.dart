import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/screens/box_details/widgets/battery_box_widget.dart';
import 'package:grubpac_driver/screens/box_details/widgets/zone_card.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppPreference.initMySharedPreferences();
  });
  test('missing battery telemetry remains unknown rather than zero', () {
    final box = BoxInfo.fromJson({'id': 'box', 'battery_level': null});
    expect(box.batteryLevel, isNull);
    expect(BoxInfo.fromJson({'id': 'box', 'battery_level': 0}).batteryLevel, 0);
  });

  test('heartbeat can clear a previously reported battery reading', () {
    final box = BoxInfo(
        id: 'box',
        boxDisplayId: 'BOX',
        batteryLevel: 90,
        battery1Level: 90,
        battery2Level: 80);
    expect(
        box
            .copyWith(
                batteryLevel: null, battery1Level: null, battery2Level: null)
            .batteryLevel,
        isNull);
    expect(
        box
            .copyWith(
                batteryLevel: null, battery1Level: null, battery2Level: null)
            .battery1Level,
        isNull);
    expect(box.copyWith().batteryLevel, 90);
  });

  testWidgets('zone card fits negative temperature at enlarged text size',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp(
          home: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: const Scaffold(
            body: Center(
                child: SizedBox(
          width: 150,
          child: BatteryBoxWidget(
              temp: -20,
              type: BatteryBoxType.first,
              title: 'Zone 1',
              isSelected: true),
        ))),
      )),
    ));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('expanded two-zone card fits narrow columns and enlarged text',
      (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp(
          home: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: Scaffold(
            body: Center(
                child: SizedBox(
                    width: 150,
                    child: ZoneCard(
                      zoneName: 'Zone 1',
                      targetTemp: '-20',
                      achievedTemp: '-19.5',
                      type: ZoneBoxType.cold,
                      isOn: true,
                      onToggle: () {},
                    )))),
      )),
    ));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
