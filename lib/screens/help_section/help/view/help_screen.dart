import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
import 'package:grubpac_driver/common_components/common_bottom_box.dart';
import 'package:grubpac_driver/common_components/common_menu_box.dart';
import 'package:grubpac_driver/common_components/common_textfield.dart';
import 'package:grubpac_driver/common_components/custom_loader.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_utils.dart';
import 'package:grubpac_driver/screens/help_section/help/controller/help_controller.dart';
import 'package:grubpac_driver/screens/help_section/help/widget/write_to_us_button.dart';
import 'package:grubpac_driver/screens/help_section/help_faq_list/controller/help_faq_list_controller.dart';
import 'package:grubpac_driver/screens/help_section/help_faq_list/view/help_faq_list_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {
    Get.find<HelpFaqListController>().getCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HelpController>(builder: (helpController) {
      return GetBuilder<HelpFaqListController>(builder: (controller) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonAppNameBar(
                isDashboardScreen: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: AppString.howCanWeHelp,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.contentNeutralPrimary,
                        fontSize: 24.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.h, bottom: 16.h),
                        child: CommonBottomBox(
                          onPressed: () =>
                              AppUtils.contactSupport("+919876543210"),
                          title: AppString.emergency,
                          description: AppString.emergencySubText,
                          buttonText: AppString.callRestaurant,
                          isEmergency: true,
                        ),
                      ),
                      WriteToUsButton(
                        onPressed: () => AppUtils.writeMail(
                            'support@example.com', 'Support Request'),
                      ),
                      Divider(
                          height: 49.h,
                          color: AppTheme.strokeInteractiveBrandDisabled,
                          thickness: 1.h),
                      AppText(
                        text: AppString.faqTitle,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.contentNeutralPrimary,
                        fontSize: 18.sp,
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 24.h),
                        child: SearchField(
                          controller: controller.searchController,
                          onChanged: (value) {
                            controller.getCategoryList(
                              isFirstLoad: true,
                              search: value,
                            );
                          },
                        ),
                      ),
                      controller.isInitialLoading
                          ? const CustomLoader(colorcircular: true)
                          : controller.faqCategories == null ||
                                  controller.faqCategories!.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(top: 40.h),
                                  child: Center(
                                    child: AppText(
                                      text: "No question found",
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  controller: controller.scrollController,
                                  itemCount: controller.faqCategories!.length +
                                      (controller.isLoading ? 1 : 0),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (index ==
                                        controller.faqCategories!.length) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16),
                                        child:
                                            CustomLoader(colorcircular: true),
                                      );
                                    }

                                    final item =
                                        controller.faqCategories![index];

                                    return Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: CommonMenuBox(
                                        onTap: () {
                                          Get.to(
                                            () => const HelpFaqListScreen(),
                                            arguments: {
                                              "id": item.id.toString(),
                                              "title": item.name.toString(),
                                            },
                                          );
                                        },
                                        title: item.name.toString(),
                                        icon: IconAsset.setup,
                                        // isProfile: true,
                                        image:
                                            '${AppConstants.helpImageUrls}${item.icon!.bucketKey}',
                                      ),
                                    );
                                  },
                                ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
