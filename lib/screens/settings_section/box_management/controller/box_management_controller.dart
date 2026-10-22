import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/exceptions/failure.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_repo.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';

import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/preference/pref_key.dart';

import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../common_components/grublock_bottom_sheet.dart';
import '../../../box_details/controller/box_details_controller.dart';
import '../../../../data/auth/session_manager.dart';

class BoxManagementController extends GetxController
    with WidgetsBindingObserver {
  final BoxManagementRepo boxRepo;
  BoxManagementController({required this.boxRepo});
  final PageController pageController = PageController();
  bool isLoading = false;
  String phone = "";
  String countryCode = "";

  int currentPage = 0;
  bool loadingBoxes = false;
  String? boxLoadError;
  int extTemp = 23;

  // ── Simulator Heartbeat (Isolated Integration) ──────────────────────────────────
  static const bool _enableSimulatorHeartbeat = kDebugMode;
  Timer? _simulatorHeartbeatTimer;
  bool _heartbeatInProgress = false;
  bool _appIsActive = true;

  @override
  void onInit() {
    phone = AppPreference.getString(PrefKey.phone);
    countryCode = AppPreference.getString(PrefKey.countryCode);
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    if (_enableSimulatorHeartbeat) {
      _startGlobalSimulatorHeartbeat();
    }
  }

  @override
  void onClose() {
    _simulatorHeartbeatTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appIsActive = state == AppLifecycleState.resumed;
  }

  List<BoxInfo> boxes = <BoxInfo>[];

  Future<void> fetchBoxes({bool isRefresh = true}) async {
    try {
      if (isRefresh || boxes.isEmpty) {
        loadingBoxes = true;
        boxLoadError = null;
        update();
        var res = await boxRepo.getBoxList();
        if (res.statusCode == 200) {
          var boxList = <BoxInfo>[];
          for (var item in res.body['data']) {
            boxList.add(BoxInfo.fromJson(item));
          }
          boxes.clear();
          boxes.addAll(boxList);
        } else {
          throw Failure(
              message: res.body['message'] ?? res.body['error'], response: res);
        }
      }
    } catch (e) {
      boxLoadError = e is Failure ? e.message : AppString.somethingWentWrong;
      AppUtils.apiErrorHandler(e);
    } finally {
      loadingBoxes = false;
      update();
    }
  }

  Future<void> addNewBox(String displayId) async {
    try {
      isLoading = true;
      update();
      var res = await boxRepo.registerbox(displayId);
      if (res.statusCode == 200 || res.statusCode == 201) {
        var box = BoxInfo.fromJson(res.body['data']);
        boxes = [...boxes, box];
        update();
        AppToast.showSuccess(message: AppString.boxAddedSuccess);
        Navigation.pop(data: {"result": true});
      } else {
        throw Failure(
            message:
                res.body['message'] ?? res.body['error'] ?? "Failed to add box",
            response: res);
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
    } finally {
      isLoading = false;
      update();
    }
  }

  /// GO TO PREVIOUS
  void goToPreviousBox() {
    if (currentPage > 0) {
      currentPage--;
      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      update();
    }
  }

  /// GO TO NEXT
  void goToNextBox() {
    if (currentPage < boxes.length - 1) {
      currentPage++;
      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      update();
    }
  }

  /// ON PAGE CHANGED
  void onPageChanged(int index) {
    currentPage = index;
    update();
  }

  /// LOGS
  void onLogsTap() {
    if (boxes.isEmpty || currentPage >= boxes.length) return;
    final box = boxes[currentPage];
    Navigation.pushNamed(RouteHelper.alerts, arg: {
      'box_id': box.id,
      'box_name': box.name.isNotEmpty ? box.name : box.boxDisplayId
    });
  }

  /// ADD BOX
  void onAddBoxTap() => Navigation.pushNamed(RouteHelper.scanBox);

  /// CONNECT BOX
  void onConnectBoxTap(String boxId) {
    final box = boxes.firstWhere(
      (b) => b.id == boxId,
      orElse: () => BoxInfo(id: '', boxDisplayId: ''),
    );
    Navigation.pushNamed(
      RouteHelper.connectBoxInstructions,
      arg: {
        "is_from": ConnectBoxFrom.fromBoxManagement,
        "box_id": boxId,
        "box_display_id": box.boxDisplayId,
      },
    );
  }

  /// CONNECT BOX API
  Future<bool> connectBox(String boxId) async {
    try {
      isLoading = true;
      update();
      var res = await boxRepo.connectBox(boxId);
      if (res.statusCode == 200) {
        fetchBoxes();
        return true;
      } else {
        throw Failure(
            message: res.body['message'] ??
                res.body['error'] ??
                'Failed to connect box',
            response: res);
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  /// REMOVE BOX
  void onRemoveBoxTap(String boxId) {
    final box = boxes.firstWhere(
      (b) => b.id == boxId,
      orElse: () => BoxInfo(id: '', boxDisplayId: ''),
    );
    Navigation.pushNamed(RouteHelper.removeBox, arg: {
      "is_from": ConnectBoxFrom.fromBoxManagement,
      "box_id": boxId,
      "box_display_id": box.boxDisplayId,
    });
  }

  /// DISCONNECT BOX
  void onDisconnectBoxTap(String boxId, String displayName) {
    Navigation.pushNamed(RouteHelper.disconnectBox, arg: {
      "is_from": ConnectBoxFrom.fromBoxManagement,
      "box_id": boxId,
      "displayName": displayName,
    });
  }

  /// DISCONNECT BOX API
  Future<bool> disconnectBox(String boxId) async {
    try {
      isLoading = true;
      update();
      var res = await boxRepo.disconnectBox(boxId);
      if (res.statusCode == 200) {
        fetchBoxes();
        return true;
      } else {
        throw Failure(
            message: res.body['message'] ??
                res.body['error'] ??
                'Failed to disconnect box',
            response: res);
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> removeBox(String boxId) async {
    try {
      isLoading = true;
      update();
      var res = await boxRepo.removeBox(boxId);
      if (res.statusCode == 200) {
        boxes.removeWhere((box) => box.id == boxId);
        AppToast.showSuccess(message: AppString.boxRemoved);
        Navigation.pop(data: {"result": true});
      } else {
        throw Failure(
            message: res.body['message'] ??
                res.body['error'] ??
                'Failed to remove box',
            response: res);
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
    } finally {
      isLoading = false;
      update();
    }
  }

  /// VIEW DETAILS BOX
  void onViewDetailsBoxTap(String boxId) =>
      Navigation.pushNamed(RouteHelper.boxDetails, arg: {"box_id": boxId});

  Future<bool> setBoxLock(String boxId, String action) async {
    try {
      isLoading = true;
      update();
      final res = await boxRepo.setBoxLock(boxId, action);
      if (res.statusCode == 200 || res.statusCode == 201) {
        final check = await boxRepo.getBoxDetail(boxId);
        if (check.statusCode != 200 ||
            check.body is! Map ||
            check.body['data'] is! Map ||
            check.body['data']['is_locked'] != (action == 'lock')) {
          throw Failure(
              message:
                  'Box lock state could not be confirmed. Refresh before retrying.',
              response: check);
        }
        AppToast.showSuccess(
          message: res.body is Map && res.body['message'] != null
              ? res.body['message']
              : 'Box ${action == 'lock' ? 'locked' : 'unlocked'} successfully',
        );
        fetchBoxes(isRefresh: true);
        if (Get.isRegistered<BoxDetailsController>()) {
          final detailsController = Get.find<BoxDetailsController>();
          if (detailsController.boxId == boxId) {
            detailsController.fetchBoxDetails();
          }
        }
        return true;
      }
      throw Failure(
        message: res.statusText ?? 'Failed to $action box',
        response: res,
      );
    } catch (e) {
      AppUtils.apiErrorHandler(e);
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> onLockTap(BuildContext context, String boxId) async {
    if (isLoading) return;
    final boxIndex = boxes.indexWhere((b) => b.id == boxId);
    if (boxIndex == -1) return;
    final box = boxes[boxIndex];
    final action = box.isLocked ? 'unlock' : 'lock';

    final session =
        Get.isRegistered<SessionManager>() ? Get.find<SessionManager>() : null;
    if (session?.isHandler == true) {
      isLoading = true;
      update();
      try {
        final res = await boxRepo.apiClient
            .postData('boxes/$boxId/otp-lock', {'action': action});
        if (res.statusCode != 200 && res.statusCode != 201) {
          throw Failure(
              message: res.statusCode == 404
                  ? 'Box access verification is currently unavailable. Contact your facility.'
                  : 'Unable to request box access verification. Please try again.',
              response: res);
        }
        AppToast.showSuccess(
            message:
                'Verification request accepted. Contact your facility to complete box access.');
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
            e is Failure ? e.message : 'Unable to request box access verification. Please try again.')));
        }
      } finally {
        isLoading = false;
        update();
      }
      return;
    }

    // Owner uses Force / Grublock (no OTP)
    await GrubLockBottomSheet.show(
      context: context,
      isLocked: box.isLocked,
      onConfirm: () async {
        return await setBoxLock(boxId, action);
      },
    );
  }

  // ── Simulator Global Heartbeat Polling Loop ──────────────────────────────────────────
  void _startGlobalSimulatorHeartbeat() async {
    _simulatorHeartbeatTimer?.cancel();
    _simulatorHeartbeatTimer =
        Timer.periodic(const Duration(seconds: 4), (timer) async {
      if (!_appIsActive || boxes.isEmpty || isLoading || _heartbeatInProgress) {
        return;
      }
      _heartbeatInProgress = true;

      try {
        final activeBoxes = List<BoxInfo>.from(boxes);
        for (var box in activeBoxes) {
          try {
            final res = await boxRepo.getSimulatorHealth(box.id);
            if (res.statusCode == 200) {
              final data = res.body['data'];
              if (data != null) {
                final updatedBox = BoxInfo.fromJson(data);

                // Update box in BoxManagementController list
                final index =
                    boxes.indexWhere((element) => element.id == box.id);
                BoxInfo? mergedBox;
                if (index != -1) {
                  mergedBox = boxes[index].copyWith(
                    isConnected: updatedBox.isConnected,
                    batteryLevel: updatedBox.batteryLevel,
                    isLocked: updatedBox.isLocked,
                    zone1Temp: updatedBox.zone1Temp,
                    zone2Temp: updatedBox.zone2Temp,
                    extTemp: updatedBox.extTemp,
                    connectionStatus: updatedBox.connectionStatus,
                    powerStatus: updatedBox.powerStatus,
                    healthStatus: updatedBox.healthStatus,
                    battery1Level: updatedBox.battery1Level,
                    battery2Level: updatedBox.battery2Level,
                    gpsAvailable: updatedBox.gpsAvailable,
                    latitude: updatedBox.latitude,
                    longitude: updatedBox.longitude,
                    solarPanel: updatedBox.solarPanel,
                    port220V110V: updatedBox.port220V110V,
                    memoryCardUsed: updatedBox.memoryCardUsed,
                    gyroSensor: updatedBox.gyroSensor,
                    turnSignals: updatedBox.turnSignals,
                    isDualZone: updatedBox.isDualZone,
                    settings: updatedBox.settings,
                    isDriverConnected: updatedBox.isDriverConnected,
                    bluetoothAvailable: updatedBox.bluetoothAvailable,
                    wifiConnected: updatedBox.wifiConnected,
                    driverId: updatedBox.driverId,
                    connectedUser: updatedBox.connectedUser,
                  );
                  boxes[index] = mergedBox;
                }

                final targetBox = mergedBox ?? updatedBox;

                // If BoxDetailsController is registered and viewing this box, sync detailed view UI
                if (Get.isRegistered<BoxDetailsController>()) {
                  final detailsController = Get.find<BoxDetailsController>();
                  if (detailsController.boxId == box.id &&
                      !detailsController.hasPendingSettings) {
                    detailsController.boxInfo = targetBox;
                    detailsController.advertSwitch =
                        targetBox.settings?.advertDisplayEnabled ?? false;
                    detailsController.dualZoneSwitch =
                        targetBox.settings?.isDualZone ?? false;
                    detailsController.ioniserSwitch =
                        targetBox.settings?.ioniserEnabled ?? false;
                    if (!detailsController.hasPendingTemperatureChanges) {
                      detailsController.firstBattery =
                          targetBox.settings?.zone1Temp ?? 0;
                      detailsController.secondBattery =
                          targetBox.settings?.zone2Temp ?? 0;
                    }
                    detailsController.boxConnectionStatus =
                        targetBox.isConnected;
                    detailsController.zoneBox1Switch =
                        targetBox.settings?.zone1Status ?? true;
                    detailsController.zoneBox2Switch =
                        targetBox.settings?.zone2Status ?? false;

                    detailsController.sliderController.value =
                        AppUtils.normalizeSliderValue(
                      detailsController.selectedBattery == 1
                          ? detailsController.firstBattery.toDouble()
                          : detailsController.secondBattery.toDouble(),
                    );
                    detailsController.update();
                  }
                }
              }
            }
          } catch (e) {
            debugPrint(
                "Simulator global health sync error for box ${box.id}: $e");
          }
        }
        update();
      } finally {
        _heartbeatInProgress = false;
      }
    });
  }
}
