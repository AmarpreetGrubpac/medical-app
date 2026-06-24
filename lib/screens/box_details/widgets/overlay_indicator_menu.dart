import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_status_pill.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/screens/box_details/widgets/outlined_box.dart';

class OverlayBluetoothMenuWidget extends StatelessWidget {
  final Offset offset;
  final Size size;
  final VoidCallback onClose;

  const OverlayBluetoothMenuWidget({
    super.key,
    required this.offset,
    required this.size,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onClose,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: AppTheme.background.withValues(alpha: 0.2),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
        Positioned(
          left: 20.w,
          right: 20.w,
          top: offset.dy - 4.h,
          child: Material(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 4.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppTheme.primary.withValues(alpha: 0.4),
                    ),
                    child: OutlinedBox(
                      borderColor: AppTheme.strokeInteractiveBrand,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8.w,
                        children: [
                          SvgPicture.asset(
                            IconAsset.bluetooth,
                            height: 24.h,
                            width: 24.w,
                            colorFilter:
                                ColorFilter.mode(AppTheme.contentBrandPrimaryOrange, BlendMode.srcIn),
                          ),
                          SvgPicture.asset(
                            IconAsset.wifiSlash,
                            height: 24.h,
                            width: 24.w,
                            colorFilter: ColorFilter.mode(
                              AppTheme.contentBrandSecondaryOrange,
                              BlendMode.srcIn,
                            ),
                          ),
                          SvgPicture.asset(
                            IconAsset.signal,
                            height: 24.h,
                            width: 24.w,
                            colorFilter:
                                ColorFilter.mode(AppTheme.contentBrandPrimaryOrange, BlendMode.srcIn),
                          ),
                          SvgPicture.asset(
                            IconAsset.locationArrow,
                            height: 24.h,
                            width: 24.w,
                            colorFilter:
                                ColorFilter.mode(AppTheme.contentBrandPrimaryOrange, BlendMode.srcIn),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.h),
                  padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    border: Border.all(color: AppTheme.contentBrandDisabled),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0),
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        offset: Offset(4, 4),
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    spacing: 8.h,
                    children: [
                      Row(
                        spacing: 8.w,
                        children: [
                          Expanded(
                            child: OutlinedBox(
                              padding: EdgeInsets.fromLTRB(12.w, 8.h, 8.w, 8.h),
                              borderColor: AppTheme.strokeBrandPrimary,
                              child: Row(
                                spacing: 8.w,
                                children: [
                                  SvgPicture.asset(
                                    IconAsset.bluetooth,
                                    height: 32.h,
                                    width: 32.h,
                                    colorFilter: ColorFilter.mode(
                                      AppTheme.contentNeutralLight,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      spacing: 8.h,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: AppString.bluetoothLabel,
                                          color: AppTheme.contentNeutralPrimary,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CommonStatusPill(title: AppString.strong, type: StatusType.connected),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: OutlinedBox(
                              padding: EdgeInsets.fromLTRB(12.w, 8.h, 8.w, 8.h),
                              borderColor: AppTheme.strokeBrandPrimaryAlt,
                              child: Row(
                                spacing: 8.w,
                                children: [
                                  SvgPicture.asset(
                                    IconAsset.wifiSlash,
                                    height: 32.h,
                                    width: 32.h,
                                    colorFilter: ColorFilter.mode(
                                      AppTheme.contentBrandDisabled,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      spacing: 8.h,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: AppString.wifiLabel,
                                          color: AppTheme.contentNeutralPrimary,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CommonStatusPill(
                                          title: AppString.noSignal,
                                          type: StatusType.disconnected,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 8.w,
                        children: [
                          Expanded(
                            child: OutlinedBox(
                              padding: EdgeInsets.fromLTRB(12.w, 8.h, 8.w, 8.h),
                              borderColor: AppTheme.strokeBrandPrimaryYellow,
                              child: Row(
                                spacing: 8.w,
                                children: [
                                  SvgPicture.asset(
                                    IconAsset.signal,
                                    height: 32.h,
                                    width: 32.h,
                                    colorFilter: ColorFilter.mode(
                                      AppTheme.contentNeutralLight,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      spacing: 8.h,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: AppString.fourGLabel,
                                          color: AppTheme.contentNeutralPrimary,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CommonStatusPill(title: AppString.weak, type: StatusType.weak),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: OutlinedBox(
                              padding: EdgeInsets.fromLTRB(12.w, 8.h, 8.w, 8.h),
                              borderColor: AppTheme.strokeBrandPrimary,
                              child: Row(
                                spacing: 8.w,
                                children: [
                                  SvgPicture.asset(
                                    IconAsset.locationArrow,
                                    height: 32.h,
                                    width: 32.h,
                                    colorFilter: ColorFilter.mode(
                                      AppTheme.contentBrandDisabled,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      spacing: 8.h,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: AppString.gpsLabel,
                                          color: AppTheme.contentNeutralPrimary,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CommonStatusPill(title: AppString.on, type: StatusType.connected),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
