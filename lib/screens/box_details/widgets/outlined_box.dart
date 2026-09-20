import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';

class OutlinedBox extends StatelessWidget {
  const OutlinedBox({
    super.key,
    this.onTap,
    required this.child,
    this.borderColor,
    this.boxColor,
    this.padding,
    this.height,
  });

  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Widget child;
  final double? height;
  final Color? borderColor, boxColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: padding ?? EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
        decoration: BoxDecoration(
          color: boxColor ?? AppTheme.backgroundNeutralSecondary,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
              color: borderColor ?? AppTheme.strokeInteractiveBrandDisabled),
        ),
        child: child,
      ),
    );
  }
}
