import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';

enum AlertType { all, warning, error, success, notification }

enum AlertCategory { all, camera, battery, lock, display, other }

enum EditFieldType { name, email, phone, pass }

enum ButtonState { defaultState, pressed, disabled, active }

abstract class ConnectBoxFrom {
  static const String fromHome = "from-home-screen";
  static const String fromBoxManagement = "from-box-management-screen";
}

abstract class ZoneBoxType {
  static const String cold = "cold";
  static const String warm = "warm";
  static const String hot = "hot";
  static const String disabled = "disabled";

  static String getType(int value) {
    return value.isGreaterThan(40)
        ? hot
        : value.isLowerThan(10)
            ? cold
            : warm;
  }

  static String title(String value) {
    switch (value) {
      case cold:
        return AppString.cold;
      case warm:
        return AppString.warm;
      case hot:
        return AppString.hot;
      default:
        return AppString.warm;
    }
  }

  static Color border(String value) {
    switch (value) {
      case cold:
        return AppTheme.colorTransparentBlue;
      case warm:
        return AppTheme.colorTransparentWarm;
      case hot:
        return AppTheme.colorTransparentHot;
      case disabled:
        return AppTheme.backgroundNeutralSecondary;
      default:
        return AppTheme.colorTransparentWarm;
    }
  }

  static Color color(String value) {
    switch (value) {
      case disabled:
        return AppTheme.strokeInteractiveBrandDisabled;
      default:
        return border(value).withValues(alpha: 0.64);
    }
  }

  static Color text(String value) {
    switch (value) {
      case disabled:
        return AppTheme.contentBrandDisabled;
      default:
        return AppTheme.contentOnPrimary;
    }
  }
}

abstract class StatusType {
  static const String connected = "connected";
  static const String weak = "weak";
  static const String disconnected = "disconnected";

  static Color color(String value) {
    switch (value) {
      case connected:
        return AppTheme.contentBrandPrimaryGreen;
      case weak:
        return AppTheme.contentBrandPrimaryYellow;
      case disconnected:
        return AppTheme.contentBrandPrimary;
      default:
        return AppTheme.contentBrandPrimaryGreen;
    }
  }

  static Color boxColor(String value) {
    switch (value) {
      case connected:
        return AppTheme.bgBrandSecondaryGreen;
      case weak:
        return AppTheme.bgBrandSecondaryYellow;
      case disconnected:
        return AppTheme.bgBrandSecondaryRed;
      default:
        return AppTheme.bgBrandSecondaryGreen;
    }
  }
}

abstract class BatteryBoxType {
  static const String first = "first";
  static const String second = "second";
  static const String full = "full";

  static double boxHeight(String value) {
    switch (value) {
      case first:
        return 141.h;
      case second:
        return 76.h;
      case full:
        return 227.h;
      default:
        return 227.h;
    }
  }
}
