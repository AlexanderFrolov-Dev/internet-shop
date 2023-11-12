import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_internet_shop/models/cart_model.dart';
import 'package:mobile_app_internet_shop/product.dart';
import 'package:mobile_app_internet_shop/profile.dart';
import 'package:mobile_app_internet_shop/screens/add_product_form.dart';
import 'package:mobile_app_internet_shop/screens/profile_screen.dart';
import 'package:mobile_app_internet_shop/widgets/cart_badge.dart';
import 'package:mobile_app_internet_shop/widgets/product_card.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  late int profileId;
  AdminHomeScreen({super.key, required this.profileId});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Product> products = [];
  static const List<Widget> widgets = <Widget> [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Вызов метода для получения данных о товарах при инициализации экрана
    getProducts();
  }

  // Метод для получения данных о товарах из JSON-файла
  Future<void> getProducts() async {
    // Получение данных из JSON-файла с помощью метода rootBundle
    final jsonProducts =
        await rootBundle.loadString('assets/data/products.json');

    // Преобразование полученных данных в формат JSON
    final jsonData = json.decode(jsonProducts);

    // Проход по списку товаров и создание экземпляров класса Product
    for (var product in jsonData) {
      products.add(Product.fromJson(product));
    }

    // Обновление состояния виджета для отображения полученных данных
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Profile> profiles = [];
    Profile.getProfiles(profiles);
    late Profile profile;

    // Цикл для перебора элементов в списке json данных
    for (var i = 0; i < profiles.length; i++) {
      // Получаем текущий элемент json
      var currentProfile = profiles[i];

      // Проверяем совпадение значений переменных с данными из текущего элемента json
      if (currentProfile.id == widget.profileId) {
        // Если значения совпадают, выводим сообщение об успешной авторизации
        profile = currentProfile;

        // Прерываем цикл, чтобы не проверять остальные элементы
        break;
      }
    }


    // Profile profile = getProfile(_usernameController.text, _passwordController.text);

    widgets.add(AdminHomeScreen(profileId: widget.profileId,));
    widgets.add(ProfileScreen(profile: profile,));

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
        body: Column(
          children: [
            Flexible(
              flex: 5,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    key: ValueKey(products[index]),
                    product: products[index],
                  );
                },
              ),
            ),
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddProductForm()),
                    );
                  },
                  child: const Text('Добавить товар'),
                ),
              ),
            ),
            BottomNavigationBar(
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
            currentIndex: _onItemTapped,)
          ],
        ));
  }
}
