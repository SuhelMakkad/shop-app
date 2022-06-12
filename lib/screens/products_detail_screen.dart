import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final products = Provider.of<Products>(context, listen: false);
    final product = products.findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(product.title),
      // ),
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
