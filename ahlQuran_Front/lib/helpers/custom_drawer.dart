import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import your controllers here
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/profile_controller.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/drawer_controller.dart'
    as mydrawer;

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

  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.book, 'title': 'الخطط والمقررات'},
    {'icon': Icons.bar_chart, 'title': 'التقارير'},
    {'icon': Icons.insert_chart, 'title': 'الإحصائيات'},
    {'icon': Icons.folder, 'title': 'إدارة المحتوى'},
    {'icon': Icons.language, 'title': 'الموقع الإلكتروني'},
    {'icon': Icons.campaign, 'title': 'الأخبار والإعلانات'},
    {'icon': Icons.menu_book, 'title': 'المكتبة'},
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
                  return Obx(() => _buildMenuItem(
                        context,
                        item['icon'],
                        item['title'],
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
        // TODO: navigation logic
      },
    );
  }
}
