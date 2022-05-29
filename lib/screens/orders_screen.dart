import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = "/orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  var _isInit = false;

  @override
  void didChangeDependencies() async {
    if (!_isInit) {
      _updateIsLoding(true);
      final ordersProvider = Provider.of<Orders>(context, listen: false);
      await ordersProvider.fetchItems();
      _updateIsLoding(false);
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  void _updateIsLoding(bool flag) {
    setState(() {
      _isLoading = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: ordersProvider.orders.length,
              itemBuilder: (ctx, index) {
                final order = ordersProvider.orders[index];
                return OrderItem(order);
              },
            ),
    );
  }
}
