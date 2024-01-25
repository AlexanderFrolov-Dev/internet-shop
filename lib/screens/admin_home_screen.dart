import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:mobile_app_internet_shop/profile.dart';
import 'package:mobile_app_internet_shop/widgets/admin_product_list.dart';

import 'home_screen.dart';

class AdminHomeScreen extends HomeScreen {
  AdminHomeScreen({super.key, required Profile profile, required AppDatabase appDatabase})
      : super(profile: profile, appDatabase: appDatabase);

  @override
  Widget buildProductList() {
    return AdminProductList(appDatabase: appDatabase);
  }
}
