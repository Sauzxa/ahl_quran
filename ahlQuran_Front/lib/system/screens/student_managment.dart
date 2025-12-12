import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/student.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/services/network/api_endpoints.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/dialogs/student.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/management_grid.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/management_show.dart';
import 'base_layout.dart';

class AddStudent extends StatelessWidget {
  const AddStudent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: BaseLayout(
        title: "Students Management",
        child: ManagementScreen<Student>(
          dataSourceEndpoint: ApiEndpoints.getStudents,
          deleteEndpoint: (student) =>
              ApiEndpoints.getAccountInfoById(student.accountInfo.accountId),
          managementType: ManagementTypes.students,
          dialog: StudentDialog(),
          rowBuilder: (student) => [
            DataGridCell<String>(
                columnName: 'id',
                value: student.personalInfo.studentId.toString()),
            DataGridCell<String>(
                columnName: 'first_name_ar',
                value: student.personalInfo.firstNameAr),
            DataGridCell<String>(
                columnName: 'last_name_ar',
                value: student.personalInfo.lastNameAr),
            DataGridCell<String>(
                columnName: 'sex', value: student.personalInfo.sex),
            DataGridCell<String>(
                columnName: 'date_of_birth',
                value: student.personalInfo.dateOfBirth),
            DataGridCell<String>(
                columnName: 'place_of_birth',
                value: student.personalInfo.placeOfBirth),
            DataGridCell<String>(
                columnName: 'nationality',
                value: student.personalInfo.nationality),
            DataGridCell<String>(
                columnName: 'lecture_name_ar',
                value: student.lectures.isNotEmpty
                    ? student.lectures.map((e) => e.lectureNameAr).join(', ')
                    : 'No Lecture Assigned'),
            DataGridCell<String>(
                columnName: 'username', value: student.accountInfo.username),
            DataGridCell<String>(columnName: 'button', value: null),
          ],
          columnsNames: [
            GridColumn(
                columnName: 'id', label: ManagementGrid.buildHeader('ID')),
            GridColumn(
                columnName: 'first_name_ar',
                label: ManagementGrid.buildHeader('First Name (AR)')),
            GridColumn(
                columnName: 'last_name_ar',
                label: ManagementGrid.buildHeader('Last Name (AR)')),
            GridColumn(
                columnName: 'sex', label: ManagementGrid.buildHeader('Sex')),
            GridColumn(
                columnName: 'date_of_birth',
                label: ManagementGrid.buildHeader('Date of Birth')),
            GridColumn(
                columnName: 'place_of_birth',
                label: ManagementGrid.buildHeader('Place of Birth')),
            GridColumn(
                columnName: 'nationality',
                label: ManagementGrid.buildHeader('Nationality')),
            GridColumn(
                columnName: 'lecture_name_ar',
                label: ManagementGrid.buildHeader('Lecture')),
            GridColumn(
                columnName: 'username',
                label: ManagementGrid.buildHeader('Username')),
            GridColumn(
              columnName: 'button',
              label: ManagementGrid.buildHeader('Action'),
              allowSorting: false,
              allowFiltering: false,
            ),
          ],
        ),
      ),
    );
  }
}
