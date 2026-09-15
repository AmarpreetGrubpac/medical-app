import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_back_button.dart';
import 'package:grubpac_driver/common_components/common_icon_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/dashboard/controller/dashboard_controller.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';

class CommonAppNameBar extends StatelessWidget {
  const CommonAppNameBar({
    super.key,
    this.isAlert = false,
    this.isDashboardScreen = false,
    this.isHome = false,
  });

  final bool isAlert, isHome, isDashboardScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundNeutralSecondary,
        border: Border(
            bottom: BorderSide(color: AppTheme.strokeInteractiveBrandDisabled)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (isDashboardScreen) {
                    final DashboardController controller =
                        Get.isRegistered<DashboardController>()
                            ? Get.find<DashboardController>()
                            : Get.put(DashboardController());

                    controller.onTabChanged(0);
                  } else {
                    Navigation.replaceAll(RouteHelper.dashboard);
                  }
                },
                behavior: HitTestBehavior.translucent,
                child: SvgPicture.asset(
                  IconAsset.appLogo,
                  height: 30.h,
                  colorFilter: ColorFilter.mode(
                      AppTheme.contentNeutralPrimary, BlendMode.srcIn),
                ),
              ),
              if (!isHome)
                GetBuilder<BoxManagementController>(
                  builder: (boxCtrl) {
                    final currentBox = boxCtrl.boxes.isNotEmpty &&
                            boxCtrl.currentPage < boxCtrl.boxes.length
                        ? boxCtrl.boxes[boxCtrl.currentPage]
                        : null;
                    final tempStr = currentBox != null
                        ? "${currentBox.extTemp ?? 23}°C"
                        : AppString.temperatureValue;

                    return Container(
                      padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 2.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppTheme.primary),
                        color: AppTheme.background,
                      ),
                      child: Row(
                        spacing: 4.w,
                        children: [
                          SvgPicture.asset(IconAsset.thermometer,
                              height: 16.h,
                              width: 16.h,
                              colorFilter: ColorFilter.mode(
                                  AppTheme.primary, BlendMode.srcIn)),
                          AppText(
                            text: tempStr,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.primary,
                            fontStyle: FontStyle.italic,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              // IconButton(
              //     onPressed: () {
              //       Get.toNamed(RouteHelper.statusButtonsScreen);
              //
              //     },
              //     icon: Icon(
              //       Icons.interests,
              //       color: Theme.of(context).primaryColor,
              //     ))
            ],
          ),
          isAlert
              ? SizedBox.shrink()
              : CommonIconButton(
                  onTap: () => Navigation.pushNamed(RouteHelper.alerts),
                  icon: IconAsset.bell),
        ],
      ),
    );
  }
}

class CommonBackAppBar extends StatelessWidget {
  const CommonBackAppBar({
    super.key,
    required this.title,
    this.fontSize,
    this.bottomPadding,
    this.trailing,
    this.backArrow = true,
    this.ignoreHPadding = false,
    this.fontColor,
  });

  final String title;
  final double? fontSize, bottomPadding;
  final Color? fontColor;
  final Widget? trailing;
  final bool backArrow, ignoreHPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ignoreHPadding ? 0 : 24.w,
        24.h,
        ignoreHPadding ? 0 : 24.w,
        bottomPadding ?? 24.h,
      ),
      child: Row(
        spacing: 8.w,
        children: [
          if (backArrow) CommonBackIconButton(),
          Expanded(
            child: AppText(
              text: title,
              fontSize: fontSize ?? 24.sp,
              fontWeight: FontWeight.w600,
              color: fontColor ?? AppTheme.contentNeutralPrimary,
            ),
          ),
          trailing ?? SizedBox.shrink(),
        ],
      ),
    );
  }
}
