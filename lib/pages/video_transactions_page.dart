import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../controllers/transaction_controller.dart';
import '../Model/youtube_model.dart';
import '../Model/transaction_model.dart';

class VideoTransactionsPage extends StatefulWidget {
  final YouTubeVideo video;

  const VideoTransactionsPage({super.key, required this.video});

  @override
  _VideoTransactionsPageState createState() => _VideoTransactionsPageState();
}

class _VideoTransactionsPageState extends State<VideoTransactionsPage> {
  final TransactionController _transactionController =
      Get.find<TransactionController>();
  bool _isLoading = true;

  // Track locally viewed transactions in this session
  final Set<String> _locallyViewedIds = <String>{};

  @override
  void initState() {
    super.initState();
    _loadVideoTransactions();
  }

  @override
  void dispose() {
    // REMOVED: Don't automatically mark all as viewed when leaving page
    super.dispose();
  }

  // REMOVED: _markViewedTransactions() method - we don't need it anymore

  Future<void> _loadVideoTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _transactionController.fetchTransactionsForVideo(widget.video.id);
    } catch (e) {
      print('Error loading video transactions: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Check if transaction is new (not viewed by artist)
  bool _isTransactionNew(dynamic transaction) {
    if (transaction is Transaction) {
      return !transaction.artistViewed &&
          !_locallyViewedIds.contains(transaction.id);
    } else if (transaction is Map<String, dynamic>) {
      final transactionId = transaction['_id'] ?? '';
      final artistViewed = transaction['artistViewed'] ?? false;
      return !artistViewed && !_locallyViewedIds.contains(transactionId);
    }
    return false;
  }

  // Get transaction ID from any format
  String _getTransactionId(dynamic transaction) {
    if (transaction is Transaction) {
      return transaction.id;
    } else if (transaction is Map<String, dynamic>) {
      return transaction['_id'] ?? '';
    }
    return '';
  }

  // Mark transaction as viewed when it becomes visible
  void _markTransactionAsViewed(dynamic transaction) {
    final transactionId = _getTransactionId(transaction);
    if (transactionId.isEmpty) return;

    // Check if it's actually unviewed before marking
    bool isCurrentlyUnviewed = false;
    if (transaction is Transaction) {
      isCurrentlyUnviewed = !transaction.artistViewed;
    } else if (transaction is Map<String, dynamic>) {
      isCurrentlyUnviewed = !(transaction['artistViewed'] ?? false);
    }

    if (isCurrentlyUnviewed && !_locallyViewedIds.contains(transactionId)) {
      _locallyViewedIds.add(transactionId);

      // Update the server that this transaction has been viewed
      _transactionController.updateArtistViewedStatus(transactionId);

      setState(() {}); // Update UI immediately
    }
  }

  // Mark all transactions as viewed
  void _markAllTransactionsAsViewed() {
    for (var transaction in _transactionController.transactions) {
      final transactionId = _getTransactionId(transaction);
      if (transactionId.isNotEmpty && _isTransactionNew(transaction)) {
        _locallyViewedIds.add(transactionId);
        // Update the server for each transaction
        _transactionController.updateArtistViewedStatus(transactionId);
      }
    }
    setState(() {});
  }

  // Check if any transactions are still unviewed
  bool _hasUnviewedTransactions() {
    return _transactionController.transactions.any(_isTransactionNew);
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy - HH:mm').format(date);
  }

  Widget _buildTransactionItem(dynamic transaction, int index) {
    final isNew = _isTransactionNew(transaction);
    final transactionId = _getTransactionId(transaction);

    return VisibilityDetector(
      key: Key('video_transaction_${transactionId}_$index'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          // When more than 50% visible, mark as viewed
          _markTransactionAsViewed(transaction);
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.new_releases,
                        color: Colors.red,
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'NEW TIP',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF0A5D4A),
                    child: Text(
                      _getSupporterInitials(transaction),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getSupporterName(transaction),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        Text(
                          _getSupporterEmail(transaction),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_getDescription(transaction) != null &&
                  _getDescription(transaction)!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.message,
                        color: Colors.grey[500],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getDescription(transaction)!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                        'ETB ${_getAmount(transaction).toStringAsFixed(0)}',
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
                        _formatDateTime(_getCreatedAt(transaction)),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
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
                      'Payment Verified',
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
  }

  // Helper methods to extract data from both Transaction objects and Maps
  String _getSupporterInitials(dynamic transaction) {
    if (transaction is Transaction) {
      return transaction.supporter != null &&
              transaction.supporter!.firstName.isNotEmpty
          ? '${transaction.supporter!.firstName[0]}${transaction.supporter!.lastName.isNotEmpty ? transaction.supporter!.lastName[0] : ''}'
              .toUpperCase()
          : 'U';
    } else if (transaction is Map<String, dynamic>) {
      final supporter = transaction['supporter'] ?? {};
      final firstName = supporter['first_name'] ?? '';
      final lastName = supporter['last_name'] ?? '';
      return firstName.isNotEmpty
          ? '${firstName[0]}${lastName.isNotEmpty ? lastName[0] : ''}'
              .toUpperCase()
          : 'U';
    }
    return 'U';
  }

  String _getSupporterName(dynamic transaction) {
    if (transaction is Transaction) {
      return transaction.supporter != null
          ? '${transaction.supporter!.firstName} ${transaction.supporter!.lastName}'
              .trim()
          : 'Unknown Supporter';
    } else if (transaction is Map<String, dynamic>) {
      final supporter = transaction['supporter'] ?? {};
      final firstName = supporter['first_name'] ?? '';
      final lastName = supporter['last_name'] ?? '';
      return '$firstName $lastName'.trim().isEmpty
          ? 'Unknown Supporter'
          : '$firstName $lastName'.trim();
    }
    return 'Unknown Supporter';
  }

  String _getSupporterEmail(dynamic transaction) {
    if (transaction is Transaction) {
      return transaction.supporter?.email ?? 'No email';
    } else if (transaction is Map<String, dynamic>) {
      final supporter = transaction['supporter'] ?? {};
      return supporter['email'] ?? 'No email';
    }
    return 'No email';
  }

  String? _getDescription(dynamic transaction) {
    if (transaction is Transaction) {
      return transaction.description;
    } else if (transaction is Map<String, dynamic>) {
      return transaction['description'];
    }
    return null;
  }

  double _getAmount(dynamic transaction) {
    if (transaction is Transaction) {
      return transaction.amount;
    } else if (transaction is Map<String, dynamic>) {
      return (transaction['amount'] as num).toDouble();
    }
    return 0.0;
  }

  DateTime _getCreatedAt(dynamic transaction) {
    if (transaction is Transaction) {
      return transaction.createdAt;
    } else if (transaction is Map<String, dynamic>) {
      return DateTime.parse(transaction['createdAt']);
    }
    return DateTime.now();
  }

  Widget _buildEmptyState() {
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
          const Text(
            'No Transactions Yet',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF2D3748),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This video hasn\'t received any tips yet',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadVideoTransactions,
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

  Widget _buildHeaderInfo() {
    final totalEarnings = _transactionController.totalSum.value;
    final transactionCount = _transactionController.transactions.length;
    final newTipsCount =
        _transactionController.transactions.where(_isTransactionNew).length;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Total Earnings',
                'ETB ${totalEarnings.toStringAsFixed(0)}',
                Icons.attach_money,
                const Color(0xFF0A5D4A),
              ),
              _buildStatItem(
                'Total Tips',
                transactionCount.toString(),
                Icons.list_alt,
                const Color(0xFF6B7280),
              ),
              if (newTipsCount > 0)
                _buildStatItem(
                  'New Tips',
                  newTipsCount.toString(),
                  Icons.new_releases,
                  Colors.red,
                ),
            ],
          ),
          if (_hasUnviewedTransactions()) const SizedBox(height: 12),
          if (_hasUnviewedTransactions())
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.blue[600],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Scroll to mark tips as viewed',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalEarnings = _transactionController.totalSum.value;
    final hasTransactions = _transactionController.transactions.isNotEmpty;

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.video.videoName,
              style: const TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Total: ETB ${totalEarnings.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Color(0xFF0A5D4A),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          if (_hasUnviewedTransactions())
            IconButton(
              icon: const Icon(Icons.checklist, color: Color(0xFF0A5D4A)),
              onPressed: _markAllTransactionsAsViewed,
              tooltip: 'Mark all tips as viewed',
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF0A5D4A)),
            onPressed: _loadVideoTransactions,
            tooltip: 'Refresh transactions',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A5D4A)),
              ),
            )
          : !hasTransactions
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadVideoTransactions,
                  color: const Color(0xFF0A5D4A),
                  child: Column(
                    children: [
                      _buildHeaderInfo(),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          children: [
                            ..._transactionController.transactions
                                .asMap()
                                .entries
                                .map((entry) => _buildTransactionItem(
                                      entry.value,
                                      entry.key,
                                    ))
                                .toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
