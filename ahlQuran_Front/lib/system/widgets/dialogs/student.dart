import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/generic_edit_controller.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/submit_form.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/guardian.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/new_models/lecture.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/services/network/api_endpoints.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/dialogs/dialog.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/system/widgets/dialogs/guardian_from_student.dart';
import '../custom_container.dart';
import '../input_field.dart';
import '../../../controllers/validator.dart';
import '../../new_models/student.dart';
import '../multiselect.dart';
import '../../utils/const/student.dart';
import '../../../controllers/generate.dart';
import '../drop_down.dart';
import '../../../controllers/form_controller.dart' as form;
import './image_picker_widget.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/helpers/date_picker.dart';

class StudentDialog<GEC extends GenericEditController<Student>>
    extends GlobalDialog {
  const StudentDialog({
    super.key,
    super.dialogHeader = "إضافة طالب",
    super.numberInputs = 15,
  });

  @override
  State<GlobalDialog> createState() =>
      _StudentDialogState<GenericEditController<Student>>();
}

class _StudentDialogState<GEC extends GenericEditController<Student>>
    extends DialogState<GEC> {
  late Generate generate;
  Student studentInfo = Student();
  bool isClicked = false; //TODO   remove this variable if not needed
  RxBool isExempt = false.obs;
  Rx<String?> enrollmentDate = Rxn<String>();
  Rx<String?> exitDate = Rxn<String>();
  MultiSelectResult<Lecture>? sessionResult;
  MultiSelectResult? guardianResult;
  //late Picker imagePicker;

  @override
  Future<void> loadData() async {
    try {
      final fetchedSessionNames =
          await getItems<Lecture>(ApiEndpoints.getLectures, Lecture.fromJson);
      final fetchedGuardianAccounts = await getItems<Guardian>(
          ApiEndpoints.getGuardianAccounts, Guardian.fromJson);

      dev.log('sessionNames: ${fetchedSessionNames.toString()}');
      dev.log('guardianAccounts: ${fetchedGuardianAccounts.toString()}');

      setState(() {
        sessionResult = fetchedSessionNames;
        guardianResult = fetchedGuardianAccounts;
      });
    } catch (e) {
      dev.log("Error loading data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    generate = Get.isRegistered<Generate>()
        ? Get.find<Generate>()
        : Get.put(Generate());
    formController.controllers[7].text = generate.generatePassword();

    if (editController?.model.value != null) {
      studentInfo = editController?.model.value ?? Student();
    } else {
      studentInfo.accountInfo.accountType = "طالب";
    }
  }

  @override
  void dispose() {
    generate.dispose();
    if (Get.isRegistered<Generate>()) {
      Get.delete<Generate>();
    }
    super.dispose();
  }

  @override
  List<Widget> formChild() {
    return [
      SessionSection(
        sessionResult: sessionResult,
        editController: editController,
        studentInfo: studentInfo,
      ),
      PersonalInfoSection(
        formController: formController,
        editController: editController,
        studentInfo: studentInfo,
        generate: generate,
      ),
      AccountInfoSection(
        formController: formController,
        studentInfo: studentInfo,
      ),
      HealthInfoSection(
        formController: formController,
        editController: editController,
        studentInfo: studentInfo,
      ),
      ContactInfoSection(
        formController: formController,
        studentInfo: studentInfo,
      ),
      ParentStatusSection(
        editController: editController,
        studentInfo: studentInfo,
      ),
      GuardianInfoSection(
        guardianResult: guardianResult,
        studentInfo: studentInfo,
      ),
      SubscriptionInfoSection(
        formController: formController,
        editController: editController,
        studentInfo: studentInfo,
        enrollmentDate: enrollmentDate,
        exitDate: exitDate,
        isExempt: isExempt,
      ),
      FormalEducationSection(
        formController: formController,
        editController: editController,
        studentInfo: studentInfo,
      ),
      ImageSection(
        editController: editController,
      )
    ];
  }

  @override
  void setDefaultFieldsValue() {
    final s = editController?.model.value;
    formController.controllers[0].text = s?.personalInfo.firstNameAr ?? '';
    formController.controllers[1].text = s?.personalInfo.lastNameAr ?? '';
    formController.controllers[2].text = s?.personalInfo.firstNameEn ?? '';
    formController.controllers[3].text = s?.personalInfo.lastNameEn ?? '';
    formController.controllers[4].text = s?.personalInfo.dateOfBirth ?? '';
    formController.controllers[5].text = s?.personalInfo.homeAddress ?? '';
    formController.controllers[6].text = s?.accountInfo.username ?? '';
    formController.controllers[7].text = s?.accountInfo.passcode ?? '';
    formController.controllers[8].text = s?.medicalInfo.diseasesCauses ?? '';
    formController.controllers[9].text = s?.medicalInfo.allergies ?? '';
    formController.controllers[10].text = s?.contactInfo.phoneNumber ?? '';
    formController.controllers[11].text = s?.contactInfo.email ?? '';
    formController.controllers[12].text = s?.subscriptionInfo.exitReason ?? '';
    formController.controllers[13].text =
        s?.formalEducationInfo.schoolName ?? '';
    formController.controllers[14].text = s?.personalInfo.placeOfBirth ?? '';
    enrollmentDate.value = s?.subscriptionInfo.enrollmentDate;
    exitDate.value = s?.subscriptionInfo.exitDate;
    isExempt.value = s?.subscriptionInfo.isExemptFromPayment == 1;
  }

  @override
  Future<bool> submit() async {
    return super.editController?.model.value == null
        ? await submitForm<Student>(
            formKey,
            studentInfo,
            ApiEndpoints.submitStudentForm,
            Student.fromJson,
          )
        : await submitEditDataForm<Student>(
            formKey,
            studentInfo,
            ApiEndpoints.getSpecialStudent(
                editController?.model.value?.accountInfo.accountId ?? -1),
            Student.fromJson,
          );
  }
}

// Session Section
class SessionSection extends StatelessWidget {
  final MultiSelectResult<Lecture>? sessionResult;
  final GenericEditController<Student>? editController;
  final Student studentInfo;

  const SessionSection({
    super.key,
    required this.sessionResult,
    required this.editController,
    required this.studentInfo,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      headerIcon: Icons.book,
      headerText: "الجلسة",
      child: MultiSelect<Lecture>(
        initialPickedItems: (editController?.model.value?.lectures ?? [])
            .map((e) => MultiSelectItem<Lecture>(
                  id: e.lectureId,
                  obj: e,
                  name: e.lectureNameAr,
                ))
            .toList(),
        getPickedItems: (pickedItems) {
          studentInfo.lectures = pickedItems.map((e) => e.obj).toList();
        },
        hintText: "البحث عن الجلسات",
        preparedData: sessionResult?.items ?? [],
        maxSelectedItems: null,
      ),
    );
  }
}

// Personal Info Section
class PersonalInfoSection extends StatelessWidget {
  final form.FormController formController;
  final GenericEditController<Student>? editController;
  final Student studentInfo;
  final Generate generate;

  const PersonalInfoSection({
    super.key,
    required this.formController,
    required this.editController,
    required this.studentInfo,
    required this.generate,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      headerIcon: Icons.person,
      headerText: "معلومات الطالب الشخصية",
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InputField(
                  inputTitle: "الاسم الأول بالعربية",
                  child: CustomTextField(
                    controller: formController.controllers[0],
                    validator: (value) =>
                        Validator.notEmptyValidator(value, "يجب إدخال الاسم"),
                    focusNode: formController.focusNodes[0],
                    onSaved: (p0) => studentInfo.personalInfo.firstNameAr = p0!,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InputField(
                  inputTitle: "اسم العائلة بالعربية",
                  child: CustomTextField(
                    controller: formController.controllers[1],
                    validator: (value) =>
                        Validator.notEmptyValidator(value, "يجب إدخال الاسم"),
                    focusNode: formController.focusNodes[1],
                    onSaved: (p0) => studentInfo.personalInfo.lastNameAr = p0!,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InputField(
                  inputTitle: "الاسم الأول باللاتينية",
                  child: CustomTextField(
                    controller: formController.controllers[2],
                    textDirection: TextDirection.ltr,
                    onChanged: (_) => formController.controllers[6].text =
                        generate.generateUsername(formController.controllers[2],
                            formController.controllers[3]),
                    onSaved: (p0) => studentInfo.personalInfo.firstNameEn = p0,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InputField(
                  inputTitle: "اسم العائلة باللاتينية",
                  child: CustomTextField(
                    controller: formController.controllers[3],
                    textDirection: TextDirection.ltr,
                    onChanged: (_) => formController.controllers[6].text =
                        generate.generateUsername(formController.controllers[2],
                            formController.controllers[3]),
                    onSaved: (p0) => studentInfo.personalInfo.lastNameEn = p0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InputField(
                  inputTitle: "الجنس",
                  child: DropDownWidget(
                    items: sex,
                    initialValue: editController?.model.value != null
                        ? editController?.model.value?.personalInfo.sex
                        : sex[0],
                    onSaved: (p0) => studentInfo.personalInfo.sex = p0!,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InputField(
                  inputTitle: "تاريخ الميلاد",
                  child: CustomTextField(
                    controller: formController.controllers[4],
                    readOnly: true,
                    onTap: () async {
                      DateTime initialDate;
                      if (formController.controllers[4].text.isNotEmpty) {
                        initialDate = DateTime.tryParse(
                                formController.controllers[4].text) ??
                            DateTime.now();
                      } else {
                        initialDate = DateTime.now();
                      }

                      final pickedDate = await showCustomDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        formController.controllers[4].text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      }
                    },
                    onSaved: (p0) => studentInfo.personalInfo.dateOfBirth = p0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InputField(
                  inputTitle: "مكان الميلاد",
                  child: CustomTextField(
                    controller: formController.controllers[14],
                    onSaved: (p0) => studentInfo.personalInfo.placeOfBirth = p0,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InputField(
                  inputTitle: "العنوان",
                  child: CustomTextField(
                    controller: formController.controllers[5],
                    onSaved: (p0) => studentInfo.personalInfo.homeAddress = p0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InputField(
                  inputTitle: "الجنسية",
                  child: DropDownWidget(
                    items: nationalities,
                    initialValue:
                        editController?.model.value?.personalInfo.nationality ??
                            nationalities[1],
                    onSaved: (p0) => studentInfo.personalInfo.nationality = p0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Account Info Section
class AccountInfoSection extends StatelessWidget {
  final form.FormController formController;
  final Student studentInfo;

  const AccountInfoSection({
    super.key,
    required this.formController,
    required this.studentInfo,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      headerIcon: Icons.account_box,
      headerText: "معلومات الحساب",
      child: Row(
        children: [
          Expanded(
            child: InputField(
              inputTitle: "اسم المستخدم",
              child: CustomTextField(
                controller: formController.controllers[6],
                onSaved: (p0) => studentInfo.accountInfo.username = p0!,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InputField(
              inputTitle: "كلمة المرور",
              child: CustomTextField(
                controller: formController.controllers[7],
                onSaved: (p0) => studentInfo.accountInfo.passcode = p0!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Health Info Section
class HealthInfoSection extends StatelessWidget {
  final form.FormController formController;
  final GenericEditController<Student>? editController;
  final Student studentInfo;

  const HealthInfoSection({
    super.key,
    required this.formController,
    required this.editController,
    required this.studentInfo,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      headerIcon: Icons.health_and_safety,
      headerText: "المعلومات الصحية",
      child: Row(
        children: [
          Expanded(
            child: InputField(
              inputTitle: "فصيلة الدم",
              child: DropDownWidget(
                items: bloodType,
                initialValue:
                    editController?.model.value?.medicalInfo.bloodType ??
                        bloodType[0],
                onSaved: (p0) => studentInfo.medicalInfo.bloodType = p0,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InputField(
              inputTitle: "أسباب الأمراض",
              child: CustomTextField(
                controller: formController.controllers[8],
                onSaved: (p0) => studentInfo.medicalInfo.diseasesCauses = p0,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InputField(
              inputTitle: "الحساسية",
              child: CustomTextField(
                controller: formController.controllers[9],
                onSaved: (p0) => studentInfo.medicalInfo.allergies = p0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Contact Info Section
class ContactInfoSection extends StatelessWidget {
  final form.FormController formController;
  final Student studentInfo;

  const ContactInfoSection({
    super.key,
    required this.formController,
    required this.studentInfo,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      headerIcon: Icons.phone,
      headerText: "معلومات الاتصال",
      child: Row(
        children: [
          Expanded(
            child: InputField(
              inputTitle: "رقم الهاتف",
              child: CustomTextField(
                controller: formController.controllers[10],
                validator: (value) => Validator.isValidPhoneNumber(value),
                focusNode: formController.focusNodes[10],
                onSaved: (p0) => studentInfo.contactInfo.phoneNumber = p0!,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InputField(
              inputTitle: "عنوان البريد الإلكتروني",
              child: CustomTextField(
                controller: formController.controllers[11],
                validator: (value) => Validator.isValidEmail(value),
                focusNode: formController.focusNodes[11],
                onSaved: (p0) => studentInfo.contactInfo.email = p0!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Parent Status Section
class ParentStatusSection extends StatelessWidget {
  final GenericEditController<Student>? editController;
  final Student studentInfo;

  const ParentStatusSection({
    super.key,
    required this.editController,
    required this.studentInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomContainer(
            headerIcon: Icons.person,
            headerText: "حالة الأب",
            child: DropDownWidget(
              items: state,
              initialValue:
                  editController?.model.value?.personalInfo.fatherStatus ??
                      state[0],
              onSaved: (p0) => studentInfo.personalInfo.fatherStatus = p0,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomContainer(
            headerIcon: Icons.person,
            headerText: "حالة الأم",
            child: DropDownWidget(
              items: state,
              initialValue:
                  editController?.model.value?.personalInfo.motherStatus ??
                      state[0],
              onSaved: (p0) => studentInfo.personalInfo.motherStatus = p0,
            ),
          ),
        ),
      ],
    );
  }
}

// Guardian Info Section
class GuardianInfoSection extends StatelessWidget {
  final MultiSelectResult? guardianResult;
  final Student studentInfo;

  const GuardianInfoSection({
    super.key,
    required this.guardianResult,
    required this.studentInfo,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      headerIcon: Icons.family_restroom,
      headerText: "معلومات عن الوصي",
      headreActions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: IconButton(
            onPressed: () async {
              Get.put(form.FormController(5), tag: "وصي");
              Get.put(Generate());
              Get.dialog(const GuardianDialogLite());
            },
            icon: Icon(
              Icons.add,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
      ],
      child: Row(
        children: [
          Expanded(
            child: InputField(
              inputTitle: "حساب الوصي",
              child: MultiSelect(
                getPickedItems: (pickedItems) {
                  if (pickedItems.isNotEmpty) {
                    studentInfo.guardian.guardianId = pickedItems[0].id;
                  }
                },
                preparedData: guardianResult?.items ?? [],
                hintText: "البحث عن حساب الوصي",
                maxSelectedItems: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Subscription Info Section
class SubscriptionInfoSection extends StatelessWidget {
  final form.FormController formController;
  final GenericEditController<Student>? editController;
  final Student studentInfo;
  final Rx<String?> enrollmentDate;
  final Rx<String?> exitDate;
  final RxBool isExempt;

  const SubscriptionInfoSection({
    super.key,
    required this.formController,
    required this.editController,
    required this.studentInfo,
    required this.enrollmentDate,
    required this.exitDate,
    required this.isExempt,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      headerText: "معلومات الاشتراك",
      headerIcon: Icons.subscriptions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateRow(context),
          const SizedBox(height: 12),
          _buildExemptRow(),
          const SizedBox(height: 12),
          _buildExitReasonField(),
        ],
      ),
    );
  }

  /// Row containing enrollment and exit date pickers
  Widget _buildDateRow(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildEnrollmentDatePicker(context)),
        const SizedBox(width: 12),
        Expanded(child: _buildExitDatePicker(context)),
      ],
    );
  }

  /// Row containing isExempt and exemption percentage dropdowns
  Widget _buildExemptRow() {
    return Row(
      children: [
        Expanded(child: _buildIsExemptDropdown()),
        const SizedBox(width: 12),
        Expanded(child: _buildExemptionPercentageDropdown()),
      ],
    );
  }

  /// Full width exit reason field
  Widget _buildExitReasonField() {
    return InputField(
      inputTitle: "سبب الخروج",
      child: CustomTextField(
        controller: formController.controllers[12],
        onSaved: (p0) => studentInfo.subscriptionInfo.exitReason = p0,
        maxLines: 3,
      ),
    );
  }

  Widget _buildEnrollmentDatePicker(BuildContext context) {
    return InputField(
      inputTitle: "تاريخ التسجيل",
      child: Obx(() => OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              minimumSize: const Size(0, 36), // small button height
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4), // more square
              ),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            onPressed: () async {
              final date = await showCustomDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                final dateStr = "${date.year}-${date.month}-${date.day}";
                enrollmentDate.value = dateStr;
                studentInfo.subscriptionInfo.enrollmentDate = dateStr;
              }
            },
            child: Text(enrollmentDate.value ?? "اختر التاريخ"),
          )),
    );
  }

  Widget _buildExitDatePicker(BuildContext context) {
    return InputField(
      inputTitle: "تاريخ الخروج",
      child: Obx(() => OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              minimumSize: const Size(0, 36), // small button height
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4), // more square
              ),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            onPressed: () async {
              final date = await showCustomDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                final dateStr = "${date.year}-${date.month}-${date.day}";
                exitDate.value = dateStr;
                studentInfo.subscriptionInfo.exitDate = dateStr;
              }
            },
            child: Text(exitDate.value ?? "اختر التاريخ"),
          )),
    );
  }

  Widget _buildIsExemptDropdown() {
    return InputField(
      inputTitle: "معفى من الدفع",
      child: DropDownWidget<bool>(
        items: trueFalse,
        initialValue: (editController
                ?.model.value?.subscriptionInfo.isExemptFromPayment ==
            1),
        onChanged: (p0) => isExempt.value = p0!,
        onSaved: (p0) => studentInfo.subscriptionInfo.isExemptFromPayment =
            p0 == true ? 1 : 0,
      ),
    );
  }

  Widget _buildExemptionPercentageDropdown() {
    return InputField(
      inputTitle: "نسبة الإعفاء",
      child: Obx(() => AbsorbPointer(
            absorbing: !isExempt.value,
            child: Opacity(
              opacity: isExempt.value ? 1.0 : 0.5,
              child: DropDownWidget<double>(
                items: exemptionPercentage,
                initialValue: editController
                        ?.model.value?.subscriptionInfo.exemptionPercentage ??
                    exemptionPercentage[0],
                onChanged: (p0) {
                  studentInfo.subscriptionInfo.exemptionPercentage =
                      isExempt.value ? p0 : null;
                },
                onSaved: (p0) =>
                    studentInfo.subscriptionInfo.exemptionPercentage = p0,
              ),
            ),
          )),
    );
  }
}

// Formal Education Section
class FormalEducationSection extends StatelessWidget {
  final form.FormController formController;
  final GenericEditController<Student>? editController;
  final Student studentInfo;

  const FormalEducationSection({
    super.key,
    required this.formController,
    required this.editController,
    required this.studentInfo,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      headerText: "التعليم الرسمي",
      headerIcon: Icons.school,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InputField(
                  inputTitle: "نوع المدرسة",
                  child: DropDownWidget(
                    items: schoolType,
                    initialValue: editController
                            ?.model.value?.formalEducationInfo.schoolType ??
                        schoolType[0],
                    onSaved: (p0) =>
                        studentInfo.formalEducationInfo.schoolType = p0,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InputField(
                  inputTitle: "اسم المدرسة",
                  child: CustomTextField(
                    controller: formController.controllers[13],
                    onSaved: (p0) =>
                        studentInfo.formalEducationInfo.schoolName = p0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InputField(
                  inputTitle: "المستوى الأكاديمي",
                  child: DropDownWidget(
                    items: academicLevel,
                    initialValue: editController
                            ?.model.value?.formalEducationInfo.academicLevel ??
                        academicLevel[0],
                    onSaved: (p0) =>
                        studentInfo.formalEducationInfo.academicLevel = p0,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InputField(
                  inputTitle: "الصف",
                  child: DropDownWidget(
                    initialValue: editController
                            ?.model.value?.formalEducationInfo.grade ??
                        grades[0],
                    items: grades,
                    onSaved: (p0) => studentInfo.formalEducationInfo.grade = p0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Image Picker Widget

class ImageSection extends StatelessWidget {
  final GenericEditController<Student>? editController;

  const ImageSection({super.key, required this.editController});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      headerIcon: Icons.image,
      headerText: "صورة الطالب",
      child: ImagePickerWidget.imagePreviewWidget(
        context,
        editController?.model.value?.personalInfo.profileImage,
      ),
    );
  }
}
