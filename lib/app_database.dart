import 'package:mobile_app_internet_shop/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

import 'cart_info.dart';

class AppDatabase {
  Database? _database;

  // Если БД существует, то получаем её, если нет, создаём новую
  Future<Database> get database async {
    if (_database != null) {
      return _database!;  // _database! - _database точно не null
    }

    _database = await _initDB();
    return _database!;
  }

  // Создаём БД app_database
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');
    return await openDatabase(
        path,
        version: 2,
        onCreate: _createTables,
        onUpgrade: _onUpgrade
    );

    // final dbPath = await getDatabasesPath();
    // final path = join(dbPath, 'app_database.db');
    // return await openDatabase(
    //     path,
    //     version: 1,
    //     onCreate: _createCartsTable
    // );
  }

  // Создаём в БД таблицу carts
  Future<void> _createCartsTable(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS carts');
    await db.execute('''
      CREATE TABLE carts(
        user_id INTEGER,
        product_id INTEGER,
        quantity INTEGER,
        PRIMARY KEY (user_id, product_id)
      )
    ''');
  }

  // Создаём в БД таблицу favorites
  Future<void> _createFavoritesTable(Database db) async {
    await db.execute('DROP TABLE IF EXISTS favorites');
    await db.execute('''
      CREATE TABLE favorites(
        user_id INTEGER,
        product_id INTEGER,
        PRIMARY KEY (user_id, product_id)
      )
    ''');
  }

  // Здесь запускаем методы для создания каждой из необходимых таблиц
  Future<void> _createTables(Database db, int version) async {
    await _createCartsTable(db, version);
    await _createFavoritesTable(db);

    // await db.execute('DROP TABLE IF EXISTS carts');
    // await db.execute('''
    //   CREATE TABLE carts(
    //     user_id INTEGER,
    //     product_id INTEGER,
    //     quantity INTEGER,
    //     PRIMARY KEY (user_id, product_id)
    //   )
    // ''');
    // await db.execute('DROP TABLE IF EXISTS favorites');
    // await db.execute('''
    //   CREATE TABLE favorites(
    //     user_id INTEGER,
    //     product_id INTEGER,
    //     PRIMARY KEY (user_id, product_id)
    //   )
    // ''');
  }

  // Метод добавления товара в таблицу carts
  Future<void> addToCartTable(int userId, int productId, int quantity) async {
    final db = await database;

    await db.insert(
      'carts',
      {'user_id': userId, 'product_id': productId, 'quantity': quantity},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Метод добавления товара в таблицу favorites
  Future<void> addToFavoritesTable(int userId, int productId) async {
    final db = await database;

    await db.insert(
      'favorites',
      {'user_id': userId, 'product_id': productId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Метод увеличения количества товара в таблице carts
  Future<void> increaseProductQuantityInCart(int userId, int productId) async {
    final db = await database;
    await db.rawUpdate('''
    UPDATE carts 
    SET quantity = quantity + 1 
    WHERE user_id = ? AND product_id = ?
  ''', [userId, productId]);
  }

  // Метод уменьшения количества товара в таблице carts
  Future<void> decreaseProductQuantityInCart(int userId, int productId) async {
    final db = await database;
    await db.rawUpdate('''
    UPDATE carts 
    SET quantity = quantity - 1 
    WHERE user_id = ? AND product_id = ?
  ''', [userId, productId]);
  }

  // Метод удаления товара из указанной таблицы по id пользователя
  Future<void> deleteProduct(String tableName, int userId, int productId) async {
    final db = await database;

    await db.delete(
      tableName,
      where: 'product_id = ? AND user_id = ?',
      whereArgs: [productId, userId],
    );
  }

  // Метод поиска всех товаров по id пользователя из указанной таблицы
  Future<List<Map<String, dynamic>>> getAllProductsByUserId(
      String tableName, int userId) async {
    final db = await database;
    List<Map<String, dynamic>> list = await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    for(Map<String, dynamic> map in list) {
      print('map keys: ${map.keys}');
      print('map values: ${map.values}');
      print('------------');
    }

    return list;
  }

  // Метод получения списка товаров для корзины
  Future<List<Product>> getProductsForCart(int userId) async {
    final db = await database;
    const cartTable = 'carts';

    // Получение товаров из корзины
    final cartList = await db.query(cartTable, where: 'user_id = ?', whereArgs: [userId]);

    final productIdsList = cartList.map((cartRow) => cartRow['product_id'] as int).toList();

    // Получение информации о товарах по их id
    final productsList = await Product.getProductsByIds(productIdsList);
    final List<CartInfo> cartInfoList = [];

    // Создание объектов CartInfo для каждого товара в корзине
    for (final cartRow in cartList) {
      final cartInfo = CartInfo.fromJson(cartRow);
      cartInfoList.add(CartInfo(cartInfo.userId, cartInfo.productId, cartInfo.quantity));
    }

    productsList.forEach((p) {
      p.quantity = cartInfoList.firstWhere((element) => p.id == element.productId).quantity;
    });

    return productsList;
  }

  Future<List<Product>> getProductsForFavorites(int userId) async {
    String tableName = 'favorites';
    List<Product> products = [];
    List<Product> favoriteProducts = [];
    Product? product;

    await Product.getAllProducts().then((value) => products.addAll(value));

    List<Map<String, dynamic>> dataList = [];
    await getAllProductsByUserId(tableName, userId)
        .then((value) => dataList.addAll(value));

    for (final productRow in dataList) {
      // Получение вхождений списка мап
      Iterable<MapEntry<String, dynamic>> entry = productRow.entries;
      int productId = 0;

      // Перебор вхождений и поиск значений по ключу
      for (var e in entry) {
        if (e.key == 'product_id') {
          productId = e.value;
          print('e.value: ${e.value}');
        }
      }

      // Получение товара из общего списка по id
      product = products.firstWhere((p) => p.id == productId);
      // print('product: ${product.name}');
      favoriteProducts.add(product);
    }

    // print('favoriteProducts length: ${favoriteProducts.length}');

    return favoriteProducts;
  }

  // Метод удаления всех товаров из указанной таблицы по id пользователя
  Future<void> deleteProductsByIdFromDb(String tableName, int userId) async {
    final db = await database;
    await db.delete(tableName, where: 'user_id = ?', whereArgs: [userId]);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1 && newVersion == 2) {
      await _createFavoritesTable(db);
    }
  }
}