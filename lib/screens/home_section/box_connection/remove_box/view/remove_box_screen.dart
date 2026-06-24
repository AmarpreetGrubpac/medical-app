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

class RemoveBoxScreen extends StatelessWidget {
  RemoveBoxScreen({super.key});

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
                  Align(alignment: Alignment.centerLeft, child: CommonBackButton()),
                  Padding(
                    padding: EdgeInsets.only(top: 120.h, bottom: 24.h),
                    child: CommonBox(isConnected: false),
                  ),
                  AppText(
                    text: AppString.boxNumber,
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
                    onPressed: () {
                      AppToast.showSuccess(message: AppString.boxRemoved);
                      Navigation.pop(data: {"result": true});
                    },
                    title: AppString.removeBox,
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
