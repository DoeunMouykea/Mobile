import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  bool isFavorite(String name) {
    return _favorites.any((item) => item['name'] == name);
  }

  void toggleFavorite(Map<String, dynamic> product) {
    final existingIndex = _favorites.indexWhere(
      (item) => item['name'] == product['name'],
    );
    if (existingIndex >= 0) {
      _favorites.removeAt(existingIndex);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }
}
