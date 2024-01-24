import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:mobile_app_internet_shop/screens/authorization_screen.dart';
import 'package:mobile_app_internet_shop/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../product.dart';
import '../screens/add_product_form.dart';
import '../sorting_method.dart';

class AdminProductList extends StatefulWidget {
  AppDatabase appDatabase;
  String initialSortingValue;

  AdminProductList({
    super.key,
    required this.appDatabase,
    required this.initialSortingValue
  });

  @override
  State<AdminProductList> createState() => _AdminProductListState();
}

class _AdminProductListState extends State<AdminProductList> {
  List<Product> products = [];
  SortingMethod? initialSortingMethod;
  // SortingMethod initialSortingMethod = SortingMethod.byPriceIncrease;
  SortingMethod? selectedSortingMethod;
  String test = '';

  @override
  void initState() {
    super.initState();
    // Вызов метода для получения данных о товарах при инициализации экрана
    getProducts();
    initialSortingMethod = getSortingMethod(AuthorizationScreen.initialSortingValue);
  }

  Future<String> getValueOfSortingMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sortingMethod') ?? SortingMethod.byPriceIncrease
        .toString();
  }

  SortingMethod? getSortingMethod(String valueOfSorting) {
    print('valueOfSorting: $valueOfSorting');
    SortingMethod? sortingMethod;
    for (SortingMethod value in SortingMethod.values) {
      if (value.label == valueOfSorting) {
        sortingMethod = value;
        break;
      }
    }

    print('sortingMethod: ${sortingMethod?.label}');
    return sortingMethod;
  }

  // void setInitialSortingMethod() async {
  //   String initialValueOfSorting = '';
  //   await getValueOfSortingMethod().then((value) => initialValueOfSorting);
  //   print('initialValueOfSorting: $initialSortingMethod');
  //   // initialSortingMethod = getSortingMethod(initialValueOfSorting);
  //   print('initialSortingMethod label: ${initialSortingMethod.label}');
  //
  //   // // Обновление состояния виджета для отображения полученных данных
  //   // setState(() {});
  // }

  void setSortingMethod(SortingMethod sortingMethod) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('methodOfSorting', sortingMethod.label);

    // // Обновление состояния виджета для отображения полученных данных
    // setState(() {});
  }

  void getSortedListOfProducts(SortingMethod sortingMethod) {
    switch (sortingMethod) {
      case SortingMethod.byPriceIncrease:
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortingMethod.byPriceDecrease:
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortingMethod.byAlphabet:
        products.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SortingMethod.byReverseAlphabet:
        products.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      default:
        print('Некорректный метод сортировки');
    }

    setState(() {});
  }

  // Метод для получения данных о товарах из JSON-файла
  Future<void> getProducts() async {
    // Получение данных из JSON-файла с помощью метода rootBundle
    final jsonProducts =
    await rootBundle.loadString('assets/data/products.json');

    // Преобразование полученных данных в формат JSON
    final jsonData = json.decode(jsonProducts);

    // Проход по списку товаров и создание экземпляров класса Product
    for (var product in jsonData) {
      products.add(Product.fromJson(product));
    }

    // Обновление состояния виджета для отображения полученных данных
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Column(children: [

          DropdownMenu<SortingMethod>(
            initialSelection: initialSortingMethod,
            // controller: colorController,
            // requestFocusOnTap is enabled/disabled by platforms when it is null.
            // On mobile platforms, this is false by default. Setting this to true will
            // trigger focus request on the text field and virtual keyboard will appear
            // afterward. On desktop platforms however, this defaults to true.
            requestFocusOnTap: true,
            label: const Text('Фильтры'),
            onSelected: (SortingMethod? sortingMethod) {
              setState(() {
                selectedSortingMethod = sortingMethod;
                print('selectedSortingMethod: $selectedSortingMethod');
                setSortingMethod(selectedSortingMethod!);
                getSortedListOfProducts(selectedSortingMethod!);
              });
            },
            dropdownMenuEntries: SortingMethod.values
                .map<DropdownMenuEntry<SortingMethod>>(
                    (SortingMethod methodOfSorting) {
                  return DropdownMenuEntry<SortingMethod>(
                    value: methodOfSorting,
                    label: methodOfSorting.label
                  );
                }).toList(),
          ),

          // DropdownButton<MethodOfSorting>(
          //   value: sortingMethodProvider.sortingMethod,
          //   onChanged: (value) {
          //     sortingMethodProvider.sortingMethod = value!;
          //   },
          //   items: MethodOfSorting.values.map((method) {
          //     return DropdownMenuItem<MethodOfSorting>(
          //       value: method,
          //       child: Text(method.label),
          //     );
          //   }).toList(),
          // ),
          Flexible(
            flex: 5,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  key: ValueKey(products[index]),
                  product: products[index],
                  appDatabase: widget.appDatabase,
                  showCartIcon: true,
                  showFavoriteIcon: true,
                  showDeleteIcon: false,
                );
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddProductForm()),
                  );
                },
                child: const Text('Добавить товар'),
              ),
            ),
          ),
        ])
    );
  }
}