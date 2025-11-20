import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../new_models/forms/account_info.dart';
import 'auth_layout.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final iconTheme = Theme.of(context).iconTheme;

    return AuthLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "إنشاء حساب جديد",
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller.usernameController,
            decoration: InputDecoration(
              hintText: "اسم المستخدم",
              prefixIcon: Icon(Icons.person_outline, color: iconTheme.color),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller.passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "كلمة المرور",
              prefixIcon: Icon(Icons.lock_outline, color: iconTheme.color),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedRole.value,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.badge_outlined, color: iconTheme.color),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: AccountInfo.validAccountTypes
                    .where((role) => role != AccountInfo.student)
                    .map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(_getRoleLabel(role)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectedRole.value = newValue;
                  }
                },
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.signup();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            ),
            child: Text(
              "إنشاء حساب",
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case AccountInfo.student:
        return 'طالب';
      case AccountInfo.teacher:
        return 'أستاذ';
      case AccountInfo.guardian:
        return 'ولي أمر';
      case AccountInfo.supervisor:
        return 'مشرف';
      default:
        return role;
    }
  }
}
