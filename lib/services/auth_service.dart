import 'package:growana/models/user.dart';
import 'package:growana/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final repo = UserRepository();

  Future<String?> register(String name, String email, String password) async {
    final existing = await repo.getUserByEmail(email);
    if (existing != null) return "Email sudah terdaftar";

    final user = User(name: name, email: email, password: password);
    await repo.createUser(user);
    return null;
  }

  Future<User?> login(String email, String password) async {
    final user = await repo.getUserByEmail(email);

    if (user == null) return null;
    if (user.password != password) return null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("currentUserId", user.id!);

    return user;
  }

  Future<User?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt("currentUserId");
    if (id == null) return null;

    return await repo.getUserById(id);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("currentUserId");
  }
}
