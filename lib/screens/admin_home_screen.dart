import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:mobile_app_internet_shop/profile.dart';
import 'package:mobile_app_internet_shop/widgets/admin_product_list.dart';

import 'home_screen.dart';

class AdminHomeScreen extends HomeScreen {
  AdminHomeScreen({super.key, required Profile profile, required AppDatabase appDatabase})
      : super(profile: profile, appDatabase: appDatabase);

  // Реализуем абстрактный метод класса предка HomeScreen
  @override
  Widget buildProductList() {
    // Просто возвращаем список товаров админа для отображения его при выборе
    // раздела BottomNavigationBarItem "Каталог"
    return AdminProductList(appDatabase: appDatabase);
  }
}
