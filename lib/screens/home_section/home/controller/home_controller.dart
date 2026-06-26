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
    Get.find<ProfileDetailsController>().getProfileData();
    update();
  }

  String phone = "";
  String countryCode = "";
  String username = "";

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
  Future<void> onDisconnectTap(String boxId) async {
    final data = await Navigation.pushNamed(
      RouteHelper.disconnectBox,
      arg: {
        "is_from": ConnectBoxFrom.fromHome,
        "box_id": boxId,
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
  Future<void> onLockTap(BuildContext context) async {
    otpController.clear();

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
  void onResendCode() {
    countdownController.restart();
    isTimerCompleted = false;
    update();
  }
}
