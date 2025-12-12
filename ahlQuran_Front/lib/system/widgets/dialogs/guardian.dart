// Imports
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/generic_edit_controller.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/dialogs/dialog.dart';
import '../drop_down.dart';
import '../../../controllers/submit_form.dart';
import '../../new_models/forms/guardian_form.dart';
import '../../utils/const/guardian.dart';
import '../../../controllers/generate.dart';
import '../../../controllers/validator.dart';
import '../custom_container.dart';
import '../input_field.dart';
import '../../../system/services/network/api_endpoints.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/helpers/date_picker.dart';

class GuardianDialog extends GlobalDialog {
  const GuardianDialog({
    super.key,
    super.dialogHeader = "إضافة ولي",
    super.numberInputs = 10,
  });

  @override
  State<GlobalDialog> createState() => _GuardianDialogState();
}

class _GuardianDialogState<
        GEC extends GenericEditController<GuardianInfoDialog>>
    extends DialogState<GEC> {
  late Generate generate;
  var guardianInfo = GuardianInfoDialog();

  @override
  void initState() {
    super.initState();
    generate = Get.isRegistered<Generate>()
        ? Get.find<Generate>()
        : Get.put(Generate());
    formController.controllers[9].text = generate.generatePassword();

    if (editController?.model.value != null) {
      guardianInfo = editController?.model.value ?? GuardianInfoDialog();
    } else {
      guardianInfo.accountInfo.accountType = "guardian";
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
      _buildGuardianSection(),
      const SizedBox(height: 10),
      _buildAccountSection(),
      const SizedBox(height: 10),
      // TODO: add profile Image section
    ];
  }

  Widget _buildGuardianSection() {
    return CustomContainer(
      headerText: "معلومات الوصي",
      headerIcon: Icons.person,
      child: Column(
        children: [
          _buildNameRow(),
          const SizedBox(height: 8),
          _buildRelationAndDobRow(),
          const SizedBox(height: 8),
          _buildContactRow(),
          const SizedBox(height: 8),
          _buildAddressAndJobRow(),
        ],
      ),
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
              inputTitle: "اسم المستخدم",
              child: CustomTextField(
                controller: formController.controllers[8],
                onSaved: (p0) => guardianInfo.accountInfo.username = p0!,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InputField(
              inputTitle: "كلمة المرور",
              child: CustomTextField(
                controller: formController.controllers[9],
                onSaved: (p0) => guardianInfo.accountInfo.passcode = p0!,
              ),
            ),
          ),
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
              onSaved: (p0) => guardianInfo.guardian.firstName = p0!,
              onChanged: (_) => formController.controllers[8].text =
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
              onChanged: (_) => formController.controllers[8].text =
                  generate.generateUsername(formController.controllers[0],
                      formController.controllers[1]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelationAndDobRow() {
    return Row(
      children: [
        Expanded(
          child: InputField(
            inputTitle: "العلاقة",
            child: DropDownWidget(
              items: relationship,
              initialValue:
                  editController?.model.value?.guardian.relationship ??
                      relationship[0],
              onSaved: (p0) => guardianInfo.guardian.relationship = p0!,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InputField(
            inputTitle: "تاريخ الميلاد",
            child: CustomTextField(
              controller: formController.controllers[3],
              readOnly: true,
              onTap: () async {
                DateTime initialDate = formController
                        .controllers[3].text.isNotEmpty
                    ? DateTime.tryParse(formController.controllers[3].text) ??
                        DateTime.now()
                    : DateTime.now();

                final pickedDate = await showCustomDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  formController.controllers[3].text =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                }
              },
              onSaved: (p0) => guardianInfo.guardian.dateOfBirth = p0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow() {
    return Row(
      children: [
        Expanded(
          child: InputField(
            inputTitle: "رقم الهاتف",
            child: CustomTextField(
              controller: formController.controllers[4],
              validator: (value) => Validator.isValidPhoneNumber(value),
              focusNode: formController.focusNodes[4],
              onSaved: (p0) => guardianInfo.contactInfo.phoneNumber = p0!,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InputField(
            inputTitle: "عنوان البريد الإلكتروني",
            child: CustomTextField(
              controller: formController.controllers[5],
              validator: (value) => Validator.isValidEmail(value),
              focusNode: formController.focusNodes[5],
              onSaved: (p0) => guardianInfo.contactInfo.email = p0!,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressAndJobRow() {
    return Row(
      children: [
        Expanded(
          child: InputField(
            inputTitle: "العنوان",
            child: CustomTextField(
              controller: formController.controllers[6],
              onSaved: (p0) => guardianInfo.guardian.homeAddress = p0,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InputField(
            inputTitle: "الوظيفة",
            child: CustomTextField(
              controller: formController.controllers[7],
              onSaved: (p0) => guardianInfo.guardian.job = p0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void setDefaultFieldsValue() {
    final s = editController?.model.value;
    formController.controllers[0].text = s?.guardian.firstName ?? '';
    formController.controllers[1].text = s?.guardian.lastName ?? '';
    formController.controllers[2].text = s?.guardian.relationship ?? '';
    formController.controllers[3].text = s?.guardian.dateOfBirth ?? '';
    formController.controllers[4].text = s?.contactInfo.phoneNumber ?? '';
    formController.controllers[5].text = s?.contactInfo.email ?? '';
    formController.controllers[6].text = s?.guardian.homeAddress ?? '';
    formController.controllers[7].text = s?.guardian.job ?? '';
    formController.controllers[8].text = s?.accountInfo.username ?? '';
    formController.controllers[9].text = s?.accountInfo.passcode ?? '';
  }

  @override
  Future<void> loadData() => Future(() {});

  @override
  Future<bool> submit() async {
    return editController?.model.value == null
        ? await submitForm(
            formKey,
            guardianInfo,
            ApiEndpoints.submitGuardianForm,
            (GuardianInfoDialog.fromJson),
          )
        : await submitEditDataForm(
            formKey,
            guardianInfo,
            ApiEndpoints.getSpecialGuardiansById(
                guardianInfo.accountInfo.accountId ?? 0),
            (GuardianInfoDialog.fromJson),
          );
  }
}
