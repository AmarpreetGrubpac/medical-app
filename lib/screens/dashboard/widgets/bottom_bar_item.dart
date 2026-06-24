import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';

class BottomBarItem extends StatelessWidget {
  final String label, icon, selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const BottomBarItem({
    super.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Column(
        spacing: 6.h,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isSelected ? selectedIcon : icon,
            height: 24.h,
            width: 24.h,
            colorFilter: ColorFilter.mode(
              isSelected ? AppTheme.contentBrandPrimaryOrange : AppTheme.contentNeutralLight,
              BlendMode.srcIn,
            ),
          ),
          AppText(
            text: label,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: isSelected ? AppTheme.commonColor : AppTheme.contentNeutralLight,
          ),
        ],
      ),
    );
  }
}
