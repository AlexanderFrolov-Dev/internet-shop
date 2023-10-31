import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/services.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String image;
  final double price;
  int quantity;

  Product(
      {required this.id,
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
  Map<String, dynamic> toJson() => {
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
    // await rootBundle.writeAsString('assets/data/products.json', newJsonString);
    final File file = File('assets/data/products.json');
    file.writeAsString(newJsonString);
  }
}
