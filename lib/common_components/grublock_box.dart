import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';

class GrubLockBox extends StatelessWidget {
  const GrubLockBox({super.key, required this.isLocked, this.onTap});

  final bool isLocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 4.h),
          decoration: BoxDecoration(
            color: AppTheme.bgBrandSecondaryYellow,
            border: Border.all(color: AppTheme.contentBrandPrimaryYellow),
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Row(
            spacing: 8.w,
            children: [
              SvgPicture.asset(
                isLocked ? IconAsset.unlock : IconAsset.lock,
                height: 24.h,
                width: 24.h,
              ),
              AppText(
                text: isLocked ? 'UNLOCK' : 'LOCK',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.contentBrandPrimaryYellow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
