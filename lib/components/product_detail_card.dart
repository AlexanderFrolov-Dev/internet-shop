import 'package:flutter/material.dart';

import '../cart.dart';
import '../product.dart';

class ProductDetailsCard extends StatelessWidget {
  final Product product;

  const ProductDetailsCard({required Key key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            product.image,
            height: 300,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  '${product.price} руб.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('Добавить в корзину'),
              onPressed: () {
                // При нажатии на кнопку добавляем товар в корзину
                Cart.getInstance().addToCart(product);
              },
            ),
          ),
        ],
      ),
    );
  }
}