import 'package:mobile_app_internet_shop/role.dart';

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
}
