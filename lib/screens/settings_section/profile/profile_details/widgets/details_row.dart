import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';

class DetailsRow extends StatelessWidget {
  const DetailsRow(
      {super.key,
      required this.icon,
      required this.title,
      required this.value});

  final String icon, title, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          height: 24.h,
          width: 24.h,
          colorFilter:
              ColorFilter.mode(AppTheme.contentNeutralLight, BlendMode.srcIn),
        ),
        Expanded(
          child: Container(
            constraints: BoxConstraints(minHeight: 24.h),
            alignment: Alignment.centerLeft,
            child: AppText(
                text: "$title:",
                fontWeight: FontWeight.w400,
                color: AppTheme.contentBrandDefault),
          ),
        ),
        Expanded(
          child: Container(
            constraints: BoxConstraints(minHeight: 24.h),
            alignment: Alignment.centerLeft,
            child: AppText(
              text: value,
              fontWeight: FontWeight.w400,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
