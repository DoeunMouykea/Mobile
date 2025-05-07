import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_screen.dart';
import 'favorite_screen.dart';
import 'account_profile_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  static final List<Map<String, dynamic>> _historyItems = [];

  static void addHistoryItem({
    required String name,
    required String image,
    required int totalItems,
    required double totalPrice,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    final newItem = {
      'name': name,
      'image': image,
      'status': 'Finished',
      'date': DateTime.now().toIso8601String(),
      'totalItems': totalItems,
      'totalPrice': totalPrice,
      'cartItems': cartItems,
    };

    _historyItems.insert(0, newItem);

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/orders/history'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newItem),
      );

      if (response.statusCode == 200) {
        print('History sent successfully');
      } else {
        print('Failed to send history: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error sending history: $e');
    }
  }

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final historyItems = HistoryScreen._historyItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body:
          historyItems.isEmpty
              ? const Center(child: Text('No purchase history yet.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: historyItems.length,
                itemBuilder: (context, index) {
                  final item = historyItems[index];
                  return _buildHistoryCard(item);
                },
              ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    final String name = item['name'];
    final String image = item['image'];
    final String status = item['status'];
    final DateTime date = DateTime.parse(item['date']);
    final int totalItems = item['totalItems'];
    final double totalPrice = item['totalPrice'];
    final List<Map<String, dynamic>> cartItems =
        List<Map<String, dynamic>>.from(item['cartItems'] ?? []);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: $totalItems item(s)',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              status == 'Finished'
                                  ? Colors.green[100]
                                  : Colors.orange[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                status == 'Finished'
                                    ? Colors.green[800]
                                    : Colors.orange[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            Column(
              children:
                  cartItems
                      .map(
                        (cartItem) => ListTile(
                          leading: Image.network(
                            cartItem['image'],
                            width: 80,
                            height: 80,
                            errorBuilder:
                                (_, __, ___) => const Icon(Icons.broken_image),
                          ),
                          title: Text(cartItem['name']),
                          subtitle: Text('Qty: ${cartItem['quantity']}'),
                          trailing: Text('\$${cartItem['price']}'),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(date),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const Spacer(),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Order Again',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {},
                    child: const Text('Evaluate'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      color: const Color(0xFFFF9933),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            iconSize: 30,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteScreen()),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              padding: const EdgeInsets.all(5),
              child: const Icon(Icons.favorite, color: Colors.white, size: 20),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.article),
            iconSize: 30,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            iconSize: 30,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AccountProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
