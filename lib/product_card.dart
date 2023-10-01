import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/product_detail_screen.dart';

import 'cart.dart';
import 'product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool showCartIcon;

  const ProductCard({required Key key, required this.product, this.showCartIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // При нажатии на карточку товара открываем экран с подробным описанием
        Navigator.push(
          context,
          MaterialPageRoute(
            // builder: (context) => ProductDetailsScreen(product: product),
            builder: (context) => ProductDetailsScreen(key: UniqueKey(), product: product),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(
                product.imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${product.price} руб.',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (showCartIcon)
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    // При нажатии на иконку корзины добавляем товар в корзину
                    Cart.getInstance().addToCart(product);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
