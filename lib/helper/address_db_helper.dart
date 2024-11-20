import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AddressDatabaseHelper {
  static final AddressDatabaseHelper _instance =
      AddressDatabaseHelper._internal();

  factory AddressDatabaseHelper() => _instance;

  AddressDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'delivery_address.db');
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE addresses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId TEXT NOT NULL,
    fullName TEXT NOT NULL,
    mobileNumber TEXT NOT NULL,
    addressLine1 TEXT NOT NULL,
    addressLine2 TEXT NOT NULL,
    landmark TEXT,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    pincode TEXT NOT NULL,
    addressType TEXT NOT NULL
  )
''');
    log('Address table created!');
  }

  Future<int> saveAddress({
    required String userId,
    required String fullName,
    required String mobileNumber,
    required String addressLine1,
    required String addressLine2,
    String? landmark,
    required String city,
    required String state,
    required String pincode,
    required String addressType,
  }) async {
    final db = await database;
    try {
      final id = await db.insert('addresses', {
        'userId': userId,
        'fullName': fullName,
        'mobileNumber': mobileNumber,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'landmark': landmark,
        'city': city,
        'state': state,
        'pincode': pincode,
        'addressType': addressType,
      });
      log('Address saved with ID: $id');
      return id;
    } catch (e) {
      log('Error saving address: $e');
      rethrow; // re-throw the error after logging
    }
  }

  Future<List<Map<String, dynamic>>> fetchAddresses(String userId) async {
    final db = await database;
    return await db
        .query('addresses', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<void> deleteAddress(int id) async {
    final db = await database;
    int rowsAffected =
        await db.delete('addresses', where: 'id = ?', whereArgs: [id]);
    log('Deleted $rowsAffected row(s) with id $id');
  }
}
