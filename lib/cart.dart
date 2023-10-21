import 'cart_item.dart';
import 'product.dart';

class Cart {
  final List<CartItem> _cartItems = [];
  double _totalPrice = 0;

  // Создаем приватный конструктор для реализации Singleton
  Cart._();

  // Создаем статическое поле для хранения единственного экземпляра класса
  static final Cart _instance = Cart._();

  // Создаем геттер для доступа к единственному экземпляру класса
  static Cart getInstance() => _instance;

  List<CartItem> get cartItems => _cartItems;

  void addToCart(Product product) {
    // Проверяем, есть ли уже такой товар в корзине
    if (cartItems.any((item) => item.product == product)) {
      // Если есть, то увеличиваем счетчик товара на 1
      int index = cartItems.indexWhere((item) => item.product == product);
      cartItems[index].quantity++;
    } else {
      // Если нет, то добавляем товар в корзину
      cartItems.add(CartItem(product, 1));
    }
    // Увеличиваем общую стоимость товаров в корзине
    _totalPrice += product.price;
  }

  void removeFromCart(Product product) {
    // Проверяем, есть ли такой товар в корзине
    if (cartItems.any((item) => item.product == product)) {
      // Если есть, то уменьшаем счетчик товара на 1
      int index = cartItems.indexWhere((item) => item.product == product);
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
    for (CartItem item in cartItems) {
      _totalPrice += item.product.price * item.quantity;
    }

    return _totalPrice;
  }

  void clearCart() {
    // Очищаем корзину и обнуляем общую стоимость
    cartItems.clear();
    _totalPrice = 0;
  }
}