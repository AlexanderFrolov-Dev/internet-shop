import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/product.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  State<StatefulWidget> createState() => _AddProductForm();
}

class _AddProductForm extends State<AddProductForm> {
  int id = 0;
  late String name = '';
  late String description = '';
  late String image = '';
  late double price = 0.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Форма добавления товара"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        child: Column(
          children: <Widget>[
            // Поле для ввода id
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'ID',
              ),
              // Сохранение введенного значения в переменную id
              onSaved: (value) {
                id = int.parse(value!);
              },
            ),
            // Поле для ввода названия
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Название',
              ),
              // Сохранение введенного значения в переменную name
              onSaved: (value) {
                name = value!;
              },
            ),
            // Поле для ввода описания
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Описание',
              ),
              // Сохранение введенного значения в переменную description
              onSaved: (value) {
                description = value!;
              },
            ),
            // Поле для ввода пути нахождения изображения
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Изображение',
              ),
              // Сохранение введенного значения в переменную image
              onSaved: (value) {
                image = value!;
              },
            ),
            // Поле для ввода цены
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Цена',
              ),
              // Сохранение введенного значения в переменную price
              onSaved: (value) {
                price = double.parse(value!);
              },
            ),
            // Кнопка для добавления товара
            ElevatedButton(
              onPressed: () {
                // Создание экземпляра класса Product и передача значений
                Product newProduct = Product(id: id,
                    name: name,
                    description: description,
                    image: image,
                    price: price);
                // Вызов метода addProduct()
                Product.addProduct(newProduct);
              },
              child: const Text('Добавить товар'),
            ),
          ],
        ),
      )
    );
  }
}