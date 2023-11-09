import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/models/cart_model.dart';
import 'package:mobile_app_internet_shop/screens/authorization_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  ChangeNotifierProvider(
      create: (context) => CartModel.getInstance(),
    child: const InternetShop(),
  )
);

class InternetShop extends StatelessWidget {
  const InternetShop({super.key});

  @override
  Widget build(BuildContext context) {
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
