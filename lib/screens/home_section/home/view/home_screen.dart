import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
import 'package:grubpac_driver/common_components/common_box.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/common_components/common_custom_painter.dart';
import 'package:grubpac_driver/common_components/common_icon_button.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/common_components/common_text_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/date_helper.dart';
import 'package:grubpac_driver/screens/home_section/home/controller/home_controller.dart';
import 'package:grubpac_driver/screens/home_section/home/widgets/info_card.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_details_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BoxManagementController>().fetchBoxes(isRefresh: false);
      homeController.getUserName();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return GetBuilder<BoxManagementController>(
          builder: (boxCtrl) {
            // Derive state from the real box list
            final bool isBoxAdded = boxCtrl.boxes.isNotEmpty;
            final BoxInfo? currentBox =
                isBoxAdded && boxCtrl.currentPage < boxCtrl.boxes.length
                    ? boxCtrl.boxes[boxCtrl.currentPage]
                    : null;
            final bool isBoxConnected = currentBox?.isConnected ?? false;
            final bool isBoxLocked = currentBox?.isLocked ?? true;

            return SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: isBoxAdded
                        ? CustomPaint(painter: GlowSemiCirclePainters())
                        : const SizedBox.shrink(),
                  ),
                  Column(
                    children: [
                      CommonAppNameBar(
                        isHome: true,
                        isDashboardScreen: true,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            GetBuilder<ProfileDetailsController>(
                              builder: (profileController) {
                                return CommonBackAppBar(
                                  title:
                                      "${getGreeting()} ${Get.find<ProfileDetailsController>().firstname}!",
                                  fontSize: 18.sp,
                                  backArrow: false,
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Row(
                                spacing: 16.w,
                                children: [
                                  Expanded(
                                    child: InfoCard(
                                      icon: IconAsset.locationPin,
                                      label: AppString.location,
                                      value: "Delhi",
                                    ),
                                  ),
                                  Expanded(
                                    child: InfoCard(
                                      icon: IconAsset.thermometer,
                                      label: AppString.temperature,
                                      value: "${currentBox?.extTemp ?? 23}°C",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            isBoxAdded
                                ? Expanded(
                                    child: Column(
                                      children: [
                                        CommonBackAppBar(
                                          title: AppString.addedBoxes,
                                          fontSize: 18.sp,
                                          fontColor:
                                              AppTheme.contentNeutralSecondary,
                                          backArrow: false,
                                          trailing: CommonCompactTextButton(
                                            onPressed: controller.onManageTap,
                                            title: AppString.manage,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              PageView.builder(
                                                controller:
                                                    boxCtrl.pageController,
                                                itemCount: boxCtrl.boxes.length,
                                                onPageChanged:
                                                    boxCtrl.onPageChanged,
                                                itemBuilder: (context, index) {
                                                  final box =
                                                      boxCtrl.boxes[index];
                                                  return box.isConnected
                                                      ? ConnectedView(
                                                          box: box,
                                                          isBoxLocked:
                                                              box.isLocked,
                                                          onDisTap: () =>
                                                              controller
                                                                  .onDisconnectTap(
                                                                      box.id,
                                                                      box.name),
                                                          onViewTap: () =>
                                                              controller
                                                                  .onViewDetailTap(
                                                                      box.id),
                                                          onLockTap: () =>
                                                              controller
                                                                  .onLockTap(
                                                            context,
                                                            box.id,
                                                          ),
                                                        )
                                                      : DisconnectedView(
                                                          box: box,
                                                          onConnectTap: () =>
                                                              controller
                                                                  .onConnectTap(
                                                                      box.id),
                                                        );
                                                },
                                              ),
                                              Positioned(
                                                top: 114.h,
                                                left: 24.w,
                                                child: CommonCompactIconButton(
                                                  onTap:
                                                      boxCtrl.goToPreviousBox,
                                                  icon: IconAsset.arrowLeft,
                                                  size: 20.h,
                                                  iconColor: AppTheme
                                                      .contentBrandDefault,
                                                  pressedIconColor: AppTheme
                                                      .contentBrandDefault,
                                                  pressedBgColor: AppTheme
                                                      .pressedTextBtnColor,
                                                ),
                                              ),
                                              Positioned(
                                                top: 114.h,
                                                right: 24.w,
                                                child: CommonCompactIconButton(
                                                  onTap: boxCtrl.goToNextBox,
                                                  icon: IconAsset.arrowRight,
                                                  size: 20.h,
                                                  iconColor: AppTheme
                                                      .contentBrandDefault,
                                                  pressedIconColor: AppTheme
                                                      .contentBrandDefault,
                                                  pressedBgColor: AppTheme
                                                      .pressedTextBtnColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : _EmptyView(onTap: controller.onAddBoxTap),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (controller.isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Empty State ────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyView({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 70.h, bottom: 48.h),
          child: SvgPicture.asset(
            AppTheme.isDark ? IconAsset.tripDark : IconAsset.trip,
            height: 200.h,
            width: 200.h,
          ),
        ),
        AppText(
          text: AppString.welcomeTrip,
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          color: AppTheme.commonColor,
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
          child: AppText(
            text: AppString.scanQRLine,
            textAlign: TextAlign.center,
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.contentNeutralSecondary,
          ),
        ),
        IntrinsicWidth(
          child: CommonButton(
            onPressed: onTap,
            iconSize: 24.h,
            fontSize: 18.sp,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            title: AppString.addMyBox,
            icon: IconAsset.scan,
          ),
        ),
      ],
    );
  }
}

// ─── Connected View ─────────────────────────────────────────────────────────

class ConnectedView extends StatelessWidget {
  final BoxInfo box;
  final bool isBoxLocked;
  final VoidCallback onViewTap;
  final Future<void> Function() onDisTap;
  final VoidCallback onLockTap;

  const ConnectedView({
    required this.box,
    required this.isBoxLocked,
    required this.onViewTap,
    required this.onDisTap,
    required this.onLockTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: CommonBox(
              onTap: onLockTap,
              isGrubLock: true,
              isBoxLocked: isBoxLocked,
            ),
          ),
          AppText(
            text: box.name.isNotEmpty ? box.name : box.boxDisplayId,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.contentNeutralPrimary,
          ),
          24.h.verticalSpace,
          IntrinsicWidth(
            child: CommonOutlinedButton(
              onPressed: onViewTap,
              title: AppString.viewDetails,
              fontSize: 18.sp,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: IntrinsicWidth(
              child: CommonTextButton(
                onPressed: onDisTap,
                title: AppString.disconnectBtn,
                height: 46.h,
                fontSize: 18.sp,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Disconnected View ───────────────────────────────────────────────────────

class DisconnectedView extends StatelessWidget {
  final BoxInfo box;
  final VoidCallback onConnectTap;

  const DisconnectedView({
    required this.box,
    required this.onConnectTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const CommonBox(isConnected: false),
          ),
          AppText(
            text: box.name.isNotEmpty ? box.name : box.boxDisplayId,
            textAlign: TextAlign.center,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.contentNeutralPrimary,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
            child: AppText(
              text: AppString.readyToConnect,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
            ),
          ),
          IntrinsicWidth(
            child: CommonButton(
              onPressed: onConnectTap,
              title: AppString.connect,
              height: 46.h,
              fontSize: 18.sp,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
          ),
        ],
      ),
    );
  }
}
