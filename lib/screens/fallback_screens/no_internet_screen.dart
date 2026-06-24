import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_back_button.dart';
import 'package:grubpac_driver/common_components/common_outlined_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';

class NoInternetScreen extends StatefulWidget {
  final VoidCallback? onRetryPressed;

  const NoInternetScreen({
    super.key,
    this.onRetryPressed,
  });

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {

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
            onPressed: () async {
              if (widget.onRetryPressed != null) {
                widget.onRetryPressed!();
              }
            },
                  // onPressed: (){
                  //   showModalBottomSheet(
                  //     context: context,
                  //     backgroundColor: Colors.transparent, // optional
                  //     isScrollControlled: true,
                  //     builder: (context) {
                  //       return Container(
                  //         padding: EdgeInsets.all(20.w),
                  //         decoration: BoxDecoration(
                  //           color: AppTheme.background,
                  //           borderRadius: BorderRadius.only(
                  //             topLeft: Radius.circular(20.r),
                  //             topRight: Radius.circular(20.r),
                  //           ),
                  //         ),
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             30.h.verticalSpace,
                  //             30.h.verticalSpace,
                  //
                  //             AppText(
                  //               text: AppString.noInternetConnection,
                  //               fontSize: 24.sp,
                  //               fontWeight: FontWeight.w700,
                  //               textAlign: TextAlign.center,
                  //               color: AppTheme.commonColor,
                  //             ),
                  //             16.h.verticalSpace,
                  //             AppText(
                  //               height: 1.50,
                  //               text: AppString.noInternetConnectionDescription,
                  //               fontSize: 17.sp,
                  //               fontWeight: FontWeight.w400,
                  //               textAlign: TextAlign.center,
                  //               color: AppTheme.contentNeutralSecondary,
                  //             ),
                  //             40.h.verticalSpace,
                  //             CommonOutlinedButton(
                  //                 title: AppString.tryAgain,
                  //                 isDisabled: false,
                  //                 isLoading: false,
                  //                 onPressed: (){
                  //                   Navigator.of(context).pop();
                  //                 }),
                  //             100.h.verticalSpace,
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //   );
                 //  }
                   ),
              18.h.verticalSpace,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CommonBackButton(),
                  SizedBox()
                ],
              ),
              SizedBox(height: Get.height * 0.05),
              Image.asset(
                ImageAsset.noInternetImage,
                height: 220.h,
                width: 220.w,
                fit: BoxFit.contain,
              ),
              30.h.verticalSpace,

              AppText(
                text: AppString.noInternetConnection,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                color: AppTheme.commonColor,
              ),
              16.h.verticalSpace,
              AppText(
                height: 1.50,
                text: AppString.noInternetConnectionDescription,
                fontSize: 17.sp,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                color: AppTheme.contentNeutralSecondary,
              ),
              8.h.verticalSpace,
              36.h.verticalSpace,

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
