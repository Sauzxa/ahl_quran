import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileController extends GetxController {
  final avatarPath = 'assets/avatar.png'.obs;
  final userName = ''.obs;
  final firstName = ''.obs;
  final lastName = ''.obs;
  final userRole = ''.obs;
  final userEmail = ''.obs;

  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    // Load user data from secure storage
    final storedFirstName = await _storage.read(key: 'firstName');
    final storedLastName = await _storage.read(key: 'lastName');
    final storedUserName = await _storage.read(key: 'userName');
    final storedEmail = await _storage.read(key: 'userEmail');
    final storedRole = await _storage.read(key: 'userRole');
    final storedAvatar = await _storage.read(key: 'avatarPath');

    if (storedFirstName != null) firstName.value = storedFirstName;
    if (storedLastName != null) lastName.value = storedLastName;
    if (storedUserName != null) userName.value = storedUserName;
    if (storedEmail != null) userEmail.value = storedEmail;
    if (storedRole != null) userRole.value = storedRole;
    if (storedAvatar != null) avatarPath.value = storedAvatar;
  }

  Future<void> updateProfile({
    required String avatar,
    required String name,
    required String role,
    String? email,
    String? first,
    String? last,
  }) async {
    avatarPath.value = avatar;
    userName.value = name;
    userRole.value = role;
    if (email != null) userEmail.value = email;
    if (first != null) firstName.value = first;
    if (last != null) lastName.value = last;

    // Save to secure storage
    await _storage.write(key: 'avatarPath', value: avatar);
    await _storage.write(key: 'userName', value: name);
    await _storage.write(key: 'userRole', value: role);
    if (email != null) await _storage.write(key: 'userEmail', value: email);
    if (first != null) await _storage.write(key: 'firstName', value: first);
    if (last != null) await _storage.write(key: 'lastName', value: last);
  }

  Future<void> clearProfile() async {
    // Clear all stored data on logout
    await _storage.deleteAll();
    avatarPath.value = 'assets/avatar.png';
    userName.value = '';
    firstName.value = '';
    lastName.value = '';
    userRole.value = '';
    userEmail.value = '';
  }
}
