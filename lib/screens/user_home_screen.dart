import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/app_database.dart';

import 'home_screen.dart';
import '../profile.dart';
import '../widgets/user_product_list.dart';

class UserHomeScreen extends HomeScreen {
  UserHomeScreen({super.key, required Profile profile, required AppDatabase appDatabase})
      : super(profile: profile, appDatabase: appDatabase);

  // Реализуем абстрактный метод класса предка HomeScreen
  @override
  Widget buildProductList() {
    // Просто возвращаем список товаров пользователя для отображения его
    // при выборе раздела BottomNavigationBarItem "Каталог"
    return UserProductList(appDatabase: appDatabase);
  }
}
