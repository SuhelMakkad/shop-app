import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import './edit_product_screen.dart';

import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static const routeName = "/user-product";

  Future<void> _refreshProducts(BuildContext ctx) {
    final providersData = Provider.of<Products>(ctx, listen: false);
    return providersData.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final providersData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () => _refreshProducts(context),
        child: ListView.builder(
          itemCount: providersData.items.length,
          itemBuilder: (_, index) {
            final item = providersData.items[index];

            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  UserProdcutItem(
                    id: item.id,
                    title: item.title,
                    imageUrl: item.imageUrl,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
