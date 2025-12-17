import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/generic_edit_controller.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/profile_controller.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/dialogs/dialog.dart';
import '../custom_container.dart';
import '../input_field.dart';
import '../../new_models/forms/teacher_form.dart';
import '../../../controllers/generate.dart';
import '../../../controllers/validator.dart';
import '../../../system/services/network/api_endpoints.dart';

class TeacherDialog extends GlobalDialog {
  const TeacherDialog({
    super.key,
    super.dialogHeader = "إضافة معلم",
    super.numberInputs = 5,
  });

  @override
  State<GlobalDialog> createState() => _TeacherDialogState();
}

class _TeacherDialogState<GEC extends GenericEditController<TeacherInfoDialog>>
    extends DialogState<GEC> {
  late Generate generate;
  var teacherInfo = TeacherInfoDialog();

  @override
  void initState() {
    super.initState();
    generate = Get.isRegistered<Generate>()
        ? Get.find<Generate>()
        : Get.put(Generate());
    formController.controllers[4].text = generate.generatePassword();

    if (editController?.model.value != null) {
      teacherInfo = editController?.model.value ?? TeacherInfoDialog();
    } else {
      teacherInfo.accountInfo.accountType = "teacher";
    }
  }

  @override
  void dispose() {
    generate.dispose();
    Get.delete<Generate>();
    super.dispose();
  }

  @override
  List<Widget> formChild() {
    return [
      _buildTeacherSection(),
      const SizedBox(height: 10),
      if (editController?.model.value == null) _buildAccountSection(),
    ];
  }

  Widget _buildTeacherSection() {
    return CustomContainer(
      headerText: "معلومات المعلم",
      headerIcon: Icons.person,
      child: Column(
        children: [
          _buildNameRow(),
          const SizedBox(height: 8),
          _buildEmailAndRiwayaRow(),
        ],
      ),
    );
  }

  Widget _buildNameRow() {
    return Row(
      children: [
        Expanded(
          child: InputField(
            inputTitle: "الاسم الأول",
            child: CustomTextField(
              controller: formController.controllers[0],
              validator: (value) =>
                  Validator.notEmptyValidator(value, "يجب إدخال الاسم"),
              focusNode: formController.focusNodes[0],
              onSaved: (p0) => teacherInfo.firstName = p0!,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InputField(
            inputTitle: "اسم العائلة",
            child: CustomTextField(
              controller: formController.controllers[1],
              validator: (value) =>
                  Validator.notEmptyValidator(value, "يجب إدخال الاسم"),
              focusNode: formController.focusNodes[1],
              onSaved: (p0) => teacherInfo.lastName = p0!,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailAndRiwayaRow() {
    return Row(
      children: [
        Expanded(
          child: InputField(
            inputTitle: "البريد الإلكتروني",
            child: CustomTextField(
              controller: formController.controllers[2],
              validator: (value) => Validator.isValidEmail(value),
              focusNode: formController.focusNodes[2],
              onSaved: (p0) => teacherInfo.email = p0!,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InputField(
            inputTitle: "الرواية",
            child: CustomTextField(
              controller: formController.controllers[3],
              validator: (value) =>
                  Validator.notEmptyValidator(value, "يجب إدخال الرواية"),
              focusNode: formController.focusNodes[3],
              onSaved: (p0) => teacherInfo.riwaya = p0!,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return CustomContainer(
      headerIcon: Icons.account_box,
      headerText: "معلومات الحساب",
      child: Row(
        children: [
          Expanded(
            child: InputField(
              inputTitle: "كلمة المرور",
              child: CustomTextField(
                controller: formController.controllers[4],
                onSaved: (p0) => teacherInfo.accountInfo.passcode = p0!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void setDefaultFieldsValue() {
    final t = editController?.model.value;
    formController.controllers[0].text = t?.firstName ?? '';
    formController.controllers[1].text = t?.lastName ?? '';
    formController.controllers[2].text = t?.email ?? '';
    formController.controllers[3].text = t?.riwaya ?? '';
    if (editController?.model.value == null) {
      formController.controllers[4].text = generate.generatePassword();
    }
  }

  @override
  Future<void> loadData() => Future(() {});

  @override
  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;
    formKey.currentState!.save();

    final profileController = Get.find<ProfileController>();
    final authToken = profileController.token.value;

    if (authToken.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يجب تسجيل الدخول أولاً',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      if (editController?.model.value == null) {
        // Create mode
        final body = {
          'firstname': teacherInfo.firstName,
          'lastname': teacherInfo.lastName,
          'email': teacherInfo.email,
          'riwaya': teacherInfo.riwaya,
          'password': teacherInfo.accountInfo.passcode,
        };

        final response = await http.post(
          Uri.parse(ApiEndpoints.getTeachers),
          headers: {
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer $authToken",
          },
          body: jsonEncode(body),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          return true;
        } else {
          debugPrint('Error creating teacher: ${response.body}');
          return false;
        }
      } else {
        // Edit mode
        final teacherId = teacherInfo.teacherId;
        if (teacherId == null) {
          Get.snackbar(
            'خطأ',
            'معرف المعلم غير موجود',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }

        final body = {
          'firstname': teacherInfo.firstName,
          'lastname': teacherInfo.lastName,
          'email': teacherInfo.email,
          'riwaya': teacherInfo.riwaya,
        };

        final response = await http.put(
          Uri.parse(ApiEndpoints.getTeacherById(teacherId)),
          headers: {
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer $authToken",
          },
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          return true;
        } else {
          debugPrint('Error updating teacher: ${response.body}');
          return false;
        }
      }
    } catch (e) {
      debugPrint('Error submitting teacher: $e');
      return false;
    }
  }
}
