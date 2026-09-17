import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';

class CommonBox extends StatelessWidget {
  const CommonBox({
    super.key,
    this.isConnected = true,
    this.isGrubLock = false,
    this.isBoxLocked = true,
    this.onTap,
  });

  final bool isConnected, isGrubLock, isBoxLocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      width: 200.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(ImageAsset.grubpacBox, height: 200.h, width: 200.h),
          Positioned(
            bottom: -8.h,
            right: -40.w,
            child: IntrinsicWidth(
              child: Container(
                padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 4.h),
                decoration: BoxDecoration(
                  color: isConnected
                      ? AppTheme.backgroundBrandSecondaryAlt
                      : AppTheme.backgroundBrandSecondary,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isConnected
                        ? AppTheme.strokeBrandPrimary
                        : AppTheme.strokeBrandPrimaryAlt,
                    width: 1,
                  ),
                ),
                child: Row(
                  spacing: 8.w,
                  children: [
                    SvgPicture.asset(
                      isConnected
                          ? IconAsset.toastSuccess
                          : IconAsset.toastError,
                      height: 24.h,
                      width: 24.h,
                    ),
                    AppText(
                      text: isConnected
                          ? AppString.connectedBtn
                          : AppString.disconnectedBtn,
                      color: isConnected
                          ? AppTheme.strokeBrandPrimary
                          : AppTheme.strokeBrandPrimaryAlt,
                      height: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isGrubLock)
            Positioned(
              top: -12.h,
              left: -12.w,
              child: GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.translucent,
                child: Container(
                  height: 64.h,
                  width: 64.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.strokeInteractiveBrandDefault,
                    ),
                    color: isBoxLocked
                        ? AppTheme.bgBrandSecondaryYellow
                        : AppTheme.background,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      isBoxLocked ? IconAsset.lock : IconAsset.unlock,
                      height: 48.h,
                      width: 48.h,
                      colorFilter: ColorFilter.mode(
                        AppTheme.contentBrandPrimaryYellow,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
