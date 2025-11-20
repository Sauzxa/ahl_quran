import 'dart:developer' as dev;
import 'dart:typed_data';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'platform_utils.dart';

class PickedImage {
  final Uint8List? bytes;
  final File? file;

  PickedImage({this.file, this.bytes});
  bool get isValid => file != null;
}

class ImagePickerWidget {
  static const int maxImageSizeBytes = 5 * 1024 * 1024;

  static Future<PickedImage?> pickImage(
      BuildContext context, ImageSource source) async {
    try {
      if (!PlatformUtils.isDesktop) {
        Get.snackbar('Unsupported', 'Only available on desktop');
        return null;
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (pickedFile == null) return null;

      File file = File(pickedFile.path);
      if (file.lengthSync() > maxImageSizeBytes) {
        Get.snackbar('Error', 'Image size exceeds 5MB');
        return null;
      }

      return PickedImage(file: file);
    } catch (e, stackTrace) {
      dev.log('Image pick failed', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Failed to pick image');
      return null;
    }
  }

  static Widget imagePreviewWidget(BuildContext context, File? image) {
    final theme = Theme.of(context);
    if (!PlatformUtils.isDesktop) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(8),
          color: theme.cardColor,
        ),
        child: Text(
          'Image preview is only available on desktop',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (image == null) {
      return Container(
        constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(8),
          color: theme.cardColor,
        ),
        child: Center(
          child: Text(
            'No image selected',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
        color: theme.cardColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          image,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                'Failed to load image',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
