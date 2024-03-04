import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_database.dart';
import 'models/cart_model.dart';
import 'models/favorite_products_model.dart';

class InternetShop extends StatelessWidget {
  final Widget? widget;
  final AppDatabase appDatabase;
  const InternetShop({super.key, required this.widget, required this.appDatabase});

  @override
  Widget build(BuildContext context) {
    // Создаём виджет верхнего уровня
    return
      // MultiProvider это виджет,
      // который предоставляет экземпляры нескольких ChangeNotifier своим потомкам.
      // Определяем конструктор, который создает новый экземпляр из CartModel.
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => CartModel.getInstance(appDatabase)),
            ChangeNotifierProvider(create: (context) => FavoriteProductsModel.getInstance(appDatabase))
          ],
          child: MaterialApp(
            title: 'Интернет-магазин',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: widget,
            debugShowCheckedModeBanner: false,
          ));
  }
}