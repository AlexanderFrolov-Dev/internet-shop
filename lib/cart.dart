import 'product.dart';

class Cart {
  List<Product> _products = [];
  double _totalPrice = 0;

  // Создаем приватный конструктор для реализации Singleton
  Cart._();

  // Создаем статическое поле для хранения единственного экземпляра класса
  static final Cart _instance = Cart._();

  // Создаем геттер для доступа к единственному экземпляру класса
  static Cart getInstance() => _instance;

  List<Product> get products => _products;
  double get totalPrice => _totalPrice;

  void addToCart(Product product) {
    // Проверяем, есть ли уже такой товар в корзине
    if (_products.contains(product)) {
      // Если есть, то увеличиваем счетчик товара на 1
      int index = _products.indexOf(product);
      _products[index].quantity++;
    } else {
      // Если нет, то добавляем товар в корзину
      _products.add(product);
    }
    // Увеличиваем общую стоимость товаров в корзине
    _totalPrice += product.price;
  }

  void removeFromCart(Product product) {
    // Проверяем, есть ли такой товар в корзине
    if (_products.contains(product)) {
      // Если есть, то уменьшаем счетчик товара на 1
      int index = _products.indexOf(product);
      if (_products[index].quantity > 1) {
        _products[index].quantity--;
        // Уменьшаем общую стоимость товаров в корзине
        _totalPrice -= product.price;
      } else {
        // Если счетчик равен 1, то удаляем товар из корзины
        _products.removeAt(index);
        // Уменьшаем общую стоимость товаров в корзине на стоимость удаленного товара
        _totalPrice -= product.price;
      }
    }
  }

  void clearCart() {
    // Очищаем корзину и обнуляем общую стоимость
    _products.clear();
    _totalPrice = 0;
  }
}