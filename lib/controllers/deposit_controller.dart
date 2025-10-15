import 'package:flutter/material.dart';
import '../apis/payment_api.dart';

class DepositController {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? videoId;
  String? paymentUrl;

  Future<bool> depositAmount() async {
    String amount = amountController.text;
    String description = descriptionController.text;

    // Validate that videoId is provided
    if (videoId == null || videoId!.isEmpty) {
      print('Video ID is required');
      return false;
    }

    final paymentApi = PaymentApi();

    var data = {
      'videoId': videoId,
      'amount': amount,
      'description': description,
    };

    try {
      final response = await paymentApi.Deposit(data);

      if (response.statusCode == 200) {
        paymentUrl = response.data['paymentUrl'];
        return true;
      } else {
        print('Failed to deposit: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  // Method to set videoId
  void setVideoId(String id) {
    videoId = id;
  }

  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
  }
}
