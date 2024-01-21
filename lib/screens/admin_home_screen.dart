import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:mobile_app_internet_shop/models/cart_model.dart';
import 'package:mobile_app_internet_shop/product.dart';
import 'package:mobile_app_internet_shop/profile.dart';
import 'package:mobile_app_internet_shop/screens/profile_screen.dart';
import 'package:mobile_app_internet_shop/widgets/admin_product_list.dart';
import 'package:mobile_app_internet_shop/widgets/cart_badge.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_screen.dart';
import '../widgets/favorite_list.dart';

enum MethodOfSorting {
  byPriceIncrease('По цене↑'),
  byPriceDecrease('По цене↓'),
  byAlphabet('По названию↑'),
  byReverseAlphabet('По названию↓');

  const MethodOfSorting(this.label);
  final String label;
}

class AdminHomeScreen extends StatefulWidget {
  AppDatabase appDatabase;
  Profile profile;

  AdminHomeScreen({super.key, required this.profile, required this.appDatabase});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
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

  Future<String> getSortingMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('methodOfSorting') ?? MethodOfSorting.byPriceIncrease
        .toString();
  }

  @override
  void initState() {
    super.initState();

    // Добавление виджетов списка товаров админинистратора и экрана профилей
    // для использования в нижней панели BottomNavigationBarItem
    widgets.add(AdminProductList(appDatabase: widget.appDatabase));
    widgets.add(FavoriteList(appDatabase: widget.appDatabase));
    widgets.add(ProfileScreen(profile: widget.profile, appDatabase: widget.appDatabase));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: DropdownMenu<MethodOfSorting>(
            dropdownMenuEntries: MethodOfSorting
                .values
                .map<DropdownMenuEntry<MethodOfSorting>>(
                  (MethodOfSorting methodOfSorting) {
                return DropdownMenuEntry<MethodOfSorting>(
                  value: methodOfSorting,
                  label: methodOfSorting.label,
                  // leadingIcon: Icon(icon.icon),
                );
              },
            ).toList(),),
          // title: const Text('Интернет-магазин'),
          actions: <Widget>[
            Expanded(
                child: DropdownMenu<MethodOfSorting>(
                  dropdownMenuEntries: MethodOfSorting
                      .values
                      .map<DropdownMenuEntry<MethodOfSorting>>(
                        (MethodOfSorting methodOfSorting) {
                      return DropdownMenuEntry<MethodOfSorting>(
                        value: methodOfSorting,
                        label: methodOfSorting.label,
                        // leadingIcon: Icon(icon.icon),
                      );
                    },
                  ).toList(),),
            ),
            // Consumer позволяет использовать CartModel,
            // который прослушивается через ChangeNotifierProvider,
            // отслеживающий все изменения происходящие в CartModel
            Consumer<CartModel>(
              // Использование счётчика товаров на значке корзины
              builder: (context, cart, child) => CartBadge(
                // Получение значения количества товаров,
                // находящихся в корзине
                value:
                    '${Provider.of<CartModel>(context, listen: false).getItemsCount()}',
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CartScreen(appDatabase: widget.appDatabase,)));
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
              icon: Icon(Icons.favorite),
              label: ('Избранное'),
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
