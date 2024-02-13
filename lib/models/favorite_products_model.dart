import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_database.dart';
import '../product.dart';

class FavoriteProductsModel extends ChangeNotifier {
  final List<Product> _favoriteItems = [];
  AppDatabase appDatabase;
  static const String tableName = 'favorites';
  // int userId = 0;

  // Создаем приватный конструктор для реализации Singleton
  FavoriteProductsModel._(this.appDatabase);

  // Создаем статическое поле для хранения единственного экземпляра класса
  static FavoriteProductsModel? _instance;

  // Создаем статический метод для получения единственного экземпляра класса
  static FavoriteProductsModel getInstance(AppDatabase appDatabase) {
    // Если экземпляр еще не создан, то создаем его
    _instance ??= FavoriteProductsModel._(appDatabase);
    return _instance!;
  }

  List<Product> get favoriteItems => _favoriteItems;

  // Метод добавления товара в корзину
  void addToFavorite(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('profileId')!;

    // Проверяем, есть ли уже такой товар в избранном.
    // Если нет, то добавляем.
    if (!favoriteItems.any((item) => item.id == product.id)) {
      await appDatabase.addToFavoritesTable(userId, product.id);
      favoriteItems.add(product);
    }

    print('add product in favorite');

    // Этот вызов сообщает виджетам,
    // которые прослушивают эту модель, о необходимости перестройки.
    notifyListeners();
  }

  // Метод удаления товара из избранного
  void removeFromFavorite(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('profileId')!;
    int id = product.id;
    Product p = favoriteItems.firstWhere((element) => element.id == id);

    await appDatabase.deleteProduct(tableName, userId, product.id);
    favoriteItems.remove(p);

    // Этот вызов сообщает виджетам,
    // которые прослушивают эту модель, о необходимости перестройки.
    notifyListeners();
  }

  void clearFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('profileId')!;

    // Очищаем избранное
    favoriteItems.clear();
    // Удаляем из БД товары пользователя
    appDatabase.deleteProductsByIdFromDb(tableName, userId);
    // Этот вызов сообщает виджетам,
    // которые прослушивают эту модель, о необходимости перестройки.
    notifyListeners();
  }

  // Future<bool> checkProductInFavorites(Product product) async {
  //   List<Product> products = [];
  //
  //   await getFavoriteProductListByUser().then((value) => products.addAll(value));
  //   print('products length: ${products.length}');
  //   // bool exist = products.contains(product);
  //   return products.any((element) => element.id == product.id);
  // }

  // // Метод для получения списка товаров пользователя из таблицы избранного
  // Future<List<Product>> getFavoriteProductListByUser() async {
  //   List<Map<String, dynamic>> usersProducts = [];
  //   List<Product> products = [];
  //   // Получение id пользователя после авторизации
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userId = prefs.getInt('profileId') ?? 0;
  //
  //   if(userId > 0) {
  //     // Получаем все записи из БД относящиеся к указанному id пользователя,
  //     // и добавляем их в локальный список мап usersProducts
  //     await appDatabase.getAllProductsByUserId(tableName, userId)
  //         .then((value) => usersProducts.addAll(value));
  //
  //     // Получение списка всех товаров из json файла
  //     await Product.getAllProducts().then((value) => products.addAll(value));
  //   }
  //
  //   return products;
  // }

  // // Метод для получения списка товаров пользователя из таблицы избранного
  // Future<List<Product>> getFavoriteProductListByUser() async {
  //   List<Product> products = [];
  //   // Получение id пользователя после авторизации
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userId = prefs.getInt('profileId') ?? 0;
  //
  //   if(userId > 0) {
  //     await appDatabase.getProductsForFavorites(userId)
  //         .then((value) => products.addAll(value));
  //   }
  //
  //   print('products.length in getFavoriteProductListByUser: ${products.length}');
  //
  //   return products;
  // }

  // // Метод восстанавления содержимого избранного пользователя из БД
  // Future<void> restoreFavoriteFromDb() async {
  //   List<Map<String, dynamic>> usersProducts = [];
  //   List<Product> products = [];
  //   Product? product;
  //
  //   await getFavoriteProductListByUser().then((value) => products.addAll(value));
  //
  //   if(products.isNotEmpty) {
  //     // Получаем все записи из БД относящиеся к указанному id пользователя,
  //     // и добавляем их в локальный список мап usersProducts
  //     await appDatabase.getAllProductsByUserId(tableName, userId).then((value) =>
  //         usersProducts.addAll(value));
  //
  //     favoriteItems.clear();
  //
  //     for (final productRow in usersProducts) {
  //       // Получение вхождений списка мап
  //       Iterable<MapEntry<String, dynamic>> entry = productRow.entries;
  //       int productId = 0;
  //
  //       // Перебор вхождений и поиск значений по ключу
  //       for (var e in entry) {
  //         if (e.key == 'product_id') {
  //           productId = e.value;
  //         }
  //       }
  //
  //       // Получение товара из общего списка по id
  //       product = products.firstWhere((p) => p.id == productId);
  //       favoriteItems.add(product);
  //     }
  //   }
  //
  //   // Этот вызов сообщает виджетам,
  //   // которые прослушивают эту модель, о необходимости перестройки.
  //   notifyListeners();
  // }

  // Метод восстанавления содержимого избранного пользователя из БД
  Future<void> restoreFavoriteFromDb() async {
    List<Product> products = [];
    // Получение id пользователя после авторизации
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('profileId') ?? 0;

    print('userId: $userId');

    if(userId > 0) {
      await appDatabase.getProductsForFavorites(userId)
          .then((value) => products.addAll(value));
    }

    print('products length: ${products.length}');

    if(products.isNotEmpty) {
      favoriteItems.clear();

      for (Product product in products) {
        favoriteItems.add(product);
      }
    }

    // Этот вызов сообщает виджетам,
    // которые прослушивают эту модель, о необходимости перестройки.
    notifyListeners();
  }
}