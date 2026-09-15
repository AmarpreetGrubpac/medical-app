import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';

class ExpandableTile extends StatelessWidget {
  const ExpandableTile({
    super.key,
    required this.onTap,
    required this.child,
    required this.title,
    this.isExpanded = false,
  });

  final VoidCallback onTap;
  final bool isExpanded;
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                    text: title,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.contentNeutralPrimary),
                RotatedBox(
                  quarterTurns: isExpanded ? 4 : 2,
                  child: SvgPicture.asset(
                    IconAsset.arrowDown,
                    height: 28.h,
                    width: 28.w,
                    colorFilter: ColorFilter.mode(
                        AppTheme.contentBrandDefault, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) child,
      ],
    );
  }
}

class ExpandableBox extends StatelessWidget {
  const ExpandableBox({
    super.key,
    this.onTap,
    this.isExpanded = false,
    this.isGrublock = false,
    this.child,
    required this.title,
    this.trailing,
    required this.icon,
  });

  final VoidCallback? onTap;
  final bool isExpanded, isGrublock;
  final Widget? child, trailing;
  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
            decoration: BoxDecoration(
              color: AppTheme.backgroundNeutralSecondary,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8.r),
                bottom: Radius.circular(isExpanded ? 0 : 8.r),
              ),
              border:
                  Border.all(color: AppTheme.strokeInteractiveBrandDisabled),
            ),
            child: Row(
              spacing: 12.w,
              children: [
                SvgPicture.asset(
                  icon,
                  height: 24.h,
                  width: 24.w,
                  colorFilter: ColorFilter.mode(
                    isGrublock
                        ? AppTheme.contentBrandPrimary
                        : AppTheme.contentNeutralLight,
                    BlendMode.srcIn,
                  ),
                ),
                Expanded(
                  child: AppText(
                    text: title,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.contentNeutralPrimary,
                  ),
                ),
                trailing ?? SizedBox.shrink(),
                RotatedBox(
                  quarterTurns: isExpanded ? 4 : 3,
                  child: SvgPicture.asset(
                    IconAsset.arrowDown,
                    height: 28.h,
                    width: 28.w,
                    colorFilter: ColorFilter.mode(
                        AppTheme.contentBrandDefault, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded && child != null)
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 16.h),
            decoration: BoxDecoration(
              color: AppTheme.expandedBoxBG,
              border: Border(
                left:
                    BorderSide(color: AppTheme.strokeInteractiveBrandDisabled),
                right:
                    BorderSide(color: AppTheme.strokeInteractiveBrandDisabled),
                bottom:
                    BorderSide(color: AppTheme.strokeInteractiveBrandDisabled),
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.r)),
            ),
            child: child,
          ),
      ],
    );
  }
}
