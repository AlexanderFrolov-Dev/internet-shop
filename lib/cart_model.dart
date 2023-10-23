import 'package:flutter/cupertino.dart';
import 'package:mobile_app_internet_shop/product.dart';

import 'cart_item.dart';

class CartModel extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  double _totalPrice = 0;

  List<CartItem> get cartItems => _cartItems;
  double get totalPrice => _totalPrice;

  void addProduct(CartItem item) {
    _cartItems.add(item);
    _totalPrice += item.product.price * item.quantity;
    notifyListeners();
  }

  void removeProduct(CartItem item) {
    _cartItems.remove(item);
    _totalPrice -= item.product.price * item.quantity;
    notifyListeners();
  }
}