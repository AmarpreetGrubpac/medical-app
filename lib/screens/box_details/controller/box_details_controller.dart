import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/exceptions/failure.dart';
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
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_repo.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../settings_section/box_management/controller/box_management_controller.dart';

class BoxDetailsController extends GetxController {
  final BoxManagementRepo boxRepo = Get.find<BoxManagementRepo>();
  String boxId = "";
  BoxInfo? boxInfo;
  String currentAction = "unlock";
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => onInitMethod());
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }

  void onInitMethod() {
    phone = AppPreference.getString(PrefKey.phone);
    countryCode = AppPreference.getString(PrefKey.countryCode);

    sliderController.value =
        AppUtils.normalizeSliderValue(firstBattery.toDouble());

    final args = Get.arguments;
    if (args != null) {
      boxId = args['box_id'] ?? "";
      if (args['page'] != null) {
        int initialPage = args['page'] as int;
        if (pageController.hasClients) {
          pageController.jumpToPage(initialPage);
        }
      }
    }

    if (boxId.isNotEmpty) {
      fetchBoxDetails();
    }

    update();
  }

  Future<void> fetchBoxDetails() async {
    try {
      isLoading = true;
      update();
      final res = await boxRepo.getBoxDetail(boxId);
      if (res.statusCode == 200) {
        boxInfo = BoxInfo.fromJson(res.body['data']);
        advertSwitch = boxInfo?.settings?.advertDisplayEnabled ?? false;
        dualZoneSwitch = boxInfo?.settings?.isDualZone ?? false;
        ioniserSwitch = boxInfo?.settings?.ioniserEnabled ?? false;
        firstBattery = boxInfo?.settings?.zone1Temp ?? 21;
        secondBattery = boxInfo?.settings?.zone2Temp ?? 21;
        boxConnectionStatus = boxInfo?.isConnected ?? false;

        sliderController.value = AppUtils.normalizeSliderValue(
          selectedBattery == 1
              ? firstBattery.toDouble()
              : secondBattery.toDouble(),
        );

        // Sync with BoxManagementController
        _syncConnectionStatusToManagement(boxConnectionStatus);
      } else {
        throw Failure(
            message: res.body['message'] ??
                res.body['error'] ??
                'Failed to load box details',
            response: res);
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> _updateSettings(
    Map<String, dynamic> changes, {
    required VoidCallback onRollback,
  }) async {
    try {
      final res = await boxRepo.updateBoxSettings(boxId, changes);
      if (res.statusCode != 200) {
        throw Failure(
          message: res.body['message'] ??
              res.body['error'] ??
              'Failed to update settings',
          response: res,
        );
      }
    } catch (e) {
      onRollback();
      AppUtils.apiErrorHandler(e);
    }
  }

  Future<void> _connectBoxCall({required VoidCallback onRollback}) async {
    try {
      final res = await boxRepo.connectBox(boxId);
      if (res.statusCode == 200) {
        AppToast.showSuccess(message: AppString.bluetoothConnectSuccess);
        fetchBoxDetails();
      } else {
        throw Failure(
            message: res.body['message'] ??
                res.body['error'] ??
                'Failed to connect box',
            response: res);
      }
    } catch (e) {
      onRollback();
      AppUtils.apiErrorHandler(e);
    }
  }

  Future<void> _disconnectBoxCall({required VoidCallback onRollback}) async {
    try {
      final res = await boxRepo.disconnectBox(boxId);
      if (res.statusCode == 200) {
        AppToast.showSuccess(message: AppString.boxDisConnected);
        fetchBoxDetails();
      } else {
        throw Failure(
            message: res.body['message'] ??
                res.body['error'] ??
                'Failed to disconnect box',
            response: res);
      }
    } catch (e) {
      onRollback();
      AppUtils.apiErrorHandler(e);
    }
  }

  void _debounceUpdateSettings() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final int initialFirst = firstBattery;
      final int initialSecond = secondBattery;
      _updateSettings(
        {
          "zone_1_temp": firstBattery,
          "zone_2_temp": secondBattery,
        },
        onRollback: () {
          firstBattery = initialFirst;
          secondBattery = initialSecond;
          sliderController.value = AppUtils.normalizeSliderValue(
            selectedBattery == 1
                ? firstBattery.toDouble()
                : secondBattery.toDouble(),
          );
          update();
        },
      );
    });
  }

  final PageController pageController = PageController();
  final InteractiveSliderController sliderController =
      InteractiveSliderController(0);

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
    if (isLoading) return;
    otpController.clear();
    currentAction = (boxInfo?.isLocked ?? true) ? "unlock" : "lock";

    // Call the sendBoxOtp function in parallel (not awaited)
    Get.find<BoxManagementController>()
        .sendBoxOtp(boxId, action: currentAction);

    isTimerCompleted = false;
    countdownController.restart();

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
    _debounceUpdateSettings();
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

  /// SELECT TEMPERATURE BUTTON
  void onSelectTempButtons(int value) {
    sliderController.value = AppUtils.normalizeSliderValue(value.toDouble());
    if (selectedBattery == 1 || !dualZoneSwitch) {
      firstBattery = value;
    } else {
      secondBattery = value;
    }
    update();
    _debounceUpdateSettings();
  }

  /// DUAL ZONE
  void toggleDualZone() {
    dualZoneSwitch = !dualZoneSwitch;
    selectedBattery = 1;
    sliderController.value =
        AppUtils.normalizeSliderValue(firstBattery.toDouble());
    update();

    _updateSettings(
      {"is_dual_zone": dualZoneSwitch},
      onRollback: () {
        dualZoneSwitch = !dualZoneSwitch;
        selectedBattery = 1;
        sliderController.value =
            AppUtils.normalizeSliderValue(firstBattery.toDouble());
        update();
      },
    );
  }

  /// ADVERT
  void toggleAdvert() {
    advertSwitch = !advertSwitch;
    update();

    _updateSettings(
      {"advert_display_enabled": advertSwitch},
      onRollback: () {
        advertSwitch = !advertSwitch;
        update();
      },
    );
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

    _updateSettings(
      {"ioniser_enabled": ioniserSwitch},
      onRollback: () {
        ioniserSwitch = !ioniserSwitch;
        update();
      },
    );
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
    if (boxConnectionStatus) {
      boxConnectionStatus = false;
      update();
      _syncConnectionStatusToManagement(false);
      _disconnectBoxCall(onRollback: () {
        boxConnectionStatus = true;
        update();
        _syncConnectionStatusToManagement(true);
      });
    } else {
      boxConnectionStatus = true;
      update();
      _syncConnectionStatusToManagement(true);
      _connectBoxCall(onRollback: () {
        boxConnectionStatus = false;
        update();
        _syncConnectionStatusToManagement(false);
      });
    }
  }

  void _syncConnectionStatusToManagement(bool isConnected) {
    try {
      final boxManagementController = Get.find<BoxManagementController>();
      final index = boxManagementController.boxes
          .indexWhere((element) => element.id == boxId);
      if (index != -1) {
        if (boxInfo != null) {
          boxManagementController.boxes[index] =
              boxInfo!.copyWith(isConnected: isConnected);
        } else {
          boxManagementController.boxes[index] = boxManagementController
              .boxes[index]
              .copyWith(isConnected: isConnected);
        }
        boxManagementController.update();
      }
    } catch (_) {}
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

    final renderBox =
        indicatorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => OverlayBluetoothMenuWidget(
          offset: offset, size: size, onClose: removeOverlay),
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

    final renderBox =
        batteryKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final double overlayLeft = offset.dx;
    final double overlayTop =
        offset.dy - MediaQuery.of(context).size.height * 0.35;

    final overlayOffset = Offset(overlayLeft, overlayTop);

    _batteryOverlayEntry = OverlayEntry(
      builder: (context) => OverlayBatteryMenuWidget(
          offset: overlayOffset, size: size, onClose: removeBatteryOverlay),
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
  CountdownController countdownController =
      CountdownController(autoStart: true);

  /// ON COUNTDOWN FINISHED
  void onCountdownFinished() {
    isTimerCompleted = true;
    update();
  }

  /// ON RESEND
  void onResendCode() async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      final success = await Get.find<BoxManagementController>()
          .sendBoxOtp(boxId, action: currentAction);
      if (success) {
        countdownController.restart();
        isTimerCompleted = false;
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  /// ON VERIFY OTP
  Future<void> verifyOtp() async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      final success = await Get.find<BoxManagementController>().verifyBoxOtp(
        boxId,
        otpController.text,
        action: currentAction,
      );
      if (success) {
        Navigation.pop();
        fetchBoxDetails();
      }
    } finally {
      isLoading = false;
      update();
    }
  }
}
