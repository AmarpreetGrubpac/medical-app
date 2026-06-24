import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/data/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  HelpRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> getCategory({
    String? query,
    int limit = 10,
    int page = 1,
  }) async {
    String uri = '${AppConstants.categoryApi}?limit=$limit&page=$page';

    if (query != null && query.isNotEmpty) {
      uri += '&query=$query';
    }

    return await apiClient.getData(uri);
  }


  Future<Response> getCategoryBYID({
    required String id,
    String? query,
    int limit = 10,
    int page = 1,
  }) async {
    String uri =
        '${AppConstants.subCategoryApi}=$id&limit=$limit&page=$page';

    if (query != null && query.isNotEmpty) {
      uri += '&query=$query';
    }

    return await apiClient.getData(uri);
  }

}
