import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProdcutItem extends StatelessWidget {
  const UserProdcutItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  final String id;
  final String title;
  final String imageUrl;

  void _deleteProduct({
    required BuildContext ctx,
    required ScaffoldMessengerState scaffoldMessenger,
    required ThemeData themeData,
  }) async {
    try {
      final productsData = Provider.of<Products>(ctx, listen: false);
      await productsData.deleteProduct(id);
    } catch (e) {
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          backgroundColor: themeData.colorScheme.error,
          content: const Text(
            "Deleing falied",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id,
                );
              },
              icon: const Icon(Icons.edit),
              color: themeData.colorScheme.primary,
            ),
            IconButton(
              onPressed: () => _deleteProduct(
                ctx: context,
                scaffoldMessenger: scaffoldMessenger,
                themeData: themeData,
              ),
              icon: const Icon(Icons.delete),
              color: themeData.colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
