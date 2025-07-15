import 'package:flutter/material.dart';

class YouTubeAdminAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool isAdmin;
  final String userName;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const YouTubeAdminAppBar({
    super.key,
    required this.isAdmin,
    required this.userName,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: isAdmin
          ? IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF2D3748)),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            )
          : null,
      title: const Text(
        'YouTube Videos',
        style: TextStyle(
          color: Color(0xFF2D3748),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (isAdmin)
          Container(
            margin: const EdgeInsets.all(8),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF0A5D4A),
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
