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
      onUpgrade: _onUpgrade, // Add upgrade logic
      version: 2, // Increment version
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
    addressType TEXT NOT NULL,
    createdAt TEXT NOT NULL
  )
''');
    log('Address table created!');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE addresses ADD COLUMN createdAt TEXT');
      log('Added createdAt column to addresses table.');
    }
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
        'createdAt': DateTime.now().toIso8601String(), // Add timestamp
      });
      log('Address saved with ID: $id');
      return id;
    } catch (e) {
      log('Error saving address: $e');
      rethrow; // Re-throw the error after logging
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

  Future<Map<String, dynamic>?> getLastSavedAddress() async {
    try {
      final db = await database; // Ensure 'database' is properly initialized
      final List<Map<String, dynamic>> result = await db.query(
        'addresses',
        orderBy: 'createdAt DESC', // Use the newly added 'createdAt' column
        limit: 1, // Get only the last saved address
      );

      if (result.isNotEmpty) {
        log('Last saved address retrieved: ${result.first}');
        return result.first; // Return the first result
      } else {
        log('No saved address found in the database.');
        return null; // Return null if no address is found
      }
    } catch (e) {
      log('Error in getLastSavedAddress: $e');
      return null; // Return null in case of an error
    }
  }
}
