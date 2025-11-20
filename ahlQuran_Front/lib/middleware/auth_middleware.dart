import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // TODO: Implement actual authentication check
    // For now, we'll assume the user is not logged in if they are trying to access protected routes
    // and redirect them to login.
    // You should replace this with your actual auth logic, e.g., checking a token in SharedPreferences or GetX controller.

    bool isAuthenticated = false; // Replace with actual check

    if (!isAuthenticated) {
      return const RouteSettings(name: Routes.logIn);
    }
    return null;
  }
}
