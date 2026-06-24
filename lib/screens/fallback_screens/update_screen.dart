import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  final highlights = [
    "Improved Bluetooth stability and box connection speed.",
    "Added live temperature monitoring for Medical boxes.",
    "Enhanced security for login sessions.",
    "General performance improvements and bug fixes.",
  ];
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
                  title: AppString.update,
                  isDisabled: false,
                  isLoading: false,
                  onPressed: () {}),
              18.h.verticalSpace,
              GestureDetector(
                onTap: (){
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent, // optional
                    isScrollControlled: true,
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Center(
                            //   child: Container(
                            //     height: 4.h,
                            //     width: 60.w,
                            //     decoration: BoxDecoration(
                            //       color: Colors.grey.shade400,
                            //       borderRadius: BorderRadius.circular(10.r),
                            //     ),
                            //   ),
                            // ),
                            // 20.h.verticalSpace,
                            Center(
                              child: AppText(
                                text: AppString.whatNewUpdate,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.center,
                                color: AppTheme.commonColor,
                              ),
                            ),
                            20.h.verticalSpace,
                            AppText(
                              height: 1,
                              text: AppString.versionName,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
                              color: AppTheme.contentNeutralSecondary,
                            ),
                            15.h.verticalSpace,
                            AppText(
                              height: 1,
                              text: AppString.releaseName,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
                              color: AppTheme.contentNeutralSecondary,
                            ),
                            10.h.verticalSpace,
                            AppText(
                              height: 1.70,
                              text: AppString.highlight,
                              fontSize: 19.sp,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
                              color: AppTheme.contentNeutralSecondary,
                            ),
                            15.h.verticalSpace,
                            ...highlights.map((text) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 14.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "•  ",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppTheme.contentNeutralSecondary,
                                        height: 1.5,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppTheme.contentNeutralSecondary,
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            25.h.verticalSpace,
                            CommonOutlinedButton(
                              title: AppString.updates,
                              isDisabled: false,
                              isLoading: false,
                              onPressed: (){
                                // Navigation.replace(
                                //   RouteHelper.newVersionAvailableScreen,
                                // );
                              },
                            ),

                            100.h.verticalSpace,
                          ],
                        ),
                      );
                    },
                  );
                },
                child: AppText(
                  text: AppString.learnMore,
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

      // ✅ Proper center body UI
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 0),
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.06),
              Image.asset(
                ImageAsset.updateImage,
                height: 220.h,
                width: 220.w,
                fit: BoxFit.contain,
              ),
              30.h.verticalSpace,

              AppText(
                text: AppString.updateTitle,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                color: AppTheme.commonColor,
              ),
              16.h.verticalSpace,
              AppText(
                height: 1.50,
                text: AppString.updateDesccription,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                color: AppTheme.contentNeutralSecondary,
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
