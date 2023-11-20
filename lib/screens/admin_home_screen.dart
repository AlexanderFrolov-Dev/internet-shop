import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/models/cart_model.dart';
import 'package:mobile_app_internet_shop/product.dart';
import 'package:mobile_app_internet_shop/profile.dart';
import 'package:mobile_app_internet_shop/screens/profile_screen.dart';
import 'package:mobile_app_internet_shop/widgets/admin_product_list.dart';
import 'package:mobile_app_internet_shop/widgets/cart_badge.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  Profile profile;

  AdminHomeScreen({super.key, required this.profile});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Product> products = [];
  List<Widget> widgets = <Widget>[];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    widgets.add(const AdminProductList());
    widgets.add(ProfileScreen(profile: widget.profile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Интернет-магазин'),
          actions: <Widget>[
            Consumer<CartModel>(
              builder: (context, cart, child) => CartBadge(
                value:
                    '${Provider.of<CartModel>(context, listen: false).getItemsCount()}',
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartScreen()));
                  },
                ),
              ),
            )
          ],
        ),
        body: Center(
          child: widgets.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: ('Каталог'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: ('Профиль'),
            ),
          ],
        )
    );
  }
}
