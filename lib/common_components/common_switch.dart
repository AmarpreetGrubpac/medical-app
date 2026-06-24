import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';

class CustomSwitch extends StatelessWidget {
  final bool isOn;
  final VoidCallback onToggle;
  final double switchWidth;
  final double switchHeight;

  const CustomSwitch({
    super.key,
    required this.isOn,
    required this.onToggle,
    this.switchWidth = 46,
    this.switchHeight = 26,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        width: switchWidth,
        height: switchHeight,
        decoration: BoxDecoration(
          color: isOn ? AppTheme.strokeBrandPrimary : AppTheme.contentNeutralLight,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.all(3),
        child: Container(
          width: switchHeight - 6,
          height: switchHeight - 6,
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

//
class CommonSwitch extends StatelessWidget {
  final bool isOn, isGreen;
  final VoidCallback onToggle;
  final double? switchWidth, switchHeight;

  const CommonSwitch({
    super.key,
    required this.isOn,
    this.isGreen = true,
    required this.onToggle,
    this.switchWidth,
    this.switchHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        width: 36.w,
        height: 20.h,
        decoration: BoxDecoration(
          color:
              isOn
                  ? isGreen
                      ? AppTheme.strokeBrandPrimary
                      : AppTheme.bgBrandPrimary
                  : AppTheme.contentNeutralLight,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.all(2.h),
        child: Container(
          height: (switchHeight ?? 20.h) - 4.h,
          width: (switchHeight ?? 20.h) - 4.h,
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
