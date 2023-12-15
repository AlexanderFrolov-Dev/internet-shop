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

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

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

  Future<void> addToDb(int userId, int productId, int quantity) async {
    final db = await database;

    await db.insert(
      'carts',
      {'user_id': userId, 'product_id': productId, 'quantity': quantity},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> increaseProductQuantity(int userId, int productId) async {
    final db = await database;
    await db.rawUpdate('''
    UPDATE carts 
    SET quantity = quantity + 1 
    WHERE user_id = ? AND product_id = ?
  ''', [userId, productId]);
  }

  Future<void> decreaseProductQuantity(int userId, int productId) async {
    final db = await database;
    await db.rawUpdate('''
    UPDATE carts 
    SET quantity = quantity - 1 
    WHERE user_id = ? AND product_id = ?
  ''', [userId, productId]);
  }

  // Future<void> reduceQuantity(int userId, int productId) async {
  //   final db = await database;
  //
  //   await db.update(
  //     'carts',
  //     {'quantity': 'quantity - 1'},
  //     where: 'product_id = ? AND user_id = ?',
  //     whereArgs: [productId, userId],
  //   );
  // }

  Future<void> deleteProduct(int userId, int productId) async {
    final db = await database;

    await db.delete(
      'carts',
      where: 'product_id = ? AND user_id = ?',
      whereArgs: [productId, userId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllProductsByUserId(int userId) async {
    final db = await database;
    return await db.query(
      'carts',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> clearCartInDb(int userId) async {
    final db = await database;
    await db.delete('carts', where: 'user_id = ?', whereArgs: [userId]);
  }
}