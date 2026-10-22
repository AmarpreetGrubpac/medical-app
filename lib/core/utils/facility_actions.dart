import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Use an actual deployment contact; never dial an example phone number.
class FacilityActions {
  static const phone = String.fromEnvironment('FACILITY_PHONE');

  static void unavailable(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<void> call(BuildContext context) async {
    if (phone.trim().isEmpty) {
      unavailable(context,
          'Facility phone number is unavailable. Contact your facility directly.');
      return;
    }
    try {
      if (await launchUrl(Uri(scheme: 'tel', path: phone),
          mode: LaunchMode.externalApplication)) {
        return;
      }
    } catch (_) {
      // The device may have no dialer; keep the contact visible for the user.
    }
    if (context.mounted) {
      unavailable(context, 'Unable to open the dialer. Call $phone.');
    }
  }
}
