import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/api_endpoints.dart';

class YouTubeUserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAuthenticated;
  final String userName;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const YouTubeUserAppBar({
    super.key,
    required this.isAuthenticated,
    required this.userName,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: isAuthenticated
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
        if (!isAuthenticated)
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            color: const Color(0xFFF8F9FA),
            child: Container(
              margin: const EdgeInsets.all(8),
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF0A5D4A),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Get.toNamed(ApiEndPoints.loginEmail);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0A5D4A),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF0A5D4A)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Get.toNamed(ApiEndPoints.registerEmail);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A5D4A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        if (isAuthenticated)
          Container(
            margin: const EdgeInsets.all(8),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF0A5D4A),
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
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
