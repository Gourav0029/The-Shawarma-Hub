import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_shawarma_hub/helper/cart_db_helper.dart';
import 'package:the_shawarma_hub/login/login.dart';

class LogoutHelper {
  final CartDatabaseHelper dbHelper = CartDatabaseHelper();
  final GetStorage storage = GetStorage();

  void logout() async {
    // Clear GetStorage data
    await storage.erase();
    log('All data cleared from GetStorage');

    // Clear SQLite database
    await dbHelper.clearDatabase();

    // Navigate to Login Page
    Get.offAll(() => const LoginPage());
    log('User logged out');
  }
}
