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
  bool isScanning = false;   // true when waiting for user to point camera to QR after clicking Scan

  void startScanning() {
    isScanning = true;
    update();
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }

  /// Called by MobileScanner every time a barcode is captured.
  Future<void> onDetect(BarcodeCapture capture) async {
    // Ignore new scans while an API call is already in progress or if we haven't started scanning.
    if (isProcessing || !isScanning) return;

    final barcode = capture.barcodes.firstOrNull;
    final rawValue = barcode?.rawValue;

    if (rawValue == null || rawValue.isEmpty) {
      return;
    }

    // ── Parse the QR payload ────────────────────────────────────────────────
    // Supports JSON format: {"box_display_id": "MOB-MED-BOX-01"} or plain string
    String? boxDisplayId;
    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is Map) {
        boxDisplayId = decoded['box_display_id']?.toString();
      } else if (decoded is String) {
        boxDisplayId = decoded.trim();
      }
    } catch (_) {
      // rawValue is plain text QR code
      boxDisplayId = rawValue.trim();
    }

    if (boxDisplayId == null || boxDisplayId.isEmpty) {
      AppToast.showError(
        title: AppString.invalidQr,
        message: AppString.invalidQrMsg,
      );
      isScanning = false;
      update();
      return;
    }
    // ────────────────────────────────────────────────────────────────────────

    scannedCode = boxDisplayId;
    isProcessing = true;
    isScanning = false;
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
