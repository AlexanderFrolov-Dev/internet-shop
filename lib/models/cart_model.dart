import 'package:flutter/cupertino.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../product.dart';

class CartModel extends ChangeNotifier {
  final List<Product> _cartItems = [];
  double _totalPrice = 0;
  AppDatabase appDatabase = AppDatabase();
  int userId = 0;

  // Создаем приватный конструктор для реализации Singleton
  CartModel._();

  // Создаем статическое поле для хранения единственного экземпляра класса
  static final CartModel _instance = CartModel._();

  // Создаем геттер для доступа к единственному экземпляру класса
  static CartModel getInstance() => _instance;

  List<Product> get cartItems => _cartItems;

  Future<Database> getDb() async {
    return await appDatabase.database;
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
      appDatabase.increaseProductQuantity(userId, product.id);
    } else {
      // Если нет, то добавляем товар в корзину
      cartItems.add(product);
      appDatabase.addToDb(userId, product.id, product.quantity);
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
        appDatabase.decreaseProductQuantity(userId, product.id);
      }
      else {
        // Если счетчик равен 0, то удаляем товар из корзины
        cartItems.removeAt(index);
        appDatabase.deleteProduct(userId, product.id);
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
    appDatabase.clearCartInDb(userId);
    notifyListeners();
  }

  // Future<List<Map<String, dynamic>>> getProductListFromDb() async {
  //   List<Map<String, dynamic>> usersProducts = [];
  //   // получение id пользователя после авторизации;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userId = prefs.getInt('profileId')!;
  //
  //   print('userId: $userId');
  //
  //   await appDatabase.getAllProductsByUserId(userId).then((value) => {
  //     usersProducts.addAll(value)
  //   });
  //
  //   print('usersProducts length: ${usersProducts.length}');
  //
  //   return usersProducts;
  //
  // }

  Future<void> restoreCartFromDb() async {
    List<Map<String, dynamic>> usersProducts = [];
    List<Product> products = [];
    // получение id пользователя после авторизации;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('profileId')!;

    Product? product;

    print('userId: $userId');

    await appDatabase.getAllProductsByUserId(userId).then((value) =>
      usersProducts.addAll(value));

    await Product.getAllProducts().then((value) => products.addAll(value));
    print('Products list length: ${products.length}');

    print('usersProducts length: ${usersProducts.length}');

    for (final productRow in usersProducts) {
      // Получение списка вхождений
      Iterable<MapEntry<String, dynamic>> entry = productRow.entries;

      int productId = 0;
      int quantity = 0;

      // Перебор вхождений и поиск значений по ключу
      for (var e in entry) {
        if (e.key == 'product_id') {
          productId = e.value;
          print('Founded product id: $productId');
        } else if (e.key == 'quantity') {
          quantity = e.value;
        }
      }

      // Product? product = await Product.getProductById(productId);

      // await Product.getProductById(productId).then((value) => product);
      
      print('Products list length: ${products.length}');

      product = products.firstWhere((p) => p.id == productId);

      print(product.toString());

      product.quantity = quantity;
      cartItems.add(product);
      print('Well done!');
      _totalPrice += product.price;
    }

    notifyListeners();
  }

  // Future<void> restoreCartFromDB() async {
  //   List<Map<String, dynamic>> usersProducts = [];
  //   // получение id пользователя после авторизации;
  //   cartItems.clear();
  //   _totalPrice = 0;
  //
  //   // getProfileId().then((value) => userId);
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userId = prefs.getInt('profileId')!;
  //
  //   appDatabase.getAllProductsByUserId(userId).then((value) => usersProducts);
  //
  //   for (final productRow in usersProducts) {
  //     // Получение списка вхождений
  //     Iterable<MapEntry<String, dynamic>> entry = productRow.entries;
  //     Product? product;
  //     int productId = 0;
  //     int quantity = 0;
  //
  //     // Перебор вхождений и поиск значений по ключу
  //     for (var e in entry) {
  //       if (e.key == 'id') {
  //         productId = e.value;
  //       } else if (e.key == 'quantity') {
  //         quantity = e.value;
  //       }
  //     }
  //
  //     Product.getProductById(productId).then((value) => product);
  //     product?.quantity = quantity;
  //     cartItems.add(product!);
  //     _totalPrice += product.price;
  //   }
  //
  //   notifyListeners();
  // }
}