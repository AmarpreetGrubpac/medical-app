import 'dart:async';
import '../../help_section/help/view/help_screen.dart';

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
import 'package:grubpac_driver/screens/box_details/widgets/overlay_battery_menu.dart';
import 'package:grubpac_driver/screens/box_details/widgets/overlay_indicator_menu.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_repo.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';
import 'package:interactive_slider/interactive_slider.dart';

import '../../settings_section/box_management/controller/box_management_controller.dart';

class BoxDetailsController extends GetxController {
  final BoxManagementRepo boxRepo = Get.find<BoxManagementRepo>();
  String boxId = "";
  BoxInfo? boxInfo;
  Timer? _debounceTimer;
  bool _temperatureWritePending = false;
  final Set<String> _pendingSettings = {};
  bool get hasPendingSettings =>
      _pendingSettings.isNotEmpty || hasPendingTemperatureChanges;
  final Map<int, int> _temperatureDrafts = {};
  final Map<int, int> _previousTargets = {};
  bool get hasPendingTemperatureChanges =>
      _temperatureWritePending || _temperatureDrafts.isNotEmpty;
  bool get canEditSelectedTarget =>
      !_temperatureWritePending &&
      (selectedBattery == 1 || !dualZoneSwitch
              ? boxInfo?.settings?.zone1Temp
              : boxInfo?.settings?.zone2Temp) !=
          null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    int initialPage = 0;
    if (args != null && args['page'] != null) {
      initialPage = args['page'] as int;
      currentPage = initialPage;
    }
    pageController = PageController(initialPage: initialPage);
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

      if (boxId.isNotEmpty) {
        fetchBoxDetails();
      }
      if (args['page'] != null) {
        int initialPage = args['page'] as int;
        if (pageController.hasClients) {
          pageController.jumpToPage(initialPage);
        }
      }
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
        firstBattery = boxInfo?.settings?.zone1Temp ?? 0;
        secondBattery = boxInfo?.settings?.zone2Temp ?? 0;
        boxConnectionStatus = boxInfo?.isConnected ?? false;
        zoneBox1Switch = boxInfo?.settings?.zone1Status ?? true;
        zoneBox2Switch = boxInfo?.settings?.zone2Status ?? false;

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

  Future<bool> _updateSettings(
    Map<String, dynamic> changes, {
    required VoidCallback onRollback,
  }) async {
    _pendingSettings.addAll(changes.keys);
    try {
      if (boxId.isEmpty) throw StateError("No box selected");
      final res = await boxRepo.updateBoxSettings(boxId, changes);
      if (res.statusCode != 200) {
        throw Failure(
          message: res.body['message'] ??
              res.body['error'] ??
              'Failed to update settings',
          response: res,
        );
      }
      return true;
    } catch (e) {
      onRollback();
      AppUtils.apiErrorHandler(e);
      return false;
    } finally {
      _pendingSettings.removeAll(changes.keys);
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

  void _changeTarget(int value) {
    // Match the existing slider bounds. Medical operating limits still require
    // server-side validation and an agreed facility policy.
    if (value < -20 || value > 70) {
      AppToast.showError(
          message: 'Choose a temperature between -20 and 70 degrees Celsius.');
      return;
    }
    if (!canEditSelectedTarget) {
      AppToast.showError(
          message:
              'Target temperature is unavailable or a change is pending. Refresh and try again.');
      return;
    }
    final zone = selectedBattery == 1 || !dualZoneSwitch ? 1 : 2;
    _previousTargets.putIfAbsent(
        zone, () => zone == 1 ? firstBattery : secondBattery);
    _temperatureDrafts[zone] = value;
    if (zone == 1) {
      firstBattery = value;
    } else {
      secondBattery = value;
    }
    sliderController.value = AppUtils.normalizeSliderValue(value.toDouble());
    update();
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final changes = {
        for (final entry in _temperatureDrafts.entries)
          'zone_${entry.key}_target_temp': entry.value
      };
      final previous = Map<int, int>.from(_previousTargets);
      _temperatureDrafts.clear();
      _previousTargets.clear();
      _temperatureWritePending = true;
      update();
      final saved = await _updateSettings(changes, onRollback: () {
        if (previous.containsKey(1)) firstBattery = previous[1]!;
        if (previous.containsKey(2)) secondBattery = previous[2]!;
        sliderController.value = AppUtils.normalizeSliderValue(
            (selectedBattery == 1 ? firstBattery : secondBattery).toDouble());
        update();
      });
      _temperatureWritePending = false;
      if (saved && !isClosed) await fetchBoxDetails();
      if (!isClosed) update();
    });
  }

  late final PageController pageController;
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
  void onHelpTap() => Get.to(() => const Scaffold(body: HelpScreen()));

  /// GRUBLOCK
  Future<void> onLockTap(BuildContext context) async {
    if (isLoading) return;
    isLoading = true;
    update();
    try {
      await Get.find<BoxManagementController>().onLockTap(context, boxId);
      await fetchBoxDetails();
    } finally {
      isLoading = false;
      update();
    }
  }

  /// LOGS
  void onLogsTap() => Navigation.pushNamed(
        RouteHelper.alerts,
        arg: {
          "box_id": boxId,
          "box_name": (boxInfo?.name.isNotEmpty == true)
              ? boxInfo!.name
              : (boxInfo?.boxDisplayId ?? ""),
        },
      );

  /// SLIDER CHANGE
  void onSliderChange(double value) {
    if (value.isFinite) _changeTarget(value.round());
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
  void onSelectTempButtons(int value) => _changeTarget(value);

  /// DUAL ZONE
  void toggleDualZone() {
    if (_pendingSettings.contains('is_dual_zone')) return;
    final previous = dualZoneSwitch;
    dualZoneSwitch = !previous;
    selectedBattery = 1;
    sliderController.value =
        AppUtils.normalizeSliderValue(firstBattery.toDouble());
    update();

    _updateSettings(
      {"is_dual_zone": dualZoneSwitch},
      onRollback: () {
        dualZoneSwitch = previous;
        selectedBattery = 1;
        sliderController.value =
            AppUtils.normalizeSliderValue(firstBattery.toDouble());
        update();
      },
    );
  }

  /// ADVERT
  void toggleAdvert() {
    if (_pendingSettings.contains('advert_display_enabled')) return;
    final previous = advertSwitch;
    advertSwitch = !previous;
    update();

    _updateSettings(
      {"advert_display_enabled": advertSwitch},
      onRollback: () {
        advertSwitch = previous;
        update();
      },
    );
  }

  /// ZONE BOX 1
  void toggleZoneBox1() {
    if (_pendingSettings.contains('zone_1_status')) return;
    final previous = zoneBox1Switch;
    zoneBox1Switch = !previous;
    update();
    _updateSettings({'zone_1_status': zoneBox1Switch}, onRollback: () {
      zoneBox1Switch = previous;
      update();
    });
  }

  /// ZONE BOX 2
  void toggleZoneBox2() {
    if (_pendingSettings.contains('zone_2_status')) return;
    final previous = zoneBox2Switch;
    zoneBox2Switch = !previous;
    update();
    _updateSettings({'zone_2_status': zoneBox2Switch}, onRollback: () {
      zoneBox2Switch = previous;
      update();
    });
  }

  /// IONISER
  void toggleIoniserSwitch() {
    if (_pendingSettings.contains('ioniser_enabled')) return;
    final previous = ioniserSwitch;
    ioniserSwitch = !previous;
    update();

    _updateSettings(
      {"ioniser_enabled": ioniserSwitch},
      onRollback: () {
        ioniserSwitch = previous;
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

  bool isLoading = false;
}

// {
//   "connection_status": "weak",
//   "battery_1_level": 14,
//   "battery_2_level"
//   "zone_1_temp": 12,
//   "zone_1_target_temp" :13
//   "zone_2_temp": 38,
//   "zone_2_target_temp" :40
//   "ambient_temp": 35,
//   "is_power_on": false,
//   "bluetooth_available": false,
//   "wifi_connected": false,
//   "cellular_active": false,
//   "zone_1_status": false,
//   "zone_2_status": false,
//   "is_dual_zone": false,
//   "gps_available" :false,
//   "solar_panel" : true,
// "220V/110V_port":true,
// "Memorycard_used": 0.8 (will multiply with 100 for percentage)
// "saveToCard": true,
// "Adas" : true,
// "BoxCam" : true,

// }
