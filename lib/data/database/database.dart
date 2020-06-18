import 'dart:io';

import 'package:daily_kitchen_base/data/models/item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
}

class DBHelper {
  static Database _database;
  static const String DB_NAME = "DKDb.db";

  static const String CART_TABLE = "CART_TABLE";

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: _onCreateDb);
  }

  _onCreateDb(Database db, int version) async {
    await db.execute("CREATE TABLE " +
        CART_TABLE +
        "(" +
        "id INTEGER PRIMARY KEY ," +
        "item_id INTEGER ," +
        "title VARCHAR(200)," +
        "rate_per_quantity REAL," +
        "rate_unit VARCHAR(10)," +
        "cleaning_required INTEGER default 0," +
        "discount REAL," +
        "no_of_units REAL," +
        "total_amount REAL)");
  }

  Future insertToCart(Item item) async {
    try {
      final db = await database;
      var res = await db.insert(CART_TABLE, item.toJsonForSqlite());

      return res;
    } catch (e) {
      throw (e);
    }
  }

  getCartItems() async {
    try {
      final db = await database;
      var res = await db.query(CART_TABLE);
      List<Item> cartItemsList = [];

      if (res.length > 0) {
        for (var each in res) {
          cartItemsList.add(Item(
              id: each['id'],
              itemId: each['item_id'],
              title: each['title'],
              ratePerQuantity: each['rate_per_quantity'].toDouble(),
              rateUnit: each['rate_unit'],
              discount: each['discount'].toDouble(),
              noOfUnits: each['no_of_units'].toDouble(),
              cleaningRequired: each['cleaning_required'] != 0,
              totalAmount: each['total_amount'].toDouble()));
        }
      }
      return cartItemsList;
    } catch (e) {
      throw (e);
    }
  }

  deleteCartItems() async {
    try {
      final db = await database;
      return await db.delete(CART_TABLE);
    } catch (e) {
      throw (e);
    }
  }

  deleteCartItem(int id) async {
    try {
      final db = await database;
      return await db.delete(CART_TABLE, where: 'id=?', whereArgs: [id]);
    } catch (e) {
      throw (e);
    }
  }

  close() async {
    try {
      final db = await database;
      db.close();
    } catch (e) {
      throw (e);
    }
  }
}
