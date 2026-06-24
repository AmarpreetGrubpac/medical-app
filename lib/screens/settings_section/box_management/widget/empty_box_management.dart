import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';

class EmptyBoxManagement extends StatelessWidget {
  const EmptyBoxManagement({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              text: AppString.noBox,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.contentNeutralPrimary,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
              child: AppText(text: AppString.scanQRLine, fontWeight: FontWeight.w400),
            ),
            IntrinsicWidth(
              child: CommonButton(
                onPressed: onTap,
                iconSize: 24.h,
                fontSize: 18.sp,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
                title: AppString.addMyBox,
                icon: IconAsset.scan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
