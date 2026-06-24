import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/common_components/common_text_button.dart';
import 'package:grubpac_driver/common_components/common_textfield.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_formatters.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/auth/controller/login_controller.dart';

import '../../../common_components/common_outlined_button.dart';
import '../../../core/utils/validation_utils.dart';
import '../controller/existing_user_controller.dart';

class ExistingUserScreen extends StatelessWidget {
  const ExistingUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          bottom: false,
          child: GetBuilder<ExistingUserController>(builder: (controller) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0.h),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      IconAsset.appLogo,
                      width: 223.w,
                      height: 48.h,
                      colorFilter:
                          ColorFilter.mode(AppTheme.primary, BlendMode.srcIn),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 36.h),
                      child: AppText(
                        text: AppString.enterRegisteredPrompt,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.center,
                        color: AppTheme.contentNeutralSecondary,
                      ),
                    ),
                    CommonTextField(
                      suffix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GestureDetector(
                          onTap: () {
                            controller.authController.clear();
                            Navigation.replaceAll(RouteHelper.login);
                          },
                          child: Image.asset(
                            ImageAsset.closeEmail,
                            height: 12,
                            width: 12,
                          ),
                        ),
                      ),
                      controller: controller.authController,
                      hintText: AppString.mobileEmailHint,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        NoSpaceFormatter(),
                        LowerCaseTextFormatter(),
                      ],
                      prefix: IntrinsicWidth(
                        child: Container(
                          padding: EdgeInsets.only(left: 16.w, right: 12.w),
                          child: Row(
                            spacing: 12.w,
                            children: [
                              SvgPicture.asset(
                                IconAsset.user,
                                height: 24.h,
                                width: 24.h,
                                colorFilter: ColorFilter.mode(
                                  AppTheme.contentNeutralLight,
                                  BlendMode.srcIn,
                                ),
                              ),
                              if (controller.isPhoneNumber)
                                AppText(
                                  text: "+91",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.sp,
                                  color: AppTheme.contentNeutralSecondary,
                                ),
                            ],
                          ),
                        ),
                      ),
                      validator: controller.authValidator,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CommonTextField(
                      controller: controller.passController,
                      isPassword: true,
                      prefix: IntrinsicWidth(
                        child: Container(
                          padding: EdgeInsets.only(left: 16.w, right: 12.w),
                          child: Row(
                            spacing: 12.w,
                            children: [
                              SvgPicture.asset(
                                IconAsset.key,
                                height: 24.h,
                                width: 24.h,
                                colorFilter: ColorFilter.mode(
                                  AppTheme.contentNeutralLight,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      hintText: AppString.password,
                      validator: (value) => AppValidation.passValidator(value),
                    ),
                    18.h.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigation.pushNamed(
                              RouteHelper.forgotPasswordScreen,
                            );
                          },
                          child: AppText(
                            text: AppString.forgotPassword,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.contentBrandDefault,
                            textDecoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.25,
                    ),
                    // Spacer(), // 👈 pushes below content to bottom

                    GetBuilder<ExistingUserController>(
                      builder: (controller) => CommonOutlinedButton(
                        onPressed: () {
                          controller.loginThroughOtp();
                        },
                        // onPressed: controller.isFormValid ? controller.login : null,
                        // isDisabled: !controller.isFormValid,
                        isDisabled: true,
                        isLoading: controller.isOtpLoading,
                        allowTapWhenDisabled: true,       // 👈 BUT clickable

                        title: AppString.LOGINUSINGOTP,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.h, bottom: 26.h),
                      child: CommonButton(
                        onPressed: () {
                          controller.loginExistingUser();
                        },
                        isLoading: controller.isLoading,
                        title: AppString.continueBtn,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CommonTextButton(
                            onPressed: Get.find<LoginController>().onPolicyTap,
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
                  ],
                ),
              ),
            );
          })),
    );
  }
}
