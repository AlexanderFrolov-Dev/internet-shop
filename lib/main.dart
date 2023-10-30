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
