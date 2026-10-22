import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PersonaType {
  owner,
  handler,
  unknown;

  static PersonaType fromString(String? value) {
    if (value == null) return PersonaType.unknown;
    final normalized = value.toLowerCase().trim();
    if (normalized == 'owner') return PersonaType.owner;
    if (normalized == 'driver' || normalized == 'handler') {
      return PersonaType.handler;
    }
    return PersonaType.unknown;
  }
}

class SessionManager extends GetxService {
  final SharedPreferences _prefs;

  SessionManager({required SharedPreferences prefs}) : _prefs = prefs;

  static const String _keyPersona = 'SESSION_PERSONA';
  static const String _keyApiPrefix = 'SESSION_API_PREFIX';
  static const String _keyClientId = 'SESSION_CLIENT_ID';
  static const String _keyUserId = 'SESSION_USER_ID';

  final Rx<String> _persona = ''.obs;
  final Rx<String> _apiPrefix = ''.obs;
  final Rx<String> _clientId = ''.obs;
  final Rx<String> _userId = ''.obs;

  String get persona => _persona.value;
  String get apiPrefix => _apiPrefix.value;
  String get clientId => _clientId.value;
  String get userId => _userId.value;

  PersonaType get personaType => PersonaType.fromString(_persona.value);

  bool get isOwner => personaType == PersonaType.owner;
  bool get isHandler => personaType == PersonaType.handler;
  bool get hasSession => _apiPrefix.value.isNotEmpty;

  /// Normalized prefix ensuring it ends with '/' and has no leading '/'
  String get normalizedApiPrefix {
    var prefix = _apiPrefix.value.trim();
    if (prefix.isEmpty) {
      // Default to owner if none resolved yet
      return 'medical-mobile/owner/';
    }
    if (prefix.startsWith('/')) {
      prefix = prefix.substring(1);
    }
    if (!prefix.endsWith('/')) {
      prefix = '$prefix/';
    }
    return prefix;
  }

  /// Initialize session from SharedPreferences
  void initialize() {
    _persona.value = _prefs.getString(_keyPersona) ?? '';
    _apiPrefix.value = _prefs.getString(_keyApiPrefix) ?? '';
    _clientId.value = _prefs.getString(_keyClientId) ?? '';
    _userId.value = _prefs.getString(_keyUserId) ?? '';
    if (kDebugMode) {
      debugPrint(
        'SessionManager initialized -> persona: ${_persona.value}, prefix: ${_apiPrefix.value}',
      );
    }
  }

  /// Save session data returned from login / check-account
  Future<void> saveSession({
    required String persona,
    required String apiPrefix,
    String? clientId,
    String? userId,
  }) async {
    _persona.value = persona;
    _apiPrefix.value = apiPrefix;
    if (clientId != null) _clientId.value = clientId;
    if (userId != null) _userId.value = userId;

    await _prefs.setString(_keyPersona, persona);
    await _prefs.setString(_keyApiPrefix, apiPrefix);
    if (clientId != null) {
      await _prefs.setString(_keyClientId, clientId);
    }
    if (userId != null) {
      await _prefs.setString(_keyUserId, userId);
    }

    if (kDebugMode) {
      debugPrint(
        'SessionManager saved -> persona: $persona, prefix: $apiPrefix, clientId: $clientId',
      );
    }
  }

  /// Clear all session data on logout / switch role
  Future<void> clearSession() async {
    _persona.value = '';
    _apiPrefix.value = '';
    _clientId.value = '';
    _userId.value = '';

    await _prefs.remove(_keyPersona);
    await _prefs.remove(_keyApiPrefix);
    await _prefs.remove(_keyClientId);
    await _prefs.remove(_keyUserId);

    if (kDebugMode) {
      debugPrint('SessionManager cleared.');
    }
  }
}
