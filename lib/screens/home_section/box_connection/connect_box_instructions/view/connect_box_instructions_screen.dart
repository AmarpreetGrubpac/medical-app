import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_back_button.dart';
import 'package:grubpac_driver/common_components/common_box.dart';
import 'package:grubpac_driver/common_components/common_custom_painter.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';

class ConnectBoxInstructionsScreen extends StatelessWidget {
  ConnectBoxInstructionsScreen({super.key});

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
                    padding: EdgeInsets.only(top: 70.h, bottom: 24.h),
                    child: CommonBox(isConnected: false),
                  ),
                  AppText(
                    text: AppString.boxNumber,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.contentBrandDefault,
                  ),
                  70.h.verticalSpace,
                  AppText(
                    text: AppString.holdOn,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.contentNeutralPrimary,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 36.h),
                    child: Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(text: AppString.beforeStart, fontSize: 18.sp, fontWeight: FontWeight.w400),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: SvgPicture.asset(
                                IconAsset.checkSquare,
                                height: 24.h,
                                width: 24.h,
                                colorFilter: ColorFilter.mode(
                                  AppTheme.contentBrandPrimaryGreen,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            Expanded(
                              child: AppText(
                                text: AppString.turnOnBluetooth,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: SvgPicture.asset(
                                IconAsset.checkSquare,
                                height: 24.h,
                                width: 24.h,
                                colorFilter: ColorFilter.mode(
                                  AppTheme.contentBrandPrimaryGreen,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            Expanded(
                              child: AppText(
                                text: AppString.bluetoothLocation,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CommonOutlinedButton(
                    onPressed: () {
                      Navigation.pushNamed(RouteHelper.boxConnecting, arg: {"is_from": isFrom});
                    },
                    title: AppString.tryToConnect,
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
