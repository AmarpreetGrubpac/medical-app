import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/screens/help_section/help/view/help_screen.dart';
import 'package:grubpac_driver/screens/home_section/home/view/home_screen.dart';
import 'package:grubpac_driver/screens/settings_section/setting/view/setting_screen.dart';

class DashboardController extends GetxController {
  int selectedIndex = 0;

  final List<Widget> screens = [HomeScreen(), SettingScreen(), HelpScreen()];

  void onTabChanged(int index) {
    selectedIndex = index;
    update();
  }
}
