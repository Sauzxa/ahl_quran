import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/generic_edit_controller.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/lecture_management_controller.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/teacher.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/services/network/api_endpoints.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/dialogs/dialog.dart';
import '../../utils/const/lecture.dart';
import '../drop_down.dart';
import '../../../controllers/submit_form.dart';
import '../../new_models/forms/lecture_form.dart';
import '../../../controllers/validator.dart';
import '../custom_container.dart';
import '../input_field.dart';
import '../custom_matrix.dart';
import '../multiselect.dart';
import 'dart:developer' as dev;

class LectureDialog extends GlobalDialog {
  const LectureDialog({
    super.key,
    super.dialogHeader = "إضافة حصة", // Add Lecture
    super.numberInputs = 2,
  });

  @override
  State<GlobalDialog> createState() =>
      _LectureDialogState<GenericEditController<LectureForm>>();
}

class _LectureDialogState<GEC extends GenericEditController<LectureForm>>
    extends DialogState<GEC> {
  // Data Loading
  @override
  Future<void> loadData() async {
    try {
      final fetchedTeachernNames =
          await getItems<Teacher>(ApiEndpoints.getTeachers, Teacher.fromJson);

      dev.log('teacherNames: ${fetchedTeachernNames.toString()}');

      setState(() {
        teacherResult = fetchedTeachernNames;
        dev.log('teacherNames: ${teacherResult.toString()}');

        // Set default values after loading teacher list
        if (editController?.model.value != null) {
          setDefaultFieldsValue();
        }
      });
    } catch (e) {
      dev.log("Error loading data: $e");
    }
  }

  // State Variables
  TimeCellController? _timeCellController;
  TimeCellController get timeCellController {
    if (_timeCellController == null) {
      if (!Get.isRegistered<TimeCellController>()) {
        Get.put(TimeCellController());
      }
      _timeCellController = Get.find<TimeCellController>();
    }
    return _timeCellController!;
  }

  final lectureInfo = LectureForm();
  MultiSelectResult<Teacher>? teacherResult;
  String selectedLectureType = type.isNotEmpty ? type[0] : '';
  bool showOnWebsite = true;
  List<MultiSelectItem<Teacher>>? selectedTeachers = [];

  // Lifecycle Methods
  @override
  void initState() {
    super.initState();
    // Initialize the TimeCellController
    if (!Get.isRegistered<TimeCellController>()) {
      Get.put(TimeCellController());
    }
    _timeCellController = Get.find<TimeCellController>();
  }

  @override
  @override
  void dispose() {
    super.dispose();
    if (_timeCellController != null) {
      _timeCellController!.dispose();
    }
    if (Get.isRegistered<TimeCellController>()) {
      Get.delete<TimeCellController>();
    }
  }

  // UI Section: Lecture Information
  Widget _buildLectureInfoSection() {
    return CustomContainer(
      headerText: "معلومات الحصة", // Lecture Information
      headerIcon: Icons.person,
      child: Column(
        children: [
          // Lecture Name Inputs
          Row(
            children: [
              Expanded(
                child: InputField(
                  inputTitle: "اسم الحصة بالعربية", // Lecture Name in Arabic
                  child: CustomTextField(
                    controller: formController.controllers[0],
                    validator: (value) => Validator.notEmptyValidator(
                        value, "يجب إدخال الاسم"), // Must enter the name
                    focusNode: formController.focusNodes[0],
                    onSaved: (p0) => lectureInfo.lecture.lectureNameAr = p0!,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InputField(
                  inputTitle:
                      "اسم الحصة بالإنجليزية", // Lecture Name in English
                  child: CustomTextField(
                    controller: formController.controllers[1],
                    validator: (value) => Validator.notEmptyValidator(
                        value, "يجب إدخال الاسم"), // Must enter the name
                    focusNode: formController.focusNodes[1],
                    onSaved: (p0) => lectureInfo.lecture.lectureNameEn = p0!,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Lecture Type Dropdown
          Row(
            children: [
              Expanded(
                child: InputField(
                  inputTitle: "نوع الحصة", // Lecture Type
                  child: DropDownWidget<String>(
                    items: type,
                    initialValue: selectedLectureType,
                    onSaved: (p0) => lectureInfo.lecture.circleType =
                        getCircleTypeValue(p0!),
                    onChanged: (p0) {
                      setState(() => selectedLectureType = p0!);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Category Dropdown
          Row(
            children: [
              Expanded(
                child: InputField(
                  inputTitle: "الفئة", // Category
                  child: DropDownWidget<String>(
                    items: const ["male", "female", "both"],
                    initialValue: lectureInfo.lecture.category ?? "both",
                    onSaved: (p0) => lectureInfo.lecture.category = p0!,
                    onChanged: (p0) {
                      setState(() => lectureInfo.lecture.category = p0!);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Teachers Multi-Select
          InputField(
            inputTitle: "المعلمون", // Teachers
            child: MultiSelect<Teacher>(
              getPickedItems: (pickedItems) {
                lectureInfo.teachers = pickedItems.map((e) => e.obj).toList();
                selectedTeachers = pickedItems;
              },
              preparedData: teacherResult?.items ?? [],
              hintText: "البحث باسم المعلم", // Search by teacher name
              maxSelectedItems: null,
              initialPickedItems: selectedTeachers ?? [],
            ),
          ),
          const SizedBox(height: 8),
          // Show on Website Dropdown
          InputField(
            inputTitle: "عرض على الموقع؟", // Show on Website?
            child: DropDownWidget<bool>(
              items: trueFalse,
              initialValue: showOnWebsite,
              onSaved: (p0) {
                lectureInfo.lecture.shownOnWebsite = transformBool(p0!);
              },
              onChanged: (p0) {
                setState(() => showOnWebsite = p0!);
              },
            ),
          ),
        ],
      ),
    );
  }

  // UI Section: Schedule Information
  Widget _buildScheduleInfoSection() {
    return CustomContainer(
      headerIcon: Icons.alarm,
      headerText: "معلومات الجدول", // Schedule Information
      child: CustomMatrix(
        controller: timeCellController,
      ),
    );
  }

  // Form Builder
  @override
  List<Widget> formChild() {
    return [
      _buildLectureInfoSection(),
      const SizedBox(height: 10),
      _buildScheduleInfoSection(),
      const SizedBox(height: 10),
    ];
  }

  // Form Submission
  @override
  Future<bool> submit() async {
    // Extract schedules from time matrix controller
    lectureInfo.schedules = timeCellController.getSelectedDays();

    // Debug: Check what data we have
    dev.log('Lecture Info: ${lectureInfo.toJson()}');
    dev.log('Is Complete: ${lectureInfo.isComplete}');
    dev.log('Schedules: ${lectureInfo.schedules}');
    dev.log('Teachers: ${lectureInfo.teachers}');

    // Check if we're editing or creating
    final isEditing = editController?.model.value != null;

    if (isEditing) {
      // Update existing lecture using the controller
      final lectureId = editController!.model.value!.lecture.lectureId;
      if (lectureId == null) {
        Get.snackbar('خطأ', 'معرف الحلقة غير موجود');
        return false;
      }

      try {
        // Get the lecture management controller
        final lectureController = Get.find<LectureManagementController>();
        await lectureController.updateLecture(lectureId, lectureInfo);
        // Don't call Get.back() here - let the parent dialog handle it
        return true;
      } catch (e, stackTrace) {
        dev.log('Error updating lecture: $e');
        dev.log('Stack trace: $stackTrace');
        Get.snackbar('خطأ', 'فشل تحديث الحلقة: ${e.toString()}');
        return false;
      }
    } else {
      // Create new lecture using the submit form
      return await submitForm<LectureForm>(
        formKey,
        lectureInfo,
        ApiEndpoints.submitLectureForm,
        (LectureForm.fromJson),
      );
    }
  }

  // Default Values Setup
  @override
  void setDefaultFieldsValue() {
    final s = editController!.model.value!;
    formController.controllers[0].text = s.lecture.lectureNameAr ?? "";
    formController.controllers[1].text = s.lecture.lectureNameEn ?? "";

    // Copy the complete lecture data to lectureInfo
    lectureInfo.lecture.lectureId = s.lecture.lectureId;
    lectureInfo.lecture.lectureNameAr = s.lecture.lectureNameAr;
    lectureInfo.lecture.lectureNameEn = s.lecture.lectureNameEn;
    lectureInfo.lecture.circleType = s.lecture.circleType;
    lectureInfo.lecture.category = s.lecture.category ?? "both";
    lectureInfo.lecture.shownOnWebsite = s.lecture.shownOnWebsite;

    // Convert English backend value to Arabic UI text
    final arabicType = getCircleTypeText(s.lecture.circleType);
    if (type.contains(arabicType)) {
      selectedLectureType = arabicType;
    } else {
      selectedLectureType = type.isNotEmpty ? type[0] : '';
    }
    showOnWebsite = s.lecture.shownOnWebsite;

    if (teacherResult != null) {
      selectedTeachers = teacherResult!.items
          ?.where((element) =>
              editController!.model.value?.teachers.contains(element.obj) ??
              false)
          .toList();
    }

    // Load existing schedules into the time matrix
    // Ensure the controller is initialized before using it
    if (s.schedules.isNotEmpty) {
      timeCellController.loadSchedules(s.schedules);
    }
  }
}
