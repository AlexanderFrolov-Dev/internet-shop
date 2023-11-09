import 'dart:convert';

import 'package:flutter/services.dart';

class Profile {
  final int id;
  String role;
  String lastName;
  String firstName;
  String patronymic;
  String login;
  String password;

  Profile(
      {required this.id,
      required this.role,
      required this.lastName,
      required this.firstName,
      required this.patronymic,
      required this.login,
      required this.password});

  // Создаем фабричный конструктор для удобного парсинга данных из json
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      role: json['role'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      patronymic: json['patronymic'],
      login: json['login'],
      password: json['password'],
    );
  }

  // Метод для получения данных о профилях из JSON-файла
  static Future<void> getProfiles(List<Profile> profiles) async {
    // Получение данных из JSON-файла с помощью метода rootBundle
    final jsonProfiles = await rootBundle.loadString('assets/data/profiles.json');

    // Преобразование полученных данных в формат JSON
    final jsonData = json.decode(jsonProfiles);

    // Проход по списку товаров и создание экземпляров класса Product
    for (var profile in jsonData) {
      profiles.add(Profile.fromJson(profile));
    }
  }
}
