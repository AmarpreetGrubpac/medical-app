import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/theme/app_theme.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/screens/dashboard/controller/dashboard_controller.dart';
import 'package:grubpac_driver/screens/dashboard/widgets/bottom_bar_item.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final DashboardController dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: controller.screens[controller.selectedIndex],
          bottomNavigationBar: SafeArea(
            bottom: true,
            child: Container(
              height: 70.h,
              margin: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundNeutralSecondary,
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(color: AppTheme.primaryButtonDisabled),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BottomBarItem(
                    onTap: () => controller.onTabChanged(0),
                    isSelected: controller.selectedIndex == 0,
                    label: AppString.home,
                    icon: IconAsset.home,
                    selectedIcon: IconAsset.selHome,
                  ),
                  BottomBarItem(
                    onTap: () => controller.onTabChanged(1),
                    isSelected: controller.selectedIndex == 1,
                    label: AppString.settings,
                    icon: IconAsset.settings,
                    selectedIcon: IconAsset.selSettings,
                  ),
                  BottomBarItem(
                    onTap: () => controller.onTabChanged(2),
                    isSelected: controller.selectedIndex == 2,
                    label: AppString.help,
                    icon: IconAsset.help,
                    selectedIcon: IconAsset.selHelp,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
