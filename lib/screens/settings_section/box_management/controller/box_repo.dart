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
    return await apiClient.postData(
      AppConstants.claimBox,
      {"box_display_id": boxId},
    );
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

  Future<Response> getSimulatorHealth(String boxId) async {
    return await apiClient.getData(
      "/simulator/boxes/$boxId/health",
    );
  }

  Future<Response> updateBoxSettings(
      String boxId, Map<String, dynamic> settings) async {
    final String url = AppConstants.updatebox.replaceAll(":box_id", boxId);
    return await apiClient.patchData(url, settings);
  }

  Future<Response> emergencyUnlockBoxes(List<String> boxIds) async {
    return await apiClient.patchData(
      AppConstants.emergencyUnlockGrublock,
      {"ids": boxIds},
    );
  }

  Future<Response> lockBoxes(List<String> boxIds) async {
    return await apiClient.patchData(
      AppConstants.lockGrublock,
      {"ids": boxIds},
    );
  }

  Future<Response> setBoxLock(String boxId, String action) async {
    try {
      if (action.toLowerCase() == 'unlock') {
        final res = await emergencyUnlockBoxes([boxId]);
        if (res.statusCode == 200) return res;
      } else {
        final res = await lockBoxes([boxId]);
        if (res.statusCode == 200) return res;
      }
    } catch (_) {
      // fallback to per-box endpoint
    }
    final String url = AppConstants.lockBox.replaceAll(":box_id", boxId);
    return await apiClient.patchData(url, {"action": action});
  }
}
