import 'package:flutter/material.dart';
import 'package:grubpac_driver/core/utils/constants.dart';

class DarkThemeColors {
  static const Color primary = Color(0xFFFE5720);
  static const Color background = Colors.black;

  //
  static const Color contentNeutralSecondary = Color(0xFFC1C7C4);
  static const Color contentNeutralLight = Color(0xFF506157);
  static const Color backgroundBrandSecondary = Color(0xFF551B0C);
  static const Color contentBrandDefault = Color(0xFF87928B);
  static const Color backgroundNeutralSecondary = Color(0xFF1F3328);
  static const Color strokeBrandPrimary = Color(0xFF5CA940);
  static const Color contentBrandActive = Color(0xFFAD260B);
  static const Color contentOnPrimary = Color(0xFFFFFFFF);
  static const Color primaryButtonDisabled = Color(0xFF6B7971);
  static const Color contentBrandDisabled = Color(0xFF37493F);
  static const Color contentBrandActiveAlt = Color(0xFF95C680);
  static const Color backgroundBrandSecondaryAlt = Color(0xFF233E18);
  static const Color commonColor = Colors.white;
  static const Color strokeBrandPrimaryAlt = Color(0xFFE44421);
  static const Color contentBrandPrimary = Color(0xFFEB603B);
  static const Color contentBrandPrimaryGreen = Color(0xFF70B256);
  static const Color colorTransparentBlue = Color(0xFF1A9CD6);
  static const Color colorTransparentWarm = Color(0xFFF99D20);
  static const Color colorTransparentHot = Color(0xFFDF221C);
  static const Color backgroundBrandSecondaryYellow = Color(0xFF5B401C);
  static const Color bgBrandSecondaryYellow = Color(0xFF8A5F24);
  static const Color contentBrandPrimaryYellow = Color(0xFFF7B65F);
  static const Color contentNeutralPrimary = Color(0xFFFFFFFF);
  static const Color contentBrandSecondary = Color(0xFF661A00);
  static const Color strokeBrandPrimaryYellow = Color(0xFFF4AD49);
  static const Color strokeInteractiveNeutralDefault = Color(0xFF6B7971);
  static const Color strokeInteractiveBrandDisabled = Color(0xFF37493F);
  static const Color loginGreyBox = Color(0xFFD9D9D9);
  static const Color contentBrandSecondaryOrange = Color(0xFF982701);
  static const Color bgBrandPrimary = Color(0xFF79867E);
  static const Color contentBrandPrimaryOrange = Color(0xFFFE6634);
  static const Color bgBrandSecondaryRed = Color(0xFF80220D);
  static const Color bgBrandSecondaryGreen = Color(0xFF2F5D1E);
  static const Color strokeInteractiveBrand = Color(0xFFCB3301);
  static const Color strokeInteractiveBrandDefault = Color(0xFFF0A433);
  static const Color pressedTextBtnColor = Color(0xFF37483E);
  static const Color pressedTextBtnText = Color(0xFFA5ACA6);
  static const Color disabledTextButton = Color(0xFF061E13);
  static const Color disabledTextColor = Color(0xFF37483E);
  static const Color brandPrimaryButtonDisabled = Color(0xFF061E12);
  static const Color pressedPrimaryButton = Color(0xFF982701);
  static const Color pressedPrimaryButtonBorder = Color(0xFFFE480B);
  static const Color outlinedButtonDisabled = Color(0xFF061E12);
  static const Color strokeInteractiveBrandActiveGreen = Color(0xFF506157);
  static const Color boxGreyBorder = Color(0xFF6B7971);
  static const Color contentNeutralLightGrey = Color(0xFFA4ACA7);
  static const Color pressedIconColor = Color(0xFFFE8D67);

  static final darkTheme = ThemeData(
    colorScheme:
        ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.dark),
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    fontFamily: FontFamily.inter,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent),
    useMaterial3: false,
  );
}
