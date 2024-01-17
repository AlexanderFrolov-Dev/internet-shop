import 'package:flutter/material.dart';
import 'package:mobile_app_internet_shop/app_database.dart';
import 'package:mobile_app_internet_shop/models/favorite_products_model.dart';
import 'package:mobile_app_internet_shop/widgets/product_detail_card.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final AppDatabase appDatabase;
  final bool showCartIcon;
  final bool showFavoriteIcon;
  final bool showDeleteIcon;

  const ProductCard(
      {required Key key,
        required this.product,
        required this.appDatabase,
        required this.showCartIcon,
        required this.showFavoriteIcon,
        required this.showDeleteIcon})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // bool existInFavorites = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   setState(() {
  //     checkInFavorites();
  //   });
  // }
  //
  // void checkInFavorites() async {
  //   await FavoriteProductsModel.getInstance(widget.appDatabase)
  //       .checkProductInFavorites(widget.product).then((value) => existInFavorites = value);
  // }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   FavoriteProductsModel.getInstance(widget.appDatabase)
    //       .checkProductInFavorites(widget.product, existInFavorites);
    //   print('existInFavorites in setState: $existInFavorites');
    // });

    // print('product name: ${widget.product.name} and existInFavorites: $existInFavorites');

    return InkWell(
      onTap: () {
        // При нажатии на карточку товара открываем экран с подробным описанием
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailsCard(key: UniqueKey(),
                  product: widget.product,
                  appDatabase: widget.appDatabase),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                widget.product.image,
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
                      widget.product.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${widget.product.price} руб.',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (widget.showCartIcon)
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    // При нажатии на иконку корзины добавляем товар в корзину
                    CartModel.getInstance(widget.appDatabase).addToCart(widget.product);
                  },
                ),
              if(widget.showFavoriteIcon)
                Consumer<FavoriteProductsModel>(
                  builder: (context, model, child) {
                    // final existsInFavorites = model.favoriteItems.contains(widget.product);
                    final existsInFavorites = model.favoriteItems
                        .any((element) => element.id == widget.product.id);
                    return IconButton(
                      icon: Icon(existsInFavorites ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        if(existsInFavorites) {
                          model.removeFromFavorite(widget.product);
                        } else {
                          model.addToFavorite(widget.product);
                        }
                      },
                    );
                  },
                ),
              if(widget.showDeleteIcon)
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // При нажатии на иконку мусорного бака удаляем товар из избранного
                      FavoriteProductsModel.getInstance(widget.appDatabase)
                          .removeFromFavorite(widget.product);
                    }
                )
            ],
          ),
        ),
      ),
    );
  }
}
