import 'package:flutter/material.dart';

class TransferPage extends StatelessWidget {
  final String senderId;
  final String receiverId;
  final String accountNumber;
  final String bankCode;
  final String bankName;
  final String currency;

  TransferPage({
    required this.senderId,
    required this.receiverId,
    required this.accountNumber,
    required this.bankCode,
    required this.bankName,
    required this.currency,
  });

  final TextEditingController amountController =
      TextEditingController(); // Controller for amount input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sender ID: $senderId'),
            Text('Receiver ID: $receiverId'),
            Text('Account Number: $accountNumber'),
            Text('Bank Code: $bankCode'),
            Text('Bank Name: $bankName'),
            Text('Currency: $currency'),
            SizedBox(height: 20),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null) {
                  // Proceed with the transfer logic
                  print('Amount to transfer: $amount');
                  // Add your transfer logic here
                } else {
                  // Show an error message if the amount is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid amount.')),
                  );
                }
              },
              child: Text('Proceed with Transfer'),
            ),
          ],
        ),
      ),
    );
  }
}
