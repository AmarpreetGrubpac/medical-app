import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanBoxController extends GetxController {
  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }

  String scannedCode = "";
  bool isScanning = false;
  bool isLoading = false;

  final MobileScannerController scannerController = MobileScannerController();

  /// ON MANUAL SCAN
  Future<void> onManualScan() async {
    isLoading = true;
    update();

    await Future.delayed(const Duration(seconds: 2), () {
      AppToast.showSuccess(message: AppString.boxAddedSuccess);
      isLoading = false;
      update();

      Navigation.replaceAll(RouteHelper.dashboard);
    });

    isScanning = true;
    update();

    scannerController.start();
  }

  /// ON STOP SCAN
  void stopScan() {
    isScanning = false;
    scannerController.stop();
    update();
  }

  /// ON DETECT
  void onDetect(BarcodeCapture capture) {
    if (!isScanning) return;

    Barcode? barcode = capture.barcodes.first;

    if (capture.barcodes.isNotEmpty && barcode.rawValue != null) {
      scannedCode = barcode.rawValue!;
      update();

      stopScan();

      AppToast.showSuccess(message: AppString.boxAddedSuccess);

      Navigation.replaceAll(RouteHelper.dashboard);
    } else {
      AppToast.showError(title: AppString.boxNotRegistered, message: AppString.boxNotRegisteredMsg);
    }
  }
}
