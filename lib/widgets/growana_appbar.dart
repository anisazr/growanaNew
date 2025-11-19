import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/user_service.dart';

class GrowanaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showActions;
  final bool showBack;
  final bool showUser;

  final VoidCallback? onBackTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onLeaderboardTap;

  const GrowanaAppBar({
    Key? key,
    this.showActions = true,
    this.showBack = false,
    this.showUser = false,
    this.onBackTap,
    this.onNotificationTap,
    this.onLeaderboardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = UserService.currentUser;

    return AppBar(
      leading:
          showBack
              ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBackTap ?? () => Navigator.pop(context),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/icon.svg',
                      height: 28,
                      color: Colors.white,
                    ),

                    if (showUser && user != null)
                      Flexible(
                        // <-- ini yang bikin anti overflow
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            user.name ?? '',
                            overflow:
                                TextOverflow
                                    .ellipsis, // kalau kepanjangan, kasih ...
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

      flexibleSpace: Container(
        decoration: const BoxDecoration(color: Color(0xFF1D7140)),
      ),

      actions: [
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
            onTap: onLeaderboardTap ?? () {},
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
