import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/common_components/common_textfield.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/screens/auth/view/login_screen.dart';

/// Page Object for Login Screen.
/// Encapsulates locators and user actions according to POM pattern.
class LoginPage {
  final WidgetTester tester;
  LoginPage(this.tester);

  Finder get loginScreenFinder => find.byType(LoginScreen);
  Finder get inputFieldFinder => find.byType(CommonTextField);
  Finder get continueBtnFinder => find.widgetWithText(CommonButton, AppString.continueBtn);
  Finder get demoBtnFinder => find.text('EXPLORE DEMO MODE');
  Finder get liveBtnFinder => find.text('SWITCH TO LIVE LOGIN');
  Finder get demoBadgeFinder => find.text('Demo Mode Active');

  void verifyVisible() {
    expect(loginScreenFinder, findsOneWidget);
  }

  Future<void> enterIdentifier(String text) async {
    final textField = find.descendant(
      of: inputFieldFinder,
      matching: find.byType(TextField),
    );
    await tester.enterText(textField, text);
    await tester.pump();
  }

  Future<void> tapContinue() async {
    await tester.tap(continueBtnFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  Future<void> toggleDemoMode() async {
    final finder = find.byWidgetPredicate((widget) {
      if (widget is Text) {
        return widget.data == 'EXPLORE DEMO MODE' ||
            widget.data == 'SWITCH TO LIVE LOGIN';
      }
      return false;
    });
    await tester.tap(finder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  void assertDemoModeActive() {
    expect(demoBadgeFinder, findsOneWidget);
    expect(liveBtnFinder, findsOneWidget);
  }

  void assertDemoModeInactive() {
    expect(demoBadgeFinder, findsNothing);
    expect(demoBtnFinder, findsOneWidget);
  }

  void assertContinueDisabled() {
    final button = tester.widget<CommonButton>(continueBtnFinder);
    expect(button.isDisabled, isTrue);
  }

  void assertContinueEnabled() {
    final button = tester.widget<CommonButton>(continueBtnFinder);
    expect(button.isDisabled, isFalse);
  }
}
