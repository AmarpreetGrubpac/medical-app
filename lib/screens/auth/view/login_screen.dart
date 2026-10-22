import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/common_components/common_text_button.dart';
import 'package:grubpac_driver/common_components/common_textfield.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_formatters.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/screens/auth/controller/login_controller.dart';
import 'package:grubpac_driver/screens/auth/widget/page_indicator.dart';
import 'package:grubpac_driver/core/flavor/app_flavor_config.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) => GetBuilder<LoginController>(
            builder: (controller) => SingleChildScrollView(
              // padding: EdgeInsets.only(
              //    ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 345.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      autoPlay: true,
                                      autoPlayAnimationDuration:
                                          const Duration(seconds: 1),
                                      height: 285.h,
                                      viewportFraction: 1,
                                      aspectRatio: 1,
                                      enableInfiniteScroll: false,
                                      onPageChanged: controller.onChangePage,
                                    ),
                                    items: List.generate(
                                        controller.carouselItems.length,
                                        (index) {
                                      final item =
                                          controller.carouselItems[index];

                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Flexible(
                                              child: Container(
                                                height: 168.h,
                                                margin: EdgeInsets.only(
                                                    bottom: 24.h),
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppTheme.loginGreyBox),
                                              ),
                                            ),
                                            AppText(
                                              text: item.title,
                                              textAlign: TextAlign.center,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme
                                                  .contentNeutralSecondary,
                                            ),
                                            4.h.verticalSpace,
                                            AppText(
                                              text: item.description,
                                              textAlign: TextAlign.center,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppTheme
                                                  .contentNeutralSecondary,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                  SizedBox(
                                    height: 60.h,
                                    child: PageIndicator(
                                      currentIndex: controller.currentPage,
                                      count: controller.carouselItems.length,
                                      dotSize: 8.h,
                                      spacing: 8.w,
                                      selectedDotSize: 12.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.background,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12.r)),
                                  border: Border(
                                    top: BorderSide(
                                        color: AppTheme
                                            .strokeInteractiveBrandDisabled),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.commonColor
                                          .withValues(alpha: 0.08),
                                      spreadRadius: 5,
                                      blurRadius: 12,
                                      offset: const Offset(0, -2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      IconAsset.appLogo,
                                      width: 223.w,
                                      height: 48.h,
                                      colorFilter: ColorFilter.mode(
                                          AppTheme.primary, BlendMode.srcIn),
                                    ),
                                    if (controller.isDemoMode) ...[
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 16.h, bottom: 20.h),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14.w, vertical: 10.h),
                                        decoration: BoxDecoration(
                                          color: AppTheme
                                              .contentBrandPrimaryGreen
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          border: Border.all(
                                            color: AppTheme
                                                .contentBrandPrimaryGreen
                                                .withValues(alpha: 0.4),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.science_outlined,
                                              color: AppTheme
                                                  .contentBrandPrimaryGreen,
                                              size: 22.sp,
                                            ),
                                            10.w.horizontalSpace,
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppText(
                                                    text: "Demo Mode Active",
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme
                                                        .contentNeutralPrimary,
                                                  ),
                                                  2.h.verticalSpace,
                                                  AppText(
                                                    text:
                                                        "Mock data active. Tap continue to test flow.",
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppTheme
                                                        .contentNeutralSecondary,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ] else ...[
                                      Padding(
                                        padding: EdgeInsetsGeometry.symmetric(
                                            vertical: 36.h),
                                        child: AppText(
                                          text: AppString.enterRegisteredPrompt,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w400,
                                          textAlign: TextAlign.center,
                                          color:
                                              AppTheme.contentNeutralSecondary,
                                        ),
                                      ),
                                    ],
                                    CommonTextField(
                                      hintText: AppString.mobileEmailHint,
                                      controller: controller.emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'\s')),
                                        NoSpaceFormatter(),
                                        LowerCaseTextFormatter(),
                                      ],
                                      prefix: IntrinsicWidth(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 16.w, right: 12.w),
                                          child: Row(
                                            spacing: 12.w,
                                            children: [
                                              SvgPicture.asset(
                                                IconAsset.user,
                                                height: 24.h,
                                                width: 24.h,
                                                colorFilter: ColorFilter.mode(
                                                  AppTheme.contentNeutralLight,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              if (controller.isPhoneNumber)
                                                AppText(
                                                  text: "+91",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18.sp,
                                                  color: AppTheme
                                                      .contentNeutralSecondary,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      validator: controller.authValidator,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 28.h, bottom: 12.h),
                                      child: CommonButton(
                                        onPressed: controller.onContinueTap,
                                        isLoading: false,
                                        title: AppString.continueBtn,
                                        isDisabled: controller.isBtnDisabled,
                                      ),
                                    ),
                                    if (AppFlavorConfig.isInitialized
                                        ? AppFlavorConfig.current.hasTestMode
                                        : true) ...[
                                      InkWell(
                                        onTap: controller.toggleDemoMode,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        child: Container(
                                          height: 46.h,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            color: controller.isDemoMode
                                                ? AppTheme.primary
                                                    .withValues(alpha: 0.08)
                                                : AppTheme
                                                    .contentBrandPrimaryGreen
                                                    .withValues(alpha: 0.08),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            border: Border.all(
                                              color: controller.isDemoMode
                                                  ? AppTheme.primary
                                                      .withValues(alpha: 0.35)
                                                  : AppTheme
                                                      .contentBrandPrimaryGreen
                                                      .withValues(alpha: 0.35),
                                              width: 1.2,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                controller.isDemoMode
                                                    ? Icons.logout_outlined
                                                    : Icons.science_outlined,
                                                size: 18.sp,
                                                color: controller.isDemoMode
                                                    ? AppTheme.primary
                                                    : AppTheme
                                                        .contentBrandPrimaryGreen,
                                              ),
                                              8.w.horizontalSpace,
                                              AppText(
                                                text: controller.isDemoMode
                                                    ? "SWITCH TO LIVE LOGIN"
                                                    : "EXPLORE DEMO MODE",
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w600,
                                                color: controller.isDemoMode
                                                    ? AppTheme.primary
                                                    : AppTheme
                                                        .contentBrandPrimaryGreen,
                                                letterSpacing: 0.5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      12.h.verticalSpace,
                                    ],
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CommonTextButton(
                                            onPressed: controller.onPolicyTap,
                                            title: AppString.privacyPolicy,
                                          ),
                                        ),
                                        Expanded(
                                          child: CommonTextButton(
                                            onPressed: controller.onTermsTap,
                                            title: AppString.termsOfService,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  controller.isLoading
                      ? Container(
                          height: Get.height,
                          width: Get.width,
                          color: const Color.fromARGB(143, 255, 255, 255),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: AppTheme.contentBrandPrimary,
                          )),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
