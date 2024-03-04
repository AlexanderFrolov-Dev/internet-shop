import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_database.dart';
import '../product.dart';

class FavoriteProductsModel extends ChangeNotifier {
  final List<Product> _favoriteItems = [];
  AppDatabase appDatabase;
  static const String tableName = 'favorites';

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

  // Метод восстанавления содержимого избранного пользователя из БД
  Future<void> restoreFavoriteFromDb() async {
    List<Product> products = [];
    // Получение id пользователя после авторизации
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('profileId') ?? 0;

    if(userId > 0) {
      await appDatabase.getProductsForFavorites(userId)
          .then((value) => products.addAll(value));
    }

    if(products.isNotEmpty) {
      _favoriteItems.clear();

      for (Product product in products) {
        _favoriteItems.add(product);
      }
    }

    // Этот вызов сообщает виджетам,
    // которые прослушивают эту модель, о необходимости перестройки.
    notifyListeners();
  }
}