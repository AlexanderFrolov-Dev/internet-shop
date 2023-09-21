import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Cart.dart';
import 'CartScreen.dart';
import 'Product.dart';

class HomeScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
      name: 'iPhone 15 Pro Max',
      description: 'Apple iPhone 15 Pro Max 1TB White Titanium (Dual Sim)',
      price: 259999.0,
      imagePath: 'assets/images/Apple iPhone 15 Pro Max 1TB White Titanium (Dual Sim).jpg',
    ),
    Product(
      name: 'HONOR 70',
      description: 'HONOR 70 8+256Gb Crystal Silver',
      price: 44999.0,
      imagePath: 'assets/images/HONOR 70 8+256Gb Crystal Silver.jpg',
    ),
    Product(
      name: 'HUAWEI Mate X3',
      description: 'HUAWEI Mate X3 12/512GB Dark Green',
      price: 169999.0,
      imagePath: 'assets/images/HUAWEI Mate X3 12512GB Dark Green.jpg',
    ),
    Product(
      name: 'Infinix Note 30 VIP',
      description: 'Infinix Note 30 VIP 12/256 White (X6710)',
      price: 31999.0,
      imagePath: 'assets/images/Infinix Note 30 VIP 12256 White (X6710).jpg',
    ),
    Product(
      name: 'realme GT 2 PRO',
      description: 'realme GT 2 PRO 12/256GB Paper White (RMX3301)',
      price: 49999.0,
      imagePath: 'assets/images/realme GT 2 PRO 12256GB Paper White (RMX3301).jpg',
    ),
    Product(
      name: 'Samsung Galaxy Z Fold5',
      description: 'Samsung Galaxy Z Fold5 512GB Icy Blue (SM-F946B)',
      price: 199999.0,
      imagePath: 'assets/images/Samsung Galaxy Z Fold5 512GB Icy Blue (SM-F946B).jpg',
    ),
    Product(
      name: 'Xiaomi 13 Ultra',
      description: 'Xiaomi 13 Ultra 512Gb Black',
      price: 139999.0,
      imagePath: 'assets/images/Xiaomi 13 Ultra 512Gb Black.jpg',
    ),
  ];

  final Cart cart = Cart();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cart: cart),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(products[index].imagePath),
            // leading: Image.asset('assets/images/product_1.jpg'),
            title: Text(products[index].name),
            subtitle: Text(products[index].description),
            trailing: Text('${products[index].price} ₽'),
            onTap: () {
              cart.addItem(products[index]);
            },
          );
        },
      ),
    );
  }
}