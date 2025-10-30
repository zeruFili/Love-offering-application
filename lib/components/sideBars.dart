import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/create_youtubevideo.dart';
import '../pages/YouTubeadminVideopage.dart';
import '../pages/YouTubeVideopage.dart';
import '../pages/transaction_history_page.dart';
import '../controllers/transaction_controller.dart';

class CustomSidebar extends StatefulWidget {
  final String userName;

  const CustomSidebar({super.key, required this.userName});

  @override
  _CustomSidebarState createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  bool _hasOwnedVideos = false;
  int _unviewedTransactionsCount = 0;
  String _userRole = '';
  late final TransactionController _transactionController;
  bool _isLoadingTransactions = false;

  @override
  void initState() {
    super.initState();
    _transactionController = Get.put(TransactionController());
    _checkUserData();
    _getUserRole();
    _loadUnviewedTransactionsCount();
  }

  Future<void> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('role') ?? '';
    });
  }

  Future<void> _checkUserData() async {
    // Check if user has videos (you might need to fetch this from your video controller)
    setState(() {
      _hasOwnedVideos = true; // Set based on actual data
    });
  }

  Future<void> _loadUnviewedTransactionsCount() async {
    if (_isLoadingTransactions || !mounted) return;

    if (mounted) {
      setState(() {
        _isLoadingTransactions = true;
      });
    }

    try {
      int totalUnviewed = 0;

      // Load supporter unviewed count
      final supporterSuccess =
          await _transactionController.fetchSupporterUnviewedData();
      if (supporterSuccess) {
        totalUnviewed += _transactionController.unviewedCount.value;
      }

      // Load artist unviewed count
      final artistSuccess =
          await _transactionController.fetchArtistUnviewedData();
      if (artistSuccess) {
        totalUnviewed += _transactionController.unviewedCount.value;
      }

      if (mounted) {
        setState(() {
          _unviewedTransactionsCount = totalUnviewed;
          _isLoadingTransactions = false;
        });
      }
    } catch (e) {
      print('Error loading unviewed transactions: $e');
      if (mounted) {
        setState(() {
          _isLoadingTransactions = false;
        });
      }
    }
  }

  Future<void> _navigateToTransactionHistory() async {
    Navigator.pop(context);

    // Navigate to TransactionHistoryPage and wait for result
    final result = await Get.to(() => const TransactionHistoryPage());

    // Refresh the unviewed count when returning
    if (mounted) {
      await _loadUnviewedTransactionsCount();
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('name');
    await prefs.remove('role');

    // Clear controller data on logout
    _transactionController.clearData();

    Get.offAllNamed('/login');
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
                  title: 'Create a Youtube Video',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const CreateYouTubeVideoPage());
                  },
                ),
                _buildMenuItem(
                  icon: Icons.history,
                  title: 'Transactions',
                  trailing: _isLoadingTransactions
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : _unviewedTransactionsCount > 0
                          ? Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                _unviewedTransactionsCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : null,
                  onTap: _navigateToTransactionHistory,
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
