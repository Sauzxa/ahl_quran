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
    formController = Get.find<form.FormController>(tag: "guardian");
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    formController.dispose();
    generate.dispose();
    Get.delete<form.FormController>(tag: "guardian");
    Get.delete<Generate>();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    isComplete.value = false;
    guardianInfo.accountInfo.passcode = guardianInfo.accountInfo.username;
    final success = await submitForm(
      guardianFormKey,
      guardianInfo,
      ApiEndpoints.submitGuardianForm,
      (GuardianInfoDialog.fromJson),
    );
    if (success) {
      Get.back();
    }
    isComplete.value = true;
  }

  Widget _buildHeader() {
    return DialogHeader(title: 'إضافة ولي أمر');
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
            inputTitle: "الاسم الأول",
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
            inputTitle: "اسم العائلة",
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
            inputTitle: "رقم الهاتف",
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
            inputTitle: "البريد الإلكتروني",
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
      inputTitle: "العلاقة",
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
        maxWidth: Get.width * 0.55,
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
