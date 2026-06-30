import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:grubpac_driver/core/exceptions/failure.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/enums.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_repo.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';

import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/app_utils.dart';

class BoxManagementController extends GetxController {
  final BoxManagementRepo boxRepo;
  BoxManagementController({required this.boxRepo});
  final PageController pageController = PageController();
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  int currentPage = 0;
  bool loadingBoxes = false;
  @override
  void onInit() {
    // fetchBoxes();
    super.onInit();
  }

  List<BoxInfo> boxes = <BoxInfo>[];

  void fetchBoxes({bool isRefresh = true}) async {
    try {
      if (isRefresh || boxes.isEmpty) {
        loadingBoxes = true;
        update();
        var res = await boxRepo.getBoxList();
        if (res.statusCode == 200) {
          var boxList = <BoxInfo>[];
          for (var item in res.body['data']) {
            boxList.add(BoxInfo.fromJson(item));
          }
          boxes.clear();
          boxes.addAll(boxList);
        } else {
          throw Failure(
              message: res.body['message'] ?? res.body['error'], response: res);
        }
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
    } finally {
      loadingBoxes = false;
      update();
    }
  }

  Future<void> addNewBox(String displayId) async {
    try {
      isLoading = true;
      update();
      var res = await boxRepo.registerbox(displayId);
      if (res.statusCode == 200 || res.statusCode == 201) {
        var box = BoxInfo.fromJson(res.body['data']);
        boxes = [...boxes, box];
        update();
        AppToast.showSuccess(message: AppString.boxAddedSuccess);
        Navigation.pop(data: {"result": true});
      } else {
        throw Failure(
            message:
                res.body['message'] ?? res.body['error'] ?? "Failed to add box",
            response: res);
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
    } finally {
      isLoading = false;
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
  void onConnectBoxTap(String boxId) {
    Navigation.pushNamed(
      RouteHelper.connectBoxInstructions,
      arg: {
        "is_from": ConnectBoxFrom.fromBoxManagement,
        "box_id": boxId,
      },
    );
  }

  /// CONNECT BOX API
  Future<bool> connectBox(String boxId) async {
    try {
      isLoading = true;
      update();
      var res = await boxRepo.connectBox(boxId);
      if (res.statusCode == 200) {
        fetchBoxes();
        return true;
      } else {
        throw Failure(
            message: res.body['message'] ??
                res.body['error'] ??
                'Failed to connect box',
            response: res);
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  /// REMOVE BOX
  void onRemoveBoxTap(String boxId) {
    Navigation.pushNamed(RouteHelper.removeBox,
        arg: {"is_from": ConnectBoxFrom.fromBoxManagement, "box_id": boxId});
  }

  /// DISCONNECT BOX
  void onDisconnectBoxTap(String boxId, String displayName) {
    Navigation.pushNamed(RouteHelper.disconnectBox, arg: {
      "is_from": ConnectBoxFrom.fromBoxManagement,
      "box_id": boxId,
      "displayName": displayName,
    });
  }

  /// DISCONNECT BOX API
  Future<bool> disconnectBox(String boxId) async {
    try {
      isLoading = true;
      update();
      var res = await boxRepo.disconnectBox(boxId);
      if (res.statusCode == 200) {
        fetchBoxes();
        return true;
      } else {
        throw Failure(
            message: res.body['message'] ??
                res.body['error'] ??
                'Failed to disconnect box',
            response: res);
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> removeBox(String boxId) async {
    try {
      isLoading = true;
      update();
      var res = await boxRepo.removeBox(boxId);
      if (res.statusCode == 200) {
        boxes.removeWhere((box) => box.id == boxId);
        AppToast.showSuccess(message: AppString.boxRemoved);
        Navigation.pop(data: {"result": true});
      } else {
        throw Failure(
            message: res.body['message'] ??
                res.body['error'] ??
                'Failed to remove box',
            response: res);
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
    } finally {
      isLoading = false;
      update();
    }
  }

  /// VIEW DETAILS BOX
  void onViewDetailsBoxTap(String boxId) =>
      Navigation.pushNamed(RouteHelper.boxDetails, arg: {"box_id": boxId});

  Future<bool> sendBoxOtp(String boxId, {String action = "unlock"}) async {
    try {
      isLoading = true;
      update();
      var res = await boxRepo.getBoxOtp(boxId, action: action);
      if (res.statusCode == 200) {
        AppToast.showSuccess(
            message: res.body['message'] ?? "OTP sent successfully");
        return true;
      } else {
        throw Failure(
            message: res.body['message'] ??
                res.body['error'] ??
                'Failed to send OTP',
            response: res);
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  /// ON VERIFY OTP

  Future<bool> verifyBoxOtp(String boxId, String otp,
      {String action = "lock"}) async {
    try {
      isLoading = true;
      update();
      var res = await boxRepo.verifyBoxOtp(
        boxId,
        otp,
        action,
      );
      if (res.statusCode == 200) {
        AppToast.showSuccess(
            message: res.body['message'] ?? "OTP verified successfully");
        return true;
      } else {
        throw Failure(
            message: res.body['message'] ??
                res.body['error'] ??
                'Failed to verify OTP',
            response: res);
      }
    } catch (e) {
      AppUtils.apiErrorHandler(e);
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }
}
