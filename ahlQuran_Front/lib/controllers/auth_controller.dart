import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../system/services/network/api_endpoints.dart';
import '../system/utils/snackbar_helper.dart';
import '../routes/app_routes.dart';
import 'profile_controller.dart';
import 'admin_controller.dart';

class AuthController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final schoolNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  // Default to president for registration/login
  final selectedRole = 'president'.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void signup() async {
    final firstname = firstnameController.text;
    final lastname = lastnameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final schoolName = schoolNameController.text;
    final phoneNumber = phoneNumberController.text;

    if (firstname.isEmpty ||
        lastname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        schoolName.isEmpty) {
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
      final url = Uri.parse(ApiEndpoints.presidentRegister);
      final body = jsonEncode({
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "password": password,
        "school_name": schoolName,
        "phone_number": phoneNumber.isNotEmpty ? phoneNumber : null,
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
        // Success - show message about pending approval
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        showSuccessSnackbar(
          responseData['message'] ?? 'حسابك قيد المراجعة من قبل المسؤول',
        );

        // Navigate back to login
        Get.back();
      } else {
        // Error - parse and clean the response
        String errorMsg = _parseErrorMessage(response.body);
        showErrorSnackbar(errorMsg);
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
    final email = usernameController.text.trim();
    final password = passwordController.text;
    final role = selectedRole.value;

    if (email.isEmpty || password.isEmpty) {
      showErrorSnackbar('يرجى ملء جميع الحقول المطلوبة');
      return;
    }

    // Set loading state
    isLoading.value = true;

    try {
      // Check if this is an admin login based on selected role
      bool isAdminLogin = role == 'admin';

      String endpoint;
      Map<String, dynamic> requestBody;

      if (isAdminLogin) {
        // Admin login
        endpoint = '${ApiEndpoints.baseUrl}/auth/admin/login';
        requestBody = {
          "user":
              email, // The controller is named usernameController, but holds the input value
          "password": password,
        };
      } else {
        // Regular user login
        if (role == 'president') {
          endpoint = ApiEndpoints.presidentLogin;
        } else if (role == 'supervisor' || role == 'superviser') {
          endpoint = ApiEndpoints.supervisorLogin;
        } else {
          // Default to old login endpoint for other roles
          endpoint = ApiEndpoints.login;
        }
        requestBody = {
          "email": email,
          "password": password,
        };
      }

      final url = Uri.parse(endpoint);
      final body = jsonEncode(requestBody);

      print('Sending login request to $url with body: $body');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));

        print('Full response data: $responseData');

        // Check if this is admin login
        if (isAdminLogin && responseData['access_token'] != null) {
          // Admin login successful
          final adminController = Get.put(AdminController());

          // Set token and wait for fetch to complete
          adminController.adminToken.value = responseData['access_token'];

          print('Admin token set: ${adminController.adminToken.value}');

          // Fetch pending presidents before navigation
          await adminController.fetchPendingPresidents();

          print('Navigating to admin dashboard...');

          // Navigate to admin dashboard
          Get.offAllNamed(Routes.adminDashboard);

          // Show snackbar (helper will handle timing)
          showSuccessSnackbar('مرحباً بك في لوحة تحكم المسؤول');

          return;
        }

        // Regular user login
        String firstName = '';
        String lastName = '';
        if (responseData['user'] != null) {
          firstName = responseData['user']['firstname'] ?? '';
          lastName = responseData['user']['lastname'] ?? '';
          print('Extracted names - First: $firstName, Last: $lastName');
        } else {
          print('No user object in response!');
        }

        // Update profile controller with user data
        final profileController = Get.find<ProfileController>();

        // Safely extract and validate access token
        String? accessToken;
        try {
          final tokenValue = responseData['access_token'];
          if (tokenValue != null && tokenValue.toString().trim().isNotEmpty) {
            accessToken = tokenValue.toString().trim();
            print('Token extracted: ${accessToken.length} characters');
          } else {
            print('No valid token in response');
            accessToken = null;
          }
        } catch (e) {
          print('Error extracting token: $e');
          accessToken = null;
        }

        await profileController.updateProfile(
          avatar: 'assets/avatar.png',
          name: email,
          role: role,
          email: email,
          first: firstName,
          last: lastName,
          accessToken: accessToken,
        );

        print(
            'Profile updated - First: ${profileController.firstName.value}, Last: ${profileController.lastName.value}');

        // Navigate to dashboard
        Get.offAllNamed(Routes.dashboardPage);

        // Show snackbar (helper will handle timing)
        showSuccessSnackbar('مرحباً بك');
      } else {
        // Error - parse and clean the response
        String errorMsg = _parseErrorMessage(response.body);
        showErrorSnackbar(errorMsg);
      }
    } catch (e) {
      print('Login error: $e');
      showErrorSnackbar(
          'فشل الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت.');
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  // Helper method to parse and clean error messages
  String _parseErrorMessage(String responseBody) {
    try {
      // Try to parse as JSON first
      final data = jsonDecode(responseBody);

      // Check for common error keys
      if (data['detail'] != null) {
        return _translateErrorMessage(data['detail'].toString());
      }
      if (data['error'] != null) {
        return _translateErrorMessage(data['error'].toString());
      }
      if (data['message'] != null) {
        return _translateErrorMessage(data['message'].toString());
      }

      return 'حدث خطأ غير متوقع';
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

  // Translate common error messages to Arabic
  String _translateErrorMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('invalid credentials') ||
        lowerMessage.contains('incorrect') ||
        lowerMessage.contains('wrong password') ||
        lowerMessage.contains('invalid email or password')) {
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
    }

    if (lowerMessage.contains('user not found') ||
        lowerMessage.contains('account not found')) {
      return 'الحساب غير موجود';
    }

    if (lowerMessage.contains('account is inactive') ||
        lowerMessage.contains('not active')) {
      return 'حسابك غير نشط. يرجى انتظار موافقة المسؤول';
    }

    if (lowerMessage.contains('account is disabled')) {
      return 'تم تعطيل حسابك. يرجى التواصل مع المسؤول';
    }

    if (lowerMessage.contains('too many attempts')) {
      return 'محاولات تسجيل دخول كثيرة. يرجى المحاولة لاحقاً';
    }

    // Return original message if no translation found
    return message;
  }

  Future<void> logout() async {
    try {
      // Clear stored profile data
      final profileController = Get.find<ProfileController>();
      await profileController.clearProfile();

      // Since the backend uses JWTs without a blacklist/logout endpoint,
      // we just clear the token locally and navigate to login.
      // If a backend logout endpoint is added later, uncomment the code below.

      /*
      final url = Uri.parse(ApiEndpoints.logout);
      final response = await http.post(url);
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Logout failed on server: ${response.body}');
      }
      */

      Get.offAllNamed(Routes.logIn);
    } catch (e) {
      print('Logout error: $e');
      // Force logout on client side
      Get.offAllNamed(Routes.logIn);
    }
  }
}
