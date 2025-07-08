import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/rent_history_page.dart';
import '../pages/my_cars_page.dart';
import '../pages/create_youtubevideo.dart';
import '../pages/YouTubeadminVideopage.dart';
import '../pages/YouTubeVideopage.dart';

class CustomSidebar extends StatefulWidget {
  final String userName;

  const CustomSidebar({super.key, required this.userName});

  @override
  _CustomSidebarState createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  bool _hasOwnedCars = false;
  int _notificationCount = 0;
  String _userRole = '';

  @override
  void initState() {
    super.initState();
    _checkUserData();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('role') ?? '';
    });
  }

  Future<void> _checkUserData() async {
    // Check if user has owned cars and notifications
    // This would typically come from your API or local storage
    setState(() {
      _hasOwnedCars = true; // Set based on actual data
      _notificationCount = 3; // Set based on actual notification count
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('name');
    await prefs.remove('role');
    Get.offAllNamed('/login'); // Navigate to login page
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header Section
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A5D4A),
                  Color(0xFF0D7A5F),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Text(
                        widget.userName.isNotEmpty
                            ? widget.userName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A5D4A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Hey, ${widget.userName}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const YouTubeVideoPage());
                  },
                ),
                _buildMenuItem(
                  icon: Icons.add_circle,
                  title: 'Create a Youtubevideo',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const CreateYouTubeVideoPage());
                  },
                ),
                _buildMenuItem(
                  icon: Icons.history,
                  title: 'Payment History',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const RentHistoryPage());
                  },
                ),
                if (_hasOwnedCars)
                  _buildMenuItem(
                    icon: Icons.video_camera_front_outlined,
                    title: 'My video',
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const MyCarsPage());
                    },
                  ),
                _buildMenuItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  trailing: _notificationCount > 0
                      ? Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            _notificationCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const YouTubeVideoPage());
                  },
                ),
                // Admin videos menu item - only visible to admins
                if (_userRole == 'admin')
                  _buildMenuItem(
                    icon: Icons.video_library,
                    title: 'Admin Videos',
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const YouTubeadminVideoPage());
                    },
                  ),
                const Divider(height: 32),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  textColor: Colors.red,
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? const Color(0xFF2D3748),
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor ?? const Color(0xFF2D3748),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
