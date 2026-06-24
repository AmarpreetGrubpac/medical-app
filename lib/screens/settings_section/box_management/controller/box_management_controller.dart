import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';

class BoxManagementController extends GetxController {
  final PageController pageController = PageController();

  int currentPage = 0;

  final List<BoxInfo> boxes = <BoxInfo>[
    BoxInfo(id: AppString.boxNumberHash, isConnected: false),
    BoxInfo(id: AppString.boxNameHash, isConnected: true),
  ];

  /// GO TO PREVIOUS
  void goToPreviousBox() {
    if (currentPage > 0) {
      currentPage--;
      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      update();
    }
  }

  /// GO TO NEXT
  void goToNextBox() {
    if (currentPage < boxes.length - 1) {
      currentPage++;
      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      update();
    }
  }

  /// ON PAGE CHANGED
  void onPageChanged(int index) {
    currentPage = index;
    update();
  }

  /// LOGS
  void onLogsTap() => Navigation.pushNamed(RouteHelper.alerts);

  /// ADD BOX
  void onAddBoxTap() => Navigation.pushNamed(RouteHelper.scanBox);

  /// CONNECT BOX
  void onConnectBoxTap() {
    Navigation.pushNamed(
      RouteHelper.connectBoxInstructions,
      arg: {"is_from": ConnectBoxFrom.fromBoxManagement},
    );
  }

  /// REMOVE BOX
  void onRemoveBoxTap() {
    Navigation.pushNamed(RouteHelper.removeBox, arg: {"is_from": ConnectBoxFrom.fromBoxManagement});
  }

  /// DISCONNECT BOX
  void onDisconnectBoxTap() {
    Navigation.pushNamed(RouteHelper.disconnectBox, arg: {"is_from": ConnectBoxFrom.fromBoxManagement});
  }

  /// VIEW DETAILS BOX
  void onViewDetailsBoxTap() => Navigation.pushNamed(RouteHelper.boxDetails);
}
