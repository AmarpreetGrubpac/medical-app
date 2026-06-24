import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/common_components/common_log_out_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
          child: Column(
            children: [
              Align(alignment: Alignment.topRight, child: CommonLogOutButton()),
              Padding(
                padding: EdgeInsets.only(top: 116.h, bottom: 60.h),
                child: SvgPicture.asset(
                  AppTheme.isDark ? IconAsset.tripDark : IconAsset.trip,
                  height: 200.h,
                  width: 200.h,
                ),
              ),
              AppText(
                text: AppString.allSet,
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.commonColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 36.h),
                child: Column(
                  spacing: 8.h,
                  children: [
                    AppText(
                      text: AppString.readyToDeliver,
                      textAlign: TextAlign.center,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.contentNeutralSecondary,
                    ),
                    AppText(
                      text: AppString.scanQRLine,
                      textAlign: TextAlign.center,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.contentNeutralSecondary,
                    ),
                  ],
                ),
              ),
              CommonButton(
                onPressed: () => Navigation.pushNamed(RouteHelper.scanBox),
                title: AppString.addMyBox,
                icon: IconAsset.scan,
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigation.replaceAll(RouteHelper.dashboard);
                },
                child: AppText(
                  text: AppString.skip,
                  textAlign: TextAlign.center,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.contentNeutralSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
