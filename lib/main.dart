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
import 'package:mobile_app_internet_shop/models/cart_model.dart';
import 'package:mobile_app_internet_shop/screens/authorization_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  // ChangeNotifierProvider это виджет,
  // который предоставляет экземпляр ChangeNotifier своим потомкам.
  // Определяем конструктор, который создает новый экземпляр из CartModel.
  ChangeNotifierProvider(
      create: (context) => CartModel.getInstance(),
    child: const InternetShop(),
  )
);

class InternetShop extends StatelessWidget {
  const InternetShop({super.key});

  @override
  Widget build(BuildContext context) {
    // Создаём виджет верхнего уровня
    return MaterialApp(
      title: 'Интернет-магазин',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthorizationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
