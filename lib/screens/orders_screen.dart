import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchItems(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (dataSnapshot.error == null) {
            return Consumer<Orders>(
              builder: (ctx, orderData, child) {
                return ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, index) {
                    final order = orderData.orders[index];
                    return OrderItem(order);
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text("An Error Occurred!"),
            );
          }
        },
      ),
    );
  }
}
