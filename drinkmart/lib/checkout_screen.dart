import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'confirmation_screen.dart'; // Import your confirmation screen
import 'history_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();
  String address = 'Royal Street, Cambodia';
  String selectedPayment = 'PayPal';
  bool sandboxMode = true;
  bool _isMounted = false;
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final double subTotal = cartProvider.totalPrice;
    final double deliveryFee = 0.50;
    final double total = subTotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CheckOut',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildAddressCard(),
            const SizedBox(height: 24),
            const Text(
              'Payment method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildPaymentMethodOption(
              'Pay on Delivery',
              'assets/Pay on Delivery.png',
            ),
            const SizedBox(height: 5),
            _buildPaymentMethodOption('Credit Card', 'assets/credit_card.png'),
            const SizedBox(height: 5),
            _buildPaymentMethodOption('PayPal', 'assets/paypal.png'),
            const SizedBox(height: 24),
            const Text(
              'Cart Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildCartItems(cartProvider),
            const SizedBox(height: 24),
            const Text(
              'Payment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPaymentDetailRow(
              'Delivery fee',
              '\$${deliveryFee.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            _buildPaymentDetailRow(
              'Sub Total',
              '\$${subTotal.toStringAsFixed(2)}',
            ),
            const Divider(height: 32, thickness: 1),
            _buildPaymentDetailRow(
              'Total',
              '\$${total.toStringAsFixed(2)}',
              isTotal: true,
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:
                            _isProcessingPayment
                                ? null
                                : () async {
                                  setState(() => _isProcessingPayment = true);
                                  if (selectedPayment == 'PayPal') {
                                    await _payWithPayPal(total, cartProvider);
                                  } else if (selectedPayment == 'Credit Card') {
                                    await _payWithCard(total, cartProvider);
                                  } else if (selectedPayment ==
                                      'Pay on Delivery') {
                                    await _payOnDelivery(total, cartProvider);
                                  }
                                  if (_isMounted) {
                                    setState(
                                      () => _isProcessingPayment = false,
                                    );
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            _isProcessingPayment
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'Payments',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                      if (sandboxMode &&
                          selectedPayment == 'PayPal' &&
                          !_isProcessingPayment)
                        Positioned(
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'SANDBOX',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (sandboxMode && selectedPayment == 'PayPal')
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Using PayPal Sandbox for testing',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _payOnDelivery(double total, CartProvider cartProvider) async {
    try {
      // Save order in history
      HistoryScreen.addHistoryItem(
        name: "Order (COD)",
        image: "assets/logo.png",
        totalItems: cartProvider.cartItems.length,
        totalPrice: total,
        cartItems: List.from(cartProvider.cartItems),
      );

      // Clear cart
      cartProvider.clearCart();

      // Navigate to confirmation screen
      if (_isMounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ConfirmationScreen(
                  orderDetails: {
                    'orderNumber':
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    'subtotal': total - 0.50,
                    'deliveryFee': 0.50,
                    'tax': 0.00,
                    'total': total,
                    'customerName':
                        'Your Name', // Replace with actual customer data
                    'deliveryAddress': address,
                    'deliveryTime': '30-45 mins',
                    'paymentMethod': 'Pay on Delivery',
                    'lastFourDigits': '',
                  },
                ),
          ),
        );
      }
    } catch (e) {
      if (_isMounted) {
        _showErrorDialog("Error: ${e.toString()}");
      }
    }
  }

  Future<void> _payWithPayPal(double total, CartProvider cartProvider) async {
    try {
      final navigator = Navigator.of(context);

      await navigator.push(
        MaterialPageRoute(
          builder:
              (context) => UsePaypal(
                sandboxMode: sandboxMode,
                clientId:
                    sandboxMode
                        ? "AV-0ZnsTrRPtWB7k0nKg59nmxkniIMDip58yPzfZTWR6KVrMq-2cfee2E08XF8GZLPQISnprbrOA-CdY"
                        : "YOUR_LIVE_CLIENT_ID",
                secretKey:
                    sandboxMode
                        ? "EAZZsT30Jopqq5lzD7FkIKuzN7DMeu94QTGXHK-HosGsNdAYj78maJKRcpxtdjrXpdSiJUEfsL4hXdah"
                        : "YOUR_LIVE_SECRET_KEY",
                returnURL: "https://success.url",
                cancelURL: "https://cancel.url",
                transactions: [
                  {
                    "amount": {
                      "total": total.toStringAsFixed(2),
                      "currency": "USD",
                      "details": {
                        "subtotal": total.toStringAsFixed(2),
                        "shipping": '0',
                        "shipping_discount": 0,
                      },
                    },
                    "description": "DrinkMart Order",
                    "item_list": {
                      "items": [
                        {
                          "name": "DrinkMart Cart",
                          "quantity": 1,
                          "price": total.toStringAsFixed(2),
                          "currency": "USD",
                        },
                      ],
                    },
                  },
                ],
                note: "Thanks for your purchase!",
                onSuccess: (params) async {
                  print("PayPal success: $params");
                  // Add to history before clearing cart
                  HistoryScreen.addHistoryItem(
                    name: "Order (PayPal)",
                    image: "assets/logo.png",
                    totalItems: cartProvider.cartItems.length,
                    totalPrice: total,
                    cartItems: List.from(cartProvider.cartItems),
                  );
                  // Clear cart on successful payment
                  cartProvider.clearCart();
                  // Navigate to confirmation screen
                  await navigator.pushReplacement(
                    MaterialPageRoute(
                      builder:
                          (context) => ConfirmationScreen(
                            orderDetails: {
                              'orderNumber':
                                  DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                              'subtotal': total - 0.50, // Subtract delivery fee
                              'deliveryFee': 0.50,
                              'tax': 0.00,
                              'total': total,
                              'customerName':
                                  'Your Name', // Replace with actual data
                              'deliveryAddress': address,
                              'deliveryTime': '30-45 mins',
                              'paymentMethod': 'PayPal',
                              'lastFourDigits': '4242',
                            },
                          ),
                    ),
                  );
                },
                onCancel: () {
                  print("PayPal cancelled");
                  navigator.pop();
                  if (_isMounted) {
                    _showErrorDialog("Payment Cancelled");
                  }
                },
                onError: (error) {
                  print("PayPal error: $error");
                  navigator.pop();
                  if (_isMounted) {
                    _showErrorDialog("An error occurred: ${error.toString()}");
                  }
                },
              ),
        ),
      );
    } catch (e) {
      if (_isMounted) {
        _showErrorDialog("Payment failed: ${e.toString()}");
      }
    }
  }

  Future<void> _payWithCard(double total, CartProvider cartProvider) async {
    try {
      // Simulate card payment processing
      await Future.delayed(const Duration(seconds: 2));
      // Add to history before clearing cart
      HistoryScreen.addHistoryItem(
        name: "Order (Credit Card)",
        image: "assets/logo.png",
        totalItems: cartProvider.cartItems.length,
        totalPrice: total,
        cartItems: List.from(cartProvider.cartItems),
      );
      // Clear cart on successful payment
      cartProvider.clearCart();

      // Navigate to confirmation screen
      if (_isMounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ConfirmationScreen(
                  orderDetails: {
                    'orderNumber':
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    'subtotal': total - 0.50, // Subtract delivery fee
                    'deliveryFee': 0.50,
                    'tax': 0.00,
                    'total': total,
                    'customerName': 'Your Name', // Replace with actual data
                    'deliveryAddress': address,
                    'deliveryTime': '30-45 mins',
                    'paymentMethod': 'Credit Card',
                    'lastFourDigits': '1234',
                  },
                ),
          ),
        );
      }
    } catch (e) {
      if (_isMounted) {
        _showErrorDialog("Payment failed: ${e.toString()}");
      }
    }
  }

  void _showErrorDialog(String message) {
    if (!_isMounted) return;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Widget _buildAddressCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.home, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Home',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(address, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _changeAddress,
                child: const Text(
                  'Change',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeAddress() async {
    try {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Change Address'),
            content: TextField(
              controller: _addressController,
              decoration: const InputDecoration(hintText: 'Enter new address'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (_isMounted) {
                    setState(() {
                      address =
                          _addressController.text.isNotEmpty
                              ? _addressController.text
                              : 'Royal Street, Cambodia';
                    });
                    _addressController.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (_isMounted) {
        _showErrorDialog("Failed to change address: ${e.toString()}");
      }
    }
  }

  Widget _buildPaymentMethodOption(String title, String imagePath) {
    final isSelected = selectedPayment == title;
    return GestureDetector(
      onTap: () {
        if (_isMounted) {
          setState(() {
            selectedPayment = title;
          });
        }
      },
      child: Card(
        color: isSelected ? Colors.orange.shade50 : null,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 40,
                height: 40,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentDetailRow(
    String title,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
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
          ),
        ),
      ],
    );
  }

  Widget _buildCartItems(CartProvider cartProvider) {
    return Column(
      children:
          cartProvider.cartItems
              .map(
                (item) => ListTile(
                  leading: Image.network(item['image'], width: 50, height: 50),
                  title: Text(item['name']),
                  subtitle: Text('Qty: ${item['quantity']}'),
                  trailing: Text('\$${item['price']}'),
                ),
              )
              .toList(),
    );
  }
}
