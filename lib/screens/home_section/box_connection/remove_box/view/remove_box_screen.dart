import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_back_button.dart';
import 'package:grubpac_driver/common_components/common_box.dart';
import 'package:grubpac_driver/common_components/common_custom_painter.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';

class RemoveBoxScreen extends StatelessWidget {
  RemoveBoxScreen({super.key});

  final String isFrom = Get.arguments?["is_from"] ?? "";
  final String boxId = Get.arguments?["box_id"] ?? "";
  final String boxDisplayId = Get.arguments?["box_display_id"] ?? "";

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxManagementController>(
      builder: (controller) => PopScope(
        // Block the system back gesture while the API call is in-flight.
        canPop: !controller.isLoading,
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  bottom: 200.h,
                  left: 0,
                  right: 0,
                  child: CustomPaint(painter: GlowSemiCirclePainters()),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        // Hide the back button while loading so the user
                        // cannot navigate away mid-request.
                        child: controller.isLoading
                            ? SizedBox(height: 40.h)
                            : CommonBackButton(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 120.h, bottom: 24.h),
                        child: CommonBox(isConnected: false),
                      ),
                      AppText(
                        text: boxDisplayId.isNotEmpty ? boxDisplayId : AppString.boxNumber,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.contentBrandDefault,
                      ),
                      60.h.verticalSpace,
                      AppText(
                        text: AppString.holdOn,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.contentNeutralPrimary,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.h, bottom: 36.h),
                        child: AppText(
                          text: AppString.removeBoxSurety,
                          textAlign: TextAlign.center,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      CommonOutlinedButton(
                        isLoading: controller.isLoading,
                        onPressed: () => controller.removeBox(boxId),
                        title: AppString.removeBox,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
