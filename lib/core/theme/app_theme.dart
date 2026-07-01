import 'package:flutter/material.dart';
import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/preference/pref_key.dart';
import 'package:grubpac_driver/core/theme/dark_theme_colors.dart';
import 'package:grubpac_driver/core/theme/light_theme_colors.dart';

class AppTheme {
  static ThemeData get light => LightThemeColors.lightTheme;

  static ThemeData get dark => DarkThemeColors.darkTheme;

  static bool get isDark => AppPreference.getString(PrefKey.theme) == "dark";

  static Color get primary =>
      isDark ? DarkThemeColors.primary : LightThemeColors.primary;

  static Color get background =>
      isDark ? DarkThemeColors.background : LightThemeColors.background;

  static Color get contentNeutralSecondary => isDark
      ? DarkThemeColors.contentNeutralSecondary
      : LightThemeColors.contentNeutralSecondary;

  static Color get contentNeutralLight => isDark
      ? DarkThemeColors.contentNeutralLight
      : LightThemeColors.contentNeutralLight;

  static Color get backgroundBrandSecondary => isDark
      ? DarkThemeColors.backgroundBrandSecondary
      : LightThemeColors.backgroundBrandSecondary;

  static Color get contentBrandDefault => isDark
      ? DarkThemeColors.contentBrandDefault
      : LightThemeColors.contentBrandDefault;

  static Color get backgroundNeutralSecondary => isDark
      ? DarkThemeColors.backgroundNeutralSecondary
      : LightThemeColors.backgroundNeutralSecondary;

  static Color get strokeBrandPrimary => isDark
      ? DarkThemeColors.strokeBrandPrimary
      : LightThemeColors.strokeBrandPrimary;

  static Color get contentBrandActive => isDark
      ? DarkThemeColors.contentBrandActive
      : LightThemeColors.contentBrandActive;

  static Color get contentOnPrimary => isDark
      ? DarkThemeColors.contentOnPrimary
      : LightThemeColors.contentOnPrimary;
  static Color get expandedBoxBG => isDark
      ? const Color.fromARGB(255, 1, 14, 7)
      : LightThemeColors.contentOnPrimary;
  static Color get primaryButtonDisabled => isDark
      ? DarkThemeColors.primaryButtonDisabled
      : LightThemeColors.primaryButtonDisabled;

  static Color get contentBrandDisabled => isDark
      ? const Color.fromARGB(255, 116, 127, 121)
      : LightThemeColors.contentBrandDisabled;

  static Color get contentBrandActiveAlt => isDark
      ? DarkThemeColors.contentBrandActiveAlt
      : LightThemeColors.contentBrandActiveAlt;

  static Color get backgroundBrandSecondaryAlt => isDark
      ? DarkThemeColors.backgroundBrandSecondaryAlt
      : LightThemeColors.backgroundBrandSecondaryAlt;

  static Color get contentBrandPrimaryGreen => isDark
      ? DarkThemeColors.contentBrandPrimaryGreen
      : LightThemeColors.contentBrandPrimaryGreen;

  static Color get contentBrandPrimary => isDark
      ? DarkThemeColors.contentBrandPrimary
      : LightThemeColors.contentBrandPrimary;

  static Color get colorTransparentWarm => isDark
      ? DarkThemeColors.colorTransparentWarm
      : LightThemeColors.colorTransparentWarm;

  static Color get colorTransparentBlue => isDark
      ? DarkThemeColors.colorTransparentBlue
      : LightThemeColors.colorTransparentBlue;

  static Color get backgroundBrandSecondaryYellow => isDark
      ? DarkThemeColors.backgroundBrandSecondaryYellow
      : LightThemeColors.backgroundBrandSecondaryYellow;

  static Color get contentBrandPrimaryYellow => isDark
      ? DarkThemeColors.contentBrandPrimaryYellow
      : LightThemeColors.contentBrandPrimaryYellow;

  static Color get contentNeutralPrimary => isDark
      ? DarkThemeColors.contentNeutralPrimary
      : LightThemeColors.contentNeutralPrimary;

  static Color get contentBrandSecondary => isDark
      ? DarkThemeColors.contentBrandSecondary
      : LightThemeColors.contentBrandSecondary;

  static Color get strokeBrandPrimaryYellow => isDark
      ? DarkThemeColors.strokeBrandPrimaryYellow
      : LightThemeColors.strokeBrandPrimaryYellow;

  static Color get strokeInteractiveNeutralDefault => isDark
      ? DarkThemeColors.strokeInteractiveNeutralDefault
      : LightThemeColors.strokeInteractiveNeutralDefault;

  static Color get strokeInteractiveBrandDisabled => isDark
      ? DarkThemeColors.strokeInteractiveBrandDisabled
      : LightThemeColors.strokeInteractiveBrandDisabled;

  static Color get commonColor =>
      isDark ? DarkThemeColors.commonColor : LightThemeColors.commonColor;

  static Color get strokeBrandPrimaryAlt => isDark
      ? DarkThemeColors.strokeBrandPrimaryAlt
      : LightThemeColors.strokeBrandPrimaryAlt;

  static Color get loginGreyBox =>
      isDark ? DarkThemeColors.loginGreyBox : LightThemeColors.loginGreyBox;

  static Color get contentBrandSecondaryOrange => isDark
      ? DarkThemeColors.contentBrandSecondaryOrange
      : LightThemeColors.contentBrandSecondaryOrange;

  static Color get bgBrandPrimary =>
      isDark ? DarkThemeColors.bgBrandPrimary : LightThemeColors.bgBrandPrimary;

  static Color get colorTransparentHot => isDark
      ? DarkThemeColors.colorTransparentHot
      : LightThemeColors.colorTransparentHot;

  static Color get contentBrandPrimaryOrange => isDark
      ? DarkThemeColors.contentBrandPrimaryOrange
      : LightThemeColors.contentBrandPrimaryOrange;

  static Color get bgBrandSecondaryYellow => isDark
      ? DarkThemeColors.bgBrandSecondaryYellow
      : LightThemeColors.bgBrandSecondaryYellow;

  static Color get bgBrandSecondaryRed => isDark
      ? DarkThemeColors.bgBrandSecondaryRed
      : LightThemeColors.bgBrandSecondaryRed;

  static Color get bgBrandSecondaryGreen => isDark
      ? DarkThemeColors.bgBrandSecondaryGreen
      : LightThemeColors.bgBrandSecondaryGreen;

  static Color get strokeInteractiveBrand => isDark
      ? DarkThemeColors.strokeInteractiveBrand
      : LightThemeColors.strokeInteractiveBrand;

  static Color get strokeInteractiveBrandDefault => isDark
      ? DarkThemeColors.strokeInteractiveBrandDefault
      : LightThemeColors.strokeInteractiveBrandDefault;

  static Color get pressedTextBtnColor => isDark
      ? DarkThemeColors.pressedTextBtnColor
      : LightThemeColors.pressedTextBtnColor;

  static Color get pressedTextBtnText => isDark
      ? DarkThemeColors.pressedTextBtnText
      : LightThemeColors.pressedTextBtnText;

  static Color get disabledTextButton => isDark
      ? DarkThemeColors.disabledTextButton
      : LightThemeColors.disabledTextButton;

  static Color get disabledTextColor => isDark
      ? DarkThemeColors.disabledTextColor
      : LightThemeColors.disabledTextColor;

  static Color get brandPrimaryButtonDisabled => isDark
      ? DarkThemeColors.brandPrimaryButtonDisabled
      : LightThemeColors.brandPrimaryButtonDisabled;

  static Color get pressedPrimaryButton => isDark
      ? DarkThemeColors.pressedPrimaryButton
      : LightThemeColors.pressedPrimaryButton;

  static Color get pressedPrimaryButtonBorder => isDark
      ? DarkThemeColors.pressedPrimaryButtonBorder
      : LightThemeColors.pressedPrimaryButtonBorder;

  static Color get outlinedButtonDisabled => isDark
      ? DarkThemeColors.outlinedButtonDisabled
      : LightThemeColors.outlinedButtonDisabled;

  static Color get strokeInteractiveBrandActiveGreen => isDark
      ? DarkThemeColors.strokeInteractiveBrandActiveGreen
      : LightThemeColors.strokeInteractiveBrandActiveGreen;

  static Color get boxGreyBorder =>
      isDark ? DarkThemeColors.boxGreyBorder : LightThemeColors.boxGreyBorder;

  static Color get contentNeutralLightGrey => isDark
      ? DarkThemeColors.contentNeutralLightGrey
      : LightThemeColors.contentNeutralLightGrey;

  static Color get pressedIconColor => isDark
      ? DarkThemeColors.pressedIconColor
      : LightThemeColors.pressedIconColor;
}
