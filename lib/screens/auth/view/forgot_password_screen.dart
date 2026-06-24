import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/common_back_button.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/screens/auth/controller/login_controller.dart';

import '../../../common_components/app_text.dart';
import '../../../common_components/common_textfield.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_string.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final ValueNotifier<bool> isEmailFilled = ValueNotifier(false);

  bool _isValidEmail(String value) {
    return value.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (loginController) {
      return Scaffold(
        resizeToAvoidBottomInset: true,

        /// 🔽 BOTTOM VERIFY BUTTON
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
            child: CommonOutlinedButton(
              title: AppString.next,
              isDisabled: loginController.isBtnDisabled,
              isLoading: loginController.isLoading,
              onPressed: () {
                if (loginController.isBtnDisabled) return;

                FocusScope.of(context).unfocus();
                loginController.forgotPassword(
                  loginController.emailController.text.trim(),
                );
              },
            ),
          ),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24.w, 30.h, 24.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonBackButton(),
                30.h.verticalSpace,
                Center(
                  child: AppText(
                    text: AppString.forgotpassword,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                ),
                36.h.verticalSpace,
                AppText(
                  text: AppString.forgotpasswordDescription,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.contentNeutralSecondary,
                  fontSize: 18.sp,
                ),
                36.h.verticalSpace,
                GetBuilder<LoginController>(
                  builder: (controller) {
                    return CommonTextField(
                      hintText: AppString.emailId,
                      controller: controller.emailController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        if (controller.isPhoneNumber)
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                        if (!controller.isPhoneNumber) LowerCaseTextFormatter(),
                      ],
                      prefix: IntrinsicWidth(
                        child: Container(
                          padding: EdgeInsets.only(left: 16.w, right: 12.w),
                          child: Row(
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
                              if (controller.isPhoneNumber) ...[
                                SizedBox(width: 12.w),
                                AppText(
                                  text: "+91",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.sp,
                                  color: AppTheme.contentNeutralSecondary,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      validator: controller.authValidator,
                    );
                  },
                ),
                120.h.verticalSpace,
              ],
            ),
          ),
        ),
      );
    });
  }
}
