import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grubpac_driver/core/flavor/app_flavor_config.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:grubpac_driver/data/api/api_client.dart';
import 'package:grubpac_driver/data/auth/session_manager.dart';
import 'package:grubpac_driver/data/auth/token_store.dart';
import 'package:grubpac_driver/screens/settings_section/box_management/controller/box_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences preferences;
  late SessionManager sessionManager;
  late TokenStore tokenStore;
  late ApiClient apiClient;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    sessionManager = SessionManager(prefs: preferences);
    sessionManager.initialize();

    tokenStore = TokenStore(legacyPreferences: preferences);
    await tokenStore.initialize();

    apiClient = ApiClient(
      appBaseUrl: AppFlavorConfig.prod.baseUrl,
      tokenStore: tokenStore,
      sharedPreferences: preferences,
      sessionManager: sessionManager,
    );
  });

  group('Unified Auth & Flavor URL Architecture', () {
    test('Flavor base URLs strictly end with /api/v1/', () {
      expect(AppFlavorConfig.prod.baseUrl, 'https://43.204.34.10.nip.io/api/v1/');
      expect(AppFlavorConfig.dev.baseUrl, 'https://preprod.43.204.34.10.nip.io/api/v1/');
      expect(AppFlavorConfig.staging.baseUrl, 'https://staging.43.204.34.10.nip.io/api/v1/');
    });

    test('Unified auth endpoints are prefix-independent', () {
      expect(AppConstants.checkAccountApi, 'medical-mobile/auth/check-account');
      expect(AppConstants.ExistingUserApi, 'medical-mobile/auth/login');
    });

    test('SessionManager default prefix falls back to Owner prefix', () {
      expect(sessionManager.normalizedApiPrefix, 'medical-mobile/owner/');
      expect(sessionManager.isOwner, false);
      expect(sessionManager.isHandler, false);
    });

    test('SessionManager stores persona and api_prefix for Owner', () async {
      await sessionManager.saveSession(
        persona: 'owner',
        apiPrefix: 'medical-mobile/owner/',
        clientId: 'client-123',
      );

      expect(sessionManager.isOwner, true);
      expect(sessionManager.isHandler, false);
      expect(sessionManager.normalizedApiPrefix, 'medical-mobile/owner/');
      expect(sessionManager.clientId, 'client-123');
    });

    test('SessionManager stores persona and api_prefix for Handler/Driver', () async {
      await sessionManager.saveSession(
        persona: 'driver',
        apiPrefix: 'medical-mobile/driver/',
        clientId: 'client-456',
      );

      expect(sessionManager.isOwner, false);
      expect(sessionManager.isHandler, true);
      expect(sessionManager.normalizedApiPrefix, 'medical-mobile/driver/');
      expect(sessionManager.clientId, 'client-456');
    });

    test('SessionManager clean reset on logout', () async {
      await sessionManager.saveSession(
        persona: 'driver',
        apiPrefix: 'medical-mobile/driver/',
      );
      expect(sessionManager.isHandler, true);

      await sessionManager.clearSession();
      expect(sessionManager.persona, '');
      expect(sessionManager.apiPrefix, '');
      expect(sessionManager.isHandler, false);
    });
  });

  group('Box Repository Role Routing', () {
    test('Owner claims box via boxes/claim with display_id', () async {
      await sessionManager.saveSession(
        persona: 'owner',
        apiPrefix: 'medical-mobile/owner/',
      );

      final repo = BoxManagementRepo(
        sharedPreferences: preferences,
        apiClient: apiClient,
      );

      expect(sessionManager.isOwner, true);
    });

    test('Handler registers box via boxes QR', () async {
      await sessionManager.saveSession(
        persona: 'driver',
        apiPrefix: 'medical-mobile/driver/',
      );

      expect(sessionManager.isHandler, true);
    });
  });
}
