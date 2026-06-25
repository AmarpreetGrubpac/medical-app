import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
import 'package:grubpac_driver/common_components/common_box.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/common_components/common_icon_button.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/common_components/common_text_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/widget/empty_box_management.dart';

class BoxManagementScreen extends StatelessWidget {
  BoxManagementScreen({super.key});

  final BoxManagementController boxManagementController =
      Get.find<BoxManagementController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxManagementController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                CommonAppNameBar(),
                CommonBackAppBar(title: AppString.boxManagement),
                Divider(
                    height: 1.h,
                    thickness: 1.h,
                    color: AppTheme.strokeInteractiveBrandDisabled),
                CommonBackAppBar(
                  title: AppString.addedBox,
                  backArrow: false,
                  fontSize: 18.sp,
                  trailing: controller.boxes.isNotEmpty
                      ? CommonCompactTextButton(
                          onPressed: controller.onLogsTap,
                          title: AppString.logs,
                          fontSize: 18.sp,
                          icon: IconAsset.arrowUpRight,
                          iconSize: 24.h,
                        )
                      : SizedBox.shrink(),
                ),
                controller.boxes.isNotEmpty
                    ? Expanded(
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: controller.pageController,
                              itemCount: controller.boxes.length,
                              onPageChanged: controller.onPageChanged,
                              itemBuilder: (BuildContext context, int index) {
                                final box = controller.boxes[index];

                                return Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 24.h),
                                      child: CommonBox(
                                          isConnected: box.isConnected),
                                    ),
                                    AppText(
                                        text: box.id,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 8.h, bottom: 24.h),
                                      child: AppText(
                                          text: AppString.lastLog,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    IntrinsicWidth(
                                      child: CommonOutlinedButton(
                                        onPressed: box.isConnected
                                            ? controller.onViewDetailsBoxTap
                                            : controller.onConnectBoxTap,
                                        title: box.isConnected
                                            ? AppString.viewDetails
                                            : AppString.connectBox,
                                        fontSize: 18.sp,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 12.h),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.h),
                                      child: IntrinsicWidth(
                                        child: CommonTextButton(
                                          onPressed: box.isConnected
                                              ? controller.onDisconnectBoxTap
                                              : controller.onRemoveBoxTap,
                                          title: box.isConnected
                                              ? AppString.disconnectBtn
                                              : AppString.removeBox,
                                          fontSize: 18.sp,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w, vertical: 12.h),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Positioned(
                              top: 114.h,
                              left: 24.w,
                              child: CommonCompactIconButton(
                                onTap: controller.goToPreviousBox,
                                icon: IconAsset.arrowLeft,
                                size: 20.h,
                                iconColor: AppTheme.contentBrandDefault,
                                pressedIconColor: AppTheme.contentBrandDefault,
                                pressedBgColor: AppTheme.pressedTextBtnColor,
                              ),
                            ),
                            Positioned(
                              top: 114.h,
                              right: 24.w,
                              child: CommonCompactIconButton(
                                onTap: controller.goToNextBox,
                                icon: IconAsset.arrowRight,
                                size: 20.h,
                                iconColor: AppTheme.contentBrandDefault,
                                pressedIconColor: AppTheme.contentBrandDefault,
                                pressedBgColor: AppTheme.pressedTextBtnColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : EmptyBoxManagement(onTap: controller.onAddBoxTap),
              ],
            ),
          ),
          floatingActionButton: controller.boxes.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(right: 24.w, bottom: 48.h),
                  child: IntrinsicHeight(
                    child: IntrinsicWidth(
                      child: CommonButton(
                        onPressed: controller.onAddBoxTap,
                        title: AppString.addBox,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        icon: IconAsset.plus,
                        iconSize: 24.h,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        );
      },
    );
  }
}
