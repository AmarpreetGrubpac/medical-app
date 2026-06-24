import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  /// SUCCESS
  static void showSuccess({String message = 'Success!'}) {
    toastification.showCustom(
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      builder:
          (context, holder) => Container(
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
            margin: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppTheme.strokeBrandPrimary),
              color: AppTheme.backgroundBrandSecondaryAlt,
              boxShadow: [
                BoxShadow(
                  offset: Offset(4, 4),
                  spreadRadius: 0,
                  blurRadius: 8,
                  color: Colors.black.withValues(alpha: 0.12),
                ),
              ],
            ),
            child: Row(
              spacing: 12.w,
              children: [
                SvgPicture.asset(
                  IconAsset.toastSuccess,
                  height: 20.h,
                  width: 20.h,
                  colorFilter: ColorFilter.mode(AppTheme.contentBrandPrimaryGreen, BlendMode.srcIn),
                ),
                Expanded(
                  child: AppText(
                    text: message,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.contentBrandActiveAlt,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  /// ERROR
  static void showError({String message = 'Something went wrong!', String title = 'Error'}) {
    toastification.showCustom(
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      builder:
          (context, holder) => Container(
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
            margin: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppTheme.strokeBrandPrimaryAlt),
              color: AppTheme.backgroundBrandSecondary,
              boxShadow: [
                BoxShadow(
                  offset: Offset(4, 4),
                  spreadRadius: 0,
                  blurRadius: 8,
                  color: Colors.black.withValues(alpha: 0.12),
                ),
              ],
            ),
            child: Row(
              spacing: 12.w,
              children: [
                SvgPicture.asset(
                  IconAsset.toastError,
                  height: 20.h,
                  width: 20.h,
                  colorFilter: ColorFilter.mode(AppTheme.contentBrandPrimary, BlendMode.srcIn),
                ),
                Expanded(
                  child: Column(
                    spacing: 6.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: title,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.contentBrandActive,
                        height: 1,
                      ),
                      AppText(
                        text: message,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.contentBrandActive,
                        height: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
