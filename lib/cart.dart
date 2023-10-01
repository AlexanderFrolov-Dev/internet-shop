import 'product.dart';

class Cart {
  List<Product> _products = [];

  // Создаем приватный конструктор для реализации Singleton
  Cart._();

  // Создаем статическое поле для хранения единственного экземпляра класса
  static final Cart _instance = Cart._();

  // Создаем геттер для доступа к единственному экземпляру класса
  static Cart getInstance() => _instance;

  List<Product> get products => _products;

  void addToCart(Product product) {
    _products.add(product);
  }
}