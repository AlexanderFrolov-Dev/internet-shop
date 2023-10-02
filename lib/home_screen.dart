import 'dart:convert';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map products = {};

  get data => null;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final assetBundle = DefaultAssetBundle.of(context);
    final jsonString = await assetBundle.loadString('assets/products.json');
    final jsonData = json.decode(jsonString);
    setState(() {
      products = jsonData['products'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internet Shop'),
      ),
      body: Center(
        child: Text(data ?? 'Loading...'),
      ),
    );
  }
}