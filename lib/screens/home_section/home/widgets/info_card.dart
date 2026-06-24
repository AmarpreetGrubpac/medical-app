import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';

class InfoCard extends StatelessWidget {
  final String icon, label, value;

  const InfoCard({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundNeutralSecondary,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppTheme.primaryButtonDisabled),
      ),
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      child: Row(
        spacing: 8.w,
        children: [
          SvgPicture.asset(
            icon,
            height: 32.h,
            width: 32.h,
            colorFilter: ColorFilter.mode(AppTheme.contentBrandPrimaryOrange, BlendMode.srcIn),
          ),
          Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(text: label, fontSize: 14.sp, fontWeight: FontWeight.w400),
              AppText(
                text: value,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.contentNeutralPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
