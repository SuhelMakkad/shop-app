import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';

import '../screens/products_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color color = Colors.white,
  }) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
        size: 20,
      ),
      onPressed: onPressed,
    );
  }

  void _addItemToCart({
    required BuildContext ctx,
    required Cart cart,
    required Product product,
  }) {
    cart.addItem(
      productId: product.id,
      price: product.price,
      title: product.title,
    );
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: const Text("Item Added to Cart!"),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () => cart.removeSingleItem(product.id),
        ),
      ),
    );
  }

  Future<void> _toggleFavoriteStatus(BuildContext ctx, Product product) async {
    try {
      await product.toggleFavoriteStatus();
    } catch (e) {
      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(ctx).colorScheme.error,
          content: const Text(
            "Can not mark as a favorite",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildIconButton(
                icon:
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                onPressed: () => _toggleFavoriteStatus(context, product),
                color: Theme.of(context).colorScheme.secondary,
              ),
              _buildIconButton(
                icon: Icons.shopping_cart,
                onPressed: () => _addItemToCart(
                  ctx: context,
                  cart: cart,
                  product: product,
                ),
              ),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
