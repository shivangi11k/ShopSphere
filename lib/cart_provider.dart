import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + (item['quantity'] as int));

  void addToCart(Map<String, dynamic> product) {
    final index = _items.indexWhere((item) => item['name'] == product['name']);
    if (index != -1) {
      _items[index]['quantity'] = (_items[index]['quantity'] as int) + 1;
    } else {
      _items.add({
        ...product,
        'quantity': 1,
        'addedAt': DateTime.now().millisecondsSinceEpoch,
      });
    }
    _sortByRecent();
    notifyListeners();
  }

  void increment(String name) {
    final index = _items.indexWhere((item) => item['name'] == name);
    _items[index]['quantity'] = (_items[index]['quantity'] as int) + 1;
    notifyListeners();
  }

  void decrement(String name) {
    final index = _items.indexWhere((item) => item['name'] == name);
    if ((_items[index]['quantity'] as int) > 1) {
      _items[index]['quantity'] = (_items[index]['quantity'] as int) - 1;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void remove(String name) {
    _items.removeWhere((item) => item['name'] == name);
    notifyListeners();
  }

  double get totalPrice {
  return _items.fold(0.0, (sum, item) {
    final price = item['price'];
    final quantity = item['quantity'] as int;
    final priceAsDouble = price is int ? price.toDouble() : price as double;
    return sum + priceAsDouble * quantity;
  });
}


  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void _sortByRecent() {
    _items.sort((a, b) {
      final aAdded = a['addedAt'] as int? ?? 0;
      final bAdded = b['addedAt'] as int? ?? 0;
      return bAdded.compareTo(aAdded);
    });
  }
}