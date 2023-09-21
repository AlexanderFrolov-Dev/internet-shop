import 'package:flutter/material.dart';

import 'HomeScreen.dart';

void main() {
  runApp(InternetShop());
}

class InternetShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Internet Shop App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
