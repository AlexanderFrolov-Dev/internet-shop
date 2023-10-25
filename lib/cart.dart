import 'product.dart';

class Cart {
  final List<Product> _cartItems = [];
  double _totalPrice = 0;

  // Создаем приватный конструктор для реализации Singleton
  Cart._();

  // Создаем статическое поле для хранения единственного экземпляра класса
  static final Cart _instance = Cart._();

  // Создаем геттер для доступа к единственному экземпляру класса
  static Cart getInstance() => _instance;

  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    // Проверяем, есть ли уже такой товар в корзине
    if (cartItems.any((item) => item == product)) {
      // Если есть, то увеличиваем счетчик товара на 1
      int index = cartItems.indexWhere((item) => item == product);
      cartItems[index].quantity++;
    } else {
      // Если нет, то добавляем товар в корзину
      cartItems.add(product);
    }
    // Увеличиваем общую стоимость товаров в корзине
    _totalPrice += product.price;
  }

  void removeFromCart(Product product) {
    // Проверяем, есть ли такой товар в корзине
    if (cartItems.any((item) => item == product)) {
      // Если есть, то уменьшаем счетчик товара на 1
      int index = cartItems.indexWhere((item) => item == product);
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        // Уменьшаем общую стоимость товаров в корзине
        _totalPrice -= product.price;
      } else {
        // Если счетчик равен 1, то удаляем товар из корзины
        cartItems.removeAt(index);
        // Уменьшаем общую стоимость товаров в корзине на стоимость удаленного товара
        _totalPrice -= product.price;
      }
    }
  }

  // Метод для получения общей суммы товаров в корзине
  double getTotalPrice() {
    // Считаем общую сумму по всем элементам корзины
    for (Product item in cartItems) {
      _totalPrice += item.price * item.quantity;
    }

    return _totalPrice;
  }

  void update() {
    cartItems;
    getTotalPrice();
  }

  void clearCart() {
    // Очищаем корзину и обнуляем общую стоимость
    cartItems.clear();
    _totalPrice = 0;
  }
}