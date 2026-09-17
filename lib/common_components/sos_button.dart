import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';

class SosButton extends StatelessWidget {
  final VoidCallback? onCallFacility;
  final VoidCallback? onAlertFacility;

  const SosButton({super.key, this.onCallFacility, this.onAlertFacility});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          EmergencyBottomSheet.show(
            context: context,
            onCallFacility: onCallFacility,
            onAlertFacility: onAlertFacility,
          );
        },
        customBorder: const CircleBorder(),
        splashColor: AppTheme.contentBrandActive.withValues(alpha: 0.2),
        highlightColor: AppTheme.contentBrandActive.withValues(alpha: 0.1),
        child: Ink(
          width: 56.w,
          height: 56.h,
          decoration: BoxDecoration(
            color: AppTheme.strokeBrandPrimaryAlt,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.transparent),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            child: SvgPicture.asset(
              IconAsset.sos,
              height: 13.h,
              width: 29.w,
            ),
          ),
        ),
      ),
    );
  }
}

class EmergencyBottomSheet extends StatelessWidget {
  final VoidCallback? onCallFacility;
  final VoidCallback? onAlertFacility;
  final String? title;
  final String? subtitle;
  final String? callFacilityTitle;
  final String? alertFacilityTitle;

  const EmergencyBottomSheet({
    super.key,
    this.onCallFacility,
    this.onAlertFacility,
    this.title,
    this.subtitle,
    this.callFacilityTitle,
    this.alertFacilityTitle,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    VoidCallback? onCallFacility,
    VoidCallback? onAlertFacility,
    String? title,
    String? subtitle,
    String? callFacilityTitle,
    String? alertFacilityTitle,
  }) {
    return showModalBottomSheet<T>(
      backgroundColor: AppTheme.background,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => EmergencyBottomSheet(
        onCallFacility: onCallFacility,
        onAlertFacility: onAlertFacility,
        title: title,
        subtitle: subtitle,
        callFacilityTitle: callFacilityTitle,
        alertFacilityTitle: alertFacilityTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
        height: onAlertFacility != null ? 300.h : 240.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              IconAsset.warning,
              height: 32.h,
              width: 32.w,
              colorFilter: ColorFilter.mode(
                AppTheme.strokeBrandPrimaryAlt,
                BlendMode.srcIn,
              ),
            ),
            AppText(
              text: title ?? AppString.emergency,
              fontWeight: FontWeight.w600,
              fontSize: 24.sp,
              color: AppTheme.contentNeutralPrimary,
            ),
            AppText(
              text: subtitle ?? AppString.emergencySubText,
              fontWeight: FontWeight.w400,
              fontSize: 15.sp,
              color: AppTheme.contentNeutralPrimary,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                onCallFacility?.call();
              },
              child: Container(
                height: 48.h,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppTheme.strokeBrandPrimaryAlt,
                ),
                child: Center(
                  child: AppText(
                    text: callFacilityTitle ?? AppString.callRestaurant,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.contentOnPrimary,
                  ),
                ),
              ),
            ),
            if (onAlertFacility != null)
              CommonOutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onAlertFacility?.call();
                },
                title: alertFacilityTitle ?? AppString.writeToUsButton,
                height: 48.h,
              ),
          ],
        ),
      ),
    );
  }
}
