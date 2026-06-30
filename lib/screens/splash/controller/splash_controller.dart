import 'dart:io';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/preference/app_preferences.dart';
import 'package:grubpac_driver/core/preference/pref_key.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/data/api/api_checker.dart';
import 'package:grubpac_driver/helper/navigation.dart';
import 'package:grubpac_driver/helper/route_helper.dart';
import 'package:grubpac_driver/screens/auth/controller/existing_user_controller.dart';
import 'package:grubpac_driver/screens/settings_section/profile/profile_details/controller/profile_details_controller.dart';
import 'package:grubpac_driver/screens/splash/repo/splash_repo.dart';
import '../model/config_model.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({required this.splashRepo});

  ConfigModel? _configData;
  ConfigModel? get configData => _configData;

  Future<void> redirectToNext() async {
    if (configData == null) {
      final isSuccess = await getConfigData();
      if (!isSuccess) {
        Navigation.replaceAll(RouteHelper.login);
        return;
      }
    }

    final config = configData?.data?.config;

    if (config == null) {
      Navigation.replaceAll(RouteHelper.login);
      return;
    }

    /// 🔧 MAINTENANCE CHECK
    /// config.maintenanceMode == "true"
    if (config.maintenanceMode == "true") {
      Get.offAllNamed(RouteHelper.maintenanceScreen);
      return;
    }

    final needUpdate = Platform.isAndroid
        ? versionToNumber(config.minAndroidVersion ?? "0") >
            versionToNumber(AppConstants.androidAppVersion)
        : versionToNumber(config.minIosVersion ?? "0") >
            versionToNumber(AppConstants.iosAppVersion);

    if (needUpdate) {
      Get.offAllNamed(RouteHelper.updateScreen);
      return;
    }
    if (!Get.find<ExistingUserController>().isLoggedIn()) {
      Navigation.replaceAll(RouteHelper.login);
    } else {
      await Get.find<ProfileDetailsController>().getProfileData();
      Navigation.replaceAll(RouteHelper.dashboard);
    }
  }

  Future<bool> getConfigData() async {
    // _configData = ConfigModel(
    //     success: true,
    //     code: 200,
    //     data: Data(
    //         config: Config(
    //             maintenanceMode: "false",
    //             minAndroidVersion: "1.0",
    //             minIosVersion: "1.0",
    //             privacyPolicyR:
    //                 "https://www.lenskart.com/eyeglasses/gender/all-men-eyeglasses.html",
    //             termsNConditionsR:
    //                 "https://www.lenskart.com/eyeglasses/gender/all-men-eyeglasses.html")));

    // return true;
    Response response = await splashRepo.getConfigData();

    if (response.statusCode == 200 && response.body != null) {
      _configData = ConfigModel.fromJson(response.body);
      update();
      return true;
    } else {
      ApiChecker.checkApi(response);
      return false;
    }
  }
}

int versionToNumber(String version) {
  List<String> parts = version.split('.');
  int major = int.tryParse(parts[0]) ?? 0;
  int minor = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
  int patch = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;

  return major * 10000 + minor * 100 + patch;
}
