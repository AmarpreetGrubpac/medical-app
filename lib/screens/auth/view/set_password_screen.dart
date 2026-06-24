import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_log_out_button.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/common_components/common_textfield.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/validation_utils.dart';
import 'package:grubpac_driver/screens/auth/controller/set_password_controller.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetPasswordController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
            child: Form(
              key: controller.formKey,
              autovalidateMode: controller.autoValidateMode,
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: CommonLogOutButton()),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 66.h),
                    child: SvgPicture.asset(
                      AppTheme.isDark ? IconAsset.tripDark : IconAsset.trip,
                      height: 200.h,
                      width: 200.h,
                    ),
                  ),
                  AppText(
                    text: AppString.welcomeRavi,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.commonColor,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 36.h),
                    child: AppText(
                      text: AppString.setPassSubtitle,
                      fontSize: 18.sp,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Column(
                    spacing: 16.h,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: controller.passController,
                        builder: (_, textValue, child) => CommonTextField(
                          controller: controller.passController,
                          isPassword: true,
                          hintText: AppString.enterPassword,
                          validator: (value) =>
                              AppValidation.passValidator(value),
                          hasError: controller.autoValidateMode ==
                                  AutovalidateMode.always
                              ? AppValidation.passValidator(textValue.text) !=
                                  null
                              : false,
                        ),
                      ),
                      ListenableBuilder(
                        listenable: Listenable.merge([
                          controller.passController,
                          controller.confirmPassController
                        ]),
                        builder: (_, child) => CommonTextField(
                          controller: controller.confirmPassController,
                          isPassword: true,
                          hintText: AppString.reEnterPassword,
                          validator: (value) =>
                              AppValidation.confirmPassValidator(
                                  value, controller.passController.text),
                          hasError: controller.autoValidateMode ==
                                  AutovalidateMode.always
                              ? AppValidation.confirmPassValidator(
                                      controller.confirmPassController.text,
                                      controller.passController.text) !=
                                  null
                              : false,
                        ),
                      ),
                    ],
                  ),
                  36.h.verticalSpace,
                  ListenableBuilder(
                    listenable: Listenable.merge([
                      controller.passController,
                      controller.confirmPassController,
                    ]),
                    builder: (context, child) => CommonOutlinedButton(
                      onPressed: () {
                        controller.setPassword();
                      },
                      isDisabled:
                          controller.passController.text.trim().isEmpty ||
                              controller.confirmPassController.text
                                  .trim()
                                  .isEmpty ||
                              controller.passController.text.trim() !=
                                  controller.confirmPassController.text.trim(),

                      isLoading: controller.isLoading,
                      title: AppString.savePassword,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
