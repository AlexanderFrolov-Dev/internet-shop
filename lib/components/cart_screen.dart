import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/components/product_card.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../cart.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart cart = Cart.getInstance();

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

  @override
  void initState() {
    super.initState();
    // Подписываемся на изменения в корзине и обновляем состояние виджета при каждом изменении
    cart.addListener(() {
      setState(() {});
    });
  }
}