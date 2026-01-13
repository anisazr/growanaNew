// lib/widgets/growana_appbar.dart - UPDATE dengan Location
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/theme_provider.dart';
import 'location_header.dart'; // IMPORT BARU

class GrowanaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showUserInfo;
  final bool showThemeToggle;
  final bool showLocation; // TAMBAH INI
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const GrowanaAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.showUserInfo = false,
    this.showThemeToggle = true,
    this.showLocation = false, // TAMBAH INI
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authService = AuthService();

    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
              color: Colors.white,
            )
          : null,
      title: Row(
        children: [
          // Logo
          SvgPicture.asset(
            'assets/images/logo.svg',
            height: 32,
            color: Colors.white,
          ),
          if (title != null) ...[
            const SizedBox(width: 12),
            Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
          if (showUserInfo) ...[
            const SizedBox(width: 12),
            FutureBuilder(
              future: authService.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Colors.white);
                }
                if (snapshot.hasData && snapshot.data != null) {
                  final user = snapshot.data!;
                  return Text(
                    'Halo, ${user.name.split(' ').first}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
          if (showLocation) ...[
            const SizedBox(width: 12),
            const LocationHeader(
              showIcon: true,
              textStyle: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ],
      ),
      backgroundColor: const Color(0xFF1D7140),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
      actions: [
        // Theme Toggle
        if (showThemeToggle)
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        // Custom Actions
        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}