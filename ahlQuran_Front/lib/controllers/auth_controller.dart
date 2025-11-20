import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../system/new_models/forms/account_info.dart';
import '../system/services/network/api_endpoints.dart';
import '../routes/app_routes.dart';

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
      Get.snackbar('Error', 'Please fill all fields');
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
        _navigateBasedOnRole(role);
      } else {
        // Error
        final errorMsg = jsonDecode(response.body)['error'] ?? 'Signup failed';
        Get.snackbar('Error', errorMsg);
      }
    } catch (e) {
      print('Signup error: $e');
      Get.snackbar('Error', 'Connection error: $e');
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
}
