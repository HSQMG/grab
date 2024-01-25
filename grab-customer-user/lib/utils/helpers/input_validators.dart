import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputValidator {
  static bool validateField(String title, String value) {
    if (value.trim().isNotEmpty) {
      return true;
    }
    Get.snackbar(
      "Error",
      "$title is empty",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    );
    return false;
  }

  static bool validatePassword(String value1, String value2) {
    if (value1.trim() == value2.trim()) {
      return true;
    }
    Get.snackbar(
      "Error",
      "Confirm Password do not match",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    );
    return false;
  }
  static bool validatePhoneNumber(String phoneNumber) {
    // Use a regular expression to check if the phone number contains only digits
    RegExp regex = RegExp(r'^[0-9]+$');
    if (regex.hasMatch(phoneNumber)) {
      return true;
    } else {
      Get.snackbar(
        "Error",
        "Invalid phone number. Please enter digits only.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      );
      return false;
    }
  }
}
