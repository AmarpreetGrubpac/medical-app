import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_back_button.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/auth/controller/existing_user_controller.dart';

class DeleteAcScreen extends StatelessWidget {
  const DeleteAcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
          child: Column(
            children: [
              Align(alignment: Alignment.centerLeft, child: CommonBackButton()),
              Container(
                padding: EdgeInsets.only(top: 92.h, bottom: 60.h),
                child: SvgPicture.asset(
                  AppTheme.isDark ? IconAsset.acDeleteDark : IconAsset.acDelete,
                  height: 120.h,
                  width: 120.h,
                ),
              ),
              AppText(
                text: AppString.deleteAccount,
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.contentNeutralPrimary,
              ),
              Padding(
                padding: EdgeInsets.only(top: 36.h, bottom: 8.h),
                child: AppText(
                  text: AppString.deleteAccountDescription1,
                  textAlign: TextAlign.center,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AppText(
                text: AppString.deleteAccountDescription2,
                textAlign: TextAlign.center,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
              ),
              Padding(
                padding: EdgeInsets.only(top: 36.h),
                child: CommonButton(
                  onPressed: () async {
                    Get.find<ExistingUserController>().deleteAccount("");
                  },
                  title: AppString.deleteAccountBtn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
