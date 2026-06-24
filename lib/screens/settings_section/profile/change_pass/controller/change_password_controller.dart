import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/screens/auth/repo/auth_repo.dart';
class ChangePasswordController extends GetxController {
  final AuthRepo authRepo;

  ChangePasswordController({required this.authRepo});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();

  bool isLoading = false;

  /// ON SAVE PASSWORD
  Future<void> onSavePassTap() async {
    if (isLoading) return;

    if (formKey.currentState?.validate() ?? false) {
      await changePassword();
    } else {
      autoValidateMode = AutovalidateMode.always;
      update();
    }
  }

  /// CHANGE PASSWORD API CALL
  Future<void> changePassword() async {
    try {
      isLoading = true;
      update();

      Response response = await authRepo.changePassword(
        oldPassController.text.trim(),
        newPassController.text.trim(),
      );

      isLoading = false;
      update();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigation.pop();
        AppToast.showSuccess(message: AppString.passChangeSuccess);
      } else {
        AppToast.showError(
          message: response.body['error'] ?? "Failed to change password",
        );
      }
    } catch (e) {
      isLoading = false;
      update();

      AppToast.showError(message: AppString.somethingWentWrong);
    }
  }

  @override
  void onClose() {
    oldPassController.dispose();
    newPassController.dispose();
    super.onClose();
  }
}
