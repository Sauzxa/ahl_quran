import 'package:flutter/material.dart';
//import 'package:get/get.dart';

import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/dashboardtile.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/header.dart';
import './base_layout.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/student_managment.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/exams/exam_teachers.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/guardian_managment.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/lecture_managment.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/attendance/attendance.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/screens/exams/exam_records.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/screens/report1_screen.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/stats/stat1.dart';

final List<DashboardTileConfig> tiles = [
  DashboardTileConfig(
    label: 'الطلاب',
    count: '59',
    icon: Icons.people,
    bigIcon: Icons.people,
    page: () => const AddStudent(),
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
    page: () => const AddLecture(),
  ),
  DashboardTileConfig(
    label: 'أولياء الأمور',
    count: '13',
    icon: Icons.person,
    bigIcon: Icons.person,
    page: () => const AddGuardian(),
  ),
  DashboardTileConfig(
    label: 'حضور الطلاب',
    icon: Icons.event_available,
    bigIcon: Icons.event_available,
    page: () => AttendanceScreen(),
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
    page: () => const ExamRecords(),
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
          const double tileWidth = 300;
          const double spacing = 12;

          // Calculate how many tiles fit in the current width
          int crossAxisCount =
              (constraints.maxWidth / (tileWidth + spacing)).floor();
          crossAxisCount = crossAxisCount < 1 ? 1 : crossAxisCount;

          // Actual grid width
          double gridWidth =
              crossAxisCount * tileWidth + (crossAxisCount - 1) * spacing;

          return Center(
            child: SizedBox(
              width: gridWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      childAspectRatio: 3.5, // Adjust for tile shape
                    ),
                    itemCount: tiles.length,
                    itemBuilder: (context, index) {
                      return DashboardTile(config: tiles[index]);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
