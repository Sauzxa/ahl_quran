import 'package:flutter/material.dart';

//import '/widgets/custom_text_form_feild.dart';
class InputField extends StatelessWidget {
  final String inputTitle;
  final Widget child;

  const InputField({
    required this.inputTitle,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          inputTitle,
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        child
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;
  final TextDirection textDirection;
  final bool readOnly;
  final void Function()? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.onSaved,
    this.validator,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.textDirection = TextDirection.rtl,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      onChanged: onChanged,
      onSaved: (value) {
        debugPrint('onSaved called with value: $value');
        if (onSaved != null) {
          onSaved!(value);
        }
      },
      keyboardType: keyboardType,
      textDirection: textDirection,
      obscureText: obscureText,
      maxLines: maxLines,
      readOnly: readOnly, // NEW
      onTap: onTap, // NEW
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
        hoverColor: Theme.of(context).inputDecorationTheme.hoverColor,
      ),
      style: TextStyle(
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
    );
  }
}
