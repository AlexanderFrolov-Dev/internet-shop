import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/product.dart';

import '../cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart cart = Cart.getInstance();

  @override
  Widget build(BuildContext context) {
    double total = 0; // Переменная для хранения общей суммы товаров в корзине
    for (Product cartItem in cart.cartItems) {
      // Цикл для подсчета общей суммы
      total += cartItem.price * cartItem.quantity;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Корзина"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.asset(
                              cart.cartItems[index].image,
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
                                    cart.cartItems[index].name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    cart.cartItems[index].description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${cart.cartItems[index].price} руб.',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      cart.addToCart(cart.cartItems[index]);
                                      setState(() {
                                        cart.cartItems;
                                        cart.cartItems[index].quantity;
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_drop_up)),
                                Text('${cart.cartItems[index].quantity}'),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        cart.removeFromCart(
                                            cart.cartItems[index]);
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_drop_down))
                              ],
                            ))
                          ],
                        ),
                      ),
                    );
                  })),
          Text("Общая сумма: $total"),
          // Отображение общей суммы товаров в корзине
          ElevatedButton(
            child: const Text("Купить"),
            onPressed: () {
              if (total > 0) {
                // Если общая сумма больше 0, то покупка успешна
                setState(() {
                  cart.clearCart();
                });
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text("Успешно"),
                      actions: [
                        TextButton(
                          child: const Text("Ок"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                // Если общая сумма равна 0, то покупка не может быть завершена
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text("Корзина пуста"),
                      actions: [
                        TextButton(
                          child: const Text("Ок"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
