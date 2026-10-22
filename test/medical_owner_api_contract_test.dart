import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/data/api/api_client.dart';
import 'package:grubpac_driver/data/auth/session_manager.dart';
import 'package:grubpac_driver/data/auth/token_store.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_repo.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _RecordingApiClient extends ApiClient {
  _RecordingApiClient({
    required TokenStore tokenStore,
    required SharedPreferences sharedPreferences,
    required SessionManager sessionManager,
  }) : super(
          appBaseUrl: 'https://example.test/api/v1/',
          tokenStore: tokenStore,
          sharedPreferences: sharedPreferences,
          sessionManager: sessionManager,
        );

  String? method;
  String? path;
  dynamic payload;

  @override
  Future<Response> postData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
    bool authenticated = true,
    bool allowRefresh = true,
  }) async {
    method = 'POST';
    path = uri;
    payload = body;
    return const Response(statusCode: 200, body: {});
  }

  @override
  Future<Response> patchData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
    bool authenticated = true,
    bool allowRefresh = true,
  }) async {
    method = 'PATCH';
    path = uri;
    payload = body;
    return const Response(statusCode: 200, body: {});
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences preferences;
  late SessionManager sessionManager;
  late _RecordingApiClient apiClient;
  late BoxManagementRepo repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    sessionManager = SessionManager(prefs: preferences);
    sessionManager.initialize();

    final tokenStore = TokenStore(legacyPreferences: preferences);
    await tokenStore.initialize();

    apiClient = _RecordingApiClient(
      tokenStore: tokenStore,
      sharedPreferences: preferences,
      sessionManager: sessionManager,
    );
    repository = BoxManagementRepo(
      sharedPreferences: preferences,
      apiClient: apiClient,
    );
  });

  test('active endpoint constants use unified relative paths', () {
    expect(AppConstants.configApi, 'config');
    expect(AppConstants.checkAccountApi, 'medical-mobile/auth/check-account');
    expect(AppConstants.ExistingUserApi, 'medical-mobile/auth/login');
    expect(AppConstants.getProfile, 'profile');
    expect(AppConstants.getAllBoxes, 'boxes');
    expect(AppConstants.getAlerts, 'notification');
    expect(AppConstants.categoryApi, 'support/category');
  });

  test('box scanner claims with display_id', () async {
    await repository.registerbox('MED-BOX-001');

    expect(apiClient.method, 'POST');
    expect(apiClient.path, AppConstants.claimBox);
    expect(apiClient.payload, {
      'display_id': 'MED-BOX-001',
      'box_display_id': 'MED-BOX-001',
    });
  });

  test('emergency unlock sends ids array to grublock endpoint', () async {
    await repository.emergencyUnlockBoxes(['box-123']);

    expect(apiClient.method, 'PATCH');
    expect(apiClient.path, AppConstants.emergencyUnlockGrublock);
    expect(apiClient.payload, {
      'ids': ['box-123']
    });
  });

  test('direct lock routes unlock to emergency_unlock endpoint', () async {
    await repository.setBoxLock('box-123', 'unlock');

    expect(apiClient.method, 'PATCH');
    expect(apiClient.path, AppConstants.emergencyUnlockGrublock);
    expect(apiClient.payload, {
      'ids': ['box-123']
    });
  });

  test('direct lock routes lock to lockGrublock endpoint', () async {
    await repository.setBoxLock('box-123', 'lock');

    expect(apiClient.method, 'PATCH');
    expect(apiClient.path, AppConstants.lockGrublock);
    expect(apiClient.payload, {
      'ids': ['box-123']
    });
  });

  test('owner box connection is not tied to the owner user id', () {
    final box = BoxInfo.fromJson({
      'id': 'box-123',
      'box_display_id': 'MED-001',
      'is_driver_connected': true,
      'driver_id': 'employee-user-id',
    });

    expect(box.isConnected, isTrue);
  });

  test('legacy plaintext tokens migrate to secure storage', () async {
    SharedPreferences.setMockInitialValues({
      AppConstants.token: 'legacy-access',
      AppConstants.refreshToken: 'legacy-refresh',
    });
    FlutterSecureStorage.setMockInitialValues({});
    final legacyPreferences = await SharedPreferences.getInstance();
    final store = TokenStore(legacyPreferences: legacyPreferences);

    await store.initialize();

    expect(store.accessToken, 'legacy-access');
    expect(store.refreshToken, 'legacy-refresh');
    expect(legacyPreferences.containsKey(AppConstants.token), isFalse);
    expect(legacyPreferences.containsKey(AppConstants.refreshToken), isFalse);
  });
}
