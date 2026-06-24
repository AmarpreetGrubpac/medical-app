import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
import 'package:grubpac_driver/common_components/common_bottom_box.dart';
import 'package:grubpac_driver/common_components/common_log_out_button.dart';
import 'package:grubpac_driver/common_components/common_menu_box.dart';
import 'package:grubpac_driver/common_components/common_text_button.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_utils.dart';
import 'package:grubpac_driver/screens/auth/controller/login_controller.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_details_controller.dart';
import 'package:grubpac_driver/screens/settings_section/setting/controller/setting_controller.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<SettingController>(
          builder: (controller) => Column(
            children: [
              CommonAppNameBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      CommonBackAppBar(
                        backArrow: false,
                        ignoreHPadding: true,
                        title: AppString.settings,
                        trailing: CommonLogOutButton(isSettings: true),
                      ),
                      GetBuilder<SettingController>(
                        builder: (controller) {
                          return CommonBottomBox(
                            onPressed: controller.onChangeTheme,
                            title: AppString.chooseYourLook,
                            description: AppString.chooseYourLookDescription,
                            buttonText: controller.isDark
                                ? AppString.tryLightMode
                                : AppString.tryDarkMode,
                          );
                        },
                      ),

                      // CommonBottomBox(
                      //   onPressed: controller.onChangeTheme,
                      //   title: AppString.chooseYourLook,
                      //   description: AppString.chooseYourLookDescription,
                      //   buttonText: Get.isDarkMode
                      //       ? AppString.tryLightMode
                      //       : AppString.tryDarkMode,
                      // ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Column(
                          spacing: 16.h,
                          children: [
                            CommonMenuBox(
                              image: '',
                              onTap: controller.onBoxManagementTap,
                              title: AppString.boxManagement,
                              icon: IconAsset.boxManagement,
                            ),
                            CommonMenuBox(
                              image: Get.find<ProfileDetailsController>().image,
                              onTap: controller.onProfileTap,
                              title: AppString.profileDetail,
                              icon: AppUtils.getInitials(controller.username,
                                  maxLetters: 1),
                              isProfile: true,
                            ),
                            CommonMenuBox(
                              image: '',
                              onTap: controller.onAlertTap,
                              title: AppString.alertPreference,
                              icon: IconAsset.alert,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CommonTextButton(
                              onPressed:
                                  Get.find<LoginController>().onPolicyTap,
                              title: AppString.privacyPolicy,
                            ),
                          ),
                          Expanded(
                            child: CommonTextButton(
                              onPressed: Get.find<LoginController>().onTermsTap,
                              title: AppString.termsOfService,
                            ),
                          ),
                        ],
                      ),
                      6.h.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
