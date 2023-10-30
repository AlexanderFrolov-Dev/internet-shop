import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_internet_shop/profile.dart';

class AuthorizationScreen extends StatelessWidget {
  List<Profile> profiles = [];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Метод для получения данных о профилях из JSON-файла
  Future<void> getProfiles() async {
    // Получение данных из JSON-файла с помощью метода rootBundle
    final jsonProfiles = await rootBundle.loadString('assets/data/profiles.json');

    // Преобразование полученных данных в формат JSON
    final jsonData = json.decode(jsonProfiles);

    // Проход по списку товаров и создание экземпляров класса Product
    for (var profile in jsonData) {
      profiles.add(Profile.fromJson(profile));
    }
  }

  @override
  Widget build(BuildContext context) {
    getProfiles();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
            SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text('Вход'),
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;

                // цикл для перебора элементов в списке json данных
                for (var i = 0; i < profiles.length; i++) {
                  // получаем текущий элемент json
                  var profile = profiles[i];

                  // проверяем совпадение значений переменных с данными из текущего элемента json
                  if (username == profile.login && password == profile.password) {
                    // если значения совпадают, выводим сообщение об успешной авторизации
                    print('Авторизация успешна');
                    print(profile.lastName);
                    break; // прерываем цикл, чтобы не проверять остальные элементы
                  } else {
                    print('Неверный логин или пароль');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}