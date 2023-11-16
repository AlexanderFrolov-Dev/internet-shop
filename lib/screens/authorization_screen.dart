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
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Profile getProfile(String username, String password) {
    late Profile profile;

    // Цикл для перебора элементов в списке json данных
    for (var i = 0; i < profiles.length; i++) {
      // Получаем текущий элемент json
      var currentProfile = profiles[i];

      // Проверяем совпадение значений переменных с данными из текущего элемента json
      if (username == currentProfile.login && password == currentProfile.password) {
        // Если значения совпадают, выводим сообщение об успешной авторизации
        profile = currentProfile;

        // Прерываем цикл, чтобы не проверять остальные элементы
        break;
      }
    }

    return profile;
  }

  void login() async {
    Profile.getProfiles(profiles);

    bool isFound = false;

    for (var i = 0; i < profiles.length; i++) {
      Profile profile = profiles[i];

      String login = '';
      String password = '';

      if (profile.login == _loginController.text) {
        login = profile.login;
      }

      if (profile.password == _passwordController.text) {
        password = profile.password;
      }

      if (login.isNotEmpty && password.isNotEmpty) {
        isFound = true;
      }
    }

    // Проверяем, что поля логина и пароля не пустые
    if (_loginController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {

      if (isFound) {
        // Определение роли пользователя (админ или обычный пользователь)
        Profile profile = getProfile(_loginController.text, _passwordController.text);
        String role = profile.role;

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
      } else {
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
              controller: _loginController,
              decoration: const InputDecoration(
                labelText: 'Логин',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Пароль',
              ),
              obscureText: true,
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