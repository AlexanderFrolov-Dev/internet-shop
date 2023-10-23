///Корректировка кода в соответствии со следующими замечаниями:
///1. HomeScreen -> ProductCard. Зачем-то вы создаете новый Product
/// и перекладываете из него всю информацию. Достаточно передать товар products[index]
///2. Использовать UniqueKey лучше не нужно - это будет заставлять виджет
///перерисовываться слишком часто. они должны работать эффективно.
///можно использовать ValueKey(product), и тогда виджет перерисуется
///только если изменится товар, к которому он привязан
///3. советую каждому товару сразу добавить поле id,
///которое будет уникально (например, число 1, 2, 3...)
///4. давайте улучшим корзину - добавим на карточку счетчик товаров
///(со стрелочками - и +),
///а когда товар добавляется в корзину несколько раз - он не дублируется,
///а увеличивается счетчик. если счетчик доходит до 0 - товар из корзины удаляется.
///внизу корзины находится общая сумма всех товаров в корзине, и кнопка "Купить",
///по нажатию на которую корзина очищается, и выводится сообщение "Успешно"

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_model.dart';
import 'components/home_screen.dart';

void main() => runApp(InternetShop());

class InternetShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
      ],
      child: MaterialApp(
        title: 'Интернет-магазин',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
