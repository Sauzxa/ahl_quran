import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import your controllers here
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/profile_controller.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/drawer_controller.dart'
    as mydrawer;
import 'package:the_doctarine_of_the_ppl_of_the_quran/routes/app_routes.dart';

class CustomDrawer extends StatefulWidget {
  final bool miniMode;
  final Function()? onToggleMiniMode;

  const CustomDrawer({
    super.key,
    this.miniMode = false,
    this.onToggleMiniMode,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final profileController = Get.find<ProfileController>();
  final drawerController = Get.find<mydrawer.DrawerController>();

  final List<dynamic> menuItems = [
    {
      'type': 'item',
      'icon': Icons.dashboard,
      'title': 'لوحة القيادة',
      'route': Routes.dashboardPage,
    },
    {
      'type': 'item',
      'icon': Icons.message,
      'title': 'الرسائل',
      'route': '/messages', // Placeholder
    },
    {
      'type': 'item',
      'icon': Icons.settings,
      'title': 'الإعدادات',
      'route': '/settings', // Placeholder
    },
    {'type': 'section', 'title': 'الشؤون الإدارية'},
    {
      'type': 'item',
      'icon': Icons.people,
      'title': 'الطلاب',
      'route': Routes.addStudent,
    },
    {
      'type': 'item',
      'icon': Icons.person_outline,
      'title': 'المعلمين',
      'route': Routes.examTeachers,
    },
    {
      'type': 'item',
      'icon': Icons.family_restroom,
      'title': 'أولياء الأمور',
      'route': Routes.addGuardian,
    },
    {
      'type': 'item',
      'icon': Icons.menu_book,
      'title': 'الحلقات',
      'route': Routes.addLecture,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      child: Container(
        width: widget.miniMode ? 70 : 280,
        color: colorScheme.primaryContainer,
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (!widget.miniMode) ...[
              Obx(() => CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        AssetImage(profileController.avatarPath.value),
                  )),
              const SizedBox(height: 8),
              Obx(() => Text(
                    profileController.userName.value,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  )),
              Obx(() => Text(
                    profileController.userRole.value,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  )),
              const Divider(height: 32),
            ] else
              const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  if (item['type'] == 'section') {
                    if (widget.miniMode) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Text(
                        item['title'],
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: const Color(0xFFD4AF37), // Gold color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return Obx(() => _buildMenuItem(
                        context,
                        item['icon'],
                        item['title'],
                        item['route'],
                        index,
                        selected: drawerController.selectedIndex.value == index,
                      ));
                },
              ),
            ),
            IconButton(
              icon: Icon(widget.miniMode
                  ? Icons.arrow_back_ios
                  : Icons.arrow_forward_ios),
              onPressed: widget.onToggleMiniMode,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
    int index, {
    bool selected = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = selected ? colorScheme.secondary : colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: color),
      title: widget.miniMode
          ? null
          : Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(color: color),
            ),
      onTap: () {
        drawerController.changeSelectedIndex(index);
        Get.toNamed(route);
      },
    );
  }
}
