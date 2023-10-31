import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_internet_shop/product.dart';
import 'package:mobile_app_internet_shop/widgets/product_card.dart';

import 'cart_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
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
        body: Column(
          children: [
            ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  key: ValueKey(products[index]),
                  product: products[index],
                );
              },
            ),
            IconButton(
                onPressed: setState(() {
                  // 1. Создание формы для ввода данных
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        Form(
                          child: Column(
                            children: <Widget>[
                              // Поле для ввода id
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'ID',
                                ),
                                // Сохранение введенного значения в переменную id
                                onSaved: (value) {
                                  id = int.parse(value);
                                },
                              ),
                              // Поле для ввода названия
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Название',
                                ),
                                // Сохранение введенного значения в переменную name
                                onSaved: (value) {
                                  name = value;
                                },
                              ),
                              // Поле для ввода цены
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Цена',
                                ),
                                // Сохранение введенного значения в переменную price
                                onSaved: (value) {
                                  price = double.parse(value);
                                },
                              ),
                              // Кнопка для добавления товара
                              RaisedButton(
                                onPressed: () {
                                  // 2. Создание экземпляра класса Product и передача значений
                                  Product newProduct = Product(id, name, price);
                                  // 3. Вызов метода addProduct()
                                  addProduct(newProduct);
                                },
                                child: Text('Добавить товар'),
                              ),
                            ],
                          ),
                        ),
                  ),
                  );

                }),
                icon: const Icon(Icons.add))
          ],
        )

    );
  }
}
