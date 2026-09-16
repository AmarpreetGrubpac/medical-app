import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/data/api/api_client.dart';
import 'package:grubpac_driver/data/auth/token_store.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_repo.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/model/box_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _RecordingApiClient extends ApiClient {
  _RecordingApiClient(TokenStore tokenStore)
      : super(
            appBaseUrl: 'https://example.test/api/v1', tokenStore: tokenStore);

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
  late _RecordingApiClient apiClient;
  late BoxManagementRepo repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    apiClient = _RecordingApiClient(
      TokenStore(legacyPreferences: preferences),
    );
    repository = BoxManagementRepo(
      sharedPreferences: preferences,
      apiClient: apiClient,
    );
  });

  test('active endpoint constants use the Medical Owner prefix', () {
    expect(AppConstants.configApi, startsWith(AppConstants.medicalOwnerPath));
    expect(AppConstants.loginApi, startsWith(AppConstants.medicalOwnerPath));
    expect(AppConstants.getProfile, startsWith(AppConstants.medicalOwnerPath));
    expect(AppConstants.getAllBoxes, startsWith(AppConstants.medicalOwnerPath));
    expect(AppConstants.getAlerts, startsWith(AppConstants.medicalOwnerPath));
    expect(AppConstants.categoryApi, startsWith(AppConstants.medicalOwnerPath));
  });

  test('box scanner claims by box_display_id', () async {
    await repository.registerbox('MED-BOX-001');

    expect(apiClient.method, 'POST');
    expect(apiClient.path, AppConstants.claimBox);
    expect(apiClient.payload, {'box_display_id': 'MED-BOX-001'});
  });

  test('direct lock sends the existing action field', () async {
    await repository.setBoxLock('box-123', 'unlock');

    expect(apiClient.method, 'PATCH');
    expect(
      apiClient.path,
      '${AppConstants.medicalOwnerPath}/boxes/box-123/lock',
    );
    expect(apiClient.payload, {'action': 'unlock'});
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
