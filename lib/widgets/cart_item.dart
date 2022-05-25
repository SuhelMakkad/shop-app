import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Are you sure?"),
              content:
                  const Text("Do you want to remove the item from the card"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  style: TextButton.styleFrom(
                    primary: themeData.colorScheme.error,
                  ).copyWith(),
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        );
      },
      background: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        color: themeData.colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 26,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: themeData.colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text(
                    '\$$price',
                    style: TextStyle(
                      color: themeData.primaryTextTheme.titleMedium!.color,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${quantity * price}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
