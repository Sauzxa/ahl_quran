import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import './auth_layout.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final iconTheme = Theme.of(context).iconTheme;
    final authController = Get.find<AuthController>();

    return AuthLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              "تسجيل الدخول",
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text("البريد الإلكتروني", style: textTheme.bodyMedium),
          const SizedBox(height: 4),
          TextField(
            controller: authController.usernameController,
            decoration: InputDecoration(
              hintText: "البريد الإلكتروني",
              prefixIcon: Icon(Icons.email_outlined, color: iconTheme.color),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text("كلمة المرور", style: textTheme.bodyMedium),
          const SizedBox(height: 4),
          TextField(
            controller: authController.passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "ادخل كلمة المرور",
              prefixIcon: Icon(Icons.lock_outline, color: iconTheme.color),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text("نوع الحساب", style: textTheme.bodyMedium),
          const SizedBox(height: 4),
          Obx(() => DropdownButtonFormField<String>(
                value: authController.selectedRole.value,
                decoration: InputDecoration(
                  hintText: "اختر نوع الحساب",
                  prefixIcon:
                      Icon(Icons.person_outline, color: iconTheme.color),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: [
                  const DropdownMenuItem(
                      value: "president", child: Text("رئيس")),
                  const DropdownMenuItem(
                      value: "supervisor", child: Text("مشرف")),
                  const DropdownMenuItem(value: "teacher", child: Text("معلم")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    authController.selectedRole.value = value;
                  }
                },
              )),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                // Navigate to Forget Password screen
              },
              child: Text(
                "نسيت كلمة المرور؟",
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              authController.login();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
            ),
            child: Text(
              "تسجيل الدخول",
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.createAccount);
                },
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium,
                    children: [
                      const TextSpan(text: "ليس لديك حساب؟ "),
                      TextSpan(
                        text: "إنشاء حساب",
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverableText extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _HoverableText({required this.text, required this.onTap});

  @override
  State<_HoverableText> createState() => _HoverableTextState();
}

class _HoverableTextState extends State<_HoverableText> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isHovered ? color.withValues(alpha: 0.7) : color,
        );

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(widget.text, style: style),
      ),
    );
  }
}

class _HoverableRichText extends StatefulWidget {
  final String prefix;
  final String action;
  final VoidCallback onTap;

  const _HoverableRichText({
    required this.prefix,
    required this.action,
    required this.onTap,
  });

  @override
  State<_HoverableRichText> createState() => _HoverableRichTextState();
}

class _HoverableRichTextState extends State<_HoverableRichText> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final baseStyle = Theme.of(context).textTheme.bodySmall;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text.rich(
          TextSpan(
            text: widget.prefix,
            style: baseStyle,
            children: [
              TextSpan(
                text: widget.action,
                style: baseStyle?.copyWith(
                  color: isHovered ? color.withValues(alpha: 0.7) : color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
