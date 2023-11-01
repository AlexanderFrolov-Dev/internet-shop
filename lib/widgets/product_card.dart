import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/widgets/product_detail_card.dart';

import '../models/cart_model.dart';
import '../product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool showCartIcon;

  const ProductCard(
      {required Key key, required this.product, this.showCartIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // При нажатии на карточку товара открываем экран с подробным описанием
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailsCard(key: UniqueKey(), product: product),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                product.image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${product.price} руб.',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (showCartIcon)
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    // При нажатии на иконку корзины добавляем товар в корзину
                    CartModel.getInstance().addToCart(product);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
