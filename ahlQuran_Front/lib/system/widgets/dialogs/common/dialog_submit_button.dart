import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Submit button with loading indicator
class DialogSubmitButton extends StatelessWidget {
  final RxBool isComplete;
  final VoidCallback onSubmit;

  const DialogSubmitButton({
    super.key,
    required this.isComplete,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Obx(() => ElevatedButton.icon(
            onPressed: isComplete.value ? onSubmit : null,
            icon: isComplete.value
                ? const Icon(Icons.send)
                : const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
            label: Text(isComplete.value ? 'Submit' : 'Submitting...'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6), // slight rounding
              ),
            ),
          )),
    );
  }
}
