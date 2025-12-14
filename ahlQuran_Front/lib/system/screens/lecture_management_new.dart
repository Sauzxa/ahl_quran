import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/lecture_management_controller.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/generic_edit_controller.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/forms/lecture_form.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/dialogs/lecture.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/three_bounce.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/error_illustration.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/drawer_controller.dart'
    as drawer;
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/utils/const/lecture.dart'
    as lecture_const;
import 'base_layout.dart';

class LectureManagementScreen extends GetView<LectureManagementController> {
  const LectureManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure sidebar is selecting "Lectures"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (Get.isRegistered<drawer.DrawerController>()) {
          Get.find<drawer.DrawerController>().changeSelectedIndex(3);
        }
      } catch (e) {
        // Ignore error if controller not found
      }
    });

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BaseLayout(
        title: "إدارة شؤون الحلقات",
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

            // Lectures table
            Expanded(
              child: _buildLecturesTable(theme),
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
            'الصفحة الرئيسية  /  إعدادات  /  إدارة الحلقات',
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
          // Type filter
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('جميع أنواع الحلقات'),
                  const SizedBox(width: 8),
                  const Text('النوع:'),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Gender/Category filter
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('ذكور'),
                  const SizedBox(width: 8),
                  const Text('الجنس:'),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Search field
          Expanded(
            flex: 3,
            child: TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: theme.cardColor,
              ),
              onChanged: (value) => controller.searchQuery.value = value,
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
          // Left side - Action Buttons
          _buildActionButton(
            'إضافة',
            Icons.add,
            theme,
            onPressed: () => _showAddLectureDialog(),
            color: const Color(0xFFC78D20),
          ),
          const SizedBox(width: 8),

          Obx(() => _buildOutlinedButton(
                'تعديل',
                Icons.edit_outlined,
                theme,
                onPressed: controller.selectedLectures.length == 1
                    ? () => _showEditLectureDialog(
                        controller.selectedLectures.first)
                    : null,
              )),
          const SizedBox(width: 8),

          Obx(() => _buildOutlinedButton(
                'تكرار',
                Icons.copy,
                theme,
                onPressed: controller.selectedLectures.length == 1
                    ? () => controller
                        .duplicateLecture(controller.selectedLectures.first)
                    : null,
              )),
          const SizedBox(width: 8),

          Obx(() => _buildOutlinedButton(
                'حذف',
                Icons.delete_outline,
                theme,
                onPressed: controller.selectedLectures.isNotEmpty
                    ? () => _confirmDelete()
                    : null,
                color: Colors.red,
              )),
          const SizedBox(width: 8),

          _buildOutlinedButton(
            'تحديد الكل',
            Icons.check_box_outlined,
            theme,
            onPressed: () => controller.selectAllLectures(),
          ),
          const SizedBox(width: 8),

          Obx(() => _buildOutlinedButton(
                'إلغاء',
                Icons.check_box_outline_blank,
                theme,
                onPressed: controller.selectedLectures.isNotEmpty
                    ? () => controller.deselectAllLectures()
                    : null,
              )),

          const Spacer(),

          // Right side - Export Buttons
          _buildExportButton('طباعة', theme),
          const SizedBox(width: 8),
          _buildExportButton('Excel', theme, color: Colors.green),
          const SizedBox(width: 8),
          _buildExportButton('إظهار+', theme, color: const Color(0xFF3F9142)),
          const SizedBox(width: 8),
          _buildShowRowsButton(theme),
        ],
      ),
    );
  }

  /// Lectures data table
  Widget _buildLecturesTable(ThemeData theme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: ThreeBounce());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return ErrorIllustration(
          illustrationPath: 'assets/illustration/bad-connection.svg',
          title: 'خطأ في الاتصال',
          message: controller.errorMessage.value,
          onRetry: () => controller.refresh(),
        );
      }

      if (controller.filteredLectures.isEmpty) {
        return const Center(
          child: Text(
            'لا توجد حلقات',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      }

      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: SfDataGrid(
          source: _LectureDataSource(
            lectures: controller.filteredLectures,
            selectedLectures: controller.selectedLectures,
            onSelectionChanged: (lecture) =>
                controller.toggleLectureSelection(lecture),
            theme: theme,
          ),
          columns: _buildColumns(),
          selectionMode: SelectionMode.none,
          rowHeight: 60,
          headerRowHeight: 50,
          columnWidthMode: ColumnWidthMode.fill,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
        ),
      );
    });
  }

  /// Build table columns
  List<GridColumn> _buildColumns() {
    return [
      GridColumn(
        columnName: 'select',
        width: 80,
        label: Container(
          alignment: Alignment.center,
          color: const Color(0xFF3F9142),
          child: const Text(
            '',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'name_ar',
        label: Container(
          alignment: Alignment.center,
          color: const Color(0xFF3F9142),
          child: const Text(
            'اسم الحلقة',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'type',
        label: Container(
          alignment: Alignment.center,
          color: const Color(0xFF3F9142),
          child: const Text(
            'نوع الحلقة',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'category',
        width: 100,
        label: Container(
          alignment: Alignment.center,
          color: const Color(0xFF3F9142),
          child: const Text(
            'الفئة',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'teachers',
        label: Container(
          alignment: Alignment.center,
          color: const Color(0xFF3F9142),
          child: const Text(
            'قائمة المعلمين',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      GridColumn(
        columnName: 'id',
        width: 80,
        label: Container(
          alignment: Alignment.center,
          color: const Color(0xFF3F9142),
          child: const Text(
            'عدد الطلاب',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];
  }

  /// Build action button (filled)
  Widget _buildActionButton(
    String label,
    IconData icon,
    ThemeData theme, {
    VoidCallback? onPressed,
    Color? color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? theme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  /// Build outlined button
  Widget _buildOutlinedButton(
    String label,
    IconData icon,
    ThemeData theme, {
    VoidCallback? onPressed,
    Color? color,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color ?? theme.primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  /// Build export button
  Widget _buildExportButton(String label, ThemeData theme, {Color? color}) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? const Color(0xFF3F9142),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(label),
    );
  }

  /// Build show rows button
  Widget _buildShowRowsButton(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3F9142),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        children: [
          Text(
            'إظهار 10 أسطر',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(width: 4),
          Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  /// Show add lecture dialog
  void _showAddLectureDialog() {
    // Clean up any existing controller
    if (Get.isRegistered<GenericEditController<LectureForm>>()) {
      Get.delete<GenericEditController<LectureForm>>();
    }

    // Register the controller with null data for new lecture
    Get.put(GenericEditController<LectureForm>(
      initialmodel: null,
      isEdit: false,
    ));

    Get.dialog(
      const LectureDialog(),
      barrierDismissible: false,
    ).then((_) {
      // Refresh lectures after dialog closes
      controller.fetchAllLectures();

      // Clean up the controller
      if (Get.isRegistered<GenericEditController<LectureForm>>()) {
        Get.delete<GenericEditController<LectureForm>>();
      }
    });
  }

  /// Show edit lecture dialog
  void _showEditLectureDialog(LectureForm lecture) {
    // Clean up any existing controller
    if (Get.isRegistered<GenericEditController<LectureForm>>()) {
      Get.delete<GenericEditController<LectureForm>>();
    }

    // Register the controller with the lecture data
    Get.put(GenericEditController<LectureForm>(
      initialmodel: lecture,
      isEdit: true,
    ));

    Get.dialog(
      const LectureDialog(dialogHeader: 'تعديل حلقة'),
      barrierDismissible: false,
    ).then((_) {
      // Refresh lectures after dialog closes
      controller.fetchAllLectures();
      controller.deselectAllLectures();

      // Clean up the controller
      if (Get.isRegistered<GenericEditController<LectureForm>>()) {
        Get.delete<GenericEditController<LectureForm>>();
      }
    });
  }

  /// Confirm delete dialog
  void _confirmDelete() {
    Get.defaultDialog(
      title: 'تأكيد الحذف',
      middleText:
          'هل أنت متأكد من حذف ${controller.selectedLectures.length} حلقة؟',
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteSelectedLectures();
        Get.back();
      },
    );
  }
}

/// Data source for SfDataGrid
class _LectureDataSource extends DataGridSource {
  final List<LectureForm> lectures;
  final RxList<LectureForm> selectedLectures;
  final Function(LectureForm) onSelectionChanged;
  final ThemeData theme;

  _LectureDataSource({
    required this.lectures,
    required this.selectedLectures,
    required this.onSelectionChanged,
    required this.theme,
  });

  @override
  List<DataGridRow> get rows => lectures
      .map((lecture) => DataGridRow(cells: [
            DataGridCell<LectureForm>(columnName: 'select', value: lecture),
            DataGridCell<String>(
                columnName: 'name_ar', value: lecture.lecture.lectureNameAr),
            DataGridCell<String>(
                columnName: 'type',
                value: _getTypeText(lecture.lecture.circleType)),
            DataGridCell<String>(
                columnName: 'category',
                value: _getCategoryText(lecture.lecture.category)),
            DataGridCell<String>(
                columnName: 'teachers',
                value: lecture.teachers
                    .map((t) => '${t.firstName} ${t.lastName}')
                    .join(', ')),
            DataGridCell<int>(columnName: 'id', value: lecture.studentCount),
          ]))
      .toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final lecture = row.getCells()[0].value as LectureForm;

    return DataGridRowAdapter(
      cells: [
        // Checkbox
        Center(
          child: Obx(() => Checkbox(
                value: selectedLectures.contains(lecture),
                onChanged: (_) => onSelectionChanged(lecture),
              )),
        ),
        // Name AR
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[1].value as String? ?? '',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        // Type
        Center(
          child: Text(
            row.getCells()[2].value as String? ?? '',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        // Category
        Center(
          child: Text(
            row.getCells()[3].value as String? ?? '',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        // Teachers
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[4].value as String? ?? '',
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        // Student Count
        Center(
          child: Text(
            row.getCells()[5].value.toString(),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  String _getCategoryText(String? category) {
    switch (category) {
      case 'male':
        return 'ذكور';
      case 'female':
        return 'إناث';
      case 'both':
        return 'ذكور و إناث';
      default:
        return '';
    }
  }

  String _getTypeText(String? type) {
    return lecture_const.getCircleTypeText(type);
  }
}
