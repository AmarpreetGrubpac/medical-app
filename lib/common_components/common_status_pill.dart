import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/utils/enums.dart';

class CommonStatusPill extends StatelessWidget {
  const CommonStatusPill({
    super.key,
    required this.title,
    required this.type,
    this.customColor,
    this.customBgColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
  });

  final String title, type;
  final Color? customColor;
  final Color? customBgColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final statusColor = customColor ?? StatusType.color(type);
    final statusBgColor = customBgColor ?? StatusType.boxColor(type);

    return Container(
      padding: padding ?? EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        color: statusBgColor,
        border: Border.all(color: statusColor),
      ),
      child: AppText(
        text: title,
        fontSize: fontSize ?? 12.sp,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: statusColor,
        height: 1,
      ),
    );
  }
}

