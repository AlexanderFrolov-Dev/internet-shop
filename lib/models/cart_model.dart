import 'package:flutter/cupertino.dart';
import 'package:mobile_app_internet_shop/databases/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../product.dart';

class CartModel extends ChangeNotifier {
  final List<Product> _cartItems = [];
  double _totalPrice = 0;
  static AppDatabase cartDatabase = AppDatabase();
  static Database? db;
  int userId = 0;

  // Создаем приватный конструктор для реализации Singleton
  CartModel._();

  // Создаем статическое поле для хранения единственного экземпляра класса
  static final CartModel _instance = CartModel._();

  // Создаем геттер для доступа к единственному экземпляру класса
  static CartModel getInstance() => _instance;

  List<Product> get cartItems => _cartItems;

  static Future<Database> getDb() async {
    return await cartDatabase.database;
  }

  static void initDatabase() {
    getDb().then((value) => db);
  }

  // Future<int?> getProfileId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getInt('profileId');
  // }

  void addToCart(Product product) async {
    // getProfileId().then((value) => userId);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('profileId')!;

    // Проверяем, есть ли уже такой товар в корзине
    if (cartItems.any((item) => item == product)) {
      // Если есть, то увеличиваем счетчик товара на 1
      int index = cartItems.indexWhere((item) => item == product);
      cartItems[index].quantity++;
      // cartDatabase.increaseQuantity(userId, product.id);
      cartDatabase.increaseProductQuantity(userId, product.id);
    } else {
      // Если нет, то добавляем товар в корзину
      cartItems.add(product);
      cartDatabase.addToDb(userId, product.id, product.quantity);
    }
    // Увеличиваем общую стоимость товаров в корзине
    _totalPrice += product.price;
    notifyListeners();
  }

  void removeFromCart(Product product) async {
    // getProfileId().then((value) => userId);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('profileId')!;

    // Проверяем, есть ли такой товар в корзине
    if (cartItems.any((item) => item == product)) {
      // Если есть, то уменьшаем счетчик товара на 1
      int index = cartItems.indexWhere((item) => item == product);
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        // Уменьшаем общую стоимость товаров в корзине
        _totalPrice -= product.price;
        // cartDatabase.reduceQuantity(userId, product.id);
        cartDatabase.decreaseProductQuantity(userId, product.id);
      }
      else {
        // Если счетчик равен 0, то удаляем товар из корзины
        cartItems.removeAt(index);
        cartDatabase.deleteProduct(userId, product.id);
        // Уменьшаем общую стоимость товаров в корзине на стоимость удаленного товара
        _totalPrice -= product.price;
      }

      notifyListeners();
    }
  }

  // Метод для получения общей суммы товаров в корзине
  double getTotalPrice() {
    // Считаем общую сумму по всем элементам корзины
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Метод для получения общего количества товаров в корзине
  int getItemsCount() {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  void clearCart() async {
    // getProfileId().then((value) => userId);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('profileId')!;

    // Очищаем корзину и обнуляем общую стоимость
    cartItems.clear();
    _totalPrice = 0;
    cartDatabase.clearCartInDb(userId);
    notifyListeners();
  }

  Future<void> restoreCartFromDB() async {
    List<Map<String, dynamic>> usersProducts = [];
    // получение id пользователя после авторизации;
    cartItems.clear();
    _totalPrice = 0;

    // getProfileId().then((value) => userId);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('profileId')!;

    cartDatabase.getAllProductsByUserId(userId).then((value) => usersProducts);

    for (final productRow in usersProducts) {
      // Получение списка вхождений
      Iterable<MapEntry<String, dynamic>> entry = productRow.entries;
      Product? product;
      int productId = 0;
      int quantity = 0;

      // Перебор вхождений и поиск значений по ключу
      for (var e in entry) {
        if (e.key == 'id') {
          productId = e.value;
        } else if (e.key == 'quantity') {
          quantity = e.value;
        }
      }

      Product.getProductById(productId).then((value) => product);
      product?.quantity = quantity;
      cartItems.add(product!);
      _totalPrice += product.price;
    }

    notifyListeners();
  }
}