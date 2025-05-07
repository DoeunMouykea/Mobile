import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  int get itemCount {
    return _cartItems.fold(0, (sum, item) {
      final quantity = item['quantity'] as int? ?? 0;
      return sum + quantity;
    });
  }

  void addToCart(Map<String, dynamic> product) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item['name'] == product['name'],
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex]['quantity'] += product['quantity'];
    } else {
      _cartItems.add(product);
    }
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void updateQuantity(Map<String, dynamic> product, int newQuantity) {
    final index = _cartItems.indexWhere(
      (item) => item['name'] == product['name'],
    );
    if (index >= 0) {
      _cartItems[index]['quantity'] = newQuantity;
      notifyListeners();
    }
  }

  double get totalPrice {
    return _cartItems.fold(0, (sum, item) {
      String priceString = item['price'].replaceAll('\$', '');
      double price = double.tryParse(priceString) ?? 0;
      return sum + (price * (item['quantity'] ?? 1));
    });
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

class CartItem {
  final String name;
  final double price;
  final int quantity;
  final String image;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });
}
