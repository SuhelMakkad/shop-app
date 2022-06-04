import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

import '../models/http_exception.dart';

class Products with ChangeNotifier {
  Products(this._authToken, this._userId, this._items);

  final _firestoreBaseURL =
      "https://flutter-shop-app-8d10f-default-rtdb.firebaseio.com";

  final String? _authToken;
  final String? _userId;

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterQuery =
        filterByUser ? '&orderBy="ownerId"&equalTo="$_userId"' : '';
    final url = Uri.parse(
        '$_firestoreBaseURL/products.json?auth=$_authToken$filterQuery');
    final productsResponse = await http.get(url);

    if (productsResponse.body == 'null') return;

    final userFavoritesUrl = Uri.parse(
        "$_firestoreBaseURL/userFavorites/$_userId.json?auth=$_authToken");
    final userFavoritesResopnse = await http.get(userFavoritesUrl);
    final userFavoritesDate = json.decode(userFavoritesResopnse.body);

    final data = json.decode(productsResponse.body) as Map<String, dynamic>;
    final List<Product> loadedProducts = [];

    data.forEach((key, value) {
      final isFavorite =
          userFavoritesDate == null ? false : userFavoritesDate[key] ?? false;

      final product = Product(
        id: key,
        title: value["title"],
        description: value["description"],
        imageUrl: value["imageUrl"],
        price: value["price"],
        ownerId: value["ownerId"],
        isFavorite: isFavorite,
      );

      loadedProducts.add(product);
    });

    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse("$_firestoreBaseURL/products.json?auth=$_authToken");
    final response = await http.post(
      url,
      body: product.copy(ownerId: _userId).toJSON(),
    );

    final data = json.decode(response.body);
    final newProduct = product.copy(
      id: data["name"],
    );

    _items.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(Product newProduct) async {
    final productId = newProduct.id;
    final productIndex =
        _items.indexWhere((product) => product.id == productId);

    if (productIndex >= 0) {
      final url = Uri.parse(
          "$_firestoreBaseURL/products/$productId.json?auth=$_authToken");
      await http.patch(url, body: newProduct.toJSON());

      _items[productIndex] = newProduct;
    } else {
      addProduct(newProduct);
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        Uri.parse("$_firestoreBaseURL/products/$id.json?auth=$_authToken");
    final productIndex = _items.indexWhere((product) => product.id == id);

    if (productIndex < 0) return;

    final product = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();

    final response = await http.delete(url);
    final statusCode = response.statusCode;

    if (statusCode >= 400) {
      _items.insert(productIndex, product);
      notifyListeners();
      throw const HttpException("Could not delete this product");
    }
  }
}
