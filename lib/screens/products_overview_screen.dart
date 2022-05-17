import 'package:flutter/material.dart';

import '../widgets/product_grid.dart';

enum PopupMenuOptions {
  showAll,
  favorites,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: [
          PopupMenuButton(
            onSelected: (PopupMenuOptions value) {
              setState(() {
                if (value == PopupMenuOptions.favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (ctx) => const [
              PopupMenuItem(
                value: PopupMenuOptions.favorites,
                child: Text("Only Favorites"),
              ),
              PopupMenuItem(
                value: PopupMenuOptions.showAll,
                child: Text("Show All"),
              ),
            ],
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
