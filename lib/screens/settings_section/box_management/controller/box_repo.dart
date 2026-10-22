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
    final isHandler = apiClient.sessionManager.isHandler;
    if (isHandler) {
      // Handler: POST …/boxes (QR)
      return await apiClient.postData(
        AppConstants.registerQrBox,
        {
          "display_id": boxId,
          "box_display_id": boxId,
        },
      );
    } else {
      // Owner: POST …/boxes/claim { "display_id": ... }
      return await apiClient.postData(
        AppConstants.claimBox,
        {
          "display_id": boxId,
          "box_display_id": boxId,
        },
      );
    }
  }

  Future<Response> postEmergencyAlert(Map<String, dynamic> data) async {
    return await apiClient.postData(
      AppConstants.emergencyAlert,
      data,
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
    if (action == 'unlock') return emergencyUnlockBoxes([boxId]);
    if (action == 'lock') return lockBoxes([boxId]);
    throw ArgumentError.value(action, 'action', 'Expected lock or unlock');
  }
}
