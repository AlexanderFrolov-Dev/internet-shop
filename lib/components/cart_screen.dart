import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/components/product_card.dart';

import '../cart.dart';

class CartScreen extends StatelessWidget {
  final Cart cart = Cart.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Корзина'),
      ),
      body: ListView.builder(
        itemCount: cart.products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            key: ValueKey(cart),
            product: cart.products[index],
            showCartIcon: false,
          );
        },
      ),
    );
  }
}