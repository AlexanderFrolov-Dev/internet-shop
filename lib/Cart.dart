import 'Product.dart';

class Cart {
  List<Product> items = [];

  void addItem(Product product) {
    items.add(product);
  }

  void removeItem(Product product) {
    items.remove(product);
  }

  List<Product> getItems() {
    return items;
  }
}