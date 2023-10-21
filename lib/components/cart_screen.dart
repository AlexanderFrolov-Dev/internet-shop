import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/components/cart_product_card.dart';

import '../cart.dart';
import '../cart_item.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart cart = Cart.getInstance();

  @override
  Widget build(BuildContext context) {
    double total = 0; // переменная для хранения общей суммы товаров в корзине
    for (CartItem cartItem in cart.cartItems) {
      // цикл для подсчета общей суммы
      total += cartItem.product.price * cartItem.quantity;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Корзина"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (context, index) {
                return CartProductCard(cart.cartItems[index]);
              },
            ),
          ),
          Text("Общая сумма: $total"),
          // отображение общей суммы товаров в корзине
          ElevatedButton(
            child: Text("Купить"),
            onPressed: () {
              cart.cartItems.clear(); // очистка корзины
              showDialog(
                // вывод сообщения об успешной покупке
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Успешно"),
                    actions: [
                      TextButton(
                        child: Text("Ок"),
                        onPressed: () {
                          Navigator.pop(context); // закрытие диалогового окна
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}