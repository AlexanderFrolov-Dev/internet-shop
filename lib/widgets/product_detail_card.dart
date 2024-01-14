import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/app_database.dart';

import '../models/cart_model.dart';
import '../product.dart';

class ProductDetailsCard extends StatelessWidget {
  final AppDatabase appDatabase;
  final Product product;

  const ProductDetailsCard({required Key key, required this.product, required this.appDatabase})
      : super(key: key);

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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  '${product.price} руб.',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: const Text('Добавить в корзину'),
              onPressed: () {
                // При нажатии на кнопку добавляем товар в корзину
                CartModel.getInstance(appDatabase).addToCart(product);
              },
            ),
          ),
        ],
      ),
    );
  }
}
