import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/student_management_controller.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/student.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/dialogs/student.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/three_bounce.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/error_illustration.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/drawer_controller.dart'
    as drawer;
import 'base_layout.dart';

class StudentManagementScreen extends GetView<StudentManagementController> {
  const StudentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure sidebar is selecting "Students"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (Get.isRegistered<drawer.DrawerController>()) {
          Get.find<drawer.DrawerController>().changeSelectedIndex(4);
        }
      } catch (e) {
        // Ignore error if controller not found
      }
    });

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BaseLayout(
        title: "إدارة شؤون الطلاب",
        child: Column(
          children: [
            // Golden header bar
            _buildHeaderBar(theme),

            const SizedBox(height: 16),

            // Search and filters
            _buildSearchAndFilters(theme),

            const SizedBox(height: 16),

            // Action buttons
            _buildActionButtons(theme),

            const SizedBox(height: 16),

            // Students table
            Expanded(
              child: _buildStudentsTable(theme),
            ),
          ],
        ),
      ),
    );
  }

  /// Golden header bar with title
  Widget _buildHeaderBar(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFDEB059), // Muted gold/orange from theme
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'إدارة الطلاب / الصفحة الرئيسية',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Search and filter section
  Widget _buildSearchAndFilters(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Lecture filter dropdown
          Expanded(
            flex: 2,
            child: Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int?>(
                      value: controller.selectedLecture.value?.lectureId,
                      hint: const Text('الحلقة: جميع الحلقات'),
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('جميع الحلقات'),
                        ),
                        ...controller.lectures.map((lecture) {
                          return DropdownMenuItem<int?>(
                            value: lecture.lectureId,
                            child: Text(lecture.lectureNameAr ?? 'غير محدد'),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          controller.updateLectureFilter(null);
                        } else {
                          final lecture = controller.lectures.firstWhere(
                            (l) => l.lectureId == value,
                          );
                          controller.updateLectureFilter(lecture);
                        }
                      },
                    ),
                  ),
                )),
          ),

          const SizedBox(width: 16),

          // Search field
          Expanded(
            flex: 3,
            child: TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'البحث...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: theme.cardColor,
              ),
              onChanged: (value) => controller.updateSearchQuery(value),
            ),
          ),
        ],
      ),
    );
  }

  /// Action buttons row
  Widget _buildActionButtons(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Right Side (Start) - Action Buttons

          // Add (Filled)
          _buildActionButton(
            'إضافة',
            Icons.add,
            theme,
            onPressed: () => _showAddStudentDialog(),
            color: const Color(0xFFC78D20), // Primary theme color
          ),
          const SizedBox(width: 8),

          // Edit (Outlined)
          Obx(() => _buildExportButton(
                'تعديل',
                Icons.edit_outlined,
                theme,
                onPressed: controller.selectedStudents.isNotEmpty
                    ? () => _showEditStudentDialog(
                        controller.selectedStudents.first)
                    : null,
              )),
          const SizedBox(width: 8),

          // Duplicate (Outlined)
          _buildExportButton(
            'تكرار',
            Icons.copy,
            theme,
            onPressed: () {
              // TODO: Implement duplicate
            },
          ),
          const SizedBox(width: 8),

          // Delete (Outlined)
          Obx(() => _buildExportButton(
                'حذف',
                Icons.delete_outline,
                theme,
                onPressed: controller.selectedStudents.isNotEmpty
                    ? () => _showDeleteConfirmation()
                    : null,
                color: Colors.red.shade400, // Red outline/text
              )),
          const SizedBox(width: 8),

          // Select All (Filled)
          _buildActionButton(
            'تحديد الكل',
            Icons.select_all,
            theme,
            onPressed: () {
              // controller.selectAll(); // TODO: Implement in controller
              // For now, select all loaded students
              for (var s in controller.filteredStudents) {
                if (!controller.isStudentSelected(s)) {
                  controller.toggleStudentSelection(s);
                }
              }
            },
            color: const Color(0xFFC78D20), // Primary theme color
          ),
          const SizedBox(width: 8),

          // Cancel (Outlined)
          Obx(() => _buildExportButton(
                'إلغاء',
                Icons.cancel_outlined,
                theme,
                onPressed: controller.selectedStudents.isNotEmpty
                    ? () => controller.clearSelections()
                    : null,
                color: Colors.grey.shade600,
              )),

          const Spacer(),

          // Left Side (End) - Export Buttons

          // Print
          _buildExportButton('طباعة', Icons.print, theme),
          const SizedBox(width: 8),

          // Show+
          _buildExportButton('إظهار+', Icons.add_chart, theme),
          const SizedBox(width: 8),

          // Excel
          _buildExportButton('Excel', Icons.table_chart, theme,
              color: Colors.green.shade700),
          const SizedBox(width: 8),

          // Show 10
          _buildExportButton('إظهار 10 أسطر', Icons.list, theme),
        ],
      ),
    );
  }

  Widget _buildExportButton(String text, IconData icon, ThemeData theme,
      {Color? color, VoidCallback? onPressed}) {
    return OutlinedButton.icon(
      onPressed: onPressed ??
          () {
            // TODO: Implement export functionality
          },
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: color ?? Colors.teal.shade700,
        side: BorderSide(color: color ?? Colors.teal.shade700),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    ThemeData theme, {
    VoidCallback? onPressed,
    Color? color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? theme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        disabledBackgroundColor: Colors.grey.shade300,
        disabledForegroundColor: Colors.grey.shade600,
      ),
    );
  }

  /// Students data table
  Widget _buildStudentsTable(ThemeData theme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: ThreeBounce());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return ErrorIllustration(
          illustrationPath: 'assets/illustration/bad-connection.svg',
          title: 'خطأ في الاتصال',
          message: controller.errorMessage.value,
          onRetry: () => controller.refresh(),
        );
      }

      if (controller.filteredStudents.isEmpty) {
        return const Center(
          child: Text(
            'لا يوجد طلاب',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      }

      return _buildDataGrid(theme);
    });
  }

  Widget _buildDataGrid(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: SfDataGrid(
        source: _StudentDataSource(
          students: controller.filteredStudents,
          controller: controller,
          onViewDetails: (student) => _showStudentDetails(student),
        ),
        columns: _buildColumns(),
        columnWidthMode: ColumnWidthMode.fill,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        selectionMode: SelectionMode.multiple,
        checkboxColumnSettings: const DataGridCheckboxColumnSettings(
          showCheckboxOnHeader: true,
        ),
        onSelectionChanged: (addedRows, removedRows) {
          // Handle selection changes if needed
        },
        rowHeight: 60,
        headerRowHeight: 50,
      ),
    );
  }

  List<GridColumn> _buildColumns() {
    return [
      // Selection checkbox column
      GridColumn(
        columnName: 'selection',
        width: 60,
        label: Container(
          alignment: Alignment.center,
          color: Colors.teal.shade700,
          child: const Icon(Icons.check_box_outline_blank, color: Colors.white),
        ),
      ),

      // Action button column
      GridColumn(
        columnName: 'action',
        width: 80,
        label: _buildHeaderCell(''), // Empty label for action column
      ),

      GridColumn(
        columnName: 'name',
        label: _buildHeaderCell('الاسم'),
      ),

      GridColumn(
        columnName: 'nickname', // Changed from 'sex'
        width: 100,
        label: _buildHeaderCell('الكنية'),
      ),

      GridColumn(
        columnName: 'gender',
        width: 100,
        label: _buildHeaderCell('الجنس'),
      ),

      GridColumn(
        columnName: 'lectures',
        label: _buildHeaderCell('الحلقات'),
      ),

      GridColumn(
        columnName: 'username',
        label: _buildHeaderCell('اسم المستخدم'),
      ),

      GridColumn(
        columnName: 'dob',
        width: 120,
        label: _buildHeaderCell('تاريخ الميلاد'),
      ),

      GridColumn(
        columnName: 'birthplace',
        label: _buildHeaderCell('مكان الميلاد'),
      ),

      GridColumn(
        columnName: 'nationality',
        width: 120,
        label: _buildHeaderCell('الجنسية'),
      ),

      GridColumn(
        columnName: 'id_type',
        width: 100,
        label: _buildHeaderCell('نوع الهوية'),
      ),
    ];
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      alignment: Alignment.center,
      color: Colors.teal.shade700,
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showAddStudentDialog() {
    Get.dialog(
      const StudentDialog(dialogHeader: 'إضافة طالب'),
      barrierDismissible: false,
    );
  }

  void _showEditStudentDialog(Student student) {
    // TODO: Pass student data to edit dialog
    Get.dialog(
      const StudentDialog(dialogHeader: 'تعديل بيانات الطالب'),
      barrierDismissible: false,
    );
  }

  void _showStudentDetails(Student student) {
    Get.dialog(
      Dialog(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    'بيانات الطالب ${student.personalInfo.firstNameAr ?? ''} ${student.personalInfo.lastNameAr ?? ''}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Divider(height: 32),

              // Student image
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 50, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 24),

              // Student details
              _buildDetailRow(
                  'الاسم:', '${student.personalInfo.firstNameAr ?? ''}'),
              _buildDetailRow(
                  'الكنية:', '${student.personalInfo.lastNameAr ?? ''}'),
              _buildDetailRow('الجنس:', '${student.personalInfo.sex ?? ''}'),
              _buildDetailRow('الحلقات:',
                  student.lectures.map((l) => l.lectureNameAr).join(', ')),
              _buildDetailRow(
                  'اسم المستخدم:', '${student.accountInfo.username ?? ''}'),
              _buildDetailRow('تاريخ الميلاد:',
                  '${student.personalInfo.dateOfBirth ?? ''}'),
              _buildDetailRow('مكان الميلاد:',
                  '${student.personalInfo.placeOfBirth ?? ''}'),
              _buildDetailRow(
                  'الجنسية:', '${student.personalInfo.nationality ?? ''}'),
              _buildDetailRow('نوع الهوية:',
                  student.personalInfo.sex == 'ذكر' ? 'ذكر' : 'أنثى'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'تأكيد الحذف',
          textAlign: TextAlign.right,
        ),
        content: Obx(() => Text(
              'هل أنت متأكد من حذف ${controller.selectedStudents.length} طالب؟',
              textAlign: TextAlign.right,
            )),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final success = await controller.deleteSelectedStudents();
              if (success) {
                Get.snackbar(
                  'نجح',
                  'تم حذف الطلاب بنجاح',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'خطأ',
                  controller.errorMessage.value,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

// DataSource for SfDataGrid
class _StudentDataSource extends DataGridSource {
  final List<Student> students;
  final StudentManagementController controller;
  final Function(Student) onViewDetails;

  _StudentDataSource({
    required this.students,
    required this.controller,
    required this.onViewDetails,
  }) {
    _buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void _buildDataGridRows() {
    dataGridRows = students.map<DataGridRow>((student) {
      return DataGridRow(
        cells: [
          // Selection checkbox
          DataGridCell<Student>(columnName: 'selection', value: student),

          // Action button
          DataGridCell<Student>(columnName: 'action', value: student),

          // Name
          DataGridCell<String>(
            columnName: 'name',
            value:
                '${student.personalInfo.firstNameAr ?? ''} ${student.personalInfo.lastNameAr ?? ''}',
          ),

          // Nickname (Last name)
          DataGridCell<String>(
            columnName: 'nickname',
            value: student.personalInfo.lastNameAr ?? '',
          ),

          // Gender
          DataGridCell<String>(
            columnName: 'gender',
            value: student.personalInfo.sex ?? '',
          ),

          // Lectures
          DataGridCell<String>(
            columnName: 'lectures',
            value: student.lectures.map((l) => l.lectureNameAr).join(', '),
          ),

          // Username
          DataGridCell<String>(
            columnName: 'username',
            value: student.accountInfo.username ?? '',
          ),

          // Date of birth
          DataGridCell<String>(
            columnName: 'dob',
            value: student.personalInfo.dateOfBirth ?? '',
          ),

          // Place of birth
          DataGridCell<String>(
            columnName: 'birthplace',
            value: student.personalInfo.placeOfBirth ?? '',
          ),

          // Nationality
          DataGridCell<String>(
            columnName: 'nationality',
            value: student.personalInfo.nationality ?? '',
          ),

          // ID Type
          DataGridCell<String>(
            columnName: 'id_type',
            value: '', // Placeholder as field might not exist yet
          ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final student = row.getCells()[0].value as Student;
    final isSelected = controller.isStudentSelected(student);

    return DataGridRowAdapter(
      color: isSelected ? Colors.teal.shade50 : null,
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'selection') {
          return Center(
            child: Obx(() => Checkbox(
                  value: controller.isStudentSelected(student),
                  onChanged: (value) {
                    controller.toggleStudentSelection(student);
                  },
                )),
          );
        }

        if (cell.columnName == 'action') {
          return Center(
            child: IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.amber),
              tooltip: 'عرض التفاصيل',
              onPressed: () => onViewDetails(student),
            ),
          );
        }

        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(
            cell.value?.toString() ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13),
          ),
        );
      }).toList(),
    );
  }
}
