import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/form_controller.dart'
    as form;
import 'package:the_doctarine_of_the_ppl_of_the_quran/controllers/generic_edit_controller.dart';
import 'common/dialog_header.dart';
import 'common/dialog_submit_button.dart';

/// Abstract dialog that provides a template for forms with optional edit support.
abstract class GlobalDialog extends StatefulWidget {
  final String dialogHeader;
  final int numberInputs;

  const GlobalDialog({
    super.key,
    this.dialogHeader = "add data",
    this.numberInputs = 10,
  });

  @override
  State<GlobalDialog> createState();
}

/// Base state class for form dialogs.
/// Subclasses should define formChild, loadData, submit, setDefaultFieldsValue.
abstract class DialogState<GEC extends GenericEditController>
    extends State<GlobalDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late ScrollController scrollController;
  late form.FormController formController;
  GEC? editController;
  RxBool isComplete = true.obs;

  /// Returns form fields as a Column.
  List<Widget> formChild();

  /// Load any necessary data (e.g. dropdowns, lists).
  Future<void> loadData();

  /// Submit the form data.
  Future<bool> submit();

  /// Pre-fill form when editing.
  void setDefaultFieldsValue();

  @override
  void initState() {
    super.initState();
    loadData();

    if (!Get.isRegistered<form.FormController>()) {
      Get.put(form.FormController(widget.numberInputs));
    }

    if (Get.isRegistered<GEC>()) {
      editController = Get.find<GEC>();
    }

    formController = Get.find<form.FormController>();
    scrollController = ScrollController();

    if (editController?.model.value != null) {
      setDefaultFieldsValue();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    formController.dispose();
    if (Get.isRegistered<ScrollController>()) {
      Get.delete<ScrollController>();
    }
    if (Get.isRegistered<form.FormController>()) {
      Get.delete<form.FormController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sections = formChild();

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
            /// Header section (title + close button)
            DialogHeader(title: widget.dialogHeader),

            /// Form content with scroll
            LayoutBuilder(
              builder: (context, constraints) {
                // Estimate the height of each section (adjust as needed)
                const double itemHeight = 90.0; // or measure dynamically
                const double separatorHeight = 10.0;
                final totalHeight = sections.length * itemHeight +
                    (sections.length - 1) * separatorHeight +
                    40; // padding

                // Set a max height (e.g., 400 or 60% of screen height if unbounded)
                final maxHeight = constraints.hasBoundedHeight &&
                        constraints.maxHeight < double.infinity
                    ? constraints.maxHeight * 0.8
                    : Get.height * 0.8;

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight:
                        totalHeight < maxHeight ? totalHeight : maxHeight,
                  ),
                  child: Form(
                    key: formKey,
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: sections.length,
                      itemBuilder: (context, index) => RepaintBoundary(
                        child: sections[index],
                      ),
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                    ),
                  ),
                );
              },
            ),

            /// Submit button at bottom
            DialogSubmitButton(
              isComplete: isComplete,
              onSubmit: _handleSubmit,
            )
          ],
        ),
      ),
    );
  }

  /// Handles form validation and submission.
  Future<void> _handleSubmit() async {
    debugPrint('Form valid: ${formKey.currentState?.validate()}');
    debugPrint(
        'Fields: ${formController.controllers.map((c) => c.text).toList()}');

    isComplete.value = false;

    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      try {
        final success = await submit();

        if (success) {
          Get.back(result: true);
          Get.snackbar('Success', 'Data submitted successfully',
              snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar('Error', 'Failed to submit data',
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred during submission',
            snackPosition: SnackPosition.BOTTOM);
        debugPrint('Error submitting form: $e');
      } finally {
        isComplete.value = true;
      }
    } else {
      Get.snackbar('Error', 'Please fill out all required fields',
          snackPosition: SnackPosition.BOTTOM);
      isComplete.value = true;
    }
  }
}
