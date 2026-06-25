import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_back_button.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/common_components/common_text_button.dart';
import 'package:grubpac_driver/common_components/custom_pinput.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_utils.dart';
import 'package:grubpac_driver/screens/auth/controller/verify_otp_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyOtpController>(
      builder: (controller) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            controller.otpController.clear();
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 150.h, 24.w, 0.h),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppTheme.isDark
                            ? IconAsset.otpLockDark
                            : IconAsset.otpLock,
                        height: 195.h,
                        width: 195.h,
                      ),
                      70.h.verticalSpace,
                      AppText(
                        text: AppString.otpVerification,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 36.h),
                        child: AppText(
                          text:
                              "${AppString.enterTheOTPSentTO}\n${controller.argsIsNumber ? "${controller.argsCountryCode}\t${controller.argsInput}" : controller.argsInput}",
                          textAlign: TextAlign.center,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.contentNeutralSecondary,
                        ),
                      ),
                      CustomPinPut(controller: controller.otpController),
                      Container(
                        margin: EdgeInsets.only(top: 36.h, bottom: 16.h),
                        alignment: Alignment.centerLeft,
                        child: Countdown(
                          controller: controller.countdownController,
                          seconds: 30,
                          interval: const Duration(milliseconds: 100),
                          onFinished: controller.onCountdownFinished,
                          build: (_, time) => CommonCompactTextButton(
                            onPressed: controller.isTimerCompleted
                                ? controller.onResendCode
                                : () {},
                            title: controller.isTimerCompleted
                                ? AppString.resendCode
                                : "${AppString.resendIn}${AppUtils.timerText(second: time.toInt())}",
                            isDisabled: !controller.isTimerCompleted,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: controller.otpController,
                        builder: (context, value, child) =>
                            CommonOutlinedButton(
                          // onPressed: (){},
                          onPressed: controller.verifyOtp,
                          isLoading: controller.isLoading,
                          isDisabled: value.text.length.isLowerThan(4),
                          title: AppString.verify,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(top: 24.h, left: 24.w, child: CommonBackButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
