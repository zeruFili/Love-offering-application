import 'package:dio/dio.dart';
import '../apis/base_api.dart';

class TransactionApi extends BaseUrl {
  // Create a new transaction (tip)
  Future<Response> createTransaction({
    required String videoId,
    required double amount,
    String? description,
  }) async {
    try {
      final response = await dio.post(
        'transaction',
        data: {
          'videoId': videoId,
          'amount': amount,
          'description': description,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  // Get all transactions (admin only)
  Future<Response> getAllTransactions() async {
    try {
      final response = await dio.get('transaction');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  // Get transactions by artist
  Future<Response> getTransactionsByArtist() async {
    try {
      final response = await dio.get('transaction/artist/my-transactions');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch artist transactions: $e');
    }
  }

  // Get transactions by supporter
  Future<Response> getTransactionsBySupporter() async {
    try {
      final response = await dio.get('transaction/supporter/my-transactions');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch supporter transactions: $e');
    }
  }

  // Get transaction by ID
  Future<Response> getTransactionById(String transactionId) async {
    try {
      final response = await dio.get('transaction/$transactionId');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch transaction: $e');
    }
  }

  // Get transactions for a specific video
  Future<Response> getTransactionsForVideo(String videoId) async {
    try {
      final response = await dio.get('transaction/video/$videoId');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch video transactions: $e');
    }
  }

  // Get total tips received by artist
  Future<Response> getArtistTotalTips() async {
    try {
      final response = await dio.get('transaction/artist/total-tips');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch total tips: $e');
    }
  }

  // Update artist viewed status
  Future<Response> updateArtistViewedStatus(String transactionId) async {
    try {
      final response = await dio.patch(
        'transaction/artist-viewed',
        data: {
          'transactionId': transactionId,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update artist viewed status: $e');
    }
  }

  // Update supporter viewed status
  Future<Response> updateSupporterViewedStatus(String transactionId) async {
    try {
      final response = await dio.patch(
        'transaction/supporter-viewed',
        data: {
          'transactionId': transactionId,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update supporter viewed status: $e');
    }
  }

  // Mark all artist transactions as viewed
  Future<Response> markAllArtistTransactionsAsViewed() async {
    try {
      final response = await dio.patch('transaction/artist/mark-all-viewed');
      return response;
    } catch (e) {
      throw Exception('Failed to mark all artist transactions as viewed: $e');
    }
  }

  // Mark all supporter transactions as viewed
  Future<Response> markAllSupporterTransactionsAsViewed() async {
    try {
      final response = await dio.patch('transaction/supporter/mark-all-viewed');
      return response;
    } catch (e) {
      throw Exception(
          'Failed to mark all supporter transactions as viewed: $e');
    }
  }

  // Get unviewed data for artist (count + transactions)
  Future<Response> getArtistUnviewedData() async {
    try {
      final response = await dio.get('transaction/artist/unviewed-data');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch artist unviewed data: $e');
    }
  }

// Get unviewed data for supporter (count + transactions)
  Future<Response> getSupporterUnviewedData() async {
    try {
      final response = await dio.get('transaction/supporter/unviewed-data');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch supporter unviewed data: $e');
    }
  }
}
