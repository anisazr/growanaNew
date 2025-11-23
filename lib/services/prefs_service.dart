// lib/services/prefs_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _keyLastEmail = 'lastEmail';
  static const _keyLastTabIndex = 'lastTabIndex';

  // Last email (String)
  static Future<void> setLastEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastEmail, email);
  }

  static Future<String?> getLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastEmail);
  }

  // Last selected bottom tab index (int)
  static Future<void> setLastTabIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLastTabIndex, index);
  }

  // return null if not set
  static Future<int?> getLastTabIndex() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_keyLastTabIndex)) return null;
    return prefs.getInt(_keyLastTabIndex);
  }

  static void saveLastTabIndex(int index) {}
}
