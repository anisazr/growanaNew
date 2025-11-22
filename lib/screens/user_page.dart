import 'package:flutter/material.dart';
import 'package:growana/models/user.dart';
import 'package:growana/screens/edit_profile_page.dart';
import 'package:growana/services/auth_service.dart';
import 'package:growana/repositories/user_repository.dart';
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
      // redirect ke LoginPage (Opsi 2)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }
    // update also compatibility service
    await UserService.refreshCurrentUser();
    setState(() {
      checking = false;
    });
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
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await UserRepository().deleteUser(currentUser!.id!);
      await auth.logout();
      await UserService.refreshCurrentUser();

      Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profil Saya")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Nama: ${currentUser!.name}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text("Email: ${currentUser!.email}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfilePage(user: currentUser!),
                    ),
                  );
                  if (updated == true) {
                    // reload data
                    currentUser = await auth.getLoggedInUser();
                    setState(() {});
                  }
                },
                child: const Text("Edit Profil"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: deleteAccount,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Hapus Akun"),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
