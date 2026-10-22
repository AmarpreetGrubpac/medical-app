import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grubpac_driver/common_components/common_bottom_box.dart';
import 'package:grubpac_driver/common_components/common_log_out_button.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/screens/settings_section/setting/view/setting_screen.dart';

/// Page Object for SettingScreen.
class SettingsPage {
  final WidgetTester tester;
  SettingsPage(this.tester);

  Finder get settingsFinder => find.byType(SettingScreen);
  Finder get logoutButtonFinder => find.byType(CommonLogOutButton);
  Finder get themeBoxFinder => find.byType(CommonBottomBox);
  Finder get boxManagementFinder => find.text(AppString.boxManagement);
  Finder get profileDetailFinder => find.text(AppString.profileDetail);

  void verifyVisible() {
    expect(settingsFinder, findsOneWidget);
  }

  Future<void> tapLogout() async {
    await tester.tap(logoutButtonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> tapThemeToggle() async {
    final toggleBtn = find.descendant(
      of: themeBoxFinder,
      matching: find.byType(GestureDetector),
    );
    await tester.tap(toggleBtn.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }
}
