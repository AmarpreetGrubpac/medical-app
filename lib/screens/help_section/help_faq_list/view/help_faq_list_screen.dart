import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/common_components/common_textfield.dart';
import 'package:grubpac_driver/common_components/custom_loader.dart';
import 'package:grubpac_driver/screens/help_section/help_faq_list/controller/help_faq_list_controller.dart';
import 'package:grubpac_driver/screens/help_section/help_faq_list/widgets/faq_tile.dart';

class HelpFaqListScreen extends StatefulWidget {
  const HelpFaqListScreen({super.key});

  @override
  State<HelpFaqListScreen> createState() => _HelpFaqListScreenState();
}

class _HelpFaqListScreenState extends State<HelpFaqListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<HelpFaqListController>();
      final args = Get.arguments;

      if (args != null) {
        String id = args["id"] ?? "";
        controller.searchController.clear();

        if (id.isNotEmpty) {
          controller.getCategoryById(id, isFirstLoad: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HelpFaqListController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CommonAppNameBar(),
              CommonBackAppBar(title: controller.title),
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                child: SearchField(
                  controller: controller.searchController,
                  onChanged: controller.onFaqSearchChanged,
                ),
              ),

              Expanded(
                child: controller.faqInitialLoading
                    ? const CustomLoader(colorcircular: true)
                    : controller.faqError != null
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.faqError!,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16.h),
                                CommonButton(
                                  onPressed: controller.retryFaq,
                                  title: 'TRY AGAIN',
                                ),
                              ],
                            ),
                          )
                        : controller.faqList == null ||
                                controller.faqList!.isEmpty
                            ? const Center(child: Text("No question found"))
                            : ListView.builder(
                                controller: controller.faqScrollController,
                                itemCount: controller.faqList!.length +
                                    (controller.faqIsLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == controller.faqList!.length) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CustomLoader(colorcircular: true),
                                    );
                                  }

                                  return FaqTile(
                                    faq: controller.faqList![index],
                                  );
                                },
                              ),
              ),

              // Expanded(
              //   child: SingleChildScrollView(
              //     child: Column(
              //       children: [
              //         // Padding(
              //         //   padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
              //         //   child: SearchField(
              //         //       controller: controller.searchController),
              //         // ),
              //         // controller.faqList == null
              //         //     ? const CustomLoader(colorcircular: true,)
              //         //     : controller.faqList!.isEmpty
              //         //     ? const Center(child: Text("No FAQs found"))
              //         //     : ListView.builder(
              //         //   itemCount: controller.faqList!.length,
              //         //   shrinkWrap: true,
              //         //   physics: NeverScrollableScrollPhysics(),
              //         //   itemBuilder: (context, index) => FaqTile(
              //         //     // faq: controller.faqList![index].question ?? "",
              //         //     faq: controller.faqList![index],
              //         //   ),
              //         // ),
              //
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      );
    });
  }
}
