import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:the_shawarma_hub/model/cart_items_model.dart';
import 'package:path/path.dart';

class CartDatabaseHelper {
  static Database? _database;

  static final CartDatabaseHelper _instance = CartDatabaseHelper._internal();

  factory CartDatabaseHelper() => _instance;

  CartDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cart_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_items(
        item_id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        price INTEGER,
        category TEXT,
        photo TEXT,
        subCategory TEXT,
        quantity INTEGER
      )
    ''');

    log('Table created!!!');
  }

  Future<void> insertOrUpdateCartItem(CartItem cartItem) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cart_items',
      where: 'item_id = ?',
      whereArgs: [cartItem.itemId],
    );

    if (maps.isNotEmpty) {
      // Item already exists in the cart, update the quantity
      await db.update(
        'cart_items',
        {'quantity': cartItem.quantity}, // Use the passed quantity directly
        where: 'item_id = ?',
        whereArgs: [cartItem.itemId],
      );

      log('Database Updation done!!! ');
    } else {
      // Item does not exist, insert new item
      await db.insert(
        'cart_items',
        cartItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      log('Insertion in database done');
    }
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart_items');

    return List.generate(maps.length, (i) {
      return CartItem(
        itemId: maps[i]['item_id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        price: maps[i]['price'],
        category: maps[i]['category'],
        photo: maps[i]['photo'],
        subCategory: maps[i]['subCategory'],
        quantity: maps[i]['quantity'],
      );
    });
  }

  // Delete Item from database
  Future<void> deleteCartItem(String itemId) async {
    final db = await database;
    await db.delete(
      'cart_items',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );

    log('Deletion done from database!!!');
  }

  //! clear all the Items in the database called when user log out
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('cart_items'); // Replace 'cart_items' with your table name
    // Add additional tables if needed
    log('All data cleared from SQLite database');
  }

  Future<int> getItemCount(String itemId) async {
    final db = await database;
    final result = await db.query(
      'cart_items',
      where: 'item_id = ?',
      whereArgs: [itemId],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first['quantity'] as int;
    }
    return 0; // Default value
  }

  Future<int> getCartItemCount() async {
    final db = await database; // Ensure the database is initialized
    final result =
        await db.rawQuery('SELECT SUM(quantity) as total FROM cart_items');
    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int; // Return the sum of quantities
    }
    return 0; // Default value if no rows found
  }
}
