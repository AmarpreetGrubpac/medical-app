import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
  DeleteAcScreen({super.key});
  final TextEditingController deletePasswordController =
      TextEditingController();

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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: AppText(
                            text: AppString.deleteAccount,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.contentNeutralPrimary,
                          ),
                          content: Column(
                            children: [
                              AppText(
                                text: AppString.deleteConfirmDescription,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.contentNeutralSecondary,
                              ),
                              TextField(
                                controller: deletePasswordController,
                              )
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: AppText(
                                text: AppString.cancel,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.contentNeutralSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (deletePasswordController.text.isNotEmpty &&
                                    deletePasswordController.text.length > 6 &&
                                    deletePasswordController.text ==
                                        "CONFIRM") {
                                  Get.find<ExistingUserController>()
                                      .deleteAccount("");
                                  Navigator.of(context, rootNavigator: true)
                                      .pop({});
                                } else {
                                  AppToast.showError(
                                      message:
                                          "Please enter CONFIRM to delete your account");
                                }
                                // Navigator.pop(context);
                              },
                              child: AppText(
                                text: AppString.delete,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        );
                      },
                    );
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
