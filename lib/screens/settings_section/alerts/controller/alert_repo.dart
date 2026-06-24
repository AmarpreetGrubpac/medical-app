import 'package:grubpac_driver/data/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  AlertRepo({required this.apiClient,required this.sharedPreferences});


}