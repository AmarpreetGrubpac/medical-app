import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/common_components/common_text_button.dart';
import 'package:grubpac_driver/common_components/custom_pinput.dart';
import 'package:grubpac_driver/common_components/grublock_box.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_utils.dart';
import 'package:grubpac_driver/screens/box_details/controller/box_details_controller.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

Widget detailsGrublockBottomSheet(BuildContext context) {
  return GetBuilder<BoxDetailsController>(builder: (controller) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 48.h),
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            border: Border(
              top: BorderSide(
                color: AppTheme.strokeInteractiveBrandDisabled,
              ),
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -2),
                color: AppTheme.contentOnPrimary.withValues(alpha: 0.16),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GrubLockBox(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: AppText(
                    text: AppString.otpVerification,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.contentNeutralPrimary,
                  ),
                ),
                AppText(
                  text: AppString.currentState,
                  textAlign: TextAlign.center,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                AppText(
                  text:
                      "${controller.countryCode}${AppUtils.maskPhoneNumber(controller.phone)}.",
                  textAlign: TextAlign.center,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: CustomPinPut(controller: controller.otpController),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 16.h),
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
                  builder: (context, value, child) => CommonOutlinedButton(
                    onPressed: () =>
                        Get.find<BoxManagementController>().verifyBoxOtp(
                      controller.boxId,
                      value.text,
                      // controller.action,
                    ),
                    isLoading: controller.isLoading,
                    isDisabled: value.text.length.isLowerThan(4),
                    title: AppString.verify,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
}
