import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'product_screen.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;
    final deliveryFee = 0.50;
    final totalPay = cartProvider.totalPrice + deliveryFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EF),
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: Colors.orange),
            tooltip: 'Add Product',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                cartItems.isEmpty
                    ? const Center(
                      child: Text(
                        'Your cart is empty',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return _buildCartItem(item, cartProvider, context);
                      },
                    ),
          ),
          _buildOrderSummary(
            cartProvider.totalPrice,
            deliveryFee,
            totalPay,
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    Map<String, dynamic> item,
    CartProvider cartProvider,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 100,
            margin: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item['image'] ?? 'assets/placeholder.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item['price'].toString()}',
                  style: const TextStyle(fontSize: 16, color: Colors.orange),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                iconSize: 20,
                onPressed: () => cartProvider.removeFromCart(item),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.orange,
                      ),
                      onPressed: () {
                        if (item['quantity'] > 1) {
                          cartProvider.updateQuantity(
                            item,
                            item['quantity'] - 1,
                          );
                        } else {
                          cartProvider.removeFromCart(item);
                        }
                      },
                    ),
                    Text(
                      '${item['quantity']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.orange),
                      onPressed: () {
                        cartProvider.updateQuantity(item, item['quantity'] + 1);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(
    double itemTotal,
    double deliveryFee,
    double totalPay,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Have a promo code?',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Discount',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 29, 28, 28),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Order summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Item total',
            '\$${itemTotal.toStringAsFixed(2)}',
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Delivery fee',
            '\$${deliveryFee.toStringAsFixed(2)}',
            color: Colors.grey[600],
          ),
          const Divider(height: 32),
          _buildSummaryRow(
            'Total Pay',
            '\$${totalPay.toStringAsFixed(2)}',
            isBold: true,
            color: Colors.black,
            highlight: true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckoutScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'CheckOut',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
    bool highlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: highlight ? Colors.orange : color,
          ),
        ),
      ],
    );
  }
}
