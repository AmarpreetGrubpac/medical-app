import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import '../../../../core/utils/app_constant.dart';
import '../../../../data/api/api_client.dart';

class BoxManagementRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  BoxManagementRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> getBoxList() async {
    return await apiClient.getData(AppConstants.getAllBoxes);
  }

  Future<Response> registerbox(String boxId) async {
    return await apiClient
        .postData(AppConstants.registerBox, {"scanned_code": boxId});
  }

  Future<Response> connectBox(String boxId) async {
    final String url = AppConstants.connectBox.replaceAll(":box_id", boxId);
    return await apiClient.postData(url, {});
  }

  Future<Response> disconnectBox(String boxId) async {
    final String url = AppConstants.disconnectBox.replaceAll(
      ":box_id",
      boxId,
    );
    return await apiClient.deleteData(
      url,
    );
  }

  Future<Response> removeBox(String boxId) async {
    final String url = AppConstants.removebox.replaceAll(":box_id", boxId);
    return await apiClient.deleteData(url);
  }

  Future<Response> getBoxDetail(String boxId) async {
    final String url = AppConstants.removebox.replaceAll(":box_id", boxId);
    return await apiClient.getData(url);
  }

  Future<Response> updateBoxSettings(
      String boxId, Map<String, dynamic> settings) async {
    final String url = AppConstants.updatebox.replaceAll(":box_id", boxId);
    return await apiClient.patchData(url, settings);
  }
}
