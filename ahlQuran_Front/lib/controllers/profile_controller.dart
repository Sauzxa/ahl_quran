import 'package:get/get.dart';

class ProfileController extends GetxController {
  final avatarPath = 'assets/avatar.png'.obs;
  final userName = ''.obs;
  final userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    // This method can be used to fetch profile from API if needed
    // For now, data is set by AuthController upon login/signup
  }

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
