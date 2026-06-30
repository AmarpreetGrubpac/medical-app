import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/preference/pref_key.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/home_section/home/widgets/home_grublock_bottom_sheet.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_details_controller.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';
import 'package:timer_count_down/timer_controller.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => onInitMethod());
  }

  void onInitMethod() {
    phone = AppPreference.getString(PrefKey.phone);
    countryCode = AppPreference.getString(PrefKey.countryCode);
    // Get.find<ProfileDetailsController>().getProfileData();
    update();
  }

  String phone = "";
  String countryCode = "";
  String username = "";
  String currentBoxId = "";
  String currentAction = "unlock";

  /// USERNAME
  void getUserName() {
    username = AppPreference.getString(PrefKey.name);
    update();
  }

  /// MANAGE
  void onManageTap() => Navigation.pushNamed(RouteHelper.boxManagement);

  /// ADD BOX
  void onAddBoxTap() => Navigation.pushNamed(RouteHelper.scanBox);

  /// CONNECT
  void onConnectTap(String boxId) {
    Navigation.pushNamed(RouteHelper.connectBoxInstructions,
        arg: {"is_from": ConnectBoxFrom.fromHome, "box_id": boxId});
  }

  /// VIEW DETAILS
  void onViewDetailTap(String boxId) =>
      Navigation.pushNamed(RouteHelper.boxDetails, arg: {"box_id": boxId});

  /// DISCONNECT — delegates to BoxManagementController
  Future<void> onDisconnectTap(String boxId, String displayName) async {
    final data = await Navigation.pushNamed(
      RouteHelper.disconnectBox,
      arg: {
        "is_from": ConnectBoxFrom.fromHome,
        "box_id": boxId,
        "displayName": displayName,
      },
    );
    if (data != null && data["result"] == true) {
      update();
    }
  }

  ///=====
  bool isTimerCompleted = false;
  bool isLoading = false;

  TextEditingController otpController = TextEditingController();
  CountdownController countdownController =
      CountdownController(autoStart: true);

  /// GRUBLOCK
  Future<void> onLockTap(BuildContext context, String boxId) async {
    if (isLoading) return;
    otpController.clear();
    currentBoxId = boxId;

    final boxCtrl = Get.find<BoxManagementController>();
    final box = boxCtrl.boxes.firstWhere((b) => b.id == boxId);
    currentAction = box.isLocked ? "unlock" : "lock";

    // Call the sendBoxOtp function in parallel (not awaited)
    Get.find<BoxManagementController>()
        .sendBoxOtp(boxId, action: currentAction);

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
              child: homeGrublockBottomSheet(context),
            ),
          ],
        );
      },
    );
  }

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
          .sendBoxOtp(currentBoxId, action: currentAction);
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
        currentBoxId,
        otpController.text,
        action: currentAction,
      );
      if (success) {
        Navigation.pop();
        Get.find<BoxManagementController>().fetchBoxes(isRefresh: true);
      }
    } finally {
      isLoading = false;
      update();
    }
  }
}
