//! To remove duplicate entries from a list while ignoring case sensitivity in Dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utils {
  static List<String> removeDuplicatesIgnoreCase(List<String> list) {
    // Create a Set to store unique elements (case-insensitive)
    Set<String> uniqueElements = {};

    // Iterate through the list
    for (String element in list) {
      // Convert each element to lowercase before adding to the Set
      uniqueElements.add(element.toLowerCase());
    }

    // Convert the Set back to a List
    List<String> result = uniqueElements.toList();
    return result;
  }

  static void dismissKeyboard({required BuildContext context}) {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        // FocusScope.of(context).unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
  }
}
