import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:mobile_app_internet_shop/models/cart_model.dart';
import 'package:mobile_app_internet_shop/models/favorite_products_model.dart';
import 'package:provider/provider.dart';

class FavoriteList extends StatefulWidget {
  final AppDatabase appDatabase;

  const FavoriteList({super.key, required this.appDatabase});

  @override
  _FavoriteListState createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  late FavoriteProductsModel favoriteProductsModel;
  late CartModel cartModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    favoriteProductsModel =
        FavoriteProductsModel.getInstance(widget.appDatabase);
    cartModel = CartModel.getInstance(widget.appDatabase);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FavoriteProductsModel>(
      builder: (context, cart, child) => Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: favoriteProductsModel.favoriteItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.asset(
                              favoriteProductsModel.favoriteItems
                                  .elementAt(index)
                                  .image,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    favoriteProductsModel.favoriteItems
                                        .elementAt(index)
                                        .name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    favoriteProductsModel.favoriteItems
                                        .elementAt(index)
                                        .description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${favoriteProductsModel.favoriteItems.elementAt(index).price} руб.',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                              children: [
                                IconButton(
                                    // Добавление товара в корзину
                                    onPressed: () {
                                      cartModel.addToCart(favoriteProductsModel
                                          .favoriteItems
                                          .elementAt(index));
                                    },
                                    icon: const Icon(Icons.shopping_cart)),
                                IconButton(
                                    // Удаление товара из избранного
                                    onPressed: () {
                                      favoriteProductsModel.removeFromFavorite(
                                          favoriteProductsModel.favoriteItems
                                              .elementAt(index));
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ))
                          ],
                        ),
                      ),
                    );
                  })),
        ],
      ),
    ));
  }
}
