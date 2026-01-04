import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:growana/models/user.dart';

class AuthService {

  /// REGISTER
  Future<String?> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // ambil user lama
    final usersString = prefs.getString('users');
    List users = usersString == null ? [] : jsonDecode(usersString);

    // cek email
    final exists = users.any((u) => u['email'] == email);
    if (exists) return 'Email sudah terdaftar';

    // tambah user baru
    users.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': name,
      'email': email,
      'password': password,
    });

    await prefs.setString('users', jsonEncode(users));
    return null; // sukses
  }

  /// LOGIN
  Future<User?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString('users');

    if (usersString == null) return null;

    final users = jsonDecode(usersString);

    try {
      final userMap = users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
      );

      await prefs.setString('currentUser', jsonEncode(userMap));
      return User.fromMap(userMap);
    } catch (_) {
      return null;
    }
  }

  /// GET USER LOGIN
  Future<User?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('currentUser');

    if (userString == null) return null;
    return User.fromMap(jsonDecode(userString));
  }

  /// LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
  }
}
