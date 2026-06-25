import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/common_textfield.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/core/utils/validation_utils.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';

import '../../../common_components/app_text.dart';
import '../../../common_components/common_back_button.dart';
import '../../../common_components/common_button.dart';
import '../controller/set_password_controller.dart';

class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({super.key});

  Widget build(BuildContext context) {
    return GetBuilder<SetPasswordController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,

          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 35.h),
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  controller.passController,
                  controller.confirmPassController,
                ]),
                builder: (context, _) {
                  final isDisabled = controller.passController.text
                          .trim()
                          .isEmpty ||
                      controller.confirmPassController.text.trim().isEmpty ||
                      // AppValidation.passValidator(
                      //         controller.passController.text) !=
                      //     null ||
                      AppValidation.confirmPassValidator(
                              controller.confirmPassController.text,
                              controller.passController.text) !=
                          null;

                  return CommonButton(
                    key: ValueKey(isDisabled), // 🔥 force rebuild
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      controller.setNewPassword(); // ✅ CALL API
                    },
                    isLoading: controller.isLoading,
                    title: AppString.savePassword,
                    isDisabled: isDisabled,
                  );
                },
              ),
            ),
          ),

          /// 🔼 CONTENT
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonBackButton(),
                  30.h.verticalSpace,

                  Center(
                    child: AppText(
                      text: AppString.setNewPassword,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  36.h.verticalSpace,

                  AppText(
                    text: AppString.setNewPassworddescription,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    color: AppTheme.contentNeutralSecondary,
                  ),

                  36.h.verticalSpace,

                  Column(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: controller.passController,
                        builder: (_, textValue, __) => CommonTextField(
                          controller: controller.passController,
                          isPassword: true,
                          hintText: AppString.enternewPassword,
                          validator: AppValidation.passValidator,
                          hasError: controller.autoValidateMode ==
                                  AutovalidateMode.always &&
                              AppValidation.passValidator(textValue.text) !=
                                  null,
                        ),
                      ),
                      16.h.verticalSpace,
                      ListenableBuilder(
                        listenable: Listenable.merge([
                          controller.passController,
                          controller.confirmPassController,
                        ]),
                        builder: (_, __) => CommonTextField(
                          controller: controller.confirmPassController,
                          isPassword: true,
                          hintText: AppString.reenternewPassword,
                          validator: (value) =>
                              AppValidation.confirmPassValidator(
                                  value, controller.passController.text),
                          hasError: controller.autoValidateMode ==
                                  AutovalidateMode.always &&
                              AppValidation.confirmPassValidator(
                                      controller.confirmPassController.text,
                                      controller.passController.text) !=
                                  null,
                        ),
                      ),
                    ],
                  ),

                  /// Extra space so fields are not hidden
                  120.h.verticalSpace,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
