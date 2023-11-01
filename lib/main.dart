/// Бизнес-логика добавления товара ещё полностью не закончена
/// (не открывается json файл для записи данных с добавленным товаром).
/// Но экраны авторизации,
/// с выбором перехода на экран админа либо пользователя после ввода логина и пароля,
/// экран с формой для добавления товара, открываются.

import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/screens/authorization_screen.dart';

void main() => runApp(const InternetShop());

class InternetShop extends StatelessWidget {
  const InternetShop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Интернет-магазин',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthorizationScreen(),
    );
  }
}
