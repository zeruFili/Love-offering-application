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
  var totalSum = 0.obs;

  // Loading states
  var isLoading = false.obs;
  var isUpdating = false.obs;

  // Track user type for proper viewed status updates
  var currentUserType = RxString(''); // 'artist' or 'supporter'

  // Combined unviewed data
  var unviewedCount = 0.obs;
  var unviewedTransactions = <dynamic>[].obs;

  // ========== UNVIEWED TRANSACTIONS METHODS ==========

  // Fetch unviewed data for artist (count + transactions)
  Future<bool> fetchArtistUnviewedData() async {
    currentUserType.value = 'artist';
    isLoading.value = true;
    try {
      final response = await TransactionApi().getArtistUnviewedData();
      if (response.statusCode == 200) {
        unviewedCount.value = response.data['count'] ?? 0;
        unviewedTransactions.value = response.data['transactions'] ?? [];
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch unviewed data for supporter (count + transactions)
  Future<bool> fetchSupporterUnviewedData() async {
    currentUserType.value = 'supporter';
    isLoading.value = true;
    try {
      final response = await TransactionApi().getSupporterUnviewedData();
      if (response.statusCode == 200) {
        unviewedCount.value = response.data['count'] ?? 0;
        unviewedTransactions.value = response.data['transactions'] ?? [];
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ========== VIEWED STATUS METHODS ==========

  // Mark all artist transactions as viewed using bulk API
  Future<bool> markAllArtistTransactionsAsViewed() async {
    isUpdating.value = true;
    try {
      final response =
          await TransactionApi().markAllArtistTransactionsAsViewed();
      if (response.statusCode == 200) {
        // Clear unviewed data
        unviewedCount.value = 0;
        unviewedTransactions.clear();

        // Also update the main transactions list
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

  // Mark all supporter transactions as viewed using bulk API
  Future<bool> markAllSupporterTransactionsAsViewed() async {
    isUpdating.value = true;
    try {
      final response =
          await TransactionApi().markAllSupporterTransactionsAsViewed();
      if (response.statusCode == 200) {
        // Clear unviewed data
        unviewedCount.value = 0;
        unviewedTransactions.clear();

        // Also update the main transactions list
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

  // Update artist viewed status
  Future<bool> updateArtistViewedStatus(String transactionId) async {
    if (transactionId.isEmpty) return false;

    final transactionApi = TransactionApi();
    try {
      final response =
          await transactionApi.updateArtistViewedStatus(transactionId);
      if (response.statusCode == 200) {
        // Update counts and remove from unviewed list
        if (unviewedCount.value > 0) {
          unviewedCount.value--;
        }
        unviewedTransactions
            .removeWhere((transaction) => transaction['_id'] == transactionId);

        // Update main transactions list
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
        // Update counts and remove from unviewed list
        if (unviewedCount.value > 0) {
          unviewedCount.value--;
        }
        unviewedTransactions
            .removeWhere((transaction) => transaction['_id'] == transactionId);

        // Update main transactions list
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

  // ========== TRANSACTION FETCHING METHODS ==========

  // Fetch transactions by artist
  Future<bool> fetchTransactionsByArtist() async {
    currentUserType.value = 'artist';
    isLoading.value = true;
    try {
      final response = await TransactionApi().getTransactionsByArtist();
      if (response.statusCode == 200) {
        transactions.value = (response.data as List).reversed.toList();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch transactions by supporter
  Future<bool> fetchTransactionsBySupporter() async {
    currentUserType.value = 'supporter';
    isLoading.value = true;
    try {
      final response = await TransactionApi().getTransactionsBySupporter();
      if (response.statusCode == 200) {
        transactions.value = (response.data as List).reversed.toList();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
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
      final response = await TransactionApi().getAllTransactions();
      if (response.statusCode == 200) {
        transactions.value = (response.data as List)
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
      print('i have been called');
      final response = await transactionApi.getTransactionsForVideo(videoId);
      print('Response received statusCode: ${response.statusCode}');

      if (response.statusCode == 200) {
        print(
            'ENTERING 200 BLOCK - Transactions fetched for video i have been called surprise');
        transactions.value = (response.data['transactions'] as List)
            .map((transactionJson) => Transaction.fromJson(transactionJson))
            .toList();

        // FIX: Use transactions.value to see the actual list content
        print('Transactions fetched for video i have been called surpirse');
        print('Transactions fetched: ${transactions.value}');
        print('Number of transactions: ${transactions.value.length}');

        // Store the total sum as well
        totalSum.value = response.data['totalSum'] ?? 0;
        print('Total sum fetched: ${totalSum.value}'); // Also fixed this line
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

  // Clear controller data
  void clearData() {
    transactions.clear();
    currentTransaction.value = null;
    paymentUrl.value = '';
    totalTips.value = 0.0;
    totalSum.value = 0;
    currentUserType.value = '';
    unviewedCount.value = 0;
    unviewedTransactions.clear();
  }

  // Reset loading states
  void resetLoadingStates() {
    isLoading.value = false;
    isUpdating.value = false;
  }
}
