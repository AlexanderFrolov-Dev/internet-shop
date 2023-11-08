import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_internet_shop/profile.dart';
import 'package:mobile_app_internet_shop/screens/registration_screen.dart';
import 'package:mobile_app_internet_shop/screens/user_home_screen.dart';

import 'admin_home_screen.dart';

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
                String username = _usernameController.text;
                String password = _passwordController.text;
                bool isCredentialsValid = false;

                // Цикл для перебора элементов в списке json данных
                for (var i = 0; i < profiles.length; i++) {
                  // Получаем текущий элемент json
                  var profile = profiles[i];

                  // Проверяем совпадение значений переменных с данными из текущего элемента json
                  if (username == profile.login && password == profile.password) {
                    // Если значения совпадают, выводим сообщение об успешной авторизации
                    isCredentialsValid = true;
                    if(profile.role == 'admin') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
                      );
                    } else if(profile.role == 'user') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserHomeScreen()),
                      );
                    }

                    // Прерываем цикл, чтобы не проверять остальные элементы
                    break;
                  }
                }

                // Если значения не совпадают, выводим сообщение об ошибке авторизации
                if (!isCredentialsValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Неверный логин или пароль',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
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