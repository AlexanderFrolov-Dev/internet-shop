import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/product.dart';

import '../cart.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart cart = Cart.getInstance();

  @override
  Widget build(BuildContext context) {
    double total = 0; // переменная для хранения общей суммы товаров в корзине
    for (Product cartItem in cart.cartItems) {
      // цикл для подсчета общей суммы
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
          Expanded(child: ListView.builder(
            itemCount: cart.cartItems.length,
            itemBuilder: (context, index) {
              // return ProductCard(key: ValueKey(cart.cartItems[index]), product: cart.cartItems[index]);
              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.asset(
                        cart.cartItems[index].image,
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
                              cart.cartItems[index].name,
                              style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              cart.cartItems[index].description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${cart.cartItems[index].price} руб.',
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
                                cart.addToCart(cart.cartItems[index]);
                                setState(() {
                                  cart.cartItems;
                                  cart.cartItems[index].quantity;
                                });
                              },
                              icon: const Icon(Icons.arrow_drop_up)
                          ),
                          Text('${cart.cartItems[index].quantity}'),
                          IconButton(
                              onPressed: () {
                                // cart.removeFromCart(cart.cartItems[index]);
                                setState(() {
                                  if(cart.cartItems[index].quantity > 0) {
                                    cart.cartItems[index].quantity--;
                                  } else {
                                    cart.removeFromCart(cart.cartItems[index]);
                                    // cart.cartItems.removeAt(index); // удаление выбранного товара из списка
                                  }
                                  // cart.cartItems.removeAt(index); // удаление выбранного товара из списка
                                });
                              },
                              icon: const Icon(Icons.arrow_drop_down)
                          )
                        ],
                      )
                      )
                    ],
                  ),
                ),
              );
            })
          ),
          Text("Общая сумма: $total"),
          // отображение общей суммы товаров в корзине
          ElevatedButton(
            child: const Text("Купить"),
            onPressed: () {
              cart.cartItems.clear(); // очистка корзины
              showDialog(
                // вывод сообщения об успешной покупке
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: const Text("Успешно"),
                    actions: [
                      TextButton(
                        child: const Text("Ок"),
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

// ElevatedButton(
// child: Text("Купить"),
// onPressed: () {
// if (total > 0) {
// // если общая сумма больше 0, то покупка успешна
// cartItems.clear();
// showDialog(
// context: context,
// builder: (context) {
// return AlertDialog(
// content: Text("Успешно"),
// actions: [
// TextButton(
// child: Text("Ок"),
// onPressed: () {
// Navigator.pop(context);
// },
// ),
// ],
// );
// },
// );
// } else {
// // если общая сумма равна 0, то покупка не может быть завершена
// showDialog(
// context: context,
// builder: (context) {
// return AlertDialog(
// content: Text("Корзина пуста"),
// actions: [
// TextButton(
// child: Text("Ок"),
// onPressed: () {
// Navigator.pop(context);
// },
// ),
// ],
// );
// },
// );