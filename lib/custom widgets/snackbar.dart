import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Custombar {
  static showBar(
    final String title,
    final String msg,
    final List<Color> bgColor,
    final Color textColor,
  ) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      msg,
      colorText: textColor,
      showProgressIndicator: true,
      isDismissible: true,
    );
  }
}
