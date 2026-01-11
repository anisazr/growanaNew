import 'package:flutter/material.dart';
import 'package:growana/models/user.dart';
import 'package:growana/screens/edit_profile_page.dart';
import 'package:growana/services/auth_service.dart';
import 'login_page.dart';
import '../services/user_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final auth = AuthService();
  User? currentUser;
  bool checking = true;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    currentUser = await auth.getLoggedInUser();
    if (currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

    await UserService.refreshCurrentUser();
    setState(() => checking = false);
  }

  Future<void> deleteAccount() async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Akun"),
        content: const Text("Apakah Anda yakin ingin menghapus akun ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await auth.logout();
      await UserService.refreshCurrentUser();
      Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1D7140);

    if (checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1D7140),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // AVATAR
                CircleAvatar(
                  radius: 44,
                  backgroundColor: primary,
                  child: Text(
                    currentUser!.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // NAMA
                Text(
                  currentUser!.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                // EMAIL
                Text(
                  currentUser!.email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),

                // EDIT PROFIL
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Profil"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfilePage(user: currentUser!),
                        ),
                      );

                      if (updated == true) {
                        currentUser = await auth.getLoggedInUser();
                        setState(() {});
                      }
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // HAPUS AKUN
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text("Hapus Akun"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: deleteAccount,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
