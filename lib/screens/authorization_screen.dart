import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/models/cart_model.dart';
import 'package:mobile_app_internet_shop/profile.dart';
import 'package:mobile_app_internet_shop/screens/registration_screen.dart';
import 'package:mobile_app_internet_shop/screens/user_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_home_screen.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({Key? key}) : super(key: key);

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  CartModel cartModel = CartModel.getInstance();
  List<Profile> profiles = [];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoggedIn = false;
  bool passwordVisible = false;
  bool isLoading = true;
  int profileId = 0;

  @override
  void initState() {
    super.initState();

    loadAuthorizationData();
  }

  // Загружаем профили пользователей,
  // присваиваем переменным profileId и isLoggedIn
  // соответствующие значения из SharedPreferences
  void loadAuthorizationData() async {
    await getProfileList().then((value) => setState(() {
        isLoading = false;
        profiles.addAll(value);
      })
    );
    await saveIdOfAuthorizedUser();
    // _checkLoginStatus();
  }

  // // Загружаем профили пользователей,
  // // присваиваем переменным profileId и isLoggedIn
  // // соответствующие значения из SharedPreferences
  // Future<void> loadAuthorizationData() async {
  //   await getProfileList().then((value) {
  //     profiles.addAll(value);
  //     isLoading = false;
  //   });
  //   // await saveIdOfAuthorizedUser();
  //   // _checkLoginStatus();
  // }

  // Создаём Future для получения профилей
  Future<List<Profile>> getProfileList() async {
    return await Profile.getProfiles();
  }

  Future<void> saveIdOfAuthorizedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileId = prefs.getInt('profileId') ?? 0;
    });
  }

  // Проверяем, авторизован ли пользователь.
  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      setState(() {
        if(profileId > 0) {
          setState(() {
            Profile profile = profiles.firstWhere((p) => p.id == profileId);

            String role = profile.role;

            // Определение роли пользователя (админ или обычный пользователь)
            if (role == 'admin') {
              // Переходим на экран администратора
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminHomeScreen(profile: profile)),
              );
            } else if (role == 'user') {
              // Переходим на экран пользователя
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UserHomeScreen(profile: profile)),
              );
            }

            cartModel.restoreCartFromDb();
          });
        }
      });
    }
  }

  // Получаем профиль из списка по логину и паролю.
  // Если не находим профиль в списке возвращаем null
  Profile? getProfile(String username, String password) {
    for (var profile in profiles) {
      if (username == profile.login && password == profile.password) {
        return profile;
      }
    }

    return null;
  }

  Profile getAuthorizedProfile(int id) {
    return profiles.firstWhere((profile) => profile.id == id);
  }

  void login() async {
    Profile? profile =
        getProfile(_usernameController.text, _passwordController.text);

    print('profile firstName: ${profile?.firstName}');

    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        profile == null) {
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
    } else {
      // Сохраняем факт авторизации в shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      print('isLoggedIn in AuthorizationScreen: ${prefs.getBool('isLoggedIn')}');
      await prefs.setInt('profileId', profile.id);

      await goToScreenByUserRole(profile);
    }
  }

  Future<void> goToScreenByUserRole(Profile profile) async {
    String role = profile.role;

    // Определение роли пользователя (админ или обычный пользователь)
    if (role == 'admin') {
      // Переходим на экран администратора
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AdminHomeScreen(profile: profile)),
      );
    } else if (role == 'user') {
      // Переходим на экран пользователя
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => UserHomeScreen(profile: profile)),
      );
    }

    await cartModel.restoreCartFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Авторизация'),
      ),
      // Если isLoading = true (т. е. мы имитируем неоконченную загрузку профилей)
      body: isLoading
          // то показываем круговой индикатор прогресса (CircularProgressIndicator)
          ? const Center(child: CircularProgressIndicator())
          // иначе отображаем форму для ввода логина и пароля
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Логин',
                      ),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: login,
                      child: const Text('Войти'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationScreen()),
                        );
                      },
                      child: const Text('Зарегистрироваться'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
