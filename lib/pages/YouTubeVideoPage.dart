import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/youtube_controller.dart';
import 'package:get/get.dart';
import '../utils/api_endpoints.dart';
import '../Model/youtube_model.dart';
import '../components/sideBars.dart';
import '../components/Deposit.dart';
import '../components/youtube_search_bar.dart';
import '../components/youtube_section_title.dart';
import '../components/youtube_loading_state.dart';
import '../components/youtube_empty_state.dart';
import '../components/youtube_user_app_bar.dart';
import '../components/youtube_user_videos_list.dart';
import '../components/youtube_login_dialog.dart';

class YouTubeVideoPage extends StatefulWidget {
  const YouTubeVideoPage({super.key});

  @override
  _YouTubeVideoPageState createState() => _YouTubeVideoPageState();
}

class _YouTubeVideoPageState extends State<YouTubeVideoPage> {
  final YouTubeVideoController videoController = YouTubeVideoController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;
  bool _isAuthenticated = false;
  String _userName = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    _loadVideos();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final name = prefs.getString('name');
    setState(() {
      _isAuthenticated = token != null && token.isNotEmpty;
      _userName = name ?? '';
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
    });
    await videoController.fetchVideos();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshVideos() async {
    await _checkAuthentication();
    await _loadVideos();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Videos refreshed successfully!'),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFF0A5D4A),
        ),
      );
    }
  }

  void _handleGiftButtonTap(YouTubeVideo video) async {
    await _checkAuthentication();
    if (!_isAuthenticated) {
      YouTubeLoginDialog.show(context);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DepositPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredVideos = videoController.videos.where((video) {
      final videoName = video.videoName.toLowerCase();
      final creatorName = video.name.toLowerCase();
      return videoName.contains(_searchQuery) ||
          creatorName.contains(_searchQuery);
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: YouTubeUserAppBar(
        isAuthenticated: _isAuthenticated,
        userName: _userName,
        scaffoldKey: _scaffoldKey,
      ),
      drawer: _isAuthenticated ? CustomSidebar(userName: _userName) : null,
      body: RefreshIndicator(
        onRefresh: _refreshVideos,
        color: const Color(0xFF0A5D4A),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              YouTubeSearchBar(controller: _searchController),
              const YouTubeSectionTitle(title: 'Trending Videos'),
              _isLoading
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: const YouTubeLoadingState(),
                    )
                  : videoController.videos.isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: YouTubeEmptyState(onRefresh: _refreshVideos),
                        )
                      : YouTubeUserVideosList(
                          videos: filteredVideos,
                          onGiftPressed: _handleGiftButtonTap,
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
