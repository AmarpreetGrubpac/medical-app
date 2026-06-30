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
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_management_controller.dart';

class DisconnectBoxScreen extends StatelessWidget {
  DisconnectBoxScreen({super.key});

  final String isFrom = Get.arguments?["is_from"] ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: CommonBackButton()),
                  Padding(
                    padding: EdgeInsets.only(top: 134.h, bottom: 24.h),
                    child: CommonBox(isConnected: true),
                  ),
                  AppText(
                    text: Get.arguments?["displayName"] ??
                        Get.arguments?["box_id"] ??
                        AppString.boxNumber,
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
                      text: AppString.disconnectionSurety,
                      textAlign: TextAlign.center,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GetBuilder<BoxManagementController>(
                    builder: (controller) {
                      return CommonOutlinedButton(
                        isLoading: controller.isLoading,
                        onPressed: () async {
                          final String boxId = Get.arguments?["box_id"] ?? "";
                          final success = await controller.disconnectBox(boxId);
                          if (success) {
                            AppToast.showSuccess(
                                message: AppString.boxDisConnected);
                            Navigation.pop(data: {"result": true});
                          }
                        },
                        title: AppString.disconnectBtn,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
