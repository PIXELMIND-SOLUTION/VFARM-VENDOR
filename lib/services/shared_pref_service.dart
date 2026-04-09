import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SharedPrefService {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Auth related
  static Future<void> saveAuthToken(String token) async {
    await _preferences.setString(AppConstants.prefToken, token);
  }

  static String? getAuthToken() {
    return _preferences.getString(AppConstants.prefToken);
  }

  static Future<void> saveVendorId(String vendorId) async {
    await _preferences.setString(AppConstants.prefVendorId, vendorId);
  }

  static String? getVendorId() {
    return _preferences.getString(AppConstants.prefVendorId);
  }

  static Future<void> saveVendorName(String name) async {
    await _preferences.setString(AppConstants.prefVendorName, name);
  }

  static String? getVendorName() {
    return _preferences.getString(AppConstants.prefVendorName);
  }

  static Future<void> saveVendorEmail(String email) async {
    await _preferences.setString(AppConstants.prefVendorEmail, email);
  }

  static String? getVendorEmail() {
    return _preferences.getString(AppConstants.prefVendorEmail);
  }

  static Future<void> saveFarmhouseId(String farmhouseId) async {
    await _preferences.setString(AppConstants.prefFarmhouseId, farmhouseId);
  }

  static String? getFarmhouseId() {
    return _preferences.getString(AppConstants.prefFarmhouseId);
  }

  static Future<void> setLoggedIn(bool value) async {
    await _preferences.setBool(AppConstants.prefIsLoggedIn, value);
  }

  static bool isLoggedIn() {
    return _preferences.getBool(AppConstants.prefIsLoggedIn) ?? false;
  }

  // Theme
  static Future<void> saveThemeMode(String themeMode) async {
    await _preferences.setString(AppConstants.prefThemeMode, themeMode);
  }

  static String getThemeMode() {
    return _preferences.getString(AppConstants.prefThemeMode) ?? 'system';
  }

  // Clear all user data (logout)
  static Future<void> clearUserData() async {
    await _preferences.remove(AppConstants.prefToken);
    await _preferences.remove(AppConstants.prefVendorId);
    await _preferences.remove(AppConstants.prefVendorName);
    await _preferences.remove(AppConstants.prefVendorEmail);
    await _preferences.remove(AppConstants.prefFarmhouseId);
    await _preferences.setBool(AppConstants.prefIsLoggedIn, false);
  }

  // Generic methods
  static Future<void> saveString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  static String? getString(String key) {
    return _preferences.getString(key);
  }

  static Future<void> saveInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  static int? getInt(String key) {
    return _preferences.getInt(key);
  }

  static Future<void> saveBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  static Future<void> saveDouble(String key, double value) async {
    await _preferences.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  static Future<void> saveStringList(String key, List<String> value) async {
    await _preferences.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  static Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  static Future<void> clearAll() async {
    await _preferences.clear();
  }
}
