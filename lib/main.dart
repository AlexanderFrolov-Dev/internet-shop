///Корректировка кода в соответствии со следующими замечаниями:
///1. HomeScreen -> ProductCard. Зачем-то вы создаете новый Product
/// и перекладываете из него всю информацию. Достаточно передать товар products[index]
///2. Использовать UniqueKey лучше не нужно - это будет заставлять виджет
///перерисовываться слишком часто. они должны работать эффективно.
///можно использовать ValueKey(product), и тогда виджет перерисуется
///только если изменится товар, к которому он привязан
///3. советую каждому товару сразу добавить поле id,
///которое будет уникально (например, число 1, 2, 3...)

import 'package:flutter/material.dart';

import 'components/home_screen.dart';

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
