import 'package:flutter/material.dart';
import 'package:grubpac_driver/core/exceptions/failure.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class AppUtils {
  /// GET BATTERY ICON
  static String getBatteryIcon(int level) {
    return level > 20 ? IconAsset.batteryFull : IconAsset.battery;
  }

  /// GET BATTERY COLOR
  static Color getBatteryColor(int level) {
    if (level <= 0) {
      return AppTheme.contentBrandDisabled;
    } else if (level < 30) {
      return AppTheme.contentBrandPrimaryOrange;
    } else if (level < 70) {
      return AppTheme.contentBrandPrimaryYellow;
    } else {
      return AppTheme.contentBrandPrimaryGreen;
    }
  }

  /// HIDE KEYBOARD
  static void hideKeyboardInApp(BuildContext context) {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  static void apiErrorHandler(dynamic e) {
    if (e is Failure) {
      AppToast.showError(message: e.message);
    } else {
      AppToast.showError(message: AppString.somethingWentWrong);
    }
  }

  /// SEND MAIL
  static Future<void> writeMail(String email, String subject) async {
    final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        query: Uri.encodeFull('subject=$subject'));

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email client';
    }
  }

  /// CONTACT SUPPORT
  static Future<void> contactSupport(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch dial pad';
    }
  }

  /// GET INITIALS
  static String getInitials(String fullName, {int maxLetters = 2}) {
    if (fullName.isEmpty) return "";

    List<String> names = fullName.trim().split(RegExp(' +'));
    if (names.isEmpty || maxLetters < 1) return "";

    String initials = "";

    for (var name in names) {
      if (name.isNotEmpty) {
        initials += name[0].toUpperCase();
      }
      if (initials.length >= maxLetters) break;
    }

    return initials.substring(0, initials.length.clamp(1, maxLetters));
  }

  /// FORMAT DURATION
  static String formatDuration(Duration position) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(position.inMinutes.remainder(60));
    final seconds = twoDigits(position.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  /// NORMALIZED SLIDER - 25 to 0.5
  static double normalizeSliderValue(double value) {
    const double min = -20;
    const double max = 70;
    return (value - min) / (max - min);
  }

  /// DENORMALIZED SLIDER - 0.5 to 25
  static double denormalizeSliderValue(double normalizedValue) {
    const double min = -20;
    const double max = 70;
    return normalizedValue * (max - min) + min;
  }

  /// MASK MOBILE NO
  static String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 4) return phoneNumber;

    String last4Digits = phoneNumber.substring(phoneNumber.length - 4);
    String masked = '*' * (phoneNumber.length - 4);

    return '$masked$last4Digits';
  }

  /// MASK EMAIL
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2 || parts[0].isEmpty) return email;

    String username = parts[0];
    String domain = parts[1];

    String maskedUsername = username[0] + '*' * (username.length - 1);

    return '$maskedUsername@$domain';
  }

  /// TIMER TEXT
  static String timerText({required int second}) {
    int minutes = second ~/ 60;
    int seconds = second % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
