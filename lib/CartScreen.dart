import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Cart.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  CartScreen({required this.cart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Screen'),
      ),
      body: ListView.builder(
        itemCount: widget.cart.getItems().length,
        itemBuilder: (context, index) {
          return ListTile(
            dense: true,
            leading: Image.asset(widget.cart.getItems()[index].imagePath),
            title: Text(widget.cart.getItems()[index].name),
            subtitle: Text(widget.cart.getItems()[index].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Deletion'),
                          content: Text('Are you sure you want to remove this item?'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Delete'),
                              onPressed: () {
                                setState(() {
                                  widget.cart.removeItem(widget.cart.getItems()[index]);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Text('${widget.cart.getItems()[index].price} ₽'),
              ],
            ),
          );
        },
      ),
    );
  }
}