import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/preference/pref_key.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/core/utils/app_utils.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/box_details/widgets/details_grublock_bottom_sheet.dart';
import 'package:grubpac_driver/screens/box_details/widgets/overlay_battery_menu.dart';
import 'package:grubpac_driver/screens/box_details/widgets/overlay_indicator_menu.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:timer_count_down/timer_controller.dart';

class BoxDetailsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => onInitMethod());
  }

  void onInitMethod() {
    phone = AppPreference.getString(PrefKey.phone);
    countryCode = AppPreference.getString(PrefKey.countryCode);

    sliderController.value = AppUtils.normalizeSliderValue(firstBattery.toDouble());

    update();
  }

  final PageController pageController = PageController();
  final InteractiveSliderController sliderController = InteractiveSliderController(0);

  String phone = "";
  String countryCode = "";

  int selectedBattery = 1;
  int currentPage = 0;

  int firstBattery = -5;
  int secondBattery = 25;

  bool advertSwitch = true;
  bool dualZoneSwitch = true;
  bool zoneBox1Switch = true;
  bool zoneBox2Switch = true;
  bool ioniserSwitch = true;
  bool isBoxExpanded = false;
  bool isConnectionsExpanded = false;
  bool isPowerExpanded = false;
  bool isStorageExpanded = false;
  bool isCameraExpanded = false;
  bool isLightExpanded = false;
  bool isStatusBoxExpanded = false;
  bool isAdvertBoxExpanded = false;
  bool isThermoBoxExpanded = false;
  bool isBatteryBoxExpanded = false;
  bool boxConnectionStatus = true;

  /// ON CHANGE PAGE
  void onChangePage(int index) {
    currentPage = index;
    update();
  }

  /// HELP
  void onHelpTap() => Navigation.pushNamed(RouteHelper.helpFaqList);

  /// GRUBLOCK
  Future<void> onLockTap(BuildContext context) async {
    otpController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Important for blur
      builder: (context) {
        return Stack(
          children: [
            // Blurred Background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withValues(alpha: 0.05), // Optional tint
              ),
            ),
            // Bottom Sheet Content
            Align(
              alignment: Alignment.bottomCenter,
              child: detailsGrublockBottomSheet(context),
            ),
          ],
        );
      },
    );
  }

  /// LOGS
  void onLogsTap() => Navigation.pushNamed(RouteHelper.alerts);

  /// SLIDER CHANGE
  void onSliderChange(double value) {
    if (selectedBattery == 1 || !dualZoneSwitch) {
      firstBattery = value.toInt();
    } else {
      secondBattery = value.toInt();
    }
    update();
  }

  /// SELECT BATTERY
  void onSelectBattery(int value) {
    selectedBattery = value;
    update();

    sliderController.value = AppUtils.normalizeSliderValue(
      value == 1 ? firstBattery.toDouble() : secondBattery.toDouble(),
    );
    update();
  }

  /// SELECT BATTERY
  void onSelectTempButtons(int value) {
    sliderController.value = AppUtils.normalizeSliderValue(value.toDouble());
    update();
  }

  /// DUAL ZONE
  void toggleDualZone() {
    dualZoneSwitch = !dualZoneSwitch;
    selectedBattery = 1;

    sliderController.value = AppUtils.normalizeSliderValue(firstBattery.toDouble());

    update();
  }

  /// ADVERT
  void toggleAdvert() {
    advertSwitch = !advertSwitch;
    update();
  }

  /// ZONE BOX 1
  void toggleZoneBox1() {
    zoneBox1Switch = !zoneBox1Switch;
    update();
  }

  /// ZONE BOX 2
  void toggleZoneBox2() {
    zoneBox2Switch = !zoneBox2Switch;
    update();
  }

  /// IONISER
  void toggleIoniserSwitch() {
    ioniserSwitch = !ioniserSwitch;
    update();
  }

  /// BOX
  void toggleBox() {
    isBoxExpanded = !isBoxExpanded;
    update();
  }

  /// CONNECTIONS
  void toggleConnections() {
    isConnectionsExpanded = !isConnectionsExpanded;
    update();
  }

  /// POWER
  void togglePower() {
    isPowerExpanded = !isPowerExpanded;
    update();
  }

  /// STORAGE
  void toggleStorage() {
    isStorageExpanded = !isStorageExpanded;
    update();
  }

  /// CAMERA
  void toggleCamera() {
    isCameraExpanded = !isCameraExpanded;
    update();
  }

  /// LIGHT
  void toggleLight() {
    isLightExpanded = !isLightExpanded;
    update();
  }

  /// STATUS BOX
  void toggleStatusBox() {
    isStatusBoxExpanded = !isStatusBoxExpanded;
    update();
  }

  /// ADVERT BOX
  void toggleAdvertBox() {
    isAdvertBoxExpanded = !isAdvertBoxExpanded;
    update();
  }

  /// THERMOMETER BOX
  void toggleThermoBox() {
    isThermoBoxExpanded = !isThermoBoxExpanded;
    update();
  }

  /// BATTERY BOX
  void toggleBatteryBox() {
    isBatteryBoxExpanded = !isBatteryBoxExpanded;
    update();
  }

  /// BOX CONNECTION STATUS
  void toggleBoxStatus() {
    boxConnectionStatus = !boxConnectionStatus;
    update();
  }

  /// OVERLAYS ============
  final GlobalKey indicatorKey = GlobalKey();
  final GlobalKey batteryKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  OverlayEntry? _batteryOverlayEntry;

  bool isOverlayOpen = false;
  bool isBatteryOverlayOpen = false;

  /// BLUETOOTH OVERLAY
  void showOverlayMenu(BuildContext context) {
    isOverlayOpen = true;
    update();

    final renderBox = indicatorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => OverlayBluetoothMenuWidget(offset: offset, size: size, onClose: removeOverlay),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// REMOVE BLUETOOTH OVERLAY
  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    isOverlayOpen = false;
    update();
  }

  /// BATTERY OVERLAY
  void showBatteryMenu(BuildContext context) {
    isBatteryOverlayOpen = true;
    update();

    final renderBox = batteryKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final double overlayLeft = offset.dx;
    final double overlayTop = offset.dy - MediaQuery.of(context).size.height * 0.35;

    final overlayOffset = Offset(overlayLeft, overlayTop);

    _batteryOverlayEntry = OverlayEntry(
      builder: (context) =>
          OverlayBatteryMenuWidget(offset: overlayOffset, size: size, onClose: removeBatteryOverlay),
    );

    Overlay.of(context).insert(_batteryOverlayEntry!);
  }

  /// REMOVE BATTERY OVERLAY
  void removeBatteryOverlay() {
    _batteryOverlayEntry?.remove();
    _batteryOverlayEntry = null;
    isBatteryOverlayOpen = false;
    update();
  }

  /// OTP VERIFICATION ==================
  bool isTimerCompleted = false;
  bool isLoading = false;

  TextEditingController otpController = TextEditingController();
  CountdownController countdownController = CountdownController(autoStart: true);

  /// ON COUNTDOWN FINISHED
  void onCountdownFinished() {
    isTimerCompleted = true;
    update();
  }

  /// ON RESEND
  void onResendCode() {
    countdownController.restart();
    isTimerCompleted = false;
    update();
  }

  /// ON VERIFY OTP
  void verify() {
    if (otpController.text == "1111") {
      isLoading = true;
      update();

      Future.delayed(const Duration(seconds: 1), () {
        isLoading = false;
        update();

        AppToast.showSuccess(message: AppString.otpVerify);

        Navigation.pop();
      });
    } else {
      AppToast.showError(message: AppString.otpTryAgain, title: AppString.invalidOTP);
    }
  }
}
