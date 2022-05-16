import 'package:flutter/material.dart';

import '../screens/products_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  final String id;
  final String title;
  final String imageUrl;

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

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildIconButton(
                icon: Icons.favorite,
                onPressed: () {},
                color: Theme.of(context).colorScheme.secondary,
              ),
              _buildIconButton(
                icon: Icons.shopping_cart,
                onPressed: () {},
              ),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: id,
            );
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
