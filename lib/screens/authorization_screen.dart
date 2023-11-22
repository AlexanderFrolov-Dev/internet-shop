import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/profile.dart';
import 'package:mobile_app_internet_shop/screens/registration_screen.dart';
import 'package:mobile_app_internet_shop/screens/user_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_home_screen.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  List<Profile> profiles = [];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoggedIn = false;
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    fillProfilesList();
    checkLoginStatus();
    passwordVisible = true;
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  void fillProfilesList() async {
    await Profile.getProfiles().then((value) => profiles = value);
  }

  Profile? getProfile(String username, String password) {
    for (var profile in profiles) {
      if (username == profile.login && password == profile.password) {
        return profile;
      }
    }

    return null;
  }

  void login() async {
    Profile? profile = getProfile(_usernameController.text, _passwordController.text);

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

        // Переходим на экран администратора
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHomeScreen(profile: profile,)));
      } else if (role == 'user') {
        // Сохраняем факт авторизации в shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Переходим на экран пользователя
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHomeScreen(profile: profile,)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Экран авторизации'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Логин',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: passwordVisible,
              decoration: InputDecoration(
                labelText: 'Пароль',
                suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(
                              () {
                            passwordVisible = !passwordVisible;
                          });
                    }),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text('Вход'),
              onPressed: () {
                login();
              },
            ),
            const SizedBox(height: 10), // Добавляем отступ между кнопками
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: const Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}