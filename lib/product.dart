import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String image;
  final double price;
  int quantity;

  Product({required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    this.quantity = 1});

  // Создаем фабричный конструктор для удобного парсинга данных из json
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
    );
  }

  // Метод toJson для преобразования объекта в JSON
  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'price': price,
      };

  // 2. Получение данных из файла products.json
  static Future<void> addProduct(Product product) async {
    String jsonString = await rootBundle.loadString(
        'assets/data/products.json');
    // 3. Преобразование данных в объект Dart
    List<dynamic> products = json.decode(jsonString);
    // 4. Добавление нового товара
    products.add(product.toJson());
    // 5. Преобразование объекта обратно в JSON
    String newJsonString = json.encode(products);
    // 6. Запись данных в файл products.json
    final File file = File('assets/data/products.json');
    file.writeAsString(newJsonString);
  }

  // static Future<Product> getProductById(int id) async {
  //   try {
  //     final data = await rootBundle.loadString('assets/products.json');
  //     final jsonResult = json.decode(data);
  //     final products = List<Product>.from(jsonResult.map((x) => Product.fromJson(x)));
  //     final product = products.firstWhere((p) => p.id == id);
  //     return product;
  //   } catch (e) {
  //     throw Exception('Не найден товар с id: $id');
  //   }
  // }

  static Future<List<Product>> getAllProducts() async {
    List<Product> products = [];

    // Загружаем содержимое файла с продуктами
    final jsonProducts = await rootBundle.loadString(
        'assets/data/products.json');
    // Преобразование полученных данных в формат JSON
    final jsonData = json.decode(jsonProducts);

    // Проход по списку товаров и создание экземпляров класса Product
    for (var product in jsonData) {
      products.add(Product.fromJson(product));
    }

    return products;
  }

  static Future<Product?> getProductById(int id) async {
    // Загружаем содержимое файла с продуктами
    final jsonProducts = await rootBundle.loadString(
        'assets/data/products.json');
    // Преобразование полученных данных в формат JSON
    final jsonData = json.decode(jsonProducts);
    Product? product;

    print('jsonData length: ${jsonData.toString()}');

    // Проход по списку товаров и создание экземпляров класса Product
    for (var product in jsonData) {
      Product currentProduct = Product.fromJson(product);

      print('Current product: ${currentProduct.toString()}');


      print('Product.fromJson(product)________${Product.fromJson(product).toString()}');
      print('Product.fromJson(product) name: ${Product.fromJson(product).name}');

      if (currentProduct.id == id) {
        return currentProduct;
      }

      // Product product = Product(id: productId, name: name, description: description, image: image, price: price);

      // Находим продукт с нужным id
      // final productJson = products.firstWhere(
      //       (product) => product['id'] == id,
      //   orElse: () => <String, dynamic>{},
      // );
      // // Если продукт не найден, возвращаем null
      // if (productJson == null) {
      //   return null;
      // }
      // Создаем объект Product из JSON
      // return Product.fromJson(productJson);
    }

    // static Future<Product?> getProductById(int id) async {
    //   // Загружаем содержимое файла с продуктами
    //   final productsJson = await rootBundle.loadString('assets/data/products.json');
    //   // Парсим JSON и создаем список продуктов
    //   final products = List<Map<String, dynamic>>.from(json.decode(productsJson));
    //   print('products length: ${products.length}');
    //   int productId = 0;
    //   String name = '';
    //   String description = '';
    //   String image = '';
    //   double price = 0;
    //
    //   for (final product in products) {
    //     Iterable<MapEntry<String, dynamic>> entry = product.entries;
    //
    //     // Перебор вхождений и поиск значений по ключу
    //     for (var e in entry) {
    //       print(e.toString());
    //
    //       if (e.key == 'id') {
    //         if (e.value == id) {
    //           productId = e.value;
    //           print('Product class productId: ${e.value}');
    //         }
    //         if (e.key == 'name') {
    //           name = e.value;
    //           print('Product class name: ${e.value}');
    //         }
    //         if (e.key == 'description') {
    //           description = e.value;
    //           print('Product class description: ${e.value}');
    //         }
    //         if (e.key == 'image') {
    //           image = e.value;
    //           print('Product class image: ${e.value}');
    //         }
    //         if (e.key == 'price') {
    //           price = e.value;
    //           print('Product class price: ${e.value}');
    //         }
    //       }
    //     }
    //   }
    //
    //   if (productId > 0) {
    //     return Product(id: productId, name: name, description: description, image: image, price: price);
    //   } else {
    //     return null;
    //   }
    //
    //   // Product product = Product(id: productId, name: name, description: description, image: image, price: price);
    //
    //   // Находим продукт с нужным id
    //   // final productJson = products.firstWhere(
    //   //       (product) => product['id'] == id,
    //   //   orElse: () => <String, dynamic>{},
    //   // );
    //   // // Если продукт не найден, возвращаем null
    //   // if (productJson == null) {
    //   //   return null;
    //   // }
    //   // Создаем объект Product из JSON
    //   // return Product.fromJson(productJson);
    // }
  }
}
