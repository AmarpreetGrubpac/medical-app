import 'dart:convert';

import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanBoxController extends GetxController {
  final MobileScannerController scannerController = MobileScannerController();

  String scannedCode = "";
  bool isProcessing = false; // true while the addNewBox API call is running

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }

  /// Called by MobileScanner every time a barcode is captured.
  Future<void> onDetect(BarcodeCapture capture) async {
    // Ignore new scans while an API call is already in progress.
    if (isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    final rawValue = barcode?.rawValue;

    if (rawValue == null || rawValue.isEmpty) {
      AppToast.showError(
        title: AppString.boxNotRegistered,
        message: AppString.boxNotRegisteredMsg,
      );
      return;
    }

    // ── Parse the QR payload ────────────────────────────────────────────────
    // Expected format: {"box_display_id": "Qwer"}
    String? boxDisplayId;
    try {
      final Map<String, dynamic> data = jsonDecode(rawValue);
      boxDisplayId = data['box_display_id']?.toString();
    } catch (_) {
      // rawValue is not valid JSON — not a Zabee box QR.
    }

    if (boxDisplayId == null || boxDisplayId.isEmpty) {
      AppToast.showError(
        title: AppString.invalidQr,
        message: AppString.invalidQrMsg,
      );
      return;
    }
    // ────────────────────────────────────────────────────────────────────────

    scannedCode = boxDisplayId;
    isProcessing = true;
    update();

    // Pause camera while we process to avoid duplicate triggers.
    await scannerController.stop();

    // Hand off to BoxManagementController which owns the addNewBox API logic.
    await Get.find<BoxManagementController>().addNewBox(boxDisplayId);

    // Reset so the camera can be re-used if the user comes back.
    isProcessing = false;
    scannedCode = "";
    update();

    // Resume scanning in case the user didn't navigate away (e.g. API error).
    await scannerController.start();
  }
}
