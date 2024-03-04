import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';

class CartScreen extends StatefulWidget {
  final AppDatabase appDatabase;

  const CartScreen({super.key, required this.appDatabase});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartModel cartModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cartModel = CartModel.getInstance(widget.appDatabase);
  }

  @override
  Widget build(BuildContext context) {
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
      // Consumer позволяет использовать CartModel,
      // который прослушивается через ChangeNotifierProvider,
      // отслеживающий все изменения происходящие в CartModel
      body: Consumer<CartModel>(
        builder: (context, cart, child) => Column(
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
                                        // Увеличение количества товара по
                                        // нажатию кнопки со стрелкой вверх
                                          onPressed: () {
                                            cart.addToCart(cart.cartItems[index]);
                                          },
                                          icon: const Icon(Icons.arrow_drop_up)),
                                      Text('${cart.cartItems[index].quantity}'),
                                      IconButton(
                                        // Уменьшение количества товара по
                                        // нажатию кнопки со стрелкой вниз
                                          onPressed: () {
                                            cart.removeFromCart(
                                                cart.cartItems[index]);
                                          },
                                          icon: const Icon(Icons.arrow_drop_down))
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      );
                    })),
            Text("Общая сумма: ${cart.getTotalPrice()}"),
            // Отображение общей суммы товаров в корзине
            ElevatedButton(
              child: const Text("Купить"),
              onPressed: () {
                if (cart.getTotalPrice() > 0) {
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
      )
    );
  }
}
