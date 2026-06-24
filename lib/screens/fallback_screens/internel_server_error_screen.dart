import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_back_button.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';

class InternelServerErrorScreen extends StatefulWidget {
  const InternelServerErrorScreen({super.key});

  @override
  State<InternelServerErrorScreen> createState() =>
      _InternelServerErrorScreenState();
}

class _InternelServerErrorScreenState extends State<InternelServerErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 30.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonOutlinedButton(
                  title: AppString.tryAgain,
                  isDisabled: false,
                  isLoading: false,
                  onPressed: () {
                    // Navigation.replace(
                    //   RouteHelper.noInternetScreen,
                    // );
                  }),
              18.h.verticalSpace,
              GestureDetector(
                onTap: () {},
                child: AppText(
                  text: AppString.internetServertitle,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  color: AppTheme.contentNeutralSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const CommonBackButton(), SizedBox()],
              ),
              SizedBox(height: Get.height * 0.05),
              Image.asset(
                ImageAsset.internelServererrorImage,
                height: 220.h,
                width: 220.w,
                fit: BoxFit.contain,
              ),
              30.h.verticalSpace,
              AppText(
                text: AppString.internelServerTitle,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                color: AppTheme.commonColor,
              ),
              16.h.verticalSpace,
              AppText(
                height: 1.50,
                text: AppString.internelServerDescription,
                fontSize: 17.sp,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                color: AppTheme.contentNeutralSecondary,
              ),
              15.h.verticalSpace,
              Center(
                child: AppText(
                  text: AppString.internelServerSubTitle,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  color: AppTheme.contentNeutralSecondary,
                ),
              ),
              36.h.verticalSpace,
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
