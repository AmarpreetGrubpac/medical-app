import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/screens/auth/controller/existing_user_controller.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/core/utils/app_toast.dart';
import 'package:grubpac_driver/data/model/response_model.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/auth/repo/auth_repo.dart';
import 'package:grubpac_driver/screens/auth/model/carousel_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:grubpac_driver/core/flavor/app_flavor_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController implements GetxService{
  final AuthRepo authRepo;
  LoginController({required this.authRepo});

  final CarouselController carouselController = CarouselController();

  final List<CarouselModel> carouselItems = [
    CarouselModel(
        title: AppString.linkYourBoxTitle,
        description: AppString.linkYourBoxDesc),
    CarouselModel(
        title: AppString.avoidBlamesTitle,
        description: AppString.avoidBlamesDesc),
    CarouselModel(
        title: AppString.stayInformedTitle,
        description: AppString.stayInformedDesc),
    CarouselModel(
        title: AppString.getSupportTitle,
        description: AppString.getSupportDesc),
  ];

  int currentPage = 0;

  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  bool isPhoneNumber = false;
  bool isBtnDisabled = true;
  bool isDemoMode = false;


  @override
  void onInit() {
    super.onInit();
    final hasTestMode = AppFlavorConfig.isInitialized
        ? AppFlavorConfig.current.hasTestMode
        : true;
    final prefs = Get.find<SharedPreferences>();
    isDemoMode = hasTestMode &&
        (prefs.getBool(AppConstants.isDemoMode) ?? false);
    if (isDemoMode) {
      emailController.text = "demo@grubpac.com";
    }
    emailController.addListener(_validatePrefix);
    _validatePrefix();
  }

  /// TOGGLE DEMO TEST ENVIRONMENT
  Future<void> toggleDemoMode() async {
    isDemoMode = !isDemoMode;
    final prefs = Get.find<SharedPreferences>();

    if (isDemoMode) {
      await prefs.setBool(AppConstants.isDemoMode, true);
      emailController.text = "demo@grubpac.com";
      AppToast.showSuccess(
        message: "Demo Mode active. Prefilled demo credentials.",
      );
    } else {
      await prefs.remove(AppConstants.isDemoMode);
      emailController.clear();
      AppToast.showSuccess(
        message: "Switched to Live Environment.",
      );
    }
    _validatePrefix();
    update();
  }

  /// ON CHANGE PAGE
  void onChangePage(int index, CarouselPageChangedReason reason) {
    currentPage = index;
    update();
  }

  void _validatePrefix() {
    String text = emailController.text.replaceAll(RegExp(r'\s+'), '');
    isPhoneNumber = _isPhoneNumber(text);
    update();

    if (text.isEmpty) {
      isBtnDisabled = true;
      update();
      return;
    }

    final isValidPhone = RegExp(r'^\+?[0-9]{10,15}$').hasMatch(text);
    final isValidEmail = _isValidEmail(text);
    final isNumeric = RegExp(r'^[0-9+]+$').hasMatch(text);

    if (isNumeric) {
      isBtnDisabled = !isValidPhone;
    } else {
      isBtnDisabled = !isValidEmail;
    }
    update();
  }

  bool _isPhoneNumber(String text) {
    final phoneRegex = RegExp(r'^\+?[0-9]{1,15}$');
    return phoneRegex.hasMatch(text);
  }

  bool _isValidEmail(String text) {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[a-zA-Z]{2,63}$');
    return emailRegex.hasMatch(text);
  }

  /// AUTH VALIDATOR
  String? authValidator(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      isBtnDisabled = true;
      update();
      return AppString.required;
    }

    final isValidPhone = RegExp(r'^\+?[0-9]{10,15}$').hasMatch(text);
    final isValidEmail = _isValidEmail(text);
    final isNumeric = RegExp(r'^[0-9+]+$').hasMatch(text);

    if (isNumeric) {
      if (!isValidPhone) {
        isBtnDisabled = true;
        update();
        return AppString.enterValidNumber;
      }
    } else {
      if (!isValidEmail) {
        isBtnDisabled = true;
        update();
        return AppString.enterValidEmail;
      }
    }

    isBtnDisabled = false;
    update();
    return null;
  }

  Future<void> onContinueTap() async {
    final input = emailController.text.trim();

    if (input.isEmpty || (!_isValidEmail(input) && !_isPhoneNumber(input))) {
      return;
    }

    isLoading = true;
    isBtnDisabled = true;
    update();

    try {
      Response response = await authRepo.checkAccountApi(
        isPhoneNumber ? "phone" : "email",
        input,
      );

      if (response.statusCode == 200) {
        bool isAccountFound = response.body['is_account_found'] ?? false;

        if (!isAccountFound) {
          AppToast.showError(
              message: AppString.incorrectMsg,
              title: AppString.accountNotFound);
          return;
        }
        bool isPasswordSet = response.body['is_password_set'] ?? false;

        if (isPasswordSet) {
          Get.find<ExistingUserController>().prefillAuth(input, isPhoneNumber);
          Navigation.pushNamed(
            RouteHelper.existingUserScreen,
            arg: {
              'auth': input,
              'is_number': isPhoneNumber,
            },
          );
        } else {
          Navigation.pushNamed(
            RouteHelper.verifyOtp,
            arg: {
              "input": input,
              "is_number": isPhoneNumber,
              if (isPhoneNumber) "country_code": "+91",
              "flow": "login",
            },
          );
        }
      } else {
        final errorMessage = response.body != null && response.body is Map
            ? response.body['error'] ?? response.statusText
            : response.statusText ?? AppString.somethingWentWrong;

        AppToast.showError(message: errorMessage);
      }
    } catch (e) {
      debugPrint("Login error: $e");
      AppToast.showError(message: AppString.somethingWentWrong);
    } finally {
      isLoading = false;
      isBtnDisabled = false;
      update();
    }
  }

  /// PROFILE
  void onPolicyTap() async {
    String url = AppConstants.privacyPolicyR;

    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView,
    )) {
      throw 'Could not launch $url';
    }
  }

  /// ALERT
  void onTermsTap() async {
    String url = AppConstants.termsNConditionsR;

    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<ResponseModel> forgotPassword(
    String email, {
    bool fromChangePass = false,
  }) async {
    isLoading = true;
    update();

    Response response = await authRepo.forgotPassword(
      isPhoneNumber ? "phone" : "email",
      email,
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, 'successfully');
      Navigation.pushNamed(
        RouteHelper.verifyOtp,
        arg: {
          "input": email,
          "is_number": isPhoneNumber,
          if (isPhoneNumber) "country_code": "+91",
          "flow": "forgot",
          "from_change_pass": fromChangePass,
        },
      );
    } else {
      responseModel = ResponseModel(false, response.statusText!);
      final errorMessage = response.body != null && response.body is Map
          ? response.body['error'] ?? response.statusText
          : response.statusText ?? AppString.somethingWentWrong;

      AppToast.showError(message: errorMessage);
    }
    isLoading = false;
    update();
    return responseModel;
  }
}
