import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_internet_shop/widgets/product_card.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../product.dart';
import '../screens/add_product_form.dart';
import '../screens/cart_screen.dart';
import 'cart_badge.dart';

class AdminProductList extends StatefulWidget {
  const AdminProductList({super.key});

  @override
  State<AdminProductList> createState() => _AdminProductListState();
}

class _AdminProductListState extends State<AdminProductList> {
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
            Consumer<CartModel>(
              builder: (context, cart, child) => CartBadge(
                value:
                '${Provider.of<CartModel>(context, listen: false).getItemsCount()}',
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartScreen()));
                  },
                ),
              ),
            )
          ],
        ),
        body:
        Column(children: [
          Flexible(
            flex: 5,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  key: ValueKey(products[index]),
                  product: products[index],
                );
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProductForm()),
                  );
                },
                child: const Text('Добавить товар'),
              ),
            ),
          ),
        ])
    );
  }
}