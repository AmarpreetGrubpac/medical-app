import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/screen_size.dart';
import 'package:pinput/pinput.dart';

class CustomPinPut extends StatelessWidget {
  const CustomPinPut({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: 4,
      controller: controller,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      preFilledWidget: AppText(
        text: "0",
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        color: AppTheme.contentNeutralLight,
      ),
      separatorBuilder: (index) => 16.w.horizontalSpace,
      defaultPinTheme: _pinTheme(),
      focusedPinTheme: _pinTheme(isFocused: true),
    );
  }

  PinTheme _pinTheme({bool isFocused = false}) {
    return PinTheme(
      height: 56.h,
      width: ScreenSize.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: isFocused ? AppTheme.primary : AppTheme.primaryButtonDisabled),
        color: AppTheme.background,
        boxShadow:
            isFocused
                ? [
                  BoxShadow(
                    offset: Offset(0, 0),
                    color: AppTheme.primary.withValues(alpha: 0.4),
                    blurRadius: 0,
                    spreadRadius: 4,
                  ),
                ]
                : [],
      ),
      textStyle: TextStyle(
        fontSize: 18.sp,
        color: AppTheme.contentNeutralSecondary,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
