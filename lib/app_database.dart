import 'package:mobile_app_internet_shop/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'cart_info.dart';

class AppDatabase {
  Database? _database;
  static const String databaseName = 'app_database.db';
  static const String cartTable = 'carts';
  static const String favoriteTable = 'favorites';
  static const String userIdByTable = 'user_id';
  static const String productIdByTable = 'product_id';
  static const String quantityByTable = 'quantity';

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
    final path = join(dbPath, databaseName);
    return await openDatabase(
        path,
        version: 2,
        onCreate: _createTables,
        onUpgrade: _onUpgrade
    );
  }

  // Создаём в БД таблицу carts
  Future<void> _createCartsTable(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS $cartTable');
    await db.execute('''
      CREATE TABLE $cartTable(
        $userIdByTable INTEGER,
        $productIdByTable INTEGER,
        $quantityByTable INTEGER,
        PRIMARY KEY ($userIdByTable, $productIdByTable)
      )
    ''');
  }

  // Создаём в БД таблицу favorites
  Future<void> _createFavoritesTable(Database db) async {
    await db.execute('DROP TABLE IF EXISTS $favoriteTable');
    await db.execute('''
      CREATE TABLE $favoriteTable(
        $userIdByTable INTEGER,
        $productIdByTable INTEGER,
        PRIMARY KEY ($userIdByTable, $productIdByTable)
      )
    ''');
  }

  // Здесь запускаем методы для создания каждой из необходимых таблиц
  Future<void> _createTables(Database db, int version) async {
    await _createCartsTable(db, version);
    await _createFavoritesTable(db);
  }

  // Метод добавления товара в таблицу carts
  Future<void> addToCartTable(int userId, int productId, int quantity) async {
    final db = await database;

    await db.insert(
      cartTable,
      {userIdByTable: userId, productIdByTable: productId, quantityByTable: quantity},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Метод добавления товара в таблицу favorites
  Future<void> addToFavoritesTable(int userId, int productId) async {
    final db = await database;

    await db.insert(
      favoriteTable,
      {userIdByTable: userId, productIdByTable: productId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Метод увеличения количества товара в таблице carts
  Future<void> increaseProductQuantityInCart(int userId, int productId) async {
    final db = await database;
    await db.rawUpdate('''
    UPDATE $cartTable 
    SET $quantityByTable = $quantityByTable + 1 
    WHERE $userIdByTable = ? AND $productIdByTable = ?
  ''', [userId, productId]);
  }

  // Метод уменьшения количества товара в таблице carts
  Future<void> decreaseProductQuantityInCart(int userId, int productId) async {
    final db = await database;
    await db.rawUpdate('''
    UPDATE $cartTable 
    SET $quantityByTable = $quantityByTable - 1 
    WHERE $userIdByTable = ? AND $productIdByTable = ?
  ''', [userId, productId]);
  }

  // Метод удаления товара из указанной таблицы по id пользователя
  Future<void> deleteProduct(String tableName, int userId, int productId) async {
    final db = await database;

    await db.delete(
      tableName,
      where: '$productIdByTable = ? AND $userIdByTable = ?',
      whereArgs: [productId, userId],
    );
  }

  // Метод поиска всех товаров по id пользователя из указанной таблицы
  Future<List<Map<String, dynamic>>> getAllProductsByUserId(String tableName, int userId) async {
    final db = await database;
    List<Map<String, dynamic>> list = await db.query(
      tableName,
      where: '$userIdByTable = ?',
      whereArgs: [userId],
    );

    return list;
  }

  // Метод получения списка товаров для корзины
  Future<List<Product>> getProductsForCart(int userId) async {
    final db = await database;

    // Получение товаров из корзины
    final cartList = await db.query(cartTable, where: '$userIdByTable = ?', whereArgs: [userId]);

    final productIdsList = cartList.map((cartRow) => cartRow[productIdByTable] as int).toList();

    // Получение информации о товарах по их id
    final productsList = await Product.getProductsByIds(productIdsList);
    final List<CartInfo> cartInfoList = [];

    // Создание объектов CartInfo для каждого товара в корзине
    for (final cartRow in cartList) {
      final cartInfo = CartInfo.fromJson(cartRow);
      cartInfoList.add(CartInfo(cartInfo.userId, cartInfo.productId, cartInfo.quantity));
    }

    for (var p in productsList) {
      p.quantity = cartInfoList.firstWhere((element) => p.id == element.productId).quantity;
    }

    return productsList;
  }

  Future<List<Product>> getProductsForFavorites(int userId) async {
    List<Product> products = [];
    List<Product> favoriteProducts = [];
    Product? product;

    await Product.getAllProducts().then((value) => products.addAll(value));

    List<Map<String, dynamic>> dataList = [];
    await getAllProductsByUserId(favoriteTable, userId)
        .then((value) => dataList.addAll(value));

    for (final productRow in dataList) {
      // Получение вхождений списка мап
      Iterable<MapEntry<String, dynamic>> entry = productRow.entries;
      int productId = 0;

      // Перебор вхождений и поиск значений по ключу
      for (var e in entry) {
        if (e.key == productIdByTable) {
          productId = e.value;
        }
      }

      // Получение товара из общего списка по id
      product = products.firstWhere((p) => p.id == productId);
      favoriteProducts.add(product);
    }

    return favoriteProducts;
  }

  // Метод удаления всех товаров из указанной таблицы по id пользователя
  Future<void> deleteProductsByIdFromDb(String tableName, int userId) async {
    final db = await database;
    await db.delete(tableName, where: '$userIdByTable = ?', whereArgs: [userId]);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createFavoritesTable(db);
    }
  }
}