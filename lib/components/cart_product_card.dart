import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/product.dart';

class CartProductCard extends StatefulWidget {
  final Product product;

  const CartProductCard({required this.product, super.key});

  @override
  State<StatefulWidget> createState() => _CartProductCard();
}

class _CartProductCard extends State<CartProductCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(
              widget.product.image,
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
                    widget.product.name,
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${widget.product.price} руб.',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(child: Column(
                children: [
                  IconButton(
                      onPressed: () {

                      },
                      icon: const Icon(Icons.arrow_drop_up))
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
