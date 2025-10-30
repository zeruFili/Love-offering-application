import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../controllers/transaction_controller.dart';
import 'artist_videos_earnings_page.dart';
import 'video_transactions_page.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TransactionController _transactionController =
      Get.find<TransactionController>();
  List<Map<String, dynamic>> _supporterTransactions = [];
  List<Map<String, dynamic>> _artistTransactions = [];
  bool _isLoadingSupporter = true;
  bool _isLoadingArtist = true;
  int _currentTabIndex = 0; // Track current tab

  // Track which transactions have been viewed
  final Set<String> _viewedSupporterTransactionIds = {};
  final Set<String> _viewedArtistTransactionIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTransactionData();
  }

  @override
  void dispose() {
    // Mark only the viewed transactions when leaving the page
    _markViewedTransactions();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _markViewedTransactions() async {
    // Mark supporter transactions that were actually viewed
    for (String transactionId in _viewedSupporterTransactionIds) {
      await _transactionController.updateSupporterViewedStatus(transactionId);
    }

    // Mark artist transactions that were actually viewed
    for (String transactionId in _viewedArtistTransactionIds) {
      await _transactionController.updateArtistViewedStatus(transactionId);
    }
  }

  // Extract transaction ID from transaction data
  String? _getTransactionId(Map<String, dynamic> transaction) {
    final transactionInfo = transaction['transaction'] ?? {};
    return transaction['_id'] ??
        transaction['id'] ??
        transactionInfo['_id'] ??
        transactionInfo['id'];
  }

  // Mark a specific transaction as viewed when it becomes visible
  void _markTransactionAsViewed(
      Map<String, dynamic> transaction, String tabType) {
    final transactionId = _getTransactionId(transaction);
    if (transactionId == null) return;

    final transactionInfo = transaction['transaction'] ?? {};
    bool isUnviewed = false;

    if (tabType == 'supporter') {
      isUnviewed = transactionInfo['supporterViewed'] == false;
      if (isUnviewed &&
          !_viewedSupporterTransactionIds.contains(transactionId)) {
        _viewedSupporterTransactionIds.add(transactionId);
      }
    } else {
      isUnviewed = transactionInfo['artistViewed'] == false;
      if (isUnviewed && !_viewedArtistTransactionIds.contains(transactionId)) {
        _viewedArtistTransactionIds.add(transactionId);
      }
    }
  }

  Future<void> _loadTransactionData() async {
    // Load supporter transactions (tips I sent)
    setState(() {
      _isLoadingSupporter = true;
    });
    final supporterSuccess =
        await _transactionController.fetchTransactionsBySupporter();
    if (supporterSuccess) {
      setState(() {
        _supporterTransactions =
            _transactionController.transactions.map((transaction) {
          if (transaction is Map<String, dynamic>) {
            return transaction;
          } else {
            return <String, dynamic>{};
          }
        }).toList();
        _isLoadingSupporter = false;
      });
    } else {
      setState(() {
        _isLoadingSupporter = false;
      });
    }

    // Load artist transactions (tips I received)
    setState(() {
      _isLoadingArtist = true;
    });
    final artistSuccess =
        await _transactionController.fetchTransactionsByArtist();
    if (artistSuccess) {
      setState(() {
        _artistTransactions =
            _transactionController.transactions.map((transaction) {
          if (transaction is Map<String, dynamic>) {
            return transaction;
          } else {
            return <String, dynamic>{};
          }
        }).toList();
        _isLoadingArtist = false;
      });
    } else {
      setState(() {
        _isLoadingArtist = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadTransactionData();
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatDateTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy - HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _extractYoutubeId(String youtubeUrl) {
    final regExp = RegExp(
      r'^.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/|shorts\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(youtubeUrl);
    return match?.group(1) ?? '';
  }

  // Check if transaction is new based on user type and tab
  bool _isTransactionNew(Map<String, dynamic> transaction, String tabType) {
    final transactionInfo = transaction['transaction'] ?? {};
    if (tabType == 'supporter') {
      return transactionInfo['supporterViewed'] == false;
    } else {
      return transactionInfo['artistViewed'] == false;
    }
  }

  Widget _buildSupporterTransactions() {
    if (_isLoadingSupporter) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A5D4A)),
        ),
      );
    }
    if (_supporterTransactions.isEmpty) {
      return _buildEmptyState(
          'No tipping history found', 'You haven\'t sent any tips yet');
    }
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: const Color(0xFF0A5D4A),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _supporterTransactions.length,
        itemBuilder: (context, index) {
          final transaction = _supporterTransactions[index];
          final video = transaction['video'] ?? {};
          final artist = transaction['artist'] ?? {};
          final transactionInfo = transaction['transaction'] ?? {};
          final isNew = _isTransactionNew(transaction, 'supporter');

          final youtubeId = _extractYoutubeId(video['youtubeURL'] ?? '');
          final thumbnailUrl = youtubeId.isNotEmpty
              ? 'https://img.youtube.com/vi/$youtubeId/mqdefault.jpg'
              : null;

          // Create a VisibilityDetector to track when this transaction becomes visible
          return VisibilityDetector(
            key: Key('supporter_${_getTransactionId(transaction) ?? index}'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.5) {
                // When more than 50% visible
                _markTransactionAsViewed(transaction, 'supporter');
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isNew
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
                    if (isNew)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'NEW',
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
                                video['videoName'] ?? 'Unknown Video',
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
                                'To: ${artist['name'] ?? 'Unknown Artist'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (transactionInfo['description'] != null)
                                Text(
                                  'Message: ${transactionInfo['description']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                              'Amount',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            Text(
                              'ETB ${(transactionInfo['amount'] ?? 0).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A5D4A),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            Text(
                              _formatDateTime(
                                  transactionInfo['createdAt'] ?? ''),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (transactionInfo['payment'] != null)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green[600],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Payment Completed',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// In the _buildArtistTransactions method, replace the current implementation with:
  Widget _buildArtistTransactions() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'View Your Video Earnings',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF2D3748),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'See all your videos and their earnings in one place',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const ArtistVideosEarningsPage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A5D4A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'View My Videos & Earnings',
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

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.attach_money,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _refreshData,
            icon: const Icon(
              Icons.refresh,
              color: Color(0xFF0A5D4A),
            ),
            label: const Text(
              'Refresh',
              style: TextStyle(
                color: Color(0xFF0A5D4A),
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
          'Transaction History',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0A5D4A),
          unselectedLabelColor: const Color(0xFF9CA3AF),
          indicatorColor: const Color(0xFF0A5D4A),
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          onTap: (index) {
            // Update current tab index when tab is clicked
            setState(() {
              _currentTabIndex = index;
            });
          },
          tabs: const [
            Tab(text: 'Tips I Sent'),
            Tab(text: 'Tips I Received'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSupporterTransactions(),
          _buildArtistTransactions(),
        ],
      ),
    );
  }
}
