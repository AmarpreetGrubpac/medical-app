import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/preference/pref_key.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_details_controller.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';

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
    final boxCtrl = Get.find<BoxManagementController>();
    final box = boxCtrl.boxes.firstWhere(
      (b) => b.id == boxId,
      orElse: () => BoxInfo(id: '', boxDisplayId: ''),
    );
    Navigation.pushNamed(
      RouteHelper.connectBoxInstructions,
      arg: {
        "is_from": ConnectBoxFrom.fromHome,
        "box_id": boxId,
        "box_display_id": box.boxDisplayId,
      },
    );
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

  bool isLoading = false;

  /// GRUBLOCK
  Future<void> onLockTap(BuildContext context, String boxId) async {
    if (isLoading) return;
    isLoading = true;
    update();
    try {
      await Get.find<BoxManagementController>().onLockTap(context, boxId);
    } finally {
      isLoading = false;
      update();
    }
  }
}
