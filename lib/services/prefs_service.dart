// lib/services/prefs_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _keyLastEmail = 'lastEmail';
  static const _keyLastTabIndex = 'lastTabIndex';

  // === LOGIN KEYS ===
  static const _keyUserName = 'user_name';
  static const _keyUserEmail = 'user_email';
  static const _keyUserPassword = 'user_password';
  static const _keyIsLoggedIn = 'is_logged_in';

  // =========================
  // Last email (String)
  static Future<void> setLastEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastEmail, email);
  }

  static Future<String?> getLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastEmail);
  }

  // =========================
  // Last selected bottom tab index (int)
  static Future<void> setLastTabIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLastTabIndex, index);
  }

  static Future<int?> getLastTabIndex() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_keyLastTabIndex)) return null;
    return prefs.getInt(_keyLastTabIndex);
  }

  // FIX: hapus fungsi kosong
  static Future<void> saveLastTabIndex(int index) async {
    await setLastTabIndex(index);
  }

  // =========================
  // === USER AUTH (SharedPreferences) ===

  /// Simpan data user saat register
  static Future<void> saveUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserPassword, password);
  }

  /// Login user
  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString(_keyUserEmail);
    final savedPassword = prefs.getString(_keyUserPassword);

    if (email == savedEmail && password == savedPassword) {
      await prefs.setBool(_keyIsLoggedIn, true);
      await setLastEmail(email);
      return true;
    }
    return false;
  }

  /// Cek status login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  /// Ambil nama user
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  /// Ambil email user
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }
}
