import 'package:flutter/foundation.dart';
import 'package:growana/models/user.dart';
import 'package:growana/services/auth_service.dart';

class UserService {
  // currentUser tetap accessible seperti sedia kala
  static User? currentUser;

  // Notifier kalau mau listen perubahan (opsional)
  static final ValueNotifier<User?> notifier = ValueNotifier(null);

  // Panggil ini setelah login / edit profile untuk refresh currentUser
  static Future<void> refreshCurrentUser() async {
    final auth = AuthService();
    currentUser = await auth.getLoggedInUser();
    notifier.value = currentUser;
  }
}
