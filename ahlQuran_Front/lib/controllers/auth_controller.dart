import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../system/new_models/forms/account_info.dart';
import '../system/services/network/api_endpoints.dart';
import '../routes/app_routes.dart';
import 'profile_controller.dart';

class AuthController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  // Ensure default is NOT student, as it's removed from dropdown we pôvide that in mobile version
  final selectedRole = AccountInfo.teacher.obs;

  void signup() async {
    final username = usernameController.text;
    final password = passwordController.text;
    final role = selectedRole.value;

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'حقول مطلوبة',
        'يرجى ملء جميع الحقول المطلوبة',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    try {
      final url = Uri.parse(ApiEndpoints.signup);
      final body = jsonEncode({
        "username": username,
        "passcode": password,
        "account_type": role,
      });

      print('Sending signup request to $url with body: $body');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Success
        // Update ProfileController with the new user data
        final profileController = Get.find<ProfileController>();
        profileController.updateProfile(
          avatar: 'assets/avatar.png', // Default avatar
          name: username,
          role: role,
        );

        _navigateBasedOnRole(role);
      } else {
        // Error - parse and clean the response
        String errorMsg = _parseErrorMessage(response.body);
        Get.snackbar(
          'خطأ في إنشاء الحساب',
          errorMsg,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      print('Signup error: $e');
      Get.snackbar(
        'خطأ في الاتصال',
        'فشل الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  void login() async {
    final username = usernameController.text;
    final password = passwordController.text;
    final role = selectedRole.value;

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'حقول مطلوبة',
        'يرجى ملء جميع الحقول المطلوبة',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    try {
      final url = Uri.parse(ApiEndpoints.login);
      final body = jsonEncode({
        "username": username,
        "passcode": password,
        "account_type": role, // Backend requires account_type
      });

      print('Sending login request to $url with body: $body');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success - backend returns the user profile object
        // Update ProfileController
        final profileController = Get.find<ProfileController>();
        profileController.updateProfile(
          avatar: 'assets/avatar.png', // Default avatar
          name: username, // Use the username entered
          role: role, // Use the selected role
        );

        _navigateBasedOnRole(role);
      } else {
        // Error - parse and clean the response
        String errorMsg = _parseErrorMessage(response.body);
        Get.snackbar(
          'خطأ في تسجيل الدخول',
          errorMsg,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      print('Login error: $e');
      Get.snackbar(
        'خطأ في الاتصال',
        'فشل الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  // Helper method to parse and clean error messages
  String _parseErrorMessage(String responseBody) {
    try {
      // Try to parse as JSON first
      final data = jsonDecode(responseBody);
      return data['error'] ?? 'حدث خطأ غير متوقع';
    } catch (e) {
      // If JSON parsing fails, it might be HTML error
      // Clean HTML tags and extract meaningful message
      String cleaned = responseBody
          .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
          .replaceAll(RegExp(r'\s+'), ' ') // Normalize whitespace
          .trim();

      // If message is too long or contains technical details, use generic message
      if (cleaned.length > 200 ||
          cleaned.contains('Fatal error') ||
          cleaned.contains('Stack trace')) {
        return 'خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقاً.';
      }

      return cleaned.isNotEmpty ? cleaned : 'حدث خطأ غير متوقع';
    }
  }

  void _navigateBasedOnRole(String role) {
    switch (role) {
      case AccountInfo.student:
        // Navigate to Student Dashboard/Management
        // Get.offAllNamed(Routes.studentDashboard); // Example
        Get.snackbar('Success', 'Welcome Student');
        break;
      case AccountInfo.teacher:
        // Navigate to Teacher Dashboard/Management
        Get.snackbar('Success', 'Welcome Teacher');
        break;
      case AccountInfo.guardian:
        // Navigate to Guardian Dashboard/Management
        Get.snackbar('Success', 'Welcome Guardian');
        break;
      case AccountInfo.supervisor:
        // Navigate to Student Management as requested
        Get.offAllNamed(Routes.addStudent);
        break;
      default:
        Get.snackbar('Error', 'Unknown role');
    }
  }

  Future<void> logout() async {
    try {
      final url = Uri.parse(ApiEndpoints.logout);
      // Assuming you might need to send a token or session ID, but for now just a POST
      final response = await http.post(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAllNamed(Routes.logIn);
      } else {
        // Even if it fails on server, we might want to clear local state and logout on client
        print('Logout failed on server: ${response.body}');
        Get.offAllNamed(Routes.logIn);
      }
    } catch (e) {
      print('Logout error: $e');
      // Force logout on client side
      Get.offAllNamed(Routes.logIn);
    }
  }
}
