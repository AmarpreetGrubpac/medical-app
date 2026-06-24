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
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_details_controller.dart';

import '../../../../helper/navigation.dart';
import '../../../../helper/route_helper.dart';
import '../../../fallback_screens/buttons_screens.dart';

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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => homeController.getUserName());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: controller.isBoxAdded
                    ? CustomPaint(painter: GlowSemiCirclePainters())
                    : SizedBox.shrink(),
              ),
              // Positioned(
              //   bottom: 24,
              //   right: 24,
              //   child: Material(
              //     color: Colors.transparent,
              //     child: FloatingActionButton(
              //       onPressed: () {
              //         print('on pressed is working');
              //         Navigation.replace(
              //           RouteHelper.statusButtonsScreen,
              //         );
              //       },
              //       backgroundColor: Theme.of(context).primaryColor,
              //       child: const Icon(Icons.interests),
              //     ),
              //   ),
              // ),
              Column(
                children: [
                  CommonAppNameBar(isHome: true),
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
                        }),
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
                                  value: AppString.temperatureValue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        controller.isBoxAdded
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
                                                controller.pageController,
                                            itemCount: 2,
                                            onPageChanged:
                                                controller.onPageChanged,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return controller.isBoxConnected
                                                  ? _ConnectedView(
                                                      onDisTap: controller
                                                          .onDisconnectTap,
                                                      onViewTap: controller
                                                          .onViewDetailTap,
                                                    )
                                                  : _DisconnectedView(
                                                      onConnectTap: controller
                                                          .onConnectTap);
                                            },
                                          ),
                                          Positioned(
                                            top: 114.h,
                                            left: 24.w,
                                            child: CommonCompactIconButton(
                                              onTap: controller.goToPreviousBox,
                                              icon: IconAsset.arrowLeft,
                                              size: 20.h,
                                              iconColor:
                                                  AppTheme.contentBrandDefault,
                                              pressedIconColor:
                                                  AppTheme.contentBrandDefault,
                                              pressedBgColor:
                                                  AppTheme.pressedTextBtnColor,
                                            ),
                                          ),
                                          Positioned(
                                            top: 114.h,
                                            right: 24.w,
                                            child: CommonCompactIconButton(
                                              onTap: controller.goToNextBox,
                                              icon: IconAsset.arrowRight,
                                              size: 20.h,
                                              iconColor:
                                                  AppTheme.contentBrandDefault,
                                              pressedIconColor:
                                                  AppTheme.contentBrandDefault,
                                              pressedBgColor:
                                                  AppTheme.pressedTextBtnColor,
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
            ],
          ),
        );
      },
    );
  }
}

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

class _ConnectedView extends StatelessWidget {
  final VoidCallback onViewTap, onDisTap;

  const _ConnectedView({required this.onViewTap, required this.onDisTap});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: CommonBox(
                onTap: () => controller.onLockTap(context),
                isGrubLock: true,
                isBoxLocked: controller.isBoxLocked,
              ),
            ),
            AppText(
              text: "BOX-1245",
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisconnectedView extends StatelessWidget {
  final VoidCallback onConnectTap;

  const _DisconnectedView({required this.onConnectTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: CommonBox(isConnected: false)),
          AppText(
            text: "BOX-1245",
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
