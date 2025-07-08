import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _depositMoney() async {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deposit Money'),
        content: TextField(
          controller: amountController,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixIcon: Icon(Icons.attach_money),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (amountController.text.isEmpty) {
                return;
              }

              Navigator.pop(context);
              setState(() {
                _isLoading = true;
              });

              try {
                // Simulate API call
                await Future.delayed(const Duration(seconds: 2));

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Money deposited successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (error) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Failed to deposit money'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } finally {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
            child: const Text('Deposit'),
          ),
        ],
      ),
    );
  }

  Future<void> _withdrawMoney() async {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Money'),
        content: TextField(
          controller: amountController,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixIcon: Icon(Icons.attach_money),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (amountController.text.isEmpty) {
                return;
              }

              Navigator.pop(context);
              setState(() {
                _isLoading = true;
              });

              try {
                // Simulate API call
                await Future.delayed(const Duration(seconds: 2));

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Money withdrawn successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (error) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Failed to withdraw money'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } finally {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Cards'),
            Tab(text: 'Payment Methods'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCardsTab(),
                _buildPaymentMethodsTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new payment method
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCardsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCreditCard(
            cardNumber: '**** **** **** 1234',
            cardHolder: 'John Doe',
            expiryDate: '12/25',
            cardType: 'Visa',
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          _buildCreditCard(
            cardNumber: '**** **** **** 5678',
            cardHolder: 'John Doe',
            expiryDate: '10/24',
            cardType: 'Mastercard',
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Deposit'),
                onPressed: _depositMoney,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.remove),
                label: const Text('Withdraw'),
                onPressed: _withdrawMoney,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCard({
    required String cardNumber,
    required String cardHolder,
    required String expiryDate,
    required String cardType,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Credit Card',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                cardType,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/chip.png',
            height: 40,
            width: 60,
          ),
          Text(
            cardNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARD HOLDER',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    cardHolder,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXPIRES',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    expiryDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsTab() {
    final paymentMethods = [
      {
        'name': 'PayPal',
        'icon': Icons.paypal,
        'isConnected': true,
      },
      {
        'name': 'Google Pay',
        'icon': Icons.g_mobiledata,
        'isConnected': true,
      },
      {
        'name': 'Apple Pay',
        'icon': Icons.apple,
        'isConnected': false,
      },
      {
        'name': 'Bank Transfer',
        'icon': Icons.account_balance,
        'isConnected': true,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: paymentMethods.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final method = paymentMethods[index];
        return ListTile(
          leading: Icon(
            method['icon'] as IconData,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
          title: Text(method['name'] as String),
          subtitle: Text(
            method['isConnected'] as bool ? 'Connected' : 'Not connected',
            style: TextStyle(
              color: method['isConnected'] as bool ? Colors.green : Colors.red,
            ),
          ),
          trailing: Switch(
            value: method['isConnected'] as bool,
            onChanged: (value) {
              // Toggle connection status
            },
          ),
          onTap: () {
            // Open payment method details
          },
        );
      },
    );
  }
}
