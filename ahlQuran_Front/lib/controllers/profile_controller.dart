import 'package:get/get.dart';

class ProfileController extends GetxController {
  final avatarPath = 'assets/avatar.png'.obs;
  final userName = 'مستخدم افتراضي'.obs;
  final userRole = 'مستخدم'.obs;

  // Optional: method to update profile info dynamically
  void updateProfile({
    required String avatar,
    required String name,
    required String role,
  }) {
    avatarPath.value = avatar;
    userName.value = name;
    userRole.value = role;
  }
}
