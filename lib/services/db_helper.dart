import 'package:kulina_test/models/cart_product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartDatabaseHelper {
  CartDatabaseHelper._();
  static final CartDatabaseHelper db = CartDatabaseHelper._();
  static Database? _database;

  final String tableCartProduct = 'cartProduct';
  final String columnName = 'name';
  final String columnImage = 'image';
  final String columnQuantity = 'quantity';
  final String columnPrice = 'price';
  final String columnProductId = 'productId';
  final String columnDate = 'date';

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDb();
    return _database;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), 'CartProduct.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE $tableCartProduct (
      $columnName TEXT NOT NULL,
      $columnImage TEXT NOT NULL,
      $columnPrice TEXT NOT NULL,
      $columnQuantity INTEGER NOT NULL,
      $columnProductId INTEGER NOT NULL,
      $columnDate TEXT NOT NULL)
       ''');
    });
  }

  Future<List<CartProductModel>> getAllProduct() async {
    var dbClient = await database;
    List<Map> maps = await dbClient!.query(
      tableCartProduct,
      orderBy: '$columnDate ASC, $columnProductId ASC',
    );
    List<CartProductModel> list = maps.isNotEmpty
        ? maps.map((product) => CartProductModel.fromJson(product)).toList()
        : [];
    return list;
  }

  insert(CartProductModel model) async {
    var dbClient = await database;

    await dbClient!.insert(
      tableCartProduct,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  updateProduct(CartProductModel model) async {
    var dbClient = await database;
    return await dbClient!.update(tableCartProduct, model.toJson(),
        where: '$columnProductId = ?', whereArgs: [model.productId]);
  }

  deleteProductWithId(CartProductModel model) async {
    var dbClient = await database;

    return await dbClient!.delete(tableCartProduct,
        where: '$columnProductId = ?', whereArgs: [model.productId]);
  }

  Future<int> deleteAllPRoduct() async {
    var dbClient = await database;
    return await dbClient!.delete(tableCartProduct);
  }

  Future close() async {
    db.close();
  }
}
