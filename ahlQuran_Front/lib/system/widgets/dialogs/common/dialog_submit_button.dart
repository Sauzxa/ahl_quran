import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Submit button with loading indicator
class DialogSubmitButton extends StatelessWidget {
  final RxBool isComplete;
  final VoidCallback onSubmit;
  final bool isEditMode;

  const DialogSubmitButton({
    super.key,
    required this.isComplete,
    required this.onSubmit,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cancel button
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              minimumSize: const Size(120, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text('إلغاء', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 12),
          // Submit button
          Obx(() => ElevatedButton.icon(
                onPressed: isComplete.value ? onSubmit : null,
                icon: isComplete.value
                    ? const Icon(Icons.check)
                    : const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                label: Text(
                  isComplete.value
                      ? 'حفظ'
                      : (isEditMode ? 'جاري التحديث...' : 'جاري الإرسال...'),
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
