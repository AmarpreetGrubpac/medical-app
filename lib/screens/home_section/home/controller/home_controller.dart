import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/preference/pref_key.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
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

  int currentPage = 0;

  final PageController pageController = PageController();

  String phone = "";
  String countryCode = "";

  String username = "";

  bool isBoxAdded = true;
  bool isBoxConnected = false;
  bool isBoxLocked = true;

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
  void onConnectTap() {
    Navigation.pushNamed(RouteHelper.connectBoxInstructions,
        arg: {"is_from": ConnectBoxFrom.fromHome});
  }

  /// VIEW DETAILS
  void onViewDetailTap() => Navigation.pushNamed(RouteHelper.boxDetails);

  /// DISCONNECT
  Future<void> onDisconnectTap() async {
    final data = await Navigation.pushNamed(
      RouteHelper.disconnectBox,
      arg: {"is_from": ConnectBoxFrom.fromHome},
    );

    if (data != null && data["result"] == true) {
      isBoxConnected = false;
      update();
    }
  }

  ///
  void onBoxConnected() {
    isBoxAdded = true;
    isBoxConnected = true;
    update();

    Navigation.doublePop();
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
    if (currentPage < 1) {
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

  /// ON VERIFY OTP
  void verify() {
    if (otpController.text == "1111") {
      isLoading = true;
      update();

      Future.delayed(const Duration(seconds: 1), () {
        isLoading = false;
        update();

        AppToast.showSuccess(message: AppString.otpVerify);
        isBoxLocked = false;

        Navigation.pop();
      });
    } else {
      AppToast.showError(
          message: AppString.otpTryAgain, title: AppString.invalidOTP);
    }
  }
}
