import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
import 'package:grubpac_driver/common_components/common_custom_painter.dart';
import 'package:grubpac_driver/screens/box_details/controller/box_details_controller.dart';
import 'package:grubpac_driver/screens/box_details/widgets/first_details_view.dart';
import 'package:grubpac_driver/screens/box_details/widgets/second_details_view.dart';

import '../../../common_components/sos_button.dart';

class BoxDetailsScreen extends StatelessWidget {
  BoxDetailsScreen({super.key});

  final BoxDetailsController boxDetailsController =
      Get.put(BoxDetailsController());

  @override
  Widget build(BuildContext context) {
    // final page = Get.arguments["page"];
    return GetBuilder<BoxDetailsController>(
      builder: (controller) => Scaffold(
        floatingActionButton: SosButton(),
        body: SafeArea(
          child: Column(
            children: [
              CommonAppNameBar(),
              Expanded(
                child: controller.isLoading && controller.boxInfo == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Stack(
                        children: [
                          Positioned.fill(
                            bottom: 170.h,
                            child: CustomPaint(
                                painter: GlowSemiCirclePainters(
                                    isVertical: true, top: 70.h)),
                          ),
                          PageView.builder(
                            scrollDirection: Axis.vertical,
                            controller: controller.pageController,
                            onPageChanged: controller.onChangePage,
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? FirstDetailsView()
                                  : SecondDetailsView();
                            },
                          ),
                          if (controller.isLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
