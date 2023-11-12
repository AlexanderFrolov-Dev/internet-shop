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

  void login() async {
    Profile.getProfiles(profiles);

    // Проверяем, что поля логина и пароля не пустые
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      // Определение роли пользователя (админ или обычный пользователь)
      Profile profile = getProfile(_usernameController.text, _passwordController.text);
      String role = profile.role;

      if (role == 'admin') {
        // Сохраняем факт авторизации в shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Переходим на экран администратора
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen(profileId: profile.id)),
        );
      } else if (role == 'user') {
        // Сохраняем факт авторизации в shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Переходим на экран пользователя
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHomeScreen()),
        );
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

  @override
  Widget build(BuildContext context) {
    // Profile.getProfiles(profiles);

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

                // String username = _usernameController.text;
                // String password = _passwordController.text;
                // bool isCredentialsValid = false;
                //
                // // Цикл для перебора элементов в списке json данных
                // for (var i = 0; i < profiles.length; i++) {
                //   // Получаем текущий элемент json
                //   var profile = profiles[i];
                //
                //   // Проверяем совпадение значений переменных с данными из текущего элемента json
                //   if (username == profile.login && password == profile.password) {
                //     // Если значения совпадают, выводим сообщение об успешной авторизации
                //     isCredentialsValid = true;
                //     if(profile.role == 'admin') {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
                //       );
                //     } else if(profile.role == 'user') {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => const UserHomeScreen()),
                //       );
                //     }
                //
                //     // Прерываем цикл, чтобы не проверять остальные элементы
                //     break;
                //   }
                // }
                //
                // // Если значения не совпадают, выводим сообщение об ошибке авторизации
                // if (!isCredentialsValid) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text(
                //         'Неверный логин или пароль',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(color: Colors.white),
                //       ),
                //       backgroundColor: Colors.blue,
                //     ),
                //   );
                // }
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