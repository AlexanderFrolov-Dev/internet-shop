import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/cart_item.dart';

import '../cart.dart';

class CartProductCard extends StatefulWidget {
  Cart cart = Cart.getInstance();
  CartItem cartItem;

  CartProductCard(this.cartItem);

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 150.0,
            width: 150.0,
            child: Image.asset(
              widget.cartItem.product.image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.cartItem.product.name,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${widget.cartItem.product.price}',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Column(
            children: <Widget>[
              InkWell(
                // onTap: () => setState(() => widget.addToCart(widget.cartItem.product)),
                onTap: () => setState(() => widget.cart.addToCart(widget.cartItem.product)),

                child: Icon(Icons.arrow_drop_up),
              ),
              SizedBox(width: 5),
              Text('${widget.cartItem.quantity}'),
              SizedBox(width: 5),
              InkWell(
                onTap: () => setState(() => widget.cart.removeFromCart(widget.cartItem.product)),
                child: Icon(Icons.arrow_drop_down),
              ),
            ],
          ),
        ],
      ),
    );
  }
}