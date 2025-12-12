import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/forms/lecture_form.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/services/network/api_endpoints.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/dialogs/lecture.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/management_grid.dart';
import '../widgets/management_show.dart';
import 'base_layout.dart';

class AddLecture extends StatelessWidget {
  const AddLecture({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: BaseLayout(
          title: "Lectures Management",
          child: ManagementScreen<LectureForm>(
            dataSourceEndpoint: ApiEndpoints.getSpecialLectures,
            deleteEndpoint: (item) =>
                ApiEndpoints.getLectureById(item.lecture.lectureId),
            managementType: ManagementTypes.students,
            dialog: LectureDialog(),
            rowBuilder: (lecture) => [
              DataGridCell<String>(
                  columnName: 'id',
                  value: lecture.lecture.lectureId.toString()),
              DataGridCell<String>(
                  columnName: 'lecture_name_ar',
                  value: lecture.lecture.lectureNameAr),
              DataGridCell<String>(
                  columnName: 'circle_type', value: lecture.lecture.circleType),
              DataGridCell<String>(
                  columnName: 'teacher_ids',
                  value: lecture.teachers
                      .map((t) => '${t.firstName} ${t.lastName}')
                      .join(', ')),
              DataGridCell<int>(
                  columnName: 'student_count', value: lecture.studentCount),
              DataGridCell<String>(columnName: 'button', value: null),
            ],
            columnsNames: [
              GridColumn(
                  columnName: 'id', label: ManagementGrid.buildHeader('ID')),
              GridColumn(
                  columnName: 'lecture_name_ar',
                  label: ManagementGrid.buildHeader('Name (AR)')),
              GridColumn(
                  columnName: 'circle_type',
                  label: ManagementGrid.buildHeader('Type')),
              GridColumn(
                  columnName: 'teacher_ids',
                  label: ManagementGrid.buildHeader('Teachers')),
              GridColumn(
                  columnName: 'student_count',
                  label: ManagementGrid.buildHeader('Students')),
              GridColumn(
                columnName: 'button',
                label: ManagementGrid.buildHeader('Action'),
                allowSorting: false,
                allowFiltering: false,
              ),
            ],
          )),
    );
  }
}
