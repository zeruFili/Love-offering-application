import 'package:dio/dio.dart';
import '../apis/base_api.dart';

class PaymentApi extends BaseUrl {
  Future<Response> Deposit(Map<String, dynamic> data) async {
    try {
      // Making a POST request to the login endpoint
      final response = await dio.post('payment', data: data);
      return response; // Return the response for further handling
    } catch (e) {
      // Handle errors (e.g., network issues, server errors)
      throw Exception('Failed to Deposit: $e');
    }
  }

  Future<Response> getAllTransactions() async {
    try {
      final response = await dio.get('payment');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<Response> getWalletBalance() async {
    try {
      final response = await dio
          .get('payment/wallet_balance'); // Adjust the endpoint as necessary
      return response;
    } catch (e) {
      throw Exception('Failed to fetch wallet balance: $e');
    }
  }
}
