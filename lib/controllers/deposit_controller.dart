import 'package:flutter/material.dart';
import '../apis/payment_api.dart';

class DepositController {
  final TextEditingController amountController = TextEditingController();
  String? paymentUrl;

  Future<bool> depositAmount() async {
    String amount = amountController.text;

    final paymentApi = PaymentApi();

    var data = {
      'amount': amount,
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

  void dispose() {
    amountController.dispose();
  }
}
