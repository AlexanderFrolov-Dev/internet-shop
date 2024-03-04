import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:mobile_app_internet_shop/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../product.dart';
import '../screens/add_product_form.dart';
import '../sorting_method.dart';

class AdminProductList extends StatefulWidget {
  final AppDatabase appDatabase;

  const AdminProductList({
    super.key,
    required this.appDatabase,
  });

  @override
  State<AdminProductList> createState() => _AdminProductListState();
}

class _AdminProductListState extends State<AdminProductList> {
  List<Product> products = [];
  SortingMethod? initialSortingMethod;
  SortingMethod? selectedSortingMethod;

  @override
  void initState() {
    super.initState();
    getProducts().then((value) => {
      loadInitialSortingMethod()
    });
  }

  void loadInitialSortingMethod() async {
    String sortingMethodValue = '';
    await getSortingMethodValue().then((value) => {
      sortingMethodValue = value,
      initialSortingMethod = getSortingMethod(sortingMethodValue),
      getSortedListOfProducts(initialSortingMethod!)
    });
  }

  SortingMethod getSortingMethod(String valueOfSorting) => SortingMethod.values.firstWhere(
    (sort) => sort.name == valueOfSorting,
    orElse: () => SortingMethod.byAlphabet,
  );

  void setSortingMethod(SortingMethod sortingMethod) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('methodOfSorting', sortingMethod.name);
  }

  Future<String> getSortingMethodValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('methodOfSorting') ?? SortingMethod.byPriceIncrease.name;
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