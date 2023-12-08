import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/databases/cart_database.dart';
import 'package:mobile_app_internet_shop/models/cart_model.dart';
import 'package:mobile_app_internet_shop/profile.dart';
import 'package:mobile_app_internet_shop/screens/registration_screen.dart';
import 'package:mobile_app_internet_shop/screens/user_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_home_screen.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({Key? key}) : super(key: key);

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  CartModel cartModel = CartModel.getInstance();
  List<Profile> profiles = [];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoggedIn = false;
  bool passwordVisible = false;
  bool isLoading = true;
  int profileId = 0;
  // CartDatabase cartDatabase = CartDatabase();

  @override
  void initState() {
    super.initState();

    // dbPath().then((value) {
    //   print('Database path: $value');
    // });

    // Создаем Future для получения списка профилей.
    // Работа по получению списка профилей началась.
    getProfileList().then((value) {
      // В then мы уже получаем в качестве результата список профилей.
      setState(() {
        // После получения списка профилей присваиваем этот результат
        // переменной profiles. Меняем значение isLoading на false,
        // обозначая этим, что загрузка профилей закончена.
        // И проверяем авторизован ли пользователь,
        // с помощью вызова метода checkLoginStatus.
        profiles = value;
        isLoading = false;
        checkLoginStatus();

        if (profileId > 0) {
          Profile authorizedProfile = getAuthorizedProfile(profileId);

          if (authorizedProfile.role == 'admin') {
            // Переходим на экран администратора
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminHomeScreen(profile: authorizedProfile)),
            );
          } else if (authorizedProfile.role == 'user') {
            // Переходим на экран пользователя
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => UserHomeScreen(profile: authorizedProfile)),
            );
          }
        }
      });
    });
  }

  // Future<String> dbPath() async {
  //   return await cartDatabase.getDatabasePath();
  // }

  // Проверяем, авторизован ли пользователь.
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Присваиваем isLoggedIn значение, которое получаем по ключу 'isLoggedIn'.
      // Если значение равно null, то присваиваем значение false.
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  // Создаем Future для получения профилей.
  Future<List<Profile>> getProfileList() async {
    return await Profile.getProfiles();
  }

  // Получаем профиль из списка по логину и паролю.
  // Если не находим профиль в списке возвращаем null.
  Profile? getProfile(String username, String password) {
    for (var profile in profiles) {
      if (username == profile.login && password == profile.password) {
        return profile;
      }
    }

    return null;
  }

  Profile getAuthorizedProfile(int id) {
    return profiles.firstWhere((profile) => profile.id == id);
  }

  void login() async {
    Profile? profile =
        getProfile(_usernameController.text, _passwordController.text);

    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        profile == null) {
      // Выводим сообщение об ошибке
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ошибка'),
            content: const Text('Неверный логин или пароль.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      String role = profile.role;

      // Определение роли пользователя (админ или обычный пользователь)
      if (role == 'admin') {
        // Сохраняем факт авторизации в shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('profileId', profile.id);

        // Переходим на экран администратора
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AdminHomeScreen(profile: profile)),
        );
      } else if (role == 'user') {
        // Сохраняем факт авторизации в shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('profileId', profile.id);

        // Переходим на экран пользователя
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UserHomeScreen(profile: profile)),
        );
      }

      cartModel.restoreCartFromDB();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Авторизация'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Логин',
                      ),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: login,
                      child: const Text('Войти'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationScreen()),
                        );
                      },
                      child: const Text('Зарегистрироваться'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
