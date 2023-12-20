import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Создаём в БД таблицу carts
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE carts(
        user_id INTEGER,
        product_id INTEGER,
        quantity INTEGER,
        PRIMARY KEY (user_id, product_id)
      )
    ''');
  }

  // Метод добавления товара в БД
  Future<void> addToDb(int userId, int productId, int quantity) async {
    final db = await database;

    await db.insert(
      'carts',
      {'user_id': userId, 'product_id': productId, 'quantity': quantity},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Метод увеличения количества товара в БД
  Future<void> increaseProductQuantity(int userId, int productId) async {
    final db = await database;
    await db.rawUpdate('''
    UPDATE carts 
    SET quantity = quantity + 1 
    WHERE user_id = ? AND product_id = ?
  ''', [userId, productId]);
  }

  // Метод уменьшения количества товара в БД
  Future<void> decreaseProductQuantity(int userId, int productId) async {
    final db = await database;
    await db.rawUpdate('''
    UPDATE carts 
    SET quantity = quantity - 1 
    WHERE user_id = ? AND product_id = ?
  ''', [userId, productId]);
  }

  // Метод удаления товара из БД по id пользователя
  Future<void> deleteProduct(int userId, int productId) async {
    final db = await database;

    await db.delete(
      'carts',
      where: 'product_id = ? AND user_id = ?',
      whereArgs: [productId, userId],
    );
  }

  // Метод поиска всех товаров по id пользователя
  Future<List<Map<String, dynamic>>> getAllProductsByUserId(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> list = await db.query(
      'carts',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    for (final productRow in list) {
      // Получение списка вхождений
      Iterable<MapEntry<String, dynamic>> entry = productRow.entries;

      // Перебор вхождений и поиск значений по ключу
      for (var e in entry) {
        if (e.key == 'product_id') {
        } else if (e.key == 'quantity') {
        }
      }
    }

    return list;
  }

  // Метод удаления всех товаров из БД по id пользователя
  Future<void> deleteProductsByIdFromDb(int userId) async {
    final db = await database;
    await db.delete('carts', where: 'user_id = ?', whereArgs: [userId]);
  }
}