import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/auth/repo/auth_repo.dart';

class SetPasswordController extends GetxController implements GetxService{
  final AuthRepo authRepo;

  SetPasswordController({required this.authRepo});

  String argsInput = "";
  String argsCountryCode = "+91";
  bool argsIsNumber = false;

  String resetToken = "";

  bool isLoading = false;
  bool fromChangePass = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;

      if (args != null) {
        argsInput = args["input"] ?? "";
        argsCountryCode = args["country_code"] ?? "+91";
        argsIsNumber = args["is_number"] ?? false;
        fromChangePass = args["from_change_pass"] ?? false;

        /// ✅ GET TOKEN HERE
        resetToken = args["token"] ?? "";

        if (resetToken.isEmpty) {
          AppToast.showError(message: "Invalid or expired token");
          Navigation.replaceAll(RouteHelper.login);
          return;
        }

        update();
      }
    });
  }

  Future<void> setNewPassword() async {

    try {
      isLoading = true;
      update();

      final String type = argsIsNumber ? "phone" : "email";
      final String bodyValue =
      argsIsNumber ? "$argsCountryCode$argsInput" : argsInput;

      Response response = await authRepo.setNewPassword(
        type,
        bodyValue,
        passController.text.trim(),
        resetToken,
      );

      if (response.statusCode == 200) {
        AppToast.showSuccess(message: AppString.passwordchanged);
        if (fromChangePass) {
          final newToken = response.body?['data']?['auth_token'] ?? resetToken;
          await authRepo.saveUserToken(newToken);
          await authRepo.onUpdateToken(newToken);
          Navigation.replaceAll(RouteHelper.dashboard);
        } else {
          Navigation.replaceAll(RouteHelper.login);
        }
      } else {
        final errorMessage =
        response.body != null && response.body is Map
            ? response.body['error'] ?? response.statusText
            : response.statusText ?? AppString.somethingWentWrong;

        AppToast.showError(message: errorMessage);
      }
    } catch (_) {
      AppToast.showError(message: AppString.somethingWentWrong);
    } finally {
      isLoading = false;
      update();
    }
  }
  Future<void> setPassword() async {

    try {
      isLoading = true;
      update();

      final String type = argsIsNumber ? "phone" : "email";
      final String bodyValue =
      argsIsNumber ? "$argsCountryCode$argsInput" : argsInput;

      Response response = await authRepo.setPassword(
        type,
        bodyValue,
        passController.text.trim(),
        resetToken,
      );

      if (response.statusCode == 200) {
        await authRepo.saveUserToken(resetToken);
        AppToast.showSuccess(message: AppString.setPasswordSuccessfully);
        // Navigation.replaceAll(RouteHelper.dashboard);
        Navigation.replaceAll(RouteHelper.welcome);

        // AppToast.showSuccess(message: AppString.passwordchanged);
        // Navigation.replaceAll(RouteHelper.login);
      } else {
        final errorMessage =
        response.body != null && response.body is Map
            ? response.body['error'] ?? response.statusText
            : response.statusText ?? AppString.somethingWentWrong;

        AppToast.showError(message: errorMessage);
      }
    } catch (_) {
      AppToast.showError(message: AppString.somethingWentWrong);
    } finally {
      isLoading = false;
      update();
    }
  }


}
