import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/common_components/app_text.dart';
import 'package:grubpac_driver/common_components/common_app_name_bar.dart';
import 'package:grubpac_driver/common_components/common_button.dart';
import 'package:grubpac_driver/common_components/common_text_button.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/controller/alerts_controller.dart';
import 'package:grubpac_driver/screens/settings_section/alerts/widget/alert_box.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlertsController>(builder: (alertsController) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CommonAppNameBar(isAlert: true),
              CommonBackAppBar(
                title: alertsController.selectedBox == "All"
                    ? "All Boxes"
                    : alertsController.selectedBox,
                trailing: CommonCompactTextButton(
                  onPressed: () =>
                      Navigation.pushNamed(RouteHelper.boxManagement),
                  title: AppString.boxes,
                  icon: IconAsset.arrowUpRight,
                  fontSize: 20.sp,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => alertsController.onRefresh(),
                  child: alertsController.isloading == true
                      ? ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],
                        )
                      : alertsController.filteredAlerts.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.w),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AppText(
                                            text: "No alerts found",
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                AppTheme.contentNeutralPrimary,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 8.h, bottom: 24.h),
                                            child: AppText(
                                              text:
                                                  "Try adjusting or resetting your filter criteria.",
                                              fontWeight: FontWeight.w400,
                                              textAlign: TextAlign.center,
                                              color: AppTheme
                                                  .contentNeutralSecondary,
                                            ),
                                          ),
                                          IntrinsicWidth(
                                            child: CommonButton(
                                              onPressed:
                                                  alertsController.resetFilters,
                                              fontSize: 16.sp,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w,
                                                  vertical: 10.h),
                                              title: "RESET FILTERS",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: alertsController.filteredAlerts.length,
                              padding: EdgeInsets.only(bottom: 80.h),
                              itemBuilder: (context, index) {
                                final alert =
                                    alertsController.filteredAlerts[index];
                                return AlertBox(
                                    onTap: () {
                                      alertsController.onView(alert.id);
                                      Navigation.pushNamed(
                                        RouteHelper.boxDetails,
                                        arg: {"page": 1, "box_id": alert.boxId},
                                      );
                                    },
                                    onDismiss: () {
                                      alertsController.onClickDismiss(alert.id);
                                    },
                                    data: alert);
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(right: 10.w, bottom: 20.h),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: CommonButton(
                onPressed: () => alertsController.onFilterTap(context),
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
