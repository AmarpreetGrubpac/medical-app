import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/common_components/common_text_button.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/controller/alerts_controller.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/widget/alert_box.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  // final AlertsController alertsController = Get.put(AlertsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlertsController>(builder: (alertsController) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CommonAppNameBar(isAlert: true),
              CommonBackAppBar(
                title: "BOX-1245",
                trailing: CommonCompactTextButton(
                  onPressed: () =>
                      Navigation.pushNamed(RouteHelper.boxManagement),
                  title: AppString.boxes,
                  icon: IconAsset.arrowUpRight,
                  fontSize: 20.sp,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: alertsController.alerts.length,
                  padding: EdgeInsets.only(bottom: 80.h),
                  itemBuilder: (context, index) {
                    return AlertBox(
                        onTap: () {}, data: alertsController.alerts[index]);
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(right: 24.w, bottom: 48.h),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: CommonButton(
                onPressed: alertsController.onFilterTap,
                title: AppString.filter,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                icon: IconAsset.filter,
                iconSize: 20.h,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    });
  }
}
