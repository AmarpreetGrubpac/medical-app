import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:interactive_slider/interactive_slider.dart';

class CommonTempSlider extends StatelessWidget {
  const CommonTempSlider({super.key, required this.controller, this.onChanged});

  final InteractiveSliderController controller;
  final void Function(double value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.h,
      width: 36.w,
      child: RotatedBox(
        quarterTurns: 3,
        child: InteractiveSlider(
          controller: controller,
          onChanged: onChanged,
          padding: EdgeInsets.zero,
          unfocusedHeight: 14.h,
          focusedHeight: 14.h,
          focusedMargin: EdgeInsets.zero,
          unfocusedMargin: EdgeInsets.zero,
          shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100.r))),
          min: -20,
          max: 70,
          unfocusedOpacity: 1,
          backgroundColor: AppTheme.contentNeutralLight,
          numberOfSegments: 90,
          segmentDividerWidth: 0,
          segmentDividerColor: Colors.transparent,
          thumbBorder: AppTheme.contentBrandDisabled,
          thumbColor: Colors.white,
          thumbRadius: 14.h,
          gradient: LinearGradient(
            colors: [
              AppTheme.colorTransparentBlue,
              AppTheme.colorTransparentWarm,
              AppTheme.colorTransparentHot,
            ],
          ),
        ),
      ),
    );
  }
}

class TempratureButtons extends StatelessWidget {
  const TempratureButtons({
    super.key,
    this.onTap,
    required this.title,
    required this.value,
    required this.isSelected,
  });

  final void Function()? onTap;
  final String title;
  final int value;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.w,
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: 10.w),
          child: AppText(
            text: "$value°C",
            fontSize: 14.sp,
            color: AppTheme.contentNeutralPrimary,
          ),
        ),
        Container(
          height: 1.h,
          width: 42.w,
          color: AppTheme.contentBrandDefault,
        ),
        GestureDetector(
          onTap: onTap,
          child: IntrinsicWidth(
            child: Container(
              height: 32.h,
              width: 66.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: isSelected
                    ? AppTheme.backgroundNeutralSecondary
                    : AppTheme.background,
                border: Border.all(
                    color: isSelected
                        ? AppTheme.strokeInteractiveBrandActiveGreen
                        : AppTheme.boxGreyBorder),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 0,
                          spreadRadius: 2,
                          color: AppTheme.strokeInteractiveBrandActiveGreen
                              .withValues(alpha: 0.4),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: AppText(
                  text: title,
                  fontSize: 14.sp,
                  textDecoration: isSelected
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  color: isSelected
                      ? AppTheme.contentNeutralLightGrey
                      : AppTheme.contentBrandDefault,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
