import 'package:flutter/material.dart';

import '../profile.dart';

class RegistrationScreen extends StatelessWidget {
  final List<Profile> profiles = [];
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _patronymicController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegistrationScreen({super.key});


  // TODO: и прочие методы валидации вводимых данных
  String lengthValidation(int length, String s) {
    return s.length < length
        ? 'Длина строки должна равняться $length или более символов' : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: Center(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Фамилия',
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Имя',
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _patronymicController,
                decoration: const InputDecoration(
                  labelText: 'Отчество',
                ),
              ),
              const SizedBox(height: 20.0),
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
                onPressed: () {
                  // TODO: код для обработки нажатия кнопки "Зарегистрироваться"
                  // TODO: в случае успешной валидации вводимых данных,
                  // TODO: отправлять письмо с кодом для подтверждения регистрации
                  // TODO: на указанный email
                },
                child: const Text('Зарегистрироваться'),
              ),
            ],
          ),
        )
      ),
    );
  }
}