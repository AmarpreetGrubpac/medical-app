import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/data/api/api_checker.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/auth/repo/auth_repo.dart';

class ExistingUserController extends GetxController implements GetxService{
  final AuthRepo authRepo;
  ExistingUserController({required this.authRepo});

  // Text controllers
  final TextEditingController authController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // Loading state
  bool isLoading = false;
  bool isOtpLoading = false;
  bool isPhoneNumber = false;
  bool isBtnDisabled = true;
  bool _isPhoneNumber(String text) {
    final phoneRegex = RegExp(r'^\+?[0-9]{1,15}$');
    return phoneRegex.hasMatch(text);
  }

  bool _isValidEmail(String text) {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[a-zA-Z]{2,63}$');
    return emailRegex.hasMatch(text);
  }

  /// Check if both fields have text
  bool get isFormValid =>
      authController.text.trim().isNotEmpty &&
      passController.text.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args != null && args['auth'] != null) {
      authController.text = args['auth'].toString();
    }

    isPhoneNumber = _isPhoneNumber(authController.text.trim());

    authController.addListener(_validateAuth);
    passController.addListener(_validateAuth);

    update();
  }

  String? authValidator(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      isBtnDisabled = true;
      update();
      return AppString.required;
    }

    final isValidPhone = RegExp(r'^[0-9]{10,15}$').hasMatch(text);
    final isValidEmail = _isValidEmail(text);
    final isNumeric = RegExp(r'^[0-9]+$').hasMatch(text);

    if (isNumeric && !isValidPhone) {
      return AppString.enterValidNumber;
    }

    if (!isNumeric && !isValidEmail) {
      return AppString.enterValidEmail;
    }

    isBtnDisabled = false;
    update();
    return null;
  }

  void _validateAuth() {
    final text = authController.text.replaceAll(RegExp(r'\s+'), '');

    isPhoneNumber = _isPhoneNumber(text);

    if (text.isEmpty) {
      isBtnDisabled = true;
      update();
      return;
    }

    final isValidPhone = RegExp(r'^[0-9]{10,15}$').hasMatch(text);
    final isValidEmail = _isValidEmail(text);
    final isNumeric = RegExp(r'^[0-9]+$').hasMatch(text);

    if (isNumeric) {
      isBtnDisabled = !isValidPhone;
    } else {
      isBtnDisabled = !isValidEmail;
    }

    update();
  }

  @override
  void onClose() {
    authController.dispose();
    passController.dispose();
    super.onClose();
  }

  Future<void> loginExistingUser() async {
    print('login existing user');
    final authText = authController.text.trim();
    final password = passController.text.trim();

    if (authText.isEmpty || password.isEmpty) {
      AppToast.showError(message: AppString.requiredPassword);
      return;
    }

    isLoading = true;
    update();

    try {
      Response response = await authRepo.loginExistingUser(
        isPhoneNumber ? "phone" : "email",
        authText,
        password,
      );

      isLoading = false;
      update();

      if (response.statusCode == 200) {
        String? token = response.body['data']?['auth_token'];

        if (token != null && token.isNotEmpty) {
          await authRepo.saveUserToken(token);
          await authRepo.onUpdateToken(token);

          // Navigation.pushNamed(RouteHelper.dashboard);
          Navigation.replaceAll(RouteHelper.dashboard);
        } else {
          AppToast.showError(
            message: AppString.somethingWentWrong,
          );
        }
      } else {
        final errorMessage = response.body != null && response.body is Map
            ? response.body['error'] ?? response.statusText
            : response.statusText ?? AppString.somethingWentWrong;

        AppToast.showError(message: errorMessage);
      }
    } catch (e) {
      isLoading = false;
      update();
      AppToast.showError(message: AppString.somethingWentWrong);
    }
  }

  bool isLoggedIn() {
    return authRepo.isLoginIn();
  }

  Future<bool> clearSavedData() async {
    Navigation.replaceAll(RouteHelper.login);
    AppToast.showSuccess(message: AppString.logoutSuccess);
    await Future.delayed(const Duration(milliseconds: 100));
    return authRepo.clearSharedPrefrences();
  }

  Future<bool> deleteSavedData() async {
    Navigation.replaceAll(RouteHelper.login);
    AppToast.showSuccess(message: AppString.deleteTitle);
    await Future.delayed(const Duration(milliseconds: 100));
    return authRepo.clearSharedPrefrences();
  }

  Future<void> logoutAccount() async {
    update();
    Response response = await authRepo.logoutAccount();
    if (response.statusCode == 200) {
      clearSavedData();
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
  }

  Future<void> deleteAccount() async {
    update();
    Response response = await authRepo.deleteAccount();
    if (response.statusCode == 200) {
      deleteSavedData();
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
  }

  Future<void> loginThroughOtp() async {
    final authText = authController.text.trim();

    if (authText.isEmpty) {
      AppToast.showError(message: AppString.required);
      return;
    }

    // Validate input
    final isValidPhone = RegExp(r'^[0-9]{10,15}$').hasMatch(authText);
    final isValidEmail = _isValidEmail(authText);

    if (!isValidPhone && !isValidEmail) {
      AppToast.showError(
        message: isPhoneNumber
            ? AppString.enterValidNumber
            : AppString.enterValidEmail,
      );
      return;
    }

    isOtpLoading = true;
    update();

    try {
      Response response = await authRepo.onLogin(
        isPhoneNumber ? "phone" : "email", // ✅ correct type
        authText, // ✅ correct body
      );

      isOtpLoading = false;
      update();

      if (response.statusCode == 200) {
        Navigation.pushNamed(
          RouteHelper.verifyOtp,
          arg: {
            "input": authText,
            "is_number": isPhoneNumber,
            if (isPhoneNumber) "country_code": "+91",
            "flow": "otp_login",
          },
        );
      } else {
        final errorMessage = response.body != null && response.body is Map
            ? response.body['error'] ?? response.statusText
            : response.statusText ?? AppString.somethingWentWrong;

        AppToast.showError(message: errorMessage);
      }
    } catch (e) {
      isOtpLoading = false;
      update();
      AppToast.showError(message: AppString.somethingWentWrong);
    }
  }
}
