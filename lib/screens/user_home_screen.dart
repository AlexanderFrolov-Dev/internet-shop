import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/product.dart';
import 'package:mobile_app_internet_shop/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../profile.dart';
import '../widgets/cart_badge.dart';
import '../widgets/user_product_list.dart';
import 'cart_screen.dart';

class UserHomeScreen extends StatefulWidget {
  Profile profile;

  UserHomeScreen({super.key, required this.profile});

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List<Product> products = [];
  List<Widget> widgets = <Widget>[];
  int _selectedIndex = 0;

  // При нажатии на элемент BottomNavigationBarItem записывает его индекс в
  // переменную _selectedIndex
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    // Добавление виджетов списка товаров админинистратора и экрана профилей
    // для использования в нижней панели BottomNavigationBarItem
    widgets.add(const UserProductList());
    widgets.add(ProfileScreen(profile: widget.profile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Интернет-магазин'),
          actions: <Widget>[
            // Consumer позволяет использовать CartModel,
            // который прослушивается через ChangeNotifierProvider,
            // отслеживающий все изменения происходящие в CartModel
            Consumer<CartModel>(
              builder: (context, cart, child) => CartBadge(
                value: '${Provider.of<CartModel>(context, listen: false).getItemsCount()}',
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
