// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:grubpac_driver/common_components/app_text.dart';
// import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
// import 'package:grubpac_driver/common_components/common_bottom_box.dart';
// import 'package:grubpac_driver/common_components/custom_loader.dart';
// import 'package:grubpac_driver/core/theme/app_theme.dart';
// import 'package:grubpac_driver/core/utils/app_string.dart';
// import 'package:grubpac_driver/core/utils/app_utils.dart';
// import 'package:grubpac_driver/screens/help_section/faq_answer/widgets/numbered_point.dart';
// import 'package:grubpac_driver/screens/help_section/help_faq_list/controller/help_faq_list_controller.dart';
//
// class FaqAnswerScreen extends StatefulWidget {
//   const FaqAnswerScreen({super.key});
//
//   @override
//   State<FaqAnswerScreen> createState() => _FaqAnswerScreenState();
// }
//
// class _FaqAnswerScreenState extends State<FaqAnswerScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       var args = Get.arguments;
//
//       if (args != null && args["faq"] != null) {
//         String id = args["faq"].toString();
//         print("ID ---> $id");
//         Get.find<HelpFaqListController>().getCategoryById(id);
//       }
//     });
//   }
//
//   final RxString faq = "".obs;
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<HelpFaqListController>(builder: (controller) {
//       return Scaffold(
//         body: SafeArea(
//           child: Column(
//             children: [
//               CommonAppNameBar(),
//               Obx(() => CommonBackAppBar(title: faq.value, fontSize: 18.sp)),
//               Divider(
//                   height: 1.h,
//                   thickness: 1.h,
//                   color: AppTheme.strokeInteractiveBrandDisabled),
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
//                   child: Column(
//                     spacing: 12.h,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText(
//                           text: AppString.reconnectInstruction,
//                           fontWeight: FontWeight.w400),
//                       NumberedPoint(
//                           number: '1.', text: AppString.reconnectStep1),
//                       NumberedPoint(
//                           number: '2.', text: AppString.reconnectStep2),
//                       NumberedPoint(
//                           number: '3.', text: AppString.reconnectStep3),
//                       AppText(
//                           text: AppString.reconnectFailureNote,
//                           fontWeight: FontWeight.w400),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
//                 child: CommonBottomBox(
//                   onPressed: () => AppUtils.writeMail(
//                       'support@example.com', 'Support Request'),
//                   title: AppString.stillHavingDoubts,
//                   description: AppString.writeToUsDescription,
//                   buttonText: AppString.writeToUs,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
import 'package:grubpac_driver/common_components/common_bottom_box.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_utils.dart';
import 'package:grubpac_driver/screens/help_section/faq_answer/widgets/numbered_point.dart';

import '../../help_faq_list/controller/help_support_model.dart';

class FaqAnswerScreen extends StatefulWidget {
  const FaqAnswerScreen({super.key});

  @override
  State<FaqAnswerScreen> createState() => _FaqAnswerScreenState();
}

class _FaqAnswerScreenState extends State<FaqAnswerScreen> {
  late Faq faq;

  @override
  void initState() {
    super.initState();

    // Get passed FAQ object
    faq = Get.arguments["faq"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// App Name Bar
            const CommonAppNameBar(),

            /// Back App Bar with Question
            CommonBackAppBar(
              title: faq.question ?? "",
              fontSize: 18.sp,
            ),

            Divider(
              height: 1.h,
              thickness: 1.h,
              color: AppTheme.strokeInteractiveBrandDisabled,
            ),

            /// Answer Section
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // /// Question
                    // AppText(
                    //   text: faq.question ?? "",
                    //   fontSize: 18.sp,
                    //   fontWeight: FontWeight.w600,
                    // ),
                    // AppText(
                    //           text: faq.categories.c ?? "",
                    //           fontWeight: FontWeight.w400),
                    SizedBox(height: 16.h),

                    /// Answer
                    NumberedPoint(number: '1.', text: faq.answer ?? ""),
                    // AppText(
                    //   text: faq.answer ?? "",
                    //   fontSize: 14.sp,
                    //   fontWeight: FontWeight.w400,
                    // ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
              child: CommonBottomBox(
                onPressed: () => AppUtils.writeMail(
                    'support@grubpac.com', 'Support Request'),
                title: AppString.stillHavingDoubts,
                description: AppString.writeToUsDescription,
                buttonText: AppString.writeToUs,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
