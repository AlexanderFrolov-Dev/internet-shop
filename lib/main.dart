/// Код соответствует рекомендациям от 03.11.2023
///
/// 1. в случае ввода неверного логина/пароля выводить пользователю сообщение,
/// а то сейчас визуально ничего не происходит
///
/// 2. после успешного входа сохранять, что пользователь авторизован.
/// входить каждый раз утомительно) для этого посмотрите пакет
/// https://pub.dev/packages/shared_preferences
/// он очень широко используется в разработке для хранения простых типов данных
///
/// 3. раз мы сохранили факт авторизации,
/// надо пользователю дать возможность разавторизоваться.
/// заодно изучим новый визуальный компонент -
/// давайте на главном экране снизу сделаем бар,
/// где будет две вкладки - одна это список товаров как сейчас,
/// а другая это профиль, где выводится,
/// под каким логином авторизовался пользователя и кнопка Выйти,
/// которая разавторизует пользователя и перекидывает его на экран логина.
/// для этого используйте стандартный компонент BottomNavigationBar
/// https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html

import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:mobile_app_internet_shop/models/cart_model.dart';
import 'package:mobile_app_internet_shop/models/favorite_products_model.dart';
import 'package:mobile_app_internet_shop/profile.dart';
import 'package:mobile_app_internet_shop/screens/admin_home_screen.dart';
import 'package:mobile_app_internet_shop/screens/authorization_screen.dart';
import 'package:mobile_app_internet_shop/screens/user_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  AppDatabase appDatabase = AppDatabase();
  CartModel cartModel = CartModel.getInstance(appDatabase);
  FavoriteProductsModel favoriteProductsModel = FavoriteProductsModel.getInstance(appDatabase);
  List<Profile> profiles = [];
  Widget? homeScreen;
  // await Profile.getProfiles().then((value) => profiles.addAll(value));
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  int profileId = prefs.getInt('profileId') ?? 0;
  bool isLoading = true;

  await Profile.getProfiles().then((value) => profiles.addAll(value));

  if(profileId > 0) {
    Profile profile = profiles.firstWhere((profile) => profile.id == profileId);
    String role = profile.role;

    if(role == 'admin') {
      homeScreen = AdminHomeScreen(profile: profile, appDatabase: appDatabase);
    } else if(role == 'user') {
      homeScreen = UserHomeScreen(profile: profile, appDatabase: appDatabase);
    }
    isLoading = false;
  } else {
    homeScreen = AuthorizationScreen(appDatabase: appDatabase);
    isLoading = false;
  }

  cartModel.restoreCartFromDb();
  favoriteProductsModel.restoreFavoriteFromDb();

  runApp(
    // MultiProvider это виджет,
    // который предоставляет экземпляры нескольких ChangeNotifier своим потомкам.
    // Определяем конструктор, который создает новый экземпляр из CartModel.
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => CartModel.getInstance(appDatabase)),
            ChangeNotifierProvider(create: (context) => FavoriteProductsModel.getInstance(appDatabase)),
          ],
          child: InternetShop(widget: isLoading // Передаем значение isLoading в качестве параметра
              ? const Center(child: CircularProgressIndicator()) // если isLoading=true, то выводим индикатор прогресса
              : homeScreen!, // иначе выводим homeScreen)
          )
      ));

  // runApp(
  //   // ChangeNotifierProvider это виджет,
  //   // который предоставляет экземпляр ChangeNotifier своим потомкам.
  //   // Определяем конструктор, который создает новый экземпляр из CartModel.
  //     ChangeNotifierProvider(
  //       create: (context) => CartModel.getInstance(appDatabase),
  //       child: InternetShop(widget: isLoading // Передаем значение isLoading в качестве параметра
  //           ? const Center(child: CircularProgressIndicator()) // если isLoading=true, то выводим индикатор прогресса
  //           : homeScreen!, // иначе выводим homeScreen)
  //     )
  // ));

  // isLoading = false;
}

class InternetShop extends StatelessWidget {
  Widget widget;
  InternetShop({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    // Создаём виджет верхнего уровня
    return MaterialApp(
      title: 'Интернет-магазин',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: widget,
      debugShowCheckedModeBanner: false,
    );
  }
}
