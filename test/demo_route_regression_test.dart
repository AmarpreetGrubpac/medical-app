import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/data/api/api_client.dart';
import 'package:grubpac_driver/data/auth/session_manager.dart';
import 'package:grubpac_driver/data/auth/token_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ApiClient client;

  setUp(() async {
    SharedPreferences.setMockInitialValues({AppConstants.isDemoMode: true});
    FlutterSecureStorage.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final tokens = TokenStore(legacyPreferences: preferences);
    await tokens.initialize();
    final session = SessionManager(prefs: preferences)..initialize();
    client = ApiClient(
      appBaseUrl: 'https://example.test/api/v1/',
      tokenStore: tokens,
      sharedPreferences: preferences,
      sessionManager: session,
    );
  });

  test('relative profile route returns the demo user', () async {
    final response = await client.getData('profile');

    expect(response.statusCode, 200);
    expect(response.body['data'], isA<Map>());
    expect(response.body['data']['first_name'], 'Demo');
  });

  test('relative boxes route returns the demo list', () async {
    final relative = await client.getData('boxes');
    final absolute = await client.getData('/boxes');

    expect(relative.statusCode, 200);
    expect(relative.body, absolute.body);
    expect(relative.body['data'], isNotEmpty);
  });
}
