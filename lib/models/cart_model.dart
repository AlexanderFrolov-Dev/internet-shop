import 'package:flutter/cupertino.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../product.dart';

class CartModel extends ChangeNotifier {
  final List<Product> _cartItems = [];
  double _totalPrice = 0;
  AppDatabase appDatabase;
  int userId = 0;

  // Создаем приватный конструктор для реализации Singleton
  CartModel._(this.appDatabase);

  // Создаем статическое поле для хранения единственного экземпляра класса
  static CartModel? _instance;

  // Создаем статический метод для получения единственного экземпляра класса
  static CartModel getInstance(AppDatabase appDatabase) {
    // Если экземпляр еще не создан, то создаем его
    _instance ??= CartModel._(appDatabase);
    return _instance!;
  }

  // // Создаем статическое поле для хранения единственного экземпляра класса
  // static final CartModel _instance = CartModel._(AppDatabase());
  //
  // // Создаем геттер для доступа к единственному экземпляру класса
  // static CartModel getInstance(AppDatabase appDatabase) => _instance;

  List<Product> get cartItems => _cartItems;

  Future<bool> isFoundProduct(Product product) async {
    return cartItems.any((item) => item == product);
  }

  // Метод добавления товара в корзину
  void addToCart(Product product) async {
    bool founded = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('profileId')!;
    print('prefs.getInt(profileId) in CartModel add: ${prefs.getInt('profileId')}');
    print('cartItems length: ${cartItems.length}');
    for(Product product in cartItems) {
      print('product name: ${product.name}');
    }
    print('this product: ${product.name}');

    // bool founded = cartItems.any((item) => item == product);

    for(Product p in cartItems) {
      if(p.id == product.id) {
        founded = true;
      }
    }

    // await isFoundProduct(product);
    print('founded: $founded');

    // Проверяем, есть ли уже такой товар в корзине
    // if (cartItems.any((item) => item == product)) {
    if (founded) {
      print('yes');
      // for(Product product in cartItems) {
      //   print('product name: ${product.name}');
      // }
      // Если есть, то увеличиваем счетчик товара на 1
      // int index = cartItems.indexWhere((item) => item == product);
      int index = cartItems.indexWhere((item) => item.id == product.id);
      cartItems[index].quantity++;
      await appDatabase.increaseProductQuantity(userId, product.id);
    } else {
      // Если нет, то добавляем товар в корзину
      cartItems.add(product);
      // Увеличиваем количество товара в БД на 1
      await appDatabase.addToDb(userId, product.id, product.quantity);
    }
    // Увеличиваем общую стоимость товаров в корзине
    _totalPrice += product.price;
    // Этот вызов сообщает виджетам,
    // которые прослушивают эту модель, о необходимости перестройки.
    notifyListeners();
  }

  // Метод удаления товара из корзины
  void removeFromCart(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('profileId')!;
    print('prefs.getInt(profileId) in CartModel remove: ${prefs.getInt('profileId')}');

    // Проверяем, есть ли такой товар в корзине
    if (cartItems.any((item) => item == product)) {
      // Если есть, то уменьшаем счетчик товара на 1
      int index = cartItems.indexWhere((item) => item == product);
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        // Уменьшаем общую стоимость товаров в корзине
        _totalPrice -= product.price;
        // Уменьшаем количество товара в БД на 1
        await appDatabase.decreaseProductQuantity(userId, product.id);
      }
      else {
        // Если счетчик равен 0, то удаляем товар из корзины
        cartItems.removeAt(index);
        // Удаляем товар из БД
        await appDatabase.deleteProduct(userId, product.id);
        // Уменьшаем общую стоимость товаров в корзине на стоимость удаленного товара
        _totalPrice -= product.price;
      }

      // Этот вызов сообщает виджетам,
      // которые прослушивают эту модель, о необходимости перестройки.
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('profileId')!;

    // Очищаем корзину и обнуляем общую стоимость
    cartItems.clear();
    _totalPrice = 0;
    // Удаляем из БД товары пользователя
    appDatabase.deleteProductsByIdFromDb(userId);
    // Этот вызов сообщает виджетам,
    // которые прослушивают эту модель, о необходимости перестройки.
    notifyListeners();
  }

  // Метод восстанавления содержимого корзины пользователя из БД
  Future<void> restoreCartFromDb() async {
    List<Map<String, dynamic>> usersProducts = [];
    List<Product> products = [];
    Product? product;
    // Получение id пользователя после авторизации
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('profileId')!;

    // Получаем все записи из БД относящиеся к указанному id пользователя,
    // и добавляем их в локальный список мап usersProducts
    await appDatabase.getAllProductsByUserId(userId).then((value) =>
      usersProducts.addAll(value));

    // Получение списка всех товаров из json файла
    await Product.getAllProducts().then((value) => products.addAll(value));

    cartItems.clear();

    for (final productRow in usersProducts) {
      // Получение вхождений списка мап
      Iterable<MapEntry<String, dynamic>> entry = productRow.entries;

      int productId = 0;
      int quantity = 0;

      // Перебор вхождений и поиск значений по ключу
      for (var e in entry) {
        if (e.key == 'product_id') {
          productId = e.value;
        } else if (e.key == 'quantity') {
          quantity = e.value;
        }
      }

      // Получение товара из общего списка по id
      product = products.firstWhere((p) => p.id == productId);

      // Добавление товара с указанием его количества в корзину
      product.quantity = quantity;
      cartItems.add(product);
      _totalPrice += product.price;
    }

    // Этот вызов сообщает виджетам,
    // которые прослушивают эту модель, о необходимости перестройки.
    notifyListeners();
  }
}