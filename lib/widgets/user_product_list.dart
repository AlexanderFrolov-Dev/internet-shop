import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_internet_shop/screens/authorization_screen.dart';
import 'package:mobile_app_internet_shop/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_database.dart';
import '../product.dart';
import '../sorting_method.dart';

class UserProductList extends StatefulWidget {
  AppDatabase appDatabase;

  UserProductList({
    super.key,
    required this.appDatabase,
  });

  @override
  State<UserProductList> createState() => _UserProductListState();
}

class _UserProductListState extends State<UserProductList> {
  List<Product> products = [];
  SortingMethod? initialSortingMethod;
  SortingMethod? selectedSortingMethod;

  @override
  void initState() {
    super.initState();
    // Получение начального значения метода сортировки.
    // initialSortingMethod = getSortingMethod(AuthorizationScreen.initialSortingValue);
    // Вызов метода для получения данных о товарах при инициализации экрана
    // getProducts();

    getProducts().then((value) => {
     loadInitialSortingMethod()
    });

    // loadInitialSortingMethod();

    // getSortedListOfProducts(initialSortingMethod!);
  }

  void loadInitialSortingMethod() async {
    String sortingMethodValue = '';
    // await getSortingMethodValue().then((value) => sortingMethodValue);
    // initialSortingMethod = getSortingMethod(sortingMethodValue);
    // await getProducts();
    // getSortedListOfProducts(initialSortingMethod!);

    await getSortingMethodValue().then((value) => {
      sortingMethodValue = value,
      print('sortingMethodValue: $sortingMethodValue'),
      initialSortingMethod = getSortingMethod(sortingMethodValue),
      print('initialSortingMethod: $initialSortingMethod'),
      print('products length: ${products.length}'),
      getSortedListOfProducts(initialSortingMethod!)
    });
  }

  SortingMethod? getSortingMethod(String valueOfSorting) {
    SortingMethod? sortingMethod;
    print('valueOfSorting: $valueOfSorting');
    for (SortingMethod value in SortingMethod.values) {
      if (value.label == valueOfSorting) {
        sortingMethod = value;
        break;
      }
    }

    print('sortingMethod: ${sortingMethod?.label}');
    return sortingMethod;
  }

  void setSortingMethod(SortingMethod sortingMethod) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('methodOfSorting', sortingMethod.label);
  }

  Future<String> getSortingMethodValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('methodOfSorting') ?? 'По цене↑';
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
          // Выпадающий список сортировки.
          DropdownMenu<SortingMethod>(
            initialSelection: initialSortingMethod,
            requestFocusOnTap: true,
            label: const Text('Фильтры'),
            onSelected: (SortingMethod? sortingMethod) {
              setState(() {
                selectedSortingMethod = sortingMethod;
                setSortingMethod(selectedSortingMethod!);
                getSortedListOfProducts(selectedSortingMethod!);
              });
            },
            // Выпадающий список состоит из списка элементов DropdownMenuEntry.
            dropdownMenuEntries: SortingMethod.values
                .map<DropdownMenuEntry<SortingMethod>>(
                    (SortingMethod methodOfSorting) {
                  return DropdownMenuEntry<SortingMethod>(
                      value: methodOfSorting,
                      label: methodOfSorting.label
                  );
                }).toList(),
          ),
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
          )
        ])
    );
  }
}