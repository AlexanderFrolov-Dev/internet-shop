import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile.dart';
import 'authorization_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AppDatabase appDatabase;
  final Profile profile;

  const ProfileScreen({super.key, required this.profile, required this.appDatabase});

  // Метод перехода на страницу авторизации при разовтаризации пользователя
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
    await prefs.setInt('profileId', 0);
    // prefs.setBool('isLoggedIn', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthorizationScreen(appDatabase: appDatabase)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Фамилия: ${profile.lastName}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Имя: ${profile.firstName}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Отчество: ${profile.patronymic}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Логин: ${profile.login}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Пароль: ${profile.password}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: В дальнейшем добавить функционал для редактирования профиля
              },
              child: const Text('Редактировать профиль'),
            ),
            ElevatedButton(
              onPressed: () {
                _logout(context);
              },
              child: const Text('Выход'),
            ),
          ],
        ),
      ),
    );
  }
}