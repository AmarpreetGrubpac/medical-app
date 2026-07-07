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
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';

class BoxConnectionErrorScreen extends StatelessWidget {
  BoxConnectionErrorScreen({super.key});

  final String isFrom = Get.arguments?["is_from"] ?? "";
  final String boxId = Get.arguments?["box_id"] ?? "";
  final String boxDisplayId = Get.arguments?["box_display_id"] ?? "";

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
                    padding: EdgeInsets.only(top: 66.h, bottom: 24.h),
                    child: CommonBox(isConnected: false),
                  ),
                  AppText(
                    text: boxDisplayId.isNotEmpty ? boxDisplayId : AppString.boxNumber,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.contentBrandDefault,
                  ),
                  66.h.verticalSpace,
                  AppText(
                    text: AppString.notConnected,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.contentNeutralPrimary,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 36.h),
                    child: Column(
                      spacing: 8.h,
                      children: [
                        AppText(
                          text: AppString.makeSureInstruction,
                          textAlign: TextAlign.center,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        AppText(text: AppString.tryMoving, fontSize: 18.sp, fontWeight: FontWeight.w400),
                      ],
                    ),
                  ),
                  CommonOutlinedButton(
                    onPressed: () {
                      Navigation.pushNamed(RouteHelper.boxConnecting, arg: {
                        "is_from": isFrom,
                        "box_id": boxId,
                        "box_display_id": boxDisplayId,
                      });
                    },
                    title: AppString.tryAgain,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 16.h),
                    alignment: Alignment.centerLeft,
                    child: AppText(text: AppString.whyNot, color: AppTheme.contentBrandDefault),
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
