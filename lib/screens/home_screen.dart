import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_internet_shop/product.dart';
import 'package:mobile_app_internet_shop/widgets/product_card.dart';

import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    // Вызов метода для получения данных о товарах при инициализации экрана
    getProducts();
  }

// Метод для получения данных о товарах из JSON-файла
  Future<void> getProducts() async {
    // Получение данных из JSON-файла с помощью метода rootBundle
    final jsonProducts =
        await rootBundle.loadString('assets/data/products.json');

    // Преобразование полученных данных в формат JSON
    final jsonData = json.decode(jsonProducts);

    // Проход по списку товаров и создание экземпляров класса Product
    for (var product in jsonData) {
      products.add(Product.fromJson(product));
    }

    // Обновление состояния виджета для отображения полученных данных
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Интернет-магазин'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(
              key: ValueKey(products[index]),
              product: products[index],
            );
          },
        ));
  }
}