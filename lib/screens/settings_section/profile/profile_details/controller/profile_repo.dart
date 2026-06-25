import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/data/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  ProfileRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> getProfileData() async {
    return apiClient.getData(AppConstants.getProfile);
  }

  // Future<Response> updatePassword(Map<String, dynamic> body) async {
  //   return apiClient.putData(AppConstants.updateProfile, body);
  // }
}
