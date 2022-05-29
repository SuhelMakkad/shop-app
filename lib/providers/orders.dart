import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  const OrderItem({
    required this.id,
    required this.products,
    required this.amount,
    required this.dateTime,
  });

  OrderItem copy({
    String? id,
    List<CartItem>? products,
    double? amount,
    DateTime? dateTime,
  }) {
    return OrderItem(
      id: id ?? this.id,
      products: products ?? this.products,
      amount: amount ?? this.amount,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  String toJSON() {
    final productsList = products.map((product) => product.toMap()).toList();

    return json.encode({
      'id': id,
      'products': productsList,
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
    });
  }
}

class Orders with ChangeNotifier {
  static const firestoreBaseURL =
      "https://flutter-shop-app-8d10f-default-rtdb.firebaseio.com/";

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchItems() async {
    final url = Uri.parse("$firestoreBaseURL/orders.json");
    final response = await http.get(url);

    if (response.body == 'null') return;

    final data = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItem> loadedOrders = [];

    data.forEach((key, value) {
      final List<dynamic> products = value["products"];
      final cartItems = products
          .map((product) => CartItem(
                id: product["id"] as String,
                title: product["title"] as String,
                quantity: product["quantity"] as int,
                price: product["price"] as double,
              ))
          .toList();

      final order = OrderItem(
        id: key,
        amount: value["amount"],
        dateTime: DateTime.parse(value["dateTime"]),
        products: cartItems,
      );

      loadedOrders.add(order);
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final orderItem = OrderItem(
      id: DateTime.now().toString(),
      products: cartProducts,
      amount: total,
      dateTime: DateTime.now(),
    );

    final url = Uri.parse("$firestoreBaseURL/orders.json");
    final response = await http.post(
      url,
      body: orderItem.toJSON(),
    );

    final data = json.decode(response.body);
    final newOrderItem = orderItem.copy(
      id: data["name"],
    );

    _orders.insert(0, newOrderItem);
    notifyListeners();
  }
}
