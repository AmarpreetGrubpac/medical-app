import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/preference/pref_key.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/dashboard/controller/dashboard_controller.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_details_controller.dart';

class SettingController extends GetxController {
  bool isDark = Get.isDarkMode;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => getUserName());
    Get.find<ProfileDetailsController>().getProfileData();
  }

  String username = "";

  /// ON CHANGE THEME
  // void onChangeTheme() {
  //   Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
  //   AppPreference.setString(PrefKey.theme, Get.isDarkMode ? "light" : "dark");
  //
  //   Get.find<DashboardController>().update();
  //   update();
  // }
  void onChangeTheme() {
    isDark = !isDark;

    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    AppPreference.setString(PrefKey.theme, isDark ? "dark" : "light");
    Get.find<DashboardController>().update();
    update(); // rebuild UI
  }
  /// BOX MANAGEMENT
  void onBoxManagementTap() => Navigation.pushNamed(RouteHelper.boxManagement);

  /// USERNAME
  void getUserName() {
    username = AppPreference.getString(PrefKey.name);
    update();
  }

  /// PROFILE
  Future<void> onProfileTap() async {
    await Navigation.pushNamed(RouteHelper.profileDetails);
    getUserName();
  }

  /// ALERT
  void onAlertTap() => Navigation.pushNamed(RouteHelper.alerts);
}
