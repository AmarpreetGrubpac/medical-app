import 'package:get/get_connect/http/src/response/response.dart';
import 'package:grubpac_driver/core/exceptions/failure.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/data/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  AlertRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getAlerts() async {
    return await apiClient.getData(AppConstants.getAlerts);
  }

  Future<Response> updateNotifications({
    required List<String> ids,
    bool? isRead,
    bool? isDismissed,
  }) async {
    final body = {
      "ids": ids,
      if (isRead != null) "is_read": isRead,
      if (isDismissed != null) "is_dismissed": isDismissed,
    };
    return await apiClient.patchData(AppConstants.getAlerts, body);
  }
}
