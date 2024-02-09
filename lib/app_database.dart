import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class AppDatabase {
  Database? _database;

  // Если БД существует, то получаем её, если нет, создаём новую
  Future<Database> get database async {
    sqfliteFfiInit();

    if (_database != null) {
      return _database!;  // _database! - _database точно не null
    }

    _database = await _initDB();
    return _database!;
  }

  // Создаём БД app_database
  Future<Database> _initDB() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'app_database.db');
    // Пакет sqflite_common_ffi представляет собой
    // альтернативную реализацию пакета SQFlute,
    // который использует FFI (интерфейс внешней функции)
    // для взаимодействия с собственной библиотекой SQLite.
    // Использование sqflite_common_ffi может быть полезным в ситуациях,
    // когда вам нужна лучшая производительность или совместимость,
    // поскольку оно направлено на повышение производительности
    // за счет взаимодействия с машинным кодом.
    return await databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _createCartsTable,
          onDowngrade: onDatabaseDowngradeDelete
        ),

        // onUpgrade: _createCartsTable
    );
  }

  // Создаём в БД таблицу carts
  Future<void> _createCartsTable(Database db, int version) async {
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
  Future<void> _createFavoritesTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites(
        user_id INTEGER,
        product_id INTEGER,
        PRIMARY KEY (user_id, product_id)
      )
    ''');
  }

  // // Здесь запускаем методы для создания каждой из необходимых таблиц
  // Future<void> _createTables(Database db, int version) async {
  //   _createCartsTable(db, version);
  //   _createFavoritesTable(db, version);
  // }

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

  // Метод поиска всех товаров по id пользователя из таблицы carts
  Future<List<Map<String, dynamic>>> getAllProductsByUserId(
      String tableName, int userId) async {
    final db = await database;
    List<Map<String, dynamic>> list = await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return list;
  }

  // Метод удаления всех товаров из указанной таблицы по id пользователя
  Future<void> deleteProductsByIdFromDb(String tableName, int userId) async {
    final db = await database;
    await db.delete(tableName, where: 'user_id = ?', whereArgs: [userId]);
  }

  // Метод миграции базы данных
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createFavoritesTable(db, newVersion);
    }
  }
}