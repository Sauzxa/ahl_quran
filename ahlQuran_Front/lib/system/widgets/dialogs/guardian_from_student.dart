import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/form_controller.dart' as form;
import '../../../controllers/generate.dart';
import '../../../controllers/validator.dart';
import '../../../system/services/network/api_endpoints.dart';
import '../../../controllers/submit_form.dart';
import '../../new_models/forms/guardian_form.dart';
import '../custom_container.dart';
import '../input_field.dart';
import '../drop_down.dart';
import './common/dialog_submit_button.dart';
import './common/dialog_header.dart';
import '../../utils/const/guardian.dart';

class GuardianDialogLite extends StatefulWidget {
  const GuardianDialogLite({super.key});

  @override
  State<GuardianDialogLite> createState() => _GuardianDialogLiteState();
}

class _GuardianDialogLiteState extends State<GuardianDialogLite> {
  final GlobalKey<FormState> guardianFormKey = GlobalKey<FormState>();
  late ScrollController scrollController;
  late Generate generate;
  late form.FormController formController;
  final guardianInfo = GuardianInfoDialog();
  RxBool isComplete = true.obs;

  @override
  void initState() {
    super.initState();
    generate = Get.find<Generate>();
    // Use the same tag "وصي" as defined in StudentDialog
    formController = Get.find<form.FormController>(tag: "وصي");
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    formController.dispose();
    generate.dispose();
    Get.delete<form.FormController>(tag: "وصي");
    Get.delete<Generate>();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!guardianFormKey.currentState!.validate()) return;
    guardianFormKey.currentState!.save();

    // Generate username/passcode if needed, though username is generated on change
    guardianInfo.accountInfo.passcode = guardianInfo.accountInfo.username;

    // Return the collected guardian info to the parent dialog
    // The parent (StudentDialog) will handle the actual submission to the backend
    Get.back(result: guardianInfo);
  }

  Widget _buildHeader() {
    return const DialogHeader(title: 'إضافة حساب ولي أمر');
  }

  Widget _buildFormContent() {
    return Flexible(
      child: Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Form(
            key: guardianFormKey,
            child: _buildGuardianInfoSection(),
          ),
        ),
      ),
    );
  }

  Widget _buildGuardianInfoSection() {
    return CustomContainer(
      headerText: "معلومات ولي الأمر",
      headerIcon: Icons.person,
      child: Column(
        children: [
          _buildNameFields(),
          const SizedBox(height: 8),
          _buildContactFields(),
          const SizedBox(height: 8),
          _buildRelationshipField(),
        ],
      ),
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: InputField(
            inputTitle: "الاسم",
            child: CustomTextField(
              controller: formController.controllers[0],
              validator: (value) =>
                  Validator.notEmptyValidator(value, "يجب إدخال الاسم"),
              focusNode: formController.focusNodes[0],
              onSaved: (p0) => guardianInfo.guardian.firstName = p0!,
              onChanged: (_) => guardianInfo.accountInfo.username =
                  generate.generateUsername(formController.controllers[0],
                      formController.controllers[1]),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InputField(
            inputTitle: "الكنية",
            child: CustomTextField(
              controller: formController.controllers[1],
              validator: (value) =>
                  Validator.notEmptyValidator(value, "يجب إدخال الاسم"),
              focusNode: formController.focusNodes[1],
              onSaved: (p0) => guardianInfo.guardian.lastName = p0!,
              onChanged: (_) => guardianInfo.accountInfo.username =
                  generate.generateUsername(formController.controllers[0],
                      formController.controllers[1]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactFields() {
    return Row(
      children: [
        Expanded(
          child: InputField(
            inputTitle: "رقم الهاتف (سيعتبر اسم المستخدم)",
            child: CustomTextField(
              controller: formController.controllers[2],
              validator: (value) => Validator.isValidPhoneNumber(value),
              focusNode: formController.focusNodes[2],
              onSaved: (p0) => guardianInfo.contactInfo.phoneNumber = p0!,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InputField(
            inputTitle: "البريد الالكتروني",
            child: CustomTextField(
              controller: formController.controllers[3],
              validator: (value) => Validator.isValidEmail(value),
              focusNode: formController.focusNodes[3],
              onSaved: (p0) => guardianInfo.contactInfo.email = p0!,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelationshipField() {
    return InputField(
      inputTitle: "صلة القرابة",
      child: DropDownWidget(
        items: relationship,
        initialValue: relationship[0],
        onSaved: (p0) => guardianInfo.guardian.relationship = p0!,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return DialogSubmitButton(
      isComplete: isComplete,
      onSubmit: _handleSubmit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 300,
        maxWidth: Get.width * 0.45, // Match StudentDialog width
      ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildFormContent(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
}
