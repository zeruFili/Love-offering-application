import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/youtube_controller.dart';
import '../controllers/transaction_controller.dart';
import '../Model/youtube_model.dart';
import '../Model/transaction_model.dart';
import 'video_transactions_page.dart';

class ArtistVideosEarningsPage extends StatefulWidget {
  const ArtistVideosEarningsPage({super.key});

  @override
  _ArtistVideosEarningsPageState createState() =>
      _ArtistVideosEarningsPageState();
}

class _ArtistVideosEarningsPageState extends State<ArtistVideosEarningsPage> {
  final YouTubeVideoController _videoController =
      Get.put(YouTubeVideoController());
  final TransactionController _transactionController =
      Get.put(TransactionController());

  List<YouTubeVideo> _myVideos = [];
  final Map<String, double> _videoEarnings = {};
  final Map<String, bool> _videoHasUnviewed = {};
  bool _isLoading = true;
  bool _isLoadingEarnings = false;

  @override
  void initState() {
    super.initState();
    _loadArtistVideosWithEarnings();
  }

  Future<void> _loadArtistVideosWithEarnings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch artist's videos
      final success = await _videoController.fetchmyVideos();
      if (success) {
        setState(() {
          _myVideos = _videoController.myvideos;
        });

        // Fetch earnings for each video
        await _fetchEarningsForAllVideos();
      }
    } catch (e) {
      print('Error loading artist videos: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchEarningsForAllVideos() async {
    for (final video in _myVideos) {
      await _fetchEarningsForVideo(video.id);
      // Add a small delay to avoid overwhelming the API
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

// In ArtistVideosEarningsPage, improve the earnings fetch method:
  Future<void> _fetchEarningsForVideo(String videoId) async {
    final success =
        await _transactionController.fetchTransactionsForVideo(videoId);
    if (success) {
      setState(() {
        _videoEarnings[videoId] =
            _transactionController.totalSum.value.toDouble();

        // Enhanced check for unviewed transactions
        _videoHasUnviewed[videoId] =
            _transactionController.transactions.any((transaction) {
          if (transaction is Transaction) {
            return !transaction.artistViewed;
          } else if (transaction is Map<String, dynamic>) {
            // Handle map format if needed
            final transactionInfo = transaction['transaction'] ?? transaction;
            return transactionInfo['artistViewed'] == false;
          }
          return false;
        });
      });
    }
  }

  void _navigateToVideoTransactions(YouTubeVideo video) {
    Get.to(() => VideoTransactionsPage(video: video));
  }

  String _extractYoutubeId(String youtubeUrl) {
    final regExp = RegExp(
      r'^.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/|shorts\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(youtubeUrl);
    return match?.group(1) ?? '';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildVideoItem(YouTubeVideo video) {
    final youtubeId = _extractYoutubeId(video.youtubeURL);
    final thumbnailUrl = youtubeId.isNotEmpty
        ? 'https://img.youtube.com/vi/$youtubeId/mqdefault.jpg'
        : null;

    final earnings = _videoEarnings[video.id] ?? 0.0;
    final hasUnviewed = _videoHasUnviewed[video.id] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: hasUnviewed
            ? Border.all(color: Colors.red.withOpacity(0.3), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasUnviewed)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'NEW TIPS',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: thumbnailUrl != null
                        ? Image.network(
                            thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.videocam,
                                color: Color(0xFF0A5D4A),
                                size: 30,
                              );
                            },
                          )
                        : const Icon(
                            Icons.videocam,
                            color: Color(0xFF0A5D4A),
                            size: 30,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.videoName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        video.message ?? 'No description provided',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Text(
                      //   'Created: ${_formatDate(video.createdAt)}',
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.grey[500],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Earnings',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    Text(
                      'ETB ${earnings.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A5D4A),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _navigateToVideoTransactions(video),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A5D4A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'View Transactions',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Videos Found',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF2D3748),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You haven\'t created any videos yet',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadArtistVideosWithEarnings,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A5D4A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Refresh',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'My Videos & Earnings',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A5D4A)),
              ),
            )
          : _myVideos.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadArtistVideosWithEarnings,
                  color: const Color(0xFF0A5D4A),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      ..._myVideos.map(_buildVideoItem).toList(),
                    ],
                  ),
                ),
    );
  }
}
