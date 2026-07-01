import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:grubpac_driver/core/exceptions/failure.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_repo.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/widget/management_grublock_bottom_sheet.dart';

import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/preference/pref_key.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/app_utils.dart';

class BoxManagementController extends GetxController {
  final BoxManagementRepo boxRepo;
  BoxManagementController({required this.boxRepo});
  final PageController pageController = PageController();
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  bool isTimerCompleted = false;
  String currentAction = "unlock";
  String currentBoxId = "";
  String phone = "";
  String countryCode = "";
  final CountdownController countdownController =
      CountdownController(autoStart: true);

  int currentPage = 0;
  bool loadingBoxes = false;
  @override
  void onInit() {
    phone = AppPreference.getString(PrefKey.phone);
    countryCode = AppPreference.getString(PrefKey.countryCode);
    super.onInit();
  }

  List<BoxInfo> boxes = <BoxInfo>[];

  void fetchBoxes({bool isRefresh = true}) async {
    try {
      if (isRefresh || boxes.isEmpty) {
        loadingBoxes = true;
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
  void onLogsTap() => Navigation.pushNamed(RouteHelper.alerts);

  /// ADD BOX
  void onAddBoxTap() => Navigation.pushNamed(RouteHelper.scanBox);

  /// CONNECT BOX
  void onConnectBoxTap(String boxId) {
    Navigation.pushNamed(
      RouteHelper.connectBoxInstructions,
      arg: {
        "is_from": ConnectBoxFrom.fromBoxManagement,
        "box_id": boxId,
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
    Navigation.pushNamed(RouteHelper.removeBox,
        arg: {"is_from": ConnectBoxFrom.fromBoxManagement, "box_id": boxId});
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

  Future<OtpDetails> sendBoxOtp(String boxId,
      {String action = "unlock"}) async {
    try {
      isLoading = true;
      update();
      var res = await boxRepo.getBoxOtp(boxId, action: action);
      if (res.statusCode == 200) {
        AppToast.showSuccess(
            message: res.body['message'] ?? "OTP sent successfully");
        return OtpDetails.fromJson(res.body['data']['otp_details'],
            status: true);
      } else {
        throw Failure(
            message: res.body['message'] ??
                res.body['error'] ??
                'Failed to send OTP',
            response: res);
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
      return OtpDetails();
    } finally {
      isLoading = false;
      update();
    }
  }

  /// ON VERIFY OTP

  Future<bool> verifyBoxOtp(String boxId, String otp,
      {String action = "lock"}) async {
    try {
      isLoading = true;
      update();
      var res = await boxRepo.verifyBoxOtp(
        boxId,
        otp,
        action,
      );
      if (res.statusCode == 200) {
        AppToast.showSuccess(
            message: res.body['message'] ?? "OTP verified successfully");
        fetchBoxes();
        return true;
      } else {
        throw Failure(
            message: res.body['message'] ??
                res.body['error'] ??
                'Failed to verify OTP',
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

  void onCountdownFinished() {
    isTimerCompleted = true;
    update();
  }

  void onResendCode() async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      final OtpDetails success =
          await sendBoxOtp(currentBoxId, action: currentAction);
      if (success.status) {
        countdownController.restart();
        isTimerCompleted = false;
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> onLockTap(BuildContext context, String boxId) async {
    if (isLoading) return;
    otpController.clear();
    currentBoxId = boxId;

    final box = boxes.firstWhere((b) => b.id == boxId);
    currentAction = box.isLocked ? "unlock" : "lock";

    isLoading = true;
    update();

    try {
      var res = await sendBoxOtp(boxId, action: currentAction);

      isTimerCompleted = false;
      countdownController.restart();

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.05),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: managementGrublockBottomSheet(context, res),
              ),
            ],
          );
        },
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> verifyOtp() async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      final success = await verifyBoxOtp(
        currentBoxId,
        otpController.text,
        action: currentAction,
      );
      if (success) {
        Navigation.pop();
      }
    } finally {
      isLoading = false;
      update();
    }
  }
}
