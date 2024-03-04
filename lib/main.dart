import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:mobile_app_internet_shop/models/cart_model.dart';
import 'package:mobile_app_internet_shop/models/favorite_products_model.dart';
import 'package:mobile_app_internet_shop/profile.dart';
import 'package:mobile_app_internet_shop/screens/admin_home_screen.dart';
import 'package:mobile_app_internet_shop/screens/authorization_screen.dart';
import 'package:mobile_app_internet_shop/screens/user_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'internet_shop.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  AppDatabase appDatabase = AppDatabase();
  CartModel cartModel = CartModel.getInstance(appDatabase);
  FavoriteProductsModel favoriteProductsModel = FavoriteProductsModel.getInstance(appDatabase);
  List<Profile> profiles = await Profile.getProfiles();
  Widget? homeScreen;
  int profileId = prefs.getInt('profileId') ?? 0;

  if(profileId > 0) {
    Profile profile = profiles.firstWhere((profile) => profile.id == profileId);
    String role = profile.role;

    if(role == 'admin') {
      homeScreen = AdminHomeScreen(
        profile: profile,
        appDatabase: appDatabase,
      );
    } else if(role == 'user') {
      homeScreen = UserHomeScreen(
        profile: profile,
        appDatabase: appDatabase,
      );
    }
  } else {
    homeScreen = AuthorizationScreen(appDatabase: appDatabase);
  }

  cartModel.restoreCartFromDb();
  favoriteProductsModel.restoreFavoriteFromDb();

  runApp(InternetShop(widget: homeScreen, appDatabase: appDatabase));
}
