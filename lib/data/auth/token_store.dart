import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grubpac_driver/core/utils/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  TokenStore({
    required SharedPreferences legacyPreferences,
    FlutterSecureStorage? secureStorage,
  })  : _legacyPreferences = legacyPreferences,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final SharedPreferences _legacyPreferences;
  final FlutterSecureStorage _secureStorage;

  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get hasAccessToken => _accessToken?.isNotEmpty == true;

  Future<void> initialize() async {
    _accessToken = await _secureStorage.read(key: AppConstants.token);
    _refreshToken = await _secureStorage.read(key: AppConstants.refreshToken);

    final legacyAccess = _legacyPreferences.getString(AppConstants.token);
    final legacyRefresh =
        _legacyPreferences.getString(AppConstants.refreshToken);

    if ((_accessToken == null || _accessToken!.isEmpty) &&
        legacyAccess?.isNotEmpty == true) {
      await writeAccessToken(legacyAccess!);
    }
    if ((_refreshToken == null || _refreshToken!.isEmpty) &&
        legacyRefresh?.isNotEmpty == true) {
      await writeRefreshToken(legacyRefresh!);
    }

    await _legacyPreferences.remove(AppConstants.token);
    await _legacyPreferences.remove(AppConstants.refreshToken);
  }

  Future<void> writeAccessToken(String value) async {
    _accessToken = value;
    await _secureStorage.write(key: AppConstants.token, value: value);
  }

  Future<void> writeRefreshToken(String value) async {
    _refreshToken = value;
    await _secureStorage.write(key: AppConstants.refreshToken, value: value);
  }

  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    await Future.wait([
      _secureStorage.delete(key: AppConstants.token),
      _secureStorage.delete(key: AppConstants.refreshToken),
      _legacyPreferences.remove(AppConstants.token),
      _legacyPreferences.remove(AppConstants.refreshToken),
    ]);
  }
}
