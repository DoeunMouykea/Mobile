import 'dart:convert';
import 'package:drinkmart/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> orderDetails;

  const ConfirmationScreen({super.key, required this.orderDetails});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  String customerName = '';
  String deliveryAddress = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/auth/user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        customerName = data['name'] ?? '';
        deliveryAddress = data['country'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderDetails = widget.orderDetails;
    final List<dynamic> products = orderDetails['products'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              'Payment Confirmation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Image.asset('assets/success.jpg', height: 200),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Order #${orderDetails['orderNumber'] ?? '0000'}'),
            const SizedBox(height: 24),

            if (products.isNotEmpty)
              _buildProductList(products)
            else
              const Text('No ordered items found.'),

            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'Order Summary',
              children: [
                _buildDetailRow(
                  'Subtotal',
                  '\$${orderDetails['subtotal']?.toStringAsFixed(2) ?? '0.00'}',
                ),
                _buildDetailRow(
                  'Delivery Fee',
                  '\$${orderDetails['deliveryFee']?.toStringAsFixed(2) ?? '0.00'}',
                ),
                _buildDetailRow(
                  'Tax',
                  '\$${orderDetails['tax']?.toStringAsFixed(2) ?? '0.00'}',
                ),
                const Divider(),
                _buildDetailRow(
                  'Total',
                  '\$${orderDetails['total']?.toStringAsFixed(2) ?? '0.00'}',
                  isTotal: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'Delivery Information',
              children: [
                _buildDetailRow('Name', customerName),
                _buildDetailRow('Address', deliveryAddress),
                _buildDetailRow(
                  'Estimated Delivery',
                  orderDetails['deliveryTime'] ?? '30-45 mins',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'Payment Method',
              children: [
                _buildDetailRow(
                  'Method',
                  orderDetails['paymentMethod'] ?? 'Credit Card',
                ),
                _buildDetailRow(
                  'Card Ending',
                  '•••• ${orderDetails['lastFourDigits'] ?? '1234'}',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Implement order tracking
                    },
                    child: const Text(
                      'Track Order',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.orange),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(color: Colors.orange, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(List<dynamic> products) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ordered Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...products.map((product) {
              final imageUrl = (product['image'] ?? '').toString().replaceFirst(
                '127.0.0.1',
                '10.0.2.2',
              );
              final quantity = product['quantity'] ?? 1;
              final price = product['price'] ?? 0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50);
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Qty: $quantity'),
                        ],
                      ),
                    ),
                    Text('\$${(price * quantity).toStringAsFixed(2)}'),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.orange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
