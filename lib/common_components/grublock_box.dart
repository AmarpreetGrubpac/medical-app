import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';

class GrubLockBox extends StatelessWidget {
  const GrubLockBox({super.key, this.isLocked = true, this.onTap});

  final bool isLocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppTheme.bgBrandSecondaryYellow,
            border: Border.all(color: AppTheme.strokeInteractiveBrandDefault),
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                isLocked ? IconAsset.lock : IconAsset.unlock,
                height: 24.h,
                width: 24.h,
              ),
              8.w.horizontalSpace,
              AppText(
                text: "GRUBLOCK",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.contentBrandPrimaryYellow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
