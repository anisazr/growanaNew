import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GrowanaAppBarAlt extends StatelessWidget implements PreferredSizeWidget {
  final bool showActions;
  final bool showBack;
  final VoidCallback? onBackTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onLeaderboardTap;

  const GrowanaAppBarAlt({
    Key? key,
    this.showActions = true,
    this.showBack = false,
    this.onBackTap,
    this.onNotificationTap,
    this.onLeaderboardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          showBack
              ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBackTap ?? () => Navigator.pop(context),
              )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/icon.svg',
                  color: Colors.white,
                ),
              ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(color: Color(0xFF1D7140)),
      ),
      actions:
          showActions
              ? [
                InkWell(
                  onTap: onNotificationTap ?? () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                ),
                InkWell(
                  onTap: onLeaderboardTap ?? () {},
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.leaderboard, color: Colors.white),
                  ),
                ),
              ]
              : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
