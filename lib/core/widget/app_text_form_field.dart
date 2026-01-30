import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom text form field that follows the app's modern design system.
class AppTextFormField extends StatelessWidget {
  /// Creates an [AppTextFormField].
  const AppTextFormField({
    required this.controller,
    super.key,
    this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.inputFormatters,
  });

  /// The controller for the text field.
  final TextEditingController controller;

  /// The label text to display.
  final String? labelText;

  /// The hint text to display.
  final String? hintText;

  /// The type of keyboard to display.
  final TextInputType keyboardType;

  /// The action button to display on the keyboard.
  final TextInputAction textInputAction;

  /// A function that validates the text input.
  final String? Function(String?)? validator;

  /// The maximum number of lines.
  final int maxLines;

  /// Whether the text field is read-only.
  final bool readOnly;

  /// A callback when the text field is tapped.
  final VoidCallback? onTap;

  /// An optional widget to display at the end of the text field.
  final Widget? suffixIcon;

  /// Optional input formatters to apply to the text.
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    validator: validator,
    maxLines: maxLines,
    readOnly: readOnly,
    onTap: onTap,
    inputFormatters: inputFormatters,
    decoration: InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: context.colorScheme.outline.withAlpha(80),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: context.colorScheme.outline.withAlpha(80),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: context.colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: context.colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: context.colorScheme.error, width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
    ),
  );
}
