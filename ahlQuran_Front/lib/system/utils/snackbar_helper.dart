import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Types of snackbars you can show
enum SnackbarType { success, error, info }

/// Displays a customizable snackbar using GetX
void showCustomSnackbar({
  required String title,
  required String message,
  SnackbarType type = SnackbarType.info,
  SnackPosition position = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 3),
}) {
  final theme = Get.theme;
  final colorScheme = theme.colorScheme;

  // Determine icon and colors based on snackbar type
  late IconData icon;
  late Color backgroundColor;
  late Color textColor;

  switch (type) {
    case SnackbarType.success:
      icon = Icons.check_circle;
      backgroundColor = colorScheme.primary;
      textColor = colorScheme.onPrimary;
      break;
    case SnackbarType.error:
      icon = Icons.error;
      backgroundColor = colorScheme.error;
      textColor = colorScheme.onError;
      break;
    case SnackbarType.info:
      icon = Icons.info;
      backgroundColor = colorScheme.secondary;
      textColor = colorScheme.onSecondary;
      break;
  }

  // Show the snackbar
  Get.snackbar(
    title,
    message,
    snackPosition: position,
    backgroundColor: backgroundColor,
    colorText: textColor,
    margin: const EdgeInsets.all(12),
    borderRadius: 10,
    icon: Icon(icon, color: textColor),
    snackStyle: SnackStyle.FLOATING,
    duration: duration,
    isDismissible: true,
  );
}

/// Show a success snackbar (default title: "نجاح")
void showSuccessSnackbar(String message, {String title = "نجاح"}) {
  showCustomSnackbar(
    title: title,
    message: message,
    type: SnackbarType.success,
  );
}

/// Show an error snackbar (default title: "خطأ")
void showErrorSnackbar(String message, {String title = "خطأ"}) {
  showCustomSnackbar(
    title: title,
    message: message,
    type: SnackbarType.error,
  );
}

/// Show an info snackbar (default title: "معلومات")
void showInfoSnackbar(String message, {String title = "معلومات"}) {
  showCustomSnackbar(
    title: title,
    message: message,
    type: SnackbarType.info,
  );
}
