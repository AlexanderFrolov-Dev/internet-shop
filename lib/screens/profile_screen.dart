import 'package:flutter/material.dart';

import '../profile.dart';

class UserScreen extends StatelessWidget {
  final Profile profile;

  const UserScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
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
          ],
        ),
      ),
    );
  }
}