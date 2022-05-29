import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = "/cart-screen";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                final item = cart.items.values.toList()[index];
                final key = cart.items.keys.toList()[index];

                return CartItem(
                  id: item.id,
                  productId: key,
                  title: item.title,
                  price: item.price,
                  quantity: item.quantity,
                );
              },
              itemCount: cart.items.length,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totlaAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium!
                            .color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  void _updateLoadingState(bool flag) {
    setState(() {
      _isLoading = flag;
    });
  }

  Future<void> _handleOrderButtonTap(BuildContext ctx) async {
    _updateLoadingState(true);

    final ordersProvider = Provider.of<Orders>(ctx, listen: false);
    await ordersProvider.addOrder(
      widget.cart.items.values.toList(),
      widget.cart.totlaAmount,
    );

    _updateLoadingState(false);

    widget.cart.clear();
    if (!mounted) return;
    Navigator.of(ctx).pushNamed(OrdersScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isButtonDisalbed = (widget.cart.totlaAmount <= 0 || _isLoading);
    return TextButton(
      onPressed: isButtonDisalbed ? null : () => _handleOrderButtonTap(context),
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text("ORDER NOW"),
    );
  }
}
