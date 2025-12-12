import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if user is authenticated by checking ProfileController
    try {
      final profileController = Get.find<ProfileController>();
      bool isAuthenticated = profileController.userName.value.isNotEmpty;

      if (!isAuthenticated) {
        return const RouteSettings(name: Routes.logIn);
      }
    } catch (e) {
      // ProfileController not found, user not logged in
      return const RouteSettings(name: Routes.logIn);
    }

    return null;
  }
}
