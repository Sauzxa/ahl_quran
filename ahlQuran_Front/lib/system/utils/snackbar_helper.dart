import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Show a success snackbar using native Flutter SnackBar
void showSuccessSnackbar(String message, {BuildContext? context}) {
  // Schedule the snackbar to show after the current frame
  SchedulerBinding.instance.addPostFrameCallback((_) {
    final scaffoldContext = context ?? _getContext();
    if (scaffoldContext == null) {
      debugPrint('❌ Success snackbar failed: No context available');
      return;
    }

    try {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 3),
        ),
      );
      debugPrint('✅ Success snackbar shown: $message');
    } catch (e) {
      debugPrint('❌ Success snackbar error: $e');
    }
  });
}

/// Show an error snackbar using native Flutter SnackBar
void showErrorSnackbar(String message, {BuildContext? context}) {
  // Schedule the snackbar to show after the current frame
  SchedulerBinding.instance.addPostFrameCallback((_) {
    final scaffoldContext = context ?? _getContext();
    if (scaffoldContext == null) {
      debugPrint('❌ Error snackbar failed: No context available');
      return;
    }

    try {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 3),
        ),
      );
      debugPrint('✅ Error snackbar shown: $message');
    } catch (e) {
      debugPrint('❌ Error snackbar error: $e');
    }
  });
}

/// Show an info snackbar using native Flutter SnackBar
void showInfoSnackbar(String message, {BuildContext? context}) {
  // Schedule the snackbar to show after the current frame
  SchedulerBinding.instance.addPostFrameCallback((_) {
    final scaffoldContext = context ?? _getContext();
    if (scaffoldContext == null) {
      debugPrint('❌ Info snackbar failed: No context available');
      return;
    }

    try {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 3),
        ),
      );
      debugPrint('✅ Info snackbar shown: $message');
    } catch (e) {
      debugPrint('❌ Info snackbar error: $e');
    }
  });
}

/// Helper to get current context from navigator
BuildContext? _getContext() {
  try {
    return WidgetsBinding.instance.focusManager.primaryFocus?.context;
  } catch (e) {
    return null;
  }
}
