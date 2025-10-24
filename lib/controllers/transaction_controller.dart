import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../apis/transaction_api.dart';
import '../Model/transaction_model.dart';

class TransactionController extends GetxController {
  // Reactive variables
  var transactions = <dynamic>[].obs;
  var currentTransaction = Rx<Transaction?>(null);
  var paymentUrl = RxString('');
  var totalTips = RxDouble(0.0);

  // Loading states
  var isLoading = false.obs;
  var isUpdating = false.obs;

  // Track user type for proper viewed status updates
  var currentUserType = RxString(''); // 'artist' or 'supporter'

  // Count unviewed transactions from raw API response
  int getUnviewedTransactionsCount() {
    int count = 0;
    for (var transaction in transactions) {
      if (transaction is Map<String, dynamic>) {
        final transactionInfo = transaction['transaction'] ?? {};
        // Check based on current user type
        if (currentUserType.value == 'artist') {
          if (transactionInfo['artistViewed'] == false) {
            count++;
          }
        } else if (currentUserType.value == 'supporter') {
          if (transactionInfo['supporterViewed'] == false) {
            count++;
          }
        }
      }
    }
    return count;
  }

  // Reactive getter for unviewed count
  RxInt get unviewedCount => getUnviewedTransactionsCount().obs;

  // Get all transaction IDs that are unviewed based on user type
  List<String> getUnviewedTransactionIds() {
    List<String> ids = [];
    for (var transaction in transactions) {
      if (transaction is Map<String, dynamic>) {
        final transactionInfo = transaction['transaction'] ?? {};
        bool isUnviewed = false;

        if (currentUserType.value == 'artist') {
          isUnviewed = transactionInfo['artistViewed'] == false;
        } else if (currentUserType.value == 'supporter') {
          isUnviewed = transactionInfo['supporterViewed'] == false;
        }

        if (isUnviewed) {
          String? transactionId = transaction['_id'] ??
              transaction['id'] ??
              transactionInfo['_id'] ??
              transactionInfo['id'];
          if (transactionId != null && transactionId.isNotEmpty) {
            ids.add(transactionId);
          }
        }
      }
    }
    return ids;
  }

  // Mark all current transactions as viewed based on user type
  Future<bool> markAllCurrentTransactionsAsViewed() async {
    isUpdating.value = true;

    try {
      List<String> unviewedIds = getUnviewedTransactionIds();

      if (unviewedIds.isEmpty) {
        // Update local data only if no IDs available
        for (var transaction in transactions) {
          if (transaction is Map<String, dynamic>) {
            final transactionInfo = transaction['transaction'] ?? {};
            if (currentUserType.value == 'artist') {
              transactionInfo['artistViewed'] = true;
            } else if (currentUserType.value == 'supporter') {
              transactionInfo['supporterViewed'] = true;
            }
          }
        }
        transactions.refresh();
        return true;
      }

      bool allSuccessful = true;
      for (String transactionId in unviewedIds) {
        bool success = false;
        if (currentUserType.value == 'artist') {
          success = await updateArtistViewedStatus(transactionId);
        } else if (currentUserType.value == 'supporter') {
          success = await updateSupporterViewedStatus(transactionId);
        }
        if (!success) {
          allSuccessful = false;
        }
      }

      if (allSuccessful) {
        // Update local data to reflect the changes
        for (var transaction in transactions) {
          if (transaction is Map<String, dynamic>) {
            final transactionInfo = transaction['transaction'] ?? {};
            if (currentUserType.value == 'artist') {
              transactionInfo['artistViewed'] = true;
            } else if (currentUserType.value == 'supporter') {
              transactionInfo['supporterViewed'] = true;
            }
          }
        }
        transactions.refresh();
      }

      return allSuccessful;
    } finally {
      isUpdating.value = false;
    }
  }

  // NEW: Mark all artist transactions as viewed using bulk API
  Future<bool> markAllArtistTransactionsAsViewed() async {
    isUpdating.value = true;
    try {
      final response =
          await TransactionApi().markAllArtistTransactionsAsViewed();
      if (response.statusCode == 200) {
        // Update local data to reflect the changes
        for (var transaction in transactions) {
          if (transaction is Map<String, dynamic>) {
            final transactionInfo = transaction['transaction'] ?? {};
            transactionInfo['artistViewed'] = true;
          }
        }
        transactions.refresh();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // NEW: Mark all supporter transactions as viewed using bulk API
  Future<bool> markAllSupporterTransactionsAsViewed() async {
    isUpdating.value = true;
    try {
      final response =
          await TransactionApi().markAllSupporterTransactionsAsViewed();
      if (response.statusCode == 200) {
        // Update local data to reflect the changes
        for (var transaction in transactions) {
          if (transaction is Map<String, dynamic>) {
            final transactionInfo = transaction['transaction'] ?? {};
            transactionInfo['supporterViewed'] = true;
          }
        }
        transactions.refresh();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // Fetch transactions by artist
  Future<bool> fetchTransactionsByArtist() async {
    currentUserType.value = 'artist';
    isLoading.value = true;
    try {
      return await _fetchTransactions(
        apiCall: () => TransactionApi().getTransactionsByArtist(),
        type: 'artist',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch transactions by supporter
  Future<bool> fetchTransactionsBySupporter() async {
    currentUserType.value = 'supporter';
    isLoading.value = true;
    try {
      return await _fetchTransactions(
        apiCall: () => TransactionApi().getTransactionsBySupporter(),
        type: 'supporter',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update artist viewed status
  Future<bool> updateArtistViewedStatus(String transactionId) async {
    if (transactionId.isEmpty) return false;

    final transactionApi = TransactionApi();
    try {
      final response =
          await transactionApi.updateArtistViewedStatus(transactionId);

      if (response.statusCode == 200) {
        // Update in the transactions list if present
        for (var transaction in transactions) {
          if (transaction is Map<String, dynamic>) {
            String? currentTransactionId = transaction['_id'] ??
                transaction['id'] ??
                transaction['transaction']?['_id'] ??
                transaction['transaction']?['id'];
            if (currentTransactionId == transactionId) {
              final transactionInfo = transaction['transaction'] ?? {};
              transactionInfo['artistViewed'] = true;
              break;
            }
          }
        }
        transactions.refresh();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Update supporter viewed status
  Future<bool> updateSupporterViewedStatus(String transactionId) async {
    if (transactionId.isEmpty) return false;

    final transactionApi = TransactionApi();
    try {
      final response =
          await transactionApi.updateSupporterViewedStatus(transactionId);

      if (response.statusCode == 200) {
        // Update in the transactions list if present
        for (var transaction in transactions) {
          if (transaction is Map<String, dynamic>) {
            String? currentTransactionId = transaction['_id'] ??
                transaction['id'] ??
                transaction['transaction']?['_id'] ??
                transaction['transaction']?['id'];
            if (currentTransactionId == transactionId) {
              final transactionInfo = transaction['transaction'] ?? {};
              transactionInfo['supporterViewed'] = true;
              break;
            }
          }
        }
        transactions.refresh();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Create transaction (tip)
  Future<bool> createTransaction({
    required String videoId,
    required double amount,
    String? description,
  }) async {
    isLoading.value = true;
    final transactionApi = TransactionApi();
    try {
      final response = await transactionApi.createTransaction(
        videoId: videoId,
        amount: amount,
        description: description,
      );
      if (response.statusCode == 200) {
        paymentUrl.value = response.data['paymentUrl'];
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch all transactions (admin only)
  Future<bool> fetchAllTransactions() async {
    isLoading.value = true;
    try {
      return await _fetchTransactions(
        apiCall: () => TransactionApi().getAllTransactions(),
        type: 'all',
        parseToModel: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch transaction by ID
  Future<bool> fetchTransactionById(String transactionId) async {
    isLoading.value = true;
    final transactionApi = TransactionApi();
    try {
      final response = await transactionApi.getTransactionById(transactionId);
      if (response.statusCode == 200) {
        currentTransaction.value = Transaction.fromJson(response.data);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch transactions for specific video
  Future<bool> fetchTransactionsForVideo(String videoId) async {
    isLoading.value = true;
    final transactionApi = TransactionApi();
    try {
      final response = await transactionApi.getTransactionsForVideo(videoId);
      if (response.statusCode == 200) {
        transactions.value = (response.data['transactions'] as List)
            .map((transactionJson) => Transaction.fromJson(transactionJson))
            .toList();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch total tips for artist
  Future<bool> fetchArtistTotalTips() async {
    isLoading.value = true;
    final transactionApi = TransactionApi();
    try {
      final response = await transactionApi.getArtistTotalTips();
      if (response.statusCode == 200) {
        totalTips.value = (response.data['totalTips'] as num).toDouble();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to handle common transaction fetching logic
  Future<bool> _fetchTransactions({
    required Future<dynamic> Function() apiCall,
    required String type,
    bool parseToModel = false,
  }) async {
    try {
      final response = await apiCall();
      if (response.statusCode == 200) {
        if (parseToModel) {
          transactions.value = (response.data as List)
              .map((transactionJson) => Transaction.fromJson(transactionJson))
              .toList();
        } else {
          transactions.value = (response.data as List).reversed.toList();
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Clear controller data
  void clearData() {
    transactions.clear();
    currentTransaction.value = null;
    paymentUrl.value = '';
    totalTips.value = 0.0;
    currentUserType.value = '';
  }
}
