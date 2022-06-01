import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final _firestoreBaseURL =
      "https://flutter-shop-app-8d10f-default-rtdb.firebaseio.com/";

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  void _setFavorite(bool falg) {
    isFavorite = falg;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken) async {
    final prevStatus = isFavorite;
    _setFavorite(!prevStatus);

    final url =
        Uri.parse("$_firestoreBaseURL/products/$id.json?auth=$authToken");
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          "isFavorite": isFavorite,
        }),
      );

      final statusCode = response.statusCode;
      if (statusCode >= 400) {
        _setFavorite(prevStatus);
        throw const HttpException("Could not delete this product");
      }
    } catch (e) {
      _setFavorite(prevStatus);
      throw const HttpException("Could not delete this product");
    }
  }

  Product copy({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  String toJSON() => json.encode(toMap());

  Map<String, Object> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'isFavorite': isFavorite,
      };
}
