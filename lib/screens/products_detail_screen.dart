import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';

import '../providers/products.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static const routeName = "/product-detail";

  void _addItemToCart({
    required BuildContext ctx,
    required Cart cart,
    required Product product,
    bool showSnakBar = true,
  }) {
    cart.addItem(
      productId: product.id,
      price: product.price,
      title: product.title,
    );

    if (!showSnakBar) return;

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

  Widget _buildFABButton({
    required String lable,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          padding: const EdgeInsets.all(12),
        ),
        onPressed: onPressed,
        child: Text(
          lable,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final products = Provider.of<Products>(context, listen: false);
    final product = products.findById(productId);

    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFABButton(
              lable: "Buy Now",
              color: const Color.fromARGB(255, 255, 216, 20),
              onPressed: () {
                _addItemToCart(
                  ctx: context,
                  cart: cart,
                  product: product,
                  showSnakBar: false,
                );

                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
            const SizedBox(
              width: 12,
            ),
            _buildFABButton(
              lable: "Add to Cart",
              color: const Color.fromARGB(255, 255, 164, 28),
              onPressed: () {
                _addItemToCart(
                  ctx: context,
                  cart: cart,
                  product: product,
                );
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              centerTitle: true,
              background: Hero(
                tag: product.id,
                child: Stack(
                  children: [
                    Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      height: 400,
                    ),
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.0),
                                Colors.black.withOpacity(0.8),
                              ],
                              stops: const [
                                0.75,
                                1.0
                              ])),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(
                height: 10,
              ),
              Text(
                product.price.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: const TextStyle(),
                ),
              ),
              const SizedBox(
                height: 1000,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
