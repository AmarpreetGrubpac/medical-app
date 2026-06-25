import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:grubpac_driver/core/exceptions/failure.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_repo.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';

import '../../../../core/utils/app_utils.dart';

class BoxManagementController extends GetxController {
  final BoxManagementRepo boxRepo;
  BoxManagementController({required this.boxRepo});
  final PageController pageController = PageController();

  int currentPage = 0;
  bool loadingBoxes = false;
  @override
  void onInit() {
    fetchBoxes();
    super.onInit();
  }

  final List<BoxInfo> boxes = <BoxInfo>[
    BoxInfo(
        id: AppString.boxNumberHash,
        isConnected: false,
        boxDisplayId: AppString.boxNameHash),
    BoxInfo(
        id: AppString.boxNameHash,
        isConnected: true,
        boxDisplayId: AppString.boxNameHash),
  ];
  void fetchBoxes() async {
    try {
      loadingBoxes = true;
      update();
      var res = await boxRepo.getBoxList();
      if (res.statusCode == 200) {
        boxes.clear();
        var boxList = <BoxInfo>[];
        for (var item in res.body['data']) {
          boxList.add(BoxInfo.fromJson(item));
        }
        boxes.addAll(boxList);
      } else {
        throw Failure(
            message: res.body['message'] ?? res.body['error'], response: res);
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
    } finally {
      loadingBoxes = false;
      update();
    }
  }

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
    Navigation.pushNamed(RouteHelper.removeBox,
        arg: {"is_from": ConnectBoxFrom.fromBoxManagement});
  }

  /// DISCONNECT BOX
  void onDisconnectBoxTap() {
    Navigation.pushNamed(RouteHelper.disconnectBox,
        arg: {"is_from": ConnectBoxFrom.fromBoxManagement});
  }

  /// VIEW DETAILS BOX
  void onViewDetailsBoxTap() => Navigation.pushNamed(RouteHelper.boxDetails);
}
