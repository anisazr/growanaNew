import 'package:flutter/material.dart';
import 'package:growana/models/user.dart';
import 'package:growana/repositories/user_repository.dart';
import 'package:growana/services/auth_service.dart';
import 'package:growana/utils/validators.dart';
import 'package:growana/services/user_service.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final repo = UserRepository();
  final auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    passwordController = TextEditingController(text: widget.user.password);
  }

  Future<void> updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final updatedUser = User(
      id: widget.user.id,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    await repo.updateUser(updatedUser);

    // refresh currentUser so UI shows latest name/email
    await UserService.refreshCurrentUser();

    setState(() => _loading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Profil berhasil diperbarui")));
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1D7140);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : updateUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Simpan Perubahan"),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
