import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/enums.dart';

class BatteryBoxWidget extends StatelessWidget {
  const BatteryBoxWidget({
    super.key,
    required this.temp,
    required this.type,
    required this.title,
    required this.isSelected,
    this.onTap,
  });

  final int temp;
  final bool isSelected;
  final String type, title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color boxColor =
        temp.isGreaterThan(40)
            ? AppTheme.colorTransparentHot
            : temp.isLowerThan(10)
            ? AppTheme.colorTransparentBlue
            : AppTheme.colorTransparentWarm;

    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [4, 4],
          strokeWidth: 4.h,
          padding: EdgeInsets.zero,
          borderPadding: EdgeInsets.zero,
          radius: Radius.circular(4.r),
          color: isSelected ? boxColor : Colors.transparent,
        ),
        childOnTop: false,
        child: BlurryContainer(
          height: BatteryBoxType.boxHeight(type),
          width: 170.w,
          blur: 4,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(4.r),
          child: Container(
            height: BatteryBoxType.boxHeight(type),
            width: 170.w,
            padding: EdgeInsets.only(left: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: isSelected ? Colors.transparent : boxColor),
              borderRadius: BorderRadius.circular(4.r),
              color: boxColor.withValues(alpha: 0.4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    AppText(
                      text: "$title set @ ",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.contentOnPrimary.withValues(alpha: 0.75),
                    ),
                    AppText(
                      text: "$temp°C",
                      fontSize: 14.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: AppTheme.contentOnPrimary,
                      textDecoration: isSelected ? TextDecoration.underline : TextDecoration.none,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppText(
                      text: "$temp",
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.contentOnPrimary.withValues(alpha: isSelected ? 0.5 : 1),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 7.h),
                      child: AppText(
                        text: "°C",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.contentOnPrimary.withValues(alpha: isSelected ? 0.5 : 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
