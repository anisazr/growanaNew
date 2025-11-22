import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:growana/screens/awards_page.dart';
import 'package:growana/widgets/location_select.dart';
import '../services/user_service.dart';
import '../theme/theme_provider.dart';

class GrowanaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showActions;
  final bool showBack;
  final bool showUser;
  final bool showLocation;

  final VoidCallback? onBackTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onLeaderboardTap;

  const GrowanaAppBar({
    Key? key,
    this.showActions = true,
    this.showBack = false,
    this.showUser = false,
    this.showLocation = false,
    this.onBackTap,
    this.onNotificationTap,
    this.onLeaderboardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = UserService.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBackTap ?? () => Navigator.pop(context),
            )
          : null,
      title: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/icon.svg',
            height: 28,
            color: Colors.white,
          ),

          // SHOW USER NAME
          if (showUser && user != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  user.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // LOCATION DROPDOWN
          if (showLocation)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: LocationSelect(
                  locations: ['Jakarta', 'Bandung', 'Surabaya'],
                  onChanged: (value) {
                    print('Lokasi dipilih: $value');
                  },
                ),
              ),
            ),
        ],
      ),

      // GRADIENT BACKGROUND
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF1D7140), Color(0xFF2A9D5F)],
          ),
        ),
      ),

      actions: [
        // THEME MODE SWITCH BUTTON
        InkWell(
          onTap: () {
            themeProvider.toggleTheme();
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.brightness_6, color: Colors.white, size: 26),
          ),
        ),

        if (showActions)
          InkWell(
            onTap: onNotificationTap ?? () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.notifications, color: Colors.white),
            ),
          ),

        if (showActions)
          InkWell(
            onTap: onLeaderboardTap ??
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AwardsPage()),
                  );
                },
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.leaderboard, color: Colors.white),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
