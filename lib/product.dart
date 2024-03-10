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
    this.quantity = 1,
});

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
        'description': description,
        'image': image,
        'price': price,
        'quantity': 1
      };

  // Получение данных из файла products.json
  static Future<void> addProduct(Product product) async {
    String jsonString = await rootBundle.loadString(
        'assets/data/products.json');
    // Преобразование данных в объект Dart
    List<dynamic> products = json.decode(jsonString);
    // Добавление нового товара
    products.add(product.toJson());
    // Преобразование объекта обратно в JSON
    String newJsonString = json.encode(products);
    // Запись данных в файл products.json
    final File file = File('assets/data/products.json');
    file.writeAsString(newJsonString);
  }

  // Метод для получения Future списка всех товаров из json файла
  static Future<List<Product>> getAllProducts() async {
    List<Product> products = [];

    // Загружаем содержимое файла с товарами
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

  // Метод получения информации о товарах по их id
  static Future<List<Product>> getProductsByIds(List<int> productIds) async {
    final productsList = await Product.getAllProducts();

    return productsList.where((product) => productIds.contains(product.id)).toList();
  }
}
