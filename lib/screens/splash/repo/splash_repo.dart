import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/data/api/api_client.dart';

class SplashRepo {
  final ApiClient apiClient;

  SplashRepo({required this.apiClient});

  Future<Response> getConfigData() async {
    return await apiClient.getData(AppConstants.configApi);
  }
}