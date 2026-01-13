// lib/services/auth_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _keyUsers = 'users';
  static const String _keyCurrentUser = 'currentUser';
  static const String _keyIsLoggedIn = 'isLoggedIn';

  /// REGISTER - Simpan user baru
  Future<String?> register(String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Ambil list users yang ada
      final usersJson = prefs.getString(_keyUsers) ?? '[]';
      final List<dynamic> users = jsonDecode(usersJson);
      
      // Cek apakah email sudah terdaftar
      final emailExists = users.any((user) => user['email'] == email);
      if (emailExists) {
        return 'Email sudah terdaftar';
      }
      
      // Buat user baru
      final newUser = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': name,
        'email': email,
        'password': password,
      };
      
      // Tambah ke list
      users.add(newUser);
      
      // Simpan ke SharedPreferences
      await prefs.setString(_keyUsers, jsonEncode(users));
      
      return null; // Success
    } catch (e) {
      return 'Error: $e';
    }
  }

  /// LOGIN - Verifikasi user
  Future<User?> login(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_keyUsers) ?? '[]';
      final List<dynamic> users = jsonDecode(usersJson);
      
      // Cari user dengan email dan password yang cocok
      final userMap = users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => null,
      );
      
      if (userMap == null) {
        return null; // Login failed
      }
      
      // Simpan sebagai current user
      await prefs.setString(_keyCurrentUser, jsonEncode(userMap));
      await prefs.setBool(_keyIsLoggedIn, true);
      
      return User.fromMap(userMap);
    } catch (e) {
      return null;
    }
  }

  /// LOGOUT - Hapus session
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentUser);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  /// CHECK LOGIN STATUS
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// GET CURRENT USER
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_keyCurrentUser);
      
      if (userJson == null) return null;
      
      final userMap = jsonDecode(userJson);
      return User.fromMap(userMap);
    } catch (e) {
      return null;
    }
  }

  /// UPDATE USER PROFILE
  Future<void> updateUser(User updatedUser) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Ambil semua users
      final usersJson = prefs.getString(_keyUsers) ?? '[]';
      final List<dynamic> users = jsonDecode(usersJson);
      
      // Cari index user yang akan diupdate
      final userIndex = users.indexWhere((user) => user['id'] == updatedUser.id);
      
      if (userIndex != -1) {
        // Update user
        users[userIndex] = updatedUser.toMap();
        
        // Simpan kembali
        await prefs.setString(_keyUsers, jsonEncode(users));
        await prefs.setString(_keyCurrentUser, jsonEncode(updatedUser.toMap()));
      }
    } catch (e) {
      print('Error updating user: $e');
    }
  }
}