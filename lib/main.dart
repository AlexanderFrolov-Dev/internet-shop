/// Рекомендации к улучшению предыдущей версии приложения:
/// 1. имена файлов во flutter принято именовать как cart_screen.dart, home_screen.dart, cart.dart. а имена классов всё ок - CartScreen, HomeScreen, Cart
/// 2. корзина понадобится в разных местах приложения, так что для ее удобного использования посмотрите паттерн Singleton
/// 3. для карточки продукта лучше сделать отдельный виджет вместо ListTile, т.к. он будет активно видоизменяться. аналогично для карточки товара в корзине. много классов и виджетов это нормально, флаттер это приветствует. можно раскладывать их для удобства по папкам
/// 4. немного изменим поведение - на карточке товара будет иконка корзины для добавления в корзину, а по клику на всю карточку будет открываться страница подробного описания товара (отдельный экрна) с большой картинкой, ниже цена, название, описание и кнопкой Добавить в корзину. в аппбаре стрелочка вернуться назад
/// 5. сейчас список товаров задан программно коллекцией - так и подразумевалось. теперь давайте список товаров перенесем в файл json в папке assets. если не сталкивайтесь - почитайте про его структуру (в случае использования сервера ответ тоже был бы в таком формате). файл будем читать его и превращать в объекты ("парсить")

import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() => runApp(InternetShop());

class InternetShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Интернет-магазин',
      home: HomeScreen(),
    );
  }
}
