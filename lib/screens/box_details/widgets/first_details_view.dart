import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
import 'package:grubpac_driver/common_components/common_icon_button.dart';
import 'package:grubpac_driver/common_components/common_status_pill.dart';
import 'package:grubpac_driver/common_components/common_switch.dart';
import 'package:grubpac_driver/common_components/common_temp_slider.dart';
import 'package:grubpac_driver/common_components/common_text_button.dart';
import 'package:grubpac_driver/common_components/grublock_box.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_utils.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/screens/box_details/controller/box_details_controller.dart';
import 'package:grubpac_driver/screens/box_details/widgets/battery_box_widget.dart';
import 'package:grubpac_driver/screens/box_details/widgets/outlined_box.dart';

class FirstDetailsView extends StatelessWidget {
  const FirstDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CommonBackAppBar(
                    title: controller.boxInfo?.name.isNotEmpty == true
                        ? controller.boxInfo!.name
                        : (controller.boxInfo?.boxDisplayId.isNotEmpty == true
                            ? controller.boxInfo!.boxDisplayId
                            : AppString.boxNumber),
                    trailing: CommonCompactIconButton(
                      onTap: controller.onHelpTap,
                      icon: IconAsset.questionCircle,
                      size: 32.h,
                      iconColor: AppTheme.contentBrandDefault,
                      pressedIconColor: AppTheme.contentBrandDefault,
                      pressedBgColor: AppTheme.pressedTextBtnColor,
                    ),
                  ),
                  Opacity(
                    opacity: controller.boxConnectionStatus ? 1.0 : 0.4,
                    child: AbsorbPointer(
                      absorbing: !controller.boxConnectionStatus,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 24.w),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [_SignalBox(), _GrublockBox()],
                            ),
                          ),
                          _BatteryBox(),
                          Container(
                            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
                            child: Row(
                              spacing: 16.w,
                              children: [
                                Expanded(child: _AdvertBox()),
                                Expanded(child: _BoxCamBox())
                              ],
                            ),
                          ),
                          _BatteryDetailsBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _SwipeUpBox(),
        ],
      ),
    );
  }
}

/// SIGNAL BOX
class _SignalBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => PopScope(
        canPop: !controller.isOverlayOpen,
        onPopInvokedWithResult: (didPop, result) {
          if (controller.isOverlayOpen) {
            controller.removeOverlay();
            return;
          }
        },
        child: OutlinedBox(
          key: controller.indicatorKey,
          onTap: () => controller.showOverlayMenu(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.w,
            children: [
              SvgPicture.asset(
                IconAsset.bluetooth,
                height: 24.h,
                width: 24.w,
                colorFilter: ColorFilter.mode(
                    (controller.boxInfo?.connectionStatus == 'strong' ||
                            controller.boxInfo?.connectionStatus == 'weak')
                        ? AppTheme.contentBrandDefault
                        : AppTheme.contentNeutralLight,
                    BlendMode.srcIn),
              ),
              SvgPicture.asset(
                controller.boxInfo?.wifiConnected == true
                    ? IconAsset.wifi
                    : IconAsset.wifiSlash,
                height: 24.h,
                width: 24.w,
                colorFilter: ColorFilter.mode(
                    controller.boxInfo?.wifiConnected == true
                        ? AppTheme.contentBrandDefault
                        : AppTheme.contentNeutralLight,
                    BlendMode.srcIn),
              ),
              SvgPicture.asset(
                IconAsset.signal,
                height: 24.h,
                width: 24.w,
                colorFilter: ColorFilter.mode(
                    (controller.boxInfo?.connectionStatus == 'strong' ||
                            controller.boxInfo?.connectionStatus == 'weak')
                        ? AppTheme.contentBrandDefault
                        : AppTheme.contentNeutralLight,
                    BlendMode.srcIn),
              ),
              SvgPicture.asset(
                IconAsset.locationArrow,
                height: 24.h,
                width: 24.w,
                colorFilter: ColorFilter.mode(
                    (controller.boxInfo?.gpsAvailable ?? false)
                        ? AppTheme.contentBrandDefault
                        : AppTheme.contentNeutralLight,
                    BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// GRUBLOCK BOX
class _GrublockBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => GrubLockBox(
        onTap: controller.boxConnectionStatus
            ? () => controller.onLockTap(context)
            : null,
      ),
    );
  }
}

/// BATTERY BOX
class _BatteryBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) {
        final isConnected = controller.boxConnectionStatus;
        return Container(
          height: 318.h,
          margin: EdgeInsetsGeometry.fromLTRB(24.w, 15.h, 0, 15.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Row(
                        spacing: 8.w,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonSwitch(
                            onToggle:
                                isConnected ? controller.toggleDualZone : () {},
                            isOn: controller.dualZoneSwitch,
                            isGreen: false,
                          ),
                          AppText(
                            text: AppString.dualZone,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.contentNeutralPrimary,
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: controller.sliderController,
                      builder: (context, value, child) {
                        return Container(
                          height: 240.h,
                          margin: EdgeInsets.symmetric(vertical: 14.h),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -12.h,
                                child: TempratureButtons(
                                  onTap: isConnected
                                      ? () => controller.onSelectTempButtons(70)
                                      : null,
                                  value: 70,
                                  isSelected:
                                      AppUtils.denormalizeSliderValue(value) ==
                                          70,
                                  title: AppString.hot,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                child: TempratureButtons(
                                  onTap: isConnected
                                      ? () => controller.onSelectTempButtons(25)
                                      : null,
                                  value: 25,
                                  isSelected:
                                      AppUtils.denormalizeSliderValue(value) ==
                                          25,
                                  title: AppString.warm,
                                ),
                              ),
                              Positioned(
                                bottom: -12.h,
                                child: TempratureButtons(
                                  onTap: isConnected
                                      ? () =>
                                          controller.onSelectTempButtons(-20)
                                      : null,
                                  value: -20,
                                  isSelected:
                                      AppUtils.denormalizeSliderValue(value) ==
                                          -20,
                                  title: AppString.cold,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 48.w,
                                child: CommonTempSlider(
                                  onChanged: isConnected
                                      ? controller.onSliderChange
                                      : null,
                                  controller: controller.sliderController,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Image.asset(ImageAsset.batteryBox,
                      fit: BoxFit.fill, height: 318.h, width: 183.w),

                  /// SINGLE
                  if (!controller.dualZoneSwitch)
                    Positioned(
                      top: 41.h,
                      bottom: 50.h,
                      left: 22.w,
                      child: BatteryBoxWidget(
                        isSelected: true,
                        title: "Zone 1",
                        temp: controller.firstBattery,
                        type: BatteryBoxType.full,
                      ),
                    ),

                  /// FIRST
                  if (controller.dualZoneSwitch)
                    Positioned(
                      top: 41.h,
                      left: 22.w,
                      child: BatteryBoxWidget(
                        onTap: isConnected
                            ? () => controller.onSelectBattery(1)
                            : null,
                        isSelected: controller.selectedBattery == 1,
                        title: "Zone 1",
                        temp: controller.firstBattery,
                        type: BatteryBoxType.first,
                      ),
                    ),

                  /// SECOND
                  if (controller.dualZoneSwitch)
                    Positioned(
                      bottom: 50.h,
                      left: 22.w,
                      child: BatteryBoxWidget(
                        onTap: isConnected
                            ? () => controller.onSelectBattery(2)
                            : null,
                        isSelected: controller.selectedBattery == 2,
                        title: "Zone 2",
                        temp: controller.secondBattery,
                        type: BatteryBoxType.second,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// BATTERY DETAILS BOX
class _BatteryDetailsBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => PopScope(
        canPop: controller.isBatteryOverlayOpen == false,
        onPopInvokedWithResult: (didPop, result) {
          if (controller.isBatteryOverlayOpen) {
            controller.removeBatteryOverlay();
            return;
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: OutlinedBox(
            child: Column(
              spacing: 8.h,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 8.sp,
                      children: [
                        controller.boxInfo?.settings?.isCharging == true
                            ? SvgPicture.asset("assets/icons/charge.svg")
                            : SizedBox.shrink(),
                        AppText(
                            text: "${controller.boxInfo?.batteryLevel ?? 0}%",
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600),
                      ],
                    ),
                    CommonCompactTextButton(
                      key: controller.batteryKey,
                      onPressed: () => controller.showBatteryMenu(context),
                      title: AppString.detailsBtn,
                      icon: IconAsset.arrowUpRight,
                      fontSize: 16.sp,
                      iconSize: 20.h,
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
                              AppUtils.getBatteryIcon(
                                  controller.boxInfo?.battery1Level ?? 100),
                              height: 24.h,
                              width: 24.h,
                              colorFilter: ColorFilter.mode(
                                AppUtils.getBatteryColor(
                                    controller.boxInfo?.battery1Level ?? 100),
                                BlendMode.srcIn,
                              ),
                            ),
                            AppText(
                              text:
                                  "${controller.boxInfo?.battery1Level ?? 100}%",
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
                              AppUtils.getBatteryIcon(
                                  controller.boxInfo?.battery2Level ?? 0),
                              height: 24.h,
                              width: 24.h,
                              colorFilter: ColorFilter.mode(
                                AppUtils.getBatteryColor(
                                    controller.boxInfo?.battery2Level ?? 0),
                                BlendMode.srcIn,
                              ),
                            ),
                            AppText(
                              text:
                                  "${controller.boxInfo?.battery2Level ?? 0}%",
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
      ),
    );
  }
}

/// SWIPE UP
class _SwipeUpBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => Container(
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Visibility(
          visible: controller.currentPage == 0,
          child: Row(
            spacing: 12.w,
            children: [
              Expanded(
                  child: Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: AppTheme.contentNeutralLight)),
              SvgPicture.asset(IconAsset.chevronUp, height: 16.h, width: 16.h),
              AppText(
                text: AppString.swipeUp,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppTheme.contentNeutralLight,
              ),
              Expanded(
                  child: Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: AppTheme.contentNeutralLight)),
            ],
          ),
        ),
      ),
    );
  }
}

/// ADVERT BOX
class _AdvertBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => OutlinedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.h,
          children: [
            // SvgPicture.asset(
            //   IconAsset.ioniser,
            //   height: 24.h,
            //   width: 24.h,
            //   colorFilter: ColorFilter.mode(
            //       AppTheme.contentNeutralLight, BlendMode.srcIn),
            // ),
            AppText(
              text: AppString.ioniser,
              fontWeight: FontWeight.w600,
              color: AppTheme.contentNeutralPrimary,
            ),
            SizedBox(
              height: 24.h,
              child: Row(
                spacing: 8.w,
                children: [
                  CommonSwitch(
                    onToggle: controller.boxConnectionStatus
                        ? controller.toggleIoniserSwitch
                        : () {},
                    isOn: controller.ioniserSwitch,
                  ),
                  AppText(
                    text:
                        controller.ioniserSwitch ? AppString.on : AppString.off,
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ],
              ),
            ),
            Row(
              spacing: 8.w,
              children: [
                SvgPicture.asset(IconAsset.warning),
                AppText(
                  text: AppString.maycauseHarm,
                  fontWeight: FontWeight.w300,
                  fontSize: 13.sp,
                  height: 1,
                  color: AppTheme.strokeInteractiveBrandDefault,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// BOX-CAM BOX
class _BoxCamBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => OutlinedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.h,
          children: [
            SvgPicture.asset(
              IconAsset.camera,
              height: 24.h,
              width: 24.h,
              colorFilter: ColorFilter.mode(
                  AppTheme.contentNeutralLight, BlendMode.srcIn),
            ),
            AppText(
              text: AppString.boxcam360,
              fontWeight: FontWeight.w600,
              color: AppTheme.contentNeutralPrimary,
            ),
            Container(
              height: 24.h,
              alignment: Alignment.centerLeft,
              child: CommonStatusPill(
                  title: AppString.on, type: StatusType.connected),
            ),
          ],
        ),
      ),
    );
  }
}
