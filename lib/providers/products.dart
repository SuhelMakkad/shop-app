import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  static const firestoreBaseURL =
      "https://flutter-shop-app-8d10f-default-rtdb.firebaseio.com/";

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse("$firestoreBaseURL/products.json");
    final response = await http.get(url);

    final data = json.decode(response.body) as Map<String, dynamic>;
    final List<Product> loadedProducts = [];

    data.forEach((key, value) {
      final product = Product(
        id: key,
        title: value["title"],
        description: value["description"],
        imageUrl: value["imageUrl"],
        price: value["price"],
        isFavorite: value["isFavorite"],
      );

      loadedProducts.add(product);
    });

    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse("$firestoreBaseURL/products.json");
    final response = await http.post(
      url,
      body: product.toJSON(product),
    );

    final data = json.decode(response.body);
    final newProduct = product.copy(
      id: data["name"],
    );

    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(Product newProduct) {
    final productIndex =
        _items.indexWhere((product) => product.id == newProduct.id);

    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
    } else {
      addProduct(newProduct);
    }
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
