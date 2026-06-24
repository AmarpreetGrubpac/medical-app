import 'package:grubpac_driver/core/preference/pref_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static late SharedPreferences _prefs;

  static Future initMySharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> clearSharedPreferences() async {
    String theme = getString(PrefKey.theme);
    await _prefs.clear();
    await setString(PrefKey.theme, theme);
    return;
  }

  /// STRING
  static Future setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String getString(String key) {
    final String? value = _prefs.getString(key);
    return value ?? "";
  }

  /// STRING LIST
  static Future setStringList(String key, List<String> data) async {
    await _prefs.setStringList(key, data);
  }

  static List<String> getStringList(String key) {
    final List<String>? data = _prefs.getStringList(key);
    return data ?? [];
  }

  /// DOUBLE
  static Future setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  static double getDouble(String key) {
    final double? value = _prefs.getDouble(key);
    return value ?? 0.0;
  }

  /// BOOLEAN
  static Future setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static bool getBool(String key) {
    final bool? value = _prefs.getBool(key);
    return value ?? false;
  }

  /// INTEGER
  static Future setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static int getInt(String key) {
    final int? value = _prefs.getInt(key);
    return value ?? 0;
  }
}
