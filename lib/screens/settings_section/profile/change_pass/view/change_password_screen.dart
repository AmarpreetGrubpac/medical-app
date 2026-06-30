import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/common_components/common_textfield.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/validation_utils.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/settings_section/profile/change_pass/controller/change_password_controller.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_details_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: Form(
            key: controller.formKey,
            autovalidateMode: controller.autoValidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonAppNameBar(),
                CommonBackAppBar(title: AppString.changePass),
                Divider(
                    height: 1.h,
                    thickness: 1.h,
                    color: AppTheme.strokeInteractiveBrandDisabled),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                            text: AppString.hitSave,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400),
                        Padding(
                          padding: EdgeInsets.only(top: 24.h, bottom: 4.h),
                          child: ValueListenableBuilder(
                            valueListenable: controller.oldPassController,
                            builder: (_, textValue, child) => CommonTextField(
                              controller: controller.oldPassController,
                              isPassword: true,
                              hintText: AppString.currentPass,
                              validator: (value) =>
                                  AppValidation.oldPassValidator(value),
                              hasError: controller.autoValidateMode ==
                                      AutovalidateMode.always
                                  ? AppValidation.oldPassValidator(
                                          textValue.text) !=
                                      null
                                  : false,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                String userAuth = "";
                                if (Get.isRegistered<ProfileDetailsController>()) {
                                  final profileController =
                                      Get.find<ProfileDetailsController>();
                                  userAuth = profileController.email.isNotEmpty
                                      ? profileController.email
                                      : profileController.phone;
                                }
                                Navigation.pushNamed(
                                  RouteHelper.forgotPasswordScreen,
                                  arg: {
                                    "from_change_pass": true,
                                    "user_auth": userAuth,
                                  },
                                );
                              },
                              child: Text(
                                "Forgot Password ?",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: AppTheme.contentBrandPrimary,
                                ),
                                // style: AppTheme.textStyle(
                                //     fontSize: 14.sp,
                                //     fontWeight: FontWeight.w400,
                                //     color: AppTheme.buttonBackground),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        ListenableBuilder(
                          listenable: Listenable.merge([
                            controller.oldPassController,
                            controller.newPassController
                          ]),
                          builder: (_, child) => CommonTextField(
                            controller: controller.newPassController,
                            isPassword: true,
                            hintText: AppString.newPass,
                            validator: (value) =>
                                AppValidation.newPassValidator(
                                    value, controller.oldPassController.text),
                            hasError: controller.autoValidateMode ==
                                    AutovalidateMode.always
                                ? AppValidation.newPassValidator(
                                        controller.newPassController.text,
                                        controller.oldPassController.text) !=
                                    null
                                : false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 48.h),
            child: ListenableBuilder(
              listenable: Listenable.merge(
                  [controller.oldPassController, controller.newPassController]),
              builder: (context, child) => CommonButton(
                onPressed: controller.onSavePassTap,
                isDisabled: controller.oldPassController.text.trim().isEmpty ||
                    controller.newPassController.text.trim().isEmpty,
                isLoading: controller.isLoading,
                title: AppString.savePassword,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
