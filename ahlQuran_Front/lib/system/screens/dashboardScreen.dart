import 'package:flutter/material.dart';
//import 'package:get/get.dart';

import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/dashboardtile.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/header.dart';
import './base_layout.dart';

import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/exams/exam_teachers.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/track_and_memorize_screen.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/screens/report1_screen.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/stats/stat1.dart';

import 'package:the_doctarine_of_the_ppl_of_the_quran/routes/app_routes.dart';

final List<DashboardTileConfig> tiles = [
  DashboardTileConfig(
    label: 'الطلاب',
    count: '59',
    icon: Icons.people,
    bigIcon: Icons.people,
    route: Routes.addStudent,
  ),
  DashboardTileConfig(
    label: 'المعلمين',
    count: '13',
    icon: Icons.people_outline,
    bigIcon: Icons.people_outline,
    page: () => const ExamTeachers(),
  ),
  DashboardTileConfig(
    label: 'الحلقات',
    count: '18',
    icon: Icons.list,
    bigIcon: Icons.list_alt,
    route: Routes.addLecture,
  ),
  DashboardTileConfig(
    label: 'أولياء الأمور',
    count: '13',
    icon: Icons.person,
    bigIcon: Icons.person,
    route: Routes.addGuardian,
  ),
  DashboardTileConfig(
    label: 'حضور الطلاب',
    icon: Icons.event_available,
    bigIcon: Icons.event_available,
    route: Routes.attendance,
  ),
  DashboardTileConfig(
    label: 'حضور المعلمين',
    icon: Icons.event,
    bigIcon: Icons.event,
    page: () => const SizedBox.shrink(), // Placeholder
  ),
  DashboardTileConfig(
    label: 'حضور الموظفين',
    icon: Icons.event_note,
    bigIcon: Icons.event_note,
    page: () => const SizedBox.shrink(), // Placeholder
  ),
  DashboardTileConfig(
    label: 'الحفظ والمراجعة',
    icon: Icons.check_box,
    bigIcon: Icons.check_box_outlined,
    page: () => const TrackAndMemorizeScreen(),
  ),
  DashboardTileConfig(
    label: 'التقارير',
    icon: Icons.description,
    bigIcon: Icons.description_outlined,
    page: () => Report1Screen(),
  ),
  DashboardTileConfig(
    label: 'الإحصاءات',
    icon: Icons.bar_chart,
    bigIcon: Icons.bar_chart_outlined,
    page: () => StudentProgressChartScreen(),
  ),
  DashboardTileConfig(
    label: 'الخطط والمقررات',
    icon: Icons.menu_book,
    bigIcon: Icons.menu_book_outlined,
    page: () => const SizedBox.shrink(), // Placeholder
  ),
  DashboardTileConfig(
    label: 'الامتحانات (قريباً)',
    icon: Icons.check_circle,
    bigIcon: Icons.check_circle_outline,
    page: () => const SizedBox.shrink(), // Placeholder
  ),
];

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'لوحة التحكم',
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double spacing = 16;
          const int maxColumns = 4;
          const int maxRows = 3;

          // Calculate number of columns based on available width
          // but cap at maxColumns (4)
          int crossAxisCount = maxColumns;
          if (constraints.maxWidth < 1200) {
            crossAxisCount = 3;
          }
          if (constraints.maxWidth < 900) {
            crossAxisCount = 2;
          }
          if (constraints.maxWidth < 600) {
            crossAxisCount = 1;
          }

          // Limit items to maxRows * maxColumns
          final maxItems = maxRows * maxColumns;
          final displayedTiles = tiles.take(maxItems).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Header(),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: 3.5,
                  ),
                  itemCount: displayedTiles.length,
                  itemBuilder: (context, index) {
                    // Calculate which row this item is in (0-indexed)
                    final row = index ~/ crossAxisCount;
                    // Apply mint green background to 2nd row (row index 1)
                    final backgroundColor =
                        row == 1 ? const Color(0xFF4DB6AC) : null;

                    // Create a modified config with the background color
                    final config = DashboardTileConfig(
                      label: displayedTiles[index].label,
                      icon: displayedTiles[index].icon,
                      bigIcon: displayedTiles[index].bigIcon,
                      page: displayedTiles[index].page,
                      route: displayedTiles[index].route,
                      count: displayedTiles[index].count,
                      isWide: displayedTiles[index].isWide,
                      backgroundColor: backgroundColor,
                    );

                    return DashboardTile(config: config);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
