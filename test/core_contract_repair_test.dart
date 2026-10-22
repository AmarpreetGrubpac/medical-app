import 'package:flutter_test/flutter_test.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/model/alert_model.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';

void main() {
  test('live notification preserves message severity and stable box identity',
      () {
    final alert = AlertModel.fromJson({
      'id': 'event',
      'box_id': 'box-1',
      'body': 'Temperature excursion',
      'severity': 'warning'
    });
    expect(alert.description, 'Temperature excursion');
    expect(alert.type, AlertType.warning);
    expect(alert.boxName, 'box-1');
  });
  test('target temperature is independent from sensor measurement', () {
    final box = BoxInfo.fromJson({
      'id': 'box',
      'zone_1_temp': 24,
      'settings': {'zone_1_temp': 24, 'zone_1_target_temp': 4}
    });
    expect(box.zone1Temp, 24);
    expect(box.settings!.zone1Temp, 4);
  });
  test('missing target is unknown even when a measurement is present', () {
    final box = BoxInfo.fromJson({
      'id': 'box',
      'zone_1_temp': 24,
      'settings': {'zone_1_temp': 24, 'zone_1_target_temp': null}
    });
    expect(box.settings!.zone1Temp, isNull);
  });
  test('tracking requires valid box coordinates and never invents a fallback',
      () {
    BoxInfo box(dynamic latitude, dynamic longitude, {bool gps = true}) =>
        BoxInfo.fromJson({
          'id': 'box',
          'gps_available': gps,
          'latitude': latitude,
          'longitude': longitude
        });
    expect(box(null, null).hasValidLocation, isFalse);
    expect(box(0, 0).hasValidLocation, isFalse);
    expect(box(91, 10).hasValidLocation, isFalse);
    expect(box(double.nan, 10).hasValidLocation, isFalse);
    expect(box(28.6, 77.2, gps: false).hasValidLocation, isFalse);
    expect(box(28.6, 77.2).hasValidLocation, isTrue);
  });
}
