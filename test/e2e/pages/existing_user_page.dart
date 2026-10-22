import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/common_components/common_textfield.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/screens/auth/view/existing_user.dart';

/// Page Object for Existing User Password Screen.
class ExistingUserPage {
  final WidgetTester tester;
  ExistingUserPage(this.tester);

  Finder get screenFinder => find.byType(ExistingUserScreen);
  Finder get passwordFieldFinder => find.widgetWithText(CommonTextField, AppString.password);
  Finder get continueBtnFinder => find.widgetWithText(CommonButton, AppString.continueBtn);

  void verifyVisible() {
    expect(screenFinder, findsOneWidget);
  }

  Future<void> enterPassword(String password) async {
    final textField = find.descendant(
      of: passwordFieldFinder,
      matching: find.byType(TextField),
    );
    await tester.enterText(textField, password);
    await tester.pump();
  }

  Future<void> tapContinue() async {
    await tester.tap(continueBtnFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }
}
