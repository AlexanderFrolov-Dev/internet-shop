import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:mobile_app_internet_shop/models/cart_model.dart';
import 'package:mobile_app_internet_shop/profile.dart';
import 'package:mobile_app_internet_shop/screens/cart_screen.dart';
import 'package:mobile_app_internet_shop/screens/profile_screen.dart';
import 'package:mobile_app_internet_shop/widgets/cart_badge.dart';
import 'package:provider/provider.dart';

import '../../widgets/favorite_list.dart';

abstract class HomeScreen extends StatefulWidget {
  final AppDatabase appDatabase;
  final Profile profile;

  const HomeScreen({
    Key? key,
    required this.profile,
    required this.appDatabase,
  }) : super(key: key);

  // Абстрактный метод для его реализации в классах потомках.
  Widget buildProductList();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    // Добавление виджетов списка товаров и экрана профилей
    // для использования в нижней панели BottomNavigationBarItem

    // Абстрактный метод buildProductList() реализуется в классах потомках ,
    // в них этот метод просто будет возвращать соответствующий класс
    // UserProductList или AdminProductList для отображения раздела
    // каталога товаров в панели BottomNavigationBarItem.
    // Т. е. можно считать, что здесь просто добавляются виджеты
    // UserProductList или AdminProductList (в зависимости от класса потомка),
    // виджет избранных товаров и виджет профиля.
    widgets.add(widget.buildProductList());
    widgets.add(FavoriteList(appDatabase: widget.appDatabase));
    widgets.add(ProfileScreen(profile: widget.profile, appDatabase: widget.appDatabase));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Интернет-магазин'),
          actions: <Widget>[
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
