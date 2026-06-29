import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/common_components/common_status_pill.dart';
import 'package:grubpac_driver/common_components/common_switch.dart';
import 'package:grubpac_driver/common_components/common_text_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/screens/box_details/controller/box_details_controller.dart';
import 'package:grubpac_driver/screens/box_details/widgets/expandable_widgets.dart';
import 'package:grubpac_driver/screens/box_details/widgets/outlined_box.dart';
import 'package:grubpac_driver/screens/box_details/widgets/zone_card.dart';

class SecondDetailsView extends StatelessWidget {
  const SecondDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => Column(
        children: [
          _SwipeDownBox(),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 8.h),
              child: Column(
                children: [
                  CommonBackAppBar(
                    title: controller.boxInfo?.name.isNotEmpty == true
                        ? controller.boxInfo!.name
                        : (controller.boxInfo?.boxDisplayId.isNotEmpty == true
                            ? controller.boxInfo!.boxDisplayId
                            : AppString.boxNumber),
                    backArrow: false,
                    ignoreHPadding: true,
                    trailing: CommonCompactTextButton(
                      onPressed: controller.onLogsTap,
                      title: AppString.viewLogs,
                      fontSize: 18.sp,
                      icon: IconAsset.arrowUpRight,
                      iconSize: 24.h,
                    ),
                  ),
                  _ZoneBoxes(),
                  _BoxWidget(),
                  _ConnectionsWidget(),
                  _PowerWidget(),
                  _StorageWidget(),
                  _CameraWidget(),
                  _LightWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// SWIPE DOWN
class _SwipeDownBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => Container(
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Visibility(
          visible: controller.currentPage == 1,
          child: Row(
            spacing: 12.w,
            children: [
              Expanded(
                  child: Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: AppTheme.contentNeutralLight)),
              SvgPicture.asset(IconAsset.chevronDown,
                  height: 16.h, width: 16.h),
              AppText(
                text: AppString.swipeDown,
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

/// ZONE BOXES
class _ZoneBoxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) {
        final isConnected = controller.boxConnectionStatus;
        return Row(
          spacing: 16.w,
          children: [
            Expanded(
              child: ZoneCard(
                zoneName: "Zone 1",
                targetTemp: "${controller.firstBattery}",
                achievedTemp: "${controller.firstBattery}",
                isOn: controller.zoneBox1Switch,
                onToggle: isConnected ? controller.toggleZoneBox1 : () {},
                type: controller.zoneBox1Switch
                    ? ZoneBoxType.getType(controller.firstBattery)
                    : ZoneBoxType.disabled,
              ),
            ),
            if (controller.dualZoneSwitch)
              Expanded(
                child: ZoneCard(
                  zoneName: "Zone 2",
                  targetTemp: "${controller.secondBattery}",
                  achievedTemp: "${controller.secondBattery}",
                  isOn: controller.zoneBox2Switch,
                  onToggle: isConnected ? controller.toggleZoneBox2 : () {},
                  type: controller.zoneBox2Switch
                      ? ZoneBoxType.getType(controller.secondBattery)
                      : ZoneBoxType.disabled,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// BOX
class _BoxWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) {
        final isConnected = controller.boxConnectionStatus;
        return ExpandableTile(
            onTap: controller.toggleBox,
            isExpanded: controller.isBoxExpanded,
            title: AppString.boxSmall,
            child: Column(
              spacing: 12.h,
              children: [
                ExpandableBox(
                  onTap: controller.toggleStatusBox,
                  isExpanded: controller.isStatusBoxExpanded,
                  icon: IconAsset.heart,
                  title: AppString.status,
                  trailing: CommonStatusPill(
                    title: isConnected
                        ? AppString.connectedBtn
                        : AppString.disconnectedBtn,
                    type: isConnected
                        ? StatusType.connected
                        : StatusType.disconnected,
                  ),
                  child: Column(
                    spacing: 12.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: isConnected
                            ? AppString.currentlyConnected
                            : AppString.currentlyDisconnected,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                      CommonOutlinedButton(
                        onPressed: controller.toggleBoxStatus,
                        height: 32.h,
                        title: isConnected
                            ? AppString.disconnectClick
                            : AppString.connectClick,
                        fontSize: 14.sp,
                      ),
                    ],
                  ),
                ),
                ExpandableBox(
                  onTap: controller.toggleAdvertBox,
                  isExpanded: controller.isAdvertBoxExpanded,
                  icon: IconAsset.advertScreen,
                  title: AppString.advert,
                  trailing: Row(
                    spacing: 8.w,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonSwitch(
                          onToggle:
                              isConnected ? controller.toggleAdvert : () {},
                          isOn: controller.advertSwitch),
                      AppText(
                        text: controller.advertSwitch
                            ? AppString.on
                            : AppString.off,
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ],
                  ),
                  child: AppText(
                    text: controller.advertSwitch
                        ? AppString.externalDisplayOn
                        : AppString.externalDisplayOff,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
                ExpandableBox(
                  icon: IconAsset.lock,
                  title: AppString.grublock,
                  isGrublock: true,
                  trailing: CommonStatusPill(
                      title: AppString.locked, type: StatusType.disconnected),
                ),
                ExpandableBox(
                  icon: IconAsset.ioniser,
                  title: AppString.ioniserLabel,
                  trailing: Row(
                    spacing: 8.w,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonSwitch(
                          onToggle: isConnected
                              ? controller.toggleIoniserSwitch
                              : () {},
                          isOn: controller.ioniserSwitch),
                      AppText(
                        text: controller.ioniserSwitch
                            ? AppString.on
                            : AppString.off,
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ],
                  ),
                ),
                ExpandableBox(
                  onTap: controller.toggleThermoBox,
                  isExpanded: controller.isThermoBoxExpanded,
                  icon: IconAsset.sun,
                  title: AppString.thermostat,
                  trailing: AppText(text: "23°C", fontWeight: FontWeight.w600),
                  child: Column(
                    spacing: 12.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: AppString.externalThermostat,
                        maxLines: 3,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                      OutlinedBox(
                        borderColor: AppTheme.primary,
                        child: Row(
                          spacing: 8.w,
                          children: [
                            SvgPicture.asset(
                              IconAsset.thermometer,
                              height: 32.h,
                              width: 32.h,
                              colorFilter: ColorFilter.mode(
                                AppTheme.contentBrandPrimaryOrange,
                                BlendMode.srcIn,
                              ),
                            ),
                            AppText(
                              text: AppString.outSideTemp,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            AppText(
                              text: "23°C",
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.contentNeutralPrimary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ExpandableBox(
                  icon: IconAsset.gyrosensor,
                  title: AppString.gyrosensor,
                  trailing: CommonStatusPill(
                      title: AppString.detected, type: StatusType.connected),
                ),
              ],
            ));
      },
    );
  }
}

/// CONNECTIONS
class _ConnectionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => ExpandableTile(
        onTap: controller.toggleConnections,
        isExpanded: controller.isConnectionsExpanded,
        title: AppString.connections,
        child: Column(
          spacing: 12.h,
          children: [
            ExpandableBox(
              icon: IconAsset.wifi,
              title: AppString.wifiLabel,
              trailing: CommonStatusPill(
                  title: AppString.noSignal, type: StatusType.disconnected),
            ),
            ExpandableBox(
              icon: IconAsset.bluetooth,
              title: AppString.bluetoothLabel,
              trailing: CommonStatusPill(
                  title: AppString.strong, type: StatusType.connected),
            ),
            ExpandableBox(
              icon: IconAsset.signal,
              title: AppString.fourGLabel,
              trailing: CommonStatusPill(
                  title: AppString.weak, type: StatusType.weak),
            ),
            ExpandableBox(
              icon: IconAsset.locationArrow,
              title: AppString.gpsLabel,
              trailing: CommonStatusPill(
                  title: AppString.on, type: StatusType.connected),
            ),
          ],
        ),
      ),
    );
  }
}

/// POWER
class _PowerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => ExpandableTile(
        onTap: controller.togglePower,
        isExpanded: controller.isPowerExpanded,
        title: AppString.power,
        child: Column(
          spacing: 12.h,
          children: [
            ExpandableBox(
              onTap: controller.toggleBatteryBox,
              isExpanded: controller.isBatteryBoxExpanded,
              icon: IconAsset.powerBank,
              title: AppString.batteryLabel,
              trailing: AppText(
                  text: "${controller.boxInfo?.batteryLevel ?? 0}%",
                  fontWeight: FontWeight.w600),
              child: Column(
                spacing: 12.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: AppString.aboutFifty.replaceAll(
                        "50%", "${controller.boxInfo?.batteryLevel ?? 0}%"),
                    maxLines: 3,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
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
                                IconAsset.batteryFull,
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
                                      text: "Battery A",
                                      color: AppTheme.contentNeutralPrimary,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    CommonStatusPill(
                                        title: "100%",
                                        type: StatusType.connected),
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
                                IconAsset.battery,
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
                                      text: "Battery B",
                                      color: AppTheme.contentNeutralPrimary,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    CommonStatusPill(
                                        title: "0%",
                                        type: StatusType.disconnected),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: IntrinsicWidth(
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
                              colorFilter: ColorFilter.mode(
                                AppTheme.contentBrandPrimary,
                                BlendMode.srcIn,
                              ),
                            ),
                            AppText(
                              text: AppString.plsChargeBattery,
                              color: AppTheme.contentBrandPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ExpandableBox(
              icon: IconAsset.sun,
              title: AppString.solarPanelsLabel,
              trailing: CommonStatusPill(
                  title: AppString.detected, type: StatusType.connected),
            ),
            ExpandableBox(
              icon: IconAsset.plug,
              title: AppString.port220VLabel,
              trailing: CommonStatusPill(
                  title: AppString.detected, type: StatusType.connected),
            ),
            ExpandableBox(
              icon: IconAsset.plug,
              title: AppString.port12VLabel,
              trailing: CommonStatusPill(
                  title: AppString.detected, type: StatusType.connected),
            ),
          ],
        ),
      ),
    );
  }
}

/// STORAGE
class _StorageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => ExpandableTile(
        onTap: controller.toggleStorage,
        isExpanded: controller.isStorageExpanded,
        title: AppString.storage,
        child: Column(
          spacing: 12.h,
          children: [
            ExpandableBox(
              icon: IconAsset.memoryCard,
              title: AppString.memoryCardLabel,
              trailing: AppText(text: "80%", fontWeight: FontWeight.w600),
            ),
            ExpandableBox(
              icon: IconAsset.floppyDisk,
              title: AppString.saveToCardLabel,
              trailing: CommonStatusPill(
                  title: AppString.on, type: StatusType.connected),
            ),
          ],
        ),
      ),
    );
  }
}

/// CAMERA
class _CameraWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => ExpandableTile(
        onTap: controller.toggleCamera,
        isExpanded: controller.isCameraExpanded,
        title: AppString.camera,
        child: Column(
          spacing: 12.h,
          children: [
            ExpandableBox(
              icon: IconAsset.camera,
              title: AppString.boxcam360,
              trailing: CommonStatusPill(
                  title: AppString.on, type: StatusType.connected),
            ),
            ExpandableBox(
              icon: IconAsset.webcam,
              title: AppString.adas,
              trailing: CommonStatusPill(
                  title: AppString.on, type: StatusType.connected),
            ),
          ],
        ),
      ),
    );
  }
}

/// LIGHT
class _LightWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => ExpandableTile(
        onTap: controller.toggleLight,
        isExpanded: controller.isLightExpanded,
        title: AppString.light,
        child: ExpandableBox(
          icon: IconAsset.arrowsRightLeft,
          title: AppString.turnSignals,
          trailing: CommonStatusPill(
              title: AppString.detected, type: StatusType.connected),
        ),
      ),
    );
  }
}
