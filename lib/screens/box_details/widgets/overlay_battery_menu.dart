import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_status_pill.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_utils.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/screens/box_details/widgets/outlined_box.dart';
import 'package:grubpac_driver/screens/box_details/controller/box_details_controller.dart';

class OverlayBatteryMenuWidget extends StatelessWidget {
  final Offset offset;
  final Size size;
  final VoidCallback onClose;

  const OverlayBatteryMenuWidget({
    super.key,
    required this.offset,
    required this.size,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BoxDetailsController>();
    final batteryLevel = controller.boxInfo?.batteryLevel ?? 0;
    final battery1Level = controller.boxInfo?.battery1Level ?? 100;
    final battery2Level = controller.boxInfo?.battery2Level ?? 0;

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
          bottom: 45.h,
          child: SafeArea(
            child: Column(
              spacing: 4.h,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (batteryLevel <= 20)
                        IntrinsicWidth(
                          child: OutlinedBox(
                            boxColor: AppTheme.bgBrandSecondaryRed,
                            borderColor: AppTheme.strokeBrandPrimaryAlt,
                            padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 4.h),
                            child: Row(
                              spacing: 8.w,
                              children: [
                                SvgPicture.asset(
                                  IconAsset.toastError,
                                  height: 24.h,
                                  width: 24.h,
                                  colorFilter: ColorFilter.mode(AppTheme.contentBrandPrimary, BlendMode.srcIn),
                                ),
                                AppText(text: AppString.plsChargeBattery, color: AppTheme.contentBrandPrimary),
                              ],
                            ),
                          ),
                        ),
                      Row(
                        spacing: 8.w,
                        children: [
                          Expanded(
                            child: OutlinedBox(
                              borderColor: AppTheme.strokeBrandPrimary,
                              child: Row(
                                spacing: 8.w,
                                children: [
                                  SvgPicture.asset(
                                    AppUtils.getBatteryIcon(battery1Level),
                                    height: 32.h,
                                    width: 32.h,
                                    colorFilter: ColorFilter.mode(
                                      AppUtils.getBatteryColor(battery1Level),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      spacing: 8.h,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: "Battery A",
                                          color: AppTheme.contentNeutralPrimary,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CommonStatusPill(
                                            title: "$battery1Level%",
                                            type: battery1Level > 20
                                                ? StatusType.connected
                                                : StatusType.disconnected),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: OutlinedBox(
                              borderColor: AppTheme.strokeBrandPrimaryAlt,
                              child: Row(
                                spacing: 8.w,
                                children: [
                                  SvgPicture.asset(
                                    AppUtils.getBatteryIcon(battery2Level),
                                    height: 32.h,
                                    width: 32.h,
                                    colorFilter: ColorFilter.mode(
                                      AppUtils.getBatteryColor(battery2Level),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      spacing: 8.h,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: "Battery B",
                                          color: AppTheme.contentNeutralPrimary,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CommonStatusPill(
                                            title: "$battery2Level%",
                                            type: battery2Level > 20
                                                ? StatusType.connected
                                                : StatusType.disconnected),
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
                Container(
                  padding: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppTheme.primary.withValues(alpha: 0.4),
                  ),
                  child: OutlinedBox(
                    borderColor: AppTheme.strokeInteractiveBrand,
                    child: Column(
                      spacing: 8.h,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: "$batteryLevel%",
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.contentBrandPrimaryOrange,
                            ),
                            GestureDetector(
                              onTap: onClose,
                              behavior: HitTestBehavior.translucent,
                              child: SizedBox(
                                height: 28.h,
                                child: Row(
                                  spacing: 8.w,
                                  children: [
                                    AppText(text: AppString.closeBtn, color: AppTheme.contentBrandDefault),
                                    SvgPicture.asset(
                                      IconAsset.arrowDown,
                                      height: 20.h,
                                      width: 20.h,
                                      colorFilter: ColorFilter.mode(
                                        AppTheme.contentBrandDefault,
                                        BlendMode.srcIn,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: AppString.batteryLabel,
                              color: AppTheme.contentNeutralPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            Row(
                              spacing: 12.w,
                              children: [
                                Row(
                                  spacing: 4.w,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      AppUtils.getBatteryIcon(battery1Level),
                                      height: 24.h,
                                      width: 24.h,
                                      colorFilter: ColorFilter.mode(
                                        AppUtils.getBatteryColor(battery1Level),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    AppText(
                                      text: "$battery1Level%",
                                      color: AppTheme.contentBrandDefault,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 4.w,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      AppUtils.getBatteryIcon(battery2Level),
                                      height: 24.h,
                                      width: 24.h,
                                      colorFilter: ColorFilter.mode(
                                        AppUtils.getBatteryColor(battery2Level),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    AppText(
                                      text: "$battery2Level%",
                                      color: AppTheme.contentBrandDefault,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
