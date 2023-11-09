/// Код отредактирован с учетом рекомендаций от 30.10.2023:
///
/// Насчет provider идея была хорошая - предлагаю к ней вернуться.
/// Она позволит обновлять только нужные места в приложении без setState,
/// который перестраивает весь экран. Предлагаю вернуться к нему и доделать
///
/// Основной концепт: создается модель,
/// в нужных местах виджеты читают из нее значения и подписываются на изменения.
/// Когда в моделе что-то меняется - она уведомляет о своем изменении
/// и виджеты перерисовываются
///
/// 1. Создаете класс модели корзины (extends ChangeNotifier).
/// Тут два пути, либо это будет отдельный класс CartModel,
/// который внутрь принимает вашу корзину Cart и передает ей действия,
/// либо может прям ваш Cart напрямую быть моделью
///
/// 2. Объявляете эту модель над всем приложением
///
/// 3. Далее в любом месте приложения можете получить к ней
/// доступ и работать с ней так же, как вы работали с вашей корзиной
/// - через context.read<CartModel>() если нужно вызывать какое-то действие
/// (например, по нажатию на кнопку
/// - через context.watch<CartModel>() если нужно прочитать какое-то значение
/// и подписаться на все изменения модели
/// - через чуть более сложный context.select<CartModel>(...)
/// если нужно слушать только определенные изменения модели, а не вообще все
///
/// 4. в методах, что-то изменяющих (добавление, удаление товаров)
/// в модели вызывается notifyListeners(), и все виджеты,
/// которые слушают эти изменения, обновятся
///
/// 5. давайте еще у иконки корзины на главном экране (в аппбаре)
/// добавим счетчик товаров,
/// который будет обновляться при добавлении товара в корзину.
/// это тоже очень удобно сделать через provider

import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/models/cart_model.dart';
import 'package:mobile_app_internet_shop/screens/admin_home_screen.dart';
import 'package:mobile_app_internet_shop/screens/authorization_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("email");
  print(email);
  runApp(
    ChangeNotifierProvider(
        create: (context) => CartModel.getInstance(),
      child: MaterialApp(
        title: 'Интернет-магазин',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: email == null ? AuthorizationScreen() : const AdminHomeScreen(),
      ),
    )
  );
}



// void main() => runApp(
//   ChangeNotifierProvider(
//       create: (context) => CartModel.getInstance(),
//     child: const InternetShop(),
//   )
// );
//
// class InternetShop extends StatelessWidget {
//   const InternetShop({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Интернет-магазин',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AuthorizationScreen(),
//     );
//   }
// }
