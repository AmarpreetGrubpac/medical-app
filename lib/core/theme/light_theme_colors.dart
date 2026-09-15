import 'package:flutter/material.dart';
import 'package:grubpac_driver/core/utils/constants.dart';

class LightThemeColors {
  static const Color primary = Color(0xFF3D4AFF);
  static const Color background = Color(0xFFFFFFFF);

  //
  static const Color contentNeutralSecondary = Color(0xFF37493F);
  static const Color contentNeutralLight = Color(0xFFA4ACA7);
  static const Color backgroundBrandSecondary = Color(0xFFFFD8CB);
  static const Color contentBrandDefault = Color(0xFF6B7971);
  static const Color backgroundNeutralSecondary = Color(0xFFEFF1F0);
  static const Color strokeBrandPrimary = Color(0xFF5CA940);
  static const Color contentBrandActive = Color(0xFFAD260B);
  static const Color contentOnPrimary = Color(0xFFFFFFFF);
  static const Color primaryButtonDisabled = Color(0xFFE0E3E1);
  static const Color contentBrandDisabled = Color(0xFFC1C7C4);
  static const Color contentBrandActiveAlt = Color(0xFF3B7D24);
  static const Color backgroundBrandSecondaryAlt = Color(0xFFDCECD4);
  static const Color strokeBrandPrimaryAlt = Color(0xFFE44421);
  static const Color contentBrandPrimary = Color(0xFF4753FF);
  static const Color contentBrandPrimaryGreen = Color(0xFF479F29);
  static const Color commonColor = Color(0xFF000000);
  static const Color colorTransparentBlue = Color(0xFF1A9CD6);
  static const Color colorTransparentWarm = Color(0xFFF99D20);
  static const Color colorTransparentHot = Color(0xFFDF221C);
  static const Color backgroundBrandSecondaryYellow = Color(0xFFFFECD7);
  static const Color bgBrandSecondaryYellow = Color(0xFFFFECD7);
  static const Color contentBrandPrimaryYellow = Color(0xFFF0A433);
  static const Color contentNeutralPrimary = Color(0xFF03130A);
  static const Color contentBrandSecondary = Color(0xFFCCCFFF);
  static const Color strokeBrandPrimaryYellow = Color(0xFFF4AD49);
  static const Color strokeInteractiveNeutralDefault = Color(0xFFE0E3E1);
  static const Color strokeInteractiveBrandDisabled = Color(0xFFE0E3E1);
  static const Color loginGreyBox = Color(0xFFD9D9D9);
  static const Color contentBrandSecondaryOrange = Color(0xFFFFD9CC);
  static const Color bgBrandPrimary = Color(0xFF79867E);
  static const Color contentBrandPrimaryOrange = Color(0xFFFE480B);
  static const Color bgBrandSecondaryRed = Color(0xFFFFD8CB);
  static const Color bgBrandSecondaryGreen = Color(0xFFDCECD4);
  static const Color strokeInteractiveBrand = Color(0xFFCB3301);
  static const Color strokeInteractiveBrandDefault = Color(0xFFF0A433);
  static const Color pressedTextBtnColor = Color(0xFFE1E3E0);
  static const Color pressedTextBtnText = Color(0xFF506056);
  static const Color disabledTextButton = Color(0xFFEEF1F0);
  static const Color disabledTextColor = Color(0xFFC1C7C4);
  static const Color brandPrimaryButtonDisabled = Color(0xFFE0E3E1);
  static const Color pressedPrimaryButton = Color(0xFF4753FF);
  static const Color pressedPrimaryButtonBorder = Color(0xFF4753FF);
  static const Color outlinedButtonDisabled = Color(0xFFEFF1F0);
  static const Color strokeInteractiveBrandActiveGreen = Color(0xFF506157);
  static const Color boxGreyBorder = Color(0xFF6B7971);
  static const Color contentNeutralLightGrey = Color(0xFF506157);
  static const Color pressedIconColor = Color(0xFFCB3301);
  static const Color expandedBoxBG = Color(0xFFFFFFFF);

  static final lightTheme = ThemeData(
    colorScheme:
        ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light),
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    fontFamily: FontFamily.inter,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent),
    useMaterial3: false,
  );
}
