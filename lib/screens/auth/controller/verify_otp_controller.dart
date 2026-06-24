import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/auth/repo/auth_repo.dart';
import 'package:timer_count_down/timer_controller.dart';

class VerifyOtpController extends GetxController implements GetxService{
  final AuthRepo authRepo;
  VerifyOtpController({required this.authRepo});

  String argsInput = "";
  String argsCountryCode = "";
  bool argsIsNumber = false;
  String otpToken = ""; // 🔥 in-memory token

  bool isTimerCompleted = false;
  bool isLoading = false;
  late String flow; // "login" | "forgot"

  TextEditingController otpController = TextEditingController();
  CountdownController countdownController =
      CountdownController(autoStart: true);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      if (args != null) {
        argsInput = args["input"] ?? "";
        argsCountryCode = args["country_code"] ?? "";
        argsIsNumber = args["is_number"] ?? false;
        flow = args["flow"] ?? "login";

        update();
      }
    });
  }

  /// COUNTDOWN FINISHED
  void onCountdownFinished() {
    isTimerCompleted = true;
    update();
  }

  /// RESEND OTP (CALL LOGIN API)
  Future<void> onResendCode() async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      Response response;
      if (flow == "forgot") {
        response = await authRepo.resendForgotPasswordEmail(argsInput);
      } else {
        // response = await authRepo.resendOtp(argsInput);
        response = await authRepo.resendOtp(
          argsIsNumber ? "phone" : "email",
          argsInput,
        );
      }
      final String message =
          response.body?['message'] ?? AppString.somethingWentWrong;

      if (response.statusCode == 200) {
        countdownController.restart();
        isTimerCompleted = false;
        otpController.clear();
        AppToast.showSuccess(message: AppString.otpResendSucceessfully);
      } else {
        AppToast.showError(message: message);
      }
    } catch (e) {
      AppToast.showError(message: e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty || isLoading) return;

    isLoading = true;
    update();

    try {
      late Response response;

      switch (flow) {
        case "forgot":
          response = await authRepo.verifyforgotPasswordotp(
            argsIsNumber ? "phone" : "email",
            argsInput,
            otpController.text,
          );
          break;

        case "otp_login":
          // response = await authRepo.verifyOtp(
          //   argsInput,
          //   otpController.text,
          // );
          response = await authRepo.verifyOtp(
            argsIsNumber ? "phone" : "email",
            argsInput,
            otpController.text.trim(),
          );
          break;

        default: // login
          // response = await authRepo.verifyOtp(
          //   argsInput,
          //   otpController.text,
          // );
          response = await authRepo.verifyOtp(
            argsIsNumber ? "phone" : "email",
            argsInput,
            otpController.text.trim(),
          );
      }

      final body = response.body;
      final message = body?['error'] ?? AppString.somethingWentWrong;

      if (response.statusCode == 200 && body?['success'] == true) {
        final token = body['data']?['auth_token'];
        if (token == null || token.isEmpty) {
          AppToast.showError(message: "Token not found");
          return;
        }
        AppToast.showSuccess(message: AppString.otpVerified);
        if (flow == "otp_login") {
          await authRepo.saveUserToken(token);
          await authRepo.onUpdateToken(token);
          Navigation.replaceAll(RouteHelper.dashboard);

          // Navigation.removeAll(RouteHelper.dashboard);
          return;
        }

        /// FORGOT PASSWORD
        if (flow == "forgot") {
          Navigation.replace(
            RouteHelper.setNewPassword,
            arg: {
              "token": token,
              "input": argsInput,
            },
          );
        } else {
          Navigation.replace(
            RouteHelper.setPassword,
            arg: {
              "token": token,
              "input": argsInput,
              "is_number": argsIsNumber,
              if (argsIsNumber) "country_code": argsCountryCode,
            },
          );
        }
      } else {
        AppToast.showError(message: message);
      }
    } catch (e) {
      AppToast.showError(message: e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }
}
