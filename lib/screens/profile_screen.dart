import 'package:flutter/material.dart';

import '../profile.dart';
import 'authorization_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Profile profile;

  const ProfileScreen({super.key, required this.profile});

  // Метод перехода на страницу авторизации при разовтаризации пользователя
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthorizationScreen()),
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