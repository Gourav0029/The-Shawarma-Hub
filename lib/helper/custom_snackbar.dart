import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Bool {
  error,
  success,
  warning,
}

class CustomSnackbar {
  static void showSnackbar(
      BuildContext context, String message, Color? bgColor) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1), // Adjust the duration as needed

      backgroundColor: bgColor ?? Colors.grey,
      elevation: 8.0,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static void showGegtSnackbar(
      {required String errorMessage, required Bool snackBartype}) {
    Get.snackbar(
      snackBartype == Bool.success ? 'Success' : 'Error',
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: snackBartype == Bool.success
          ? Colors.green
          : snackBartype == Bool.error
              ? Colors.red
              : Colors.orange,
      colorText: Colors.white,
    );
  }
}
