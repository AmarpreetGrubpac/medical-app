import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/screens/scan_box/controller/scan_box_controller.dart';
import 'package:grubpac_driver/screens/scan_box/view/scan_box_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Page Object for ScanBoxScreen.
class ScanBoxPage {
  final WidgetTester tester;
  ScanBoxPage(this.tester);

  Finder get scanScreenFinder => find.byType(ScanBoxScreen);

  void verifyVisible() {
    expect(scanScreenFinder, findsOneWidget);
  }

  Future<void> simulateQrScan(String qrPayload) async {
    final controller = Get.find<ScanBoxController>();
    controller.startScanning();
    await controller.onDetect(
      BarcodeCapture(barcodes: [
        Barcode(rawValue: qrPayload),
      ]),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }
}
