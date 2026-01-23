import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom text field widget that provides a flexible and styled input field.
///
/// This widget allows for various configurations such as label text, hint text,
/// prefix and suffix icons, and input validation. It also supports different
/// keyboard types and actions, as well as customization for appearance and behavior.
///
/// The [CustomTextField] is a stateless widget that requires a [controller]
/// to manage the text input. Other parameters are optional and can be used
/// to customize the text field's appearance and functionality.
///
class CustomTextField extends StatelessWidget {
  /// Creates a [CustomTextField].
  ///
  /// The [controller] parameter is required and must not be null.
  const CustomTextField({
    required this.controller,
    super.key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
    this.height,
  });

  /// The controller for managing the text input.
  final TextEditingController controller;

  /// The text to display as the label for the text field.
  final String? labelText;

  /// The text to display as a hint in the text field.
  final String? hintText;

  /// An optional icon to display before the text input.
  final IconData? prefixIcon;

  /// An optional widget to display after the text input.
  final Widget? suffixIcon;

  /// Whether the text input should be obscured (e.g., for passwords).
  final bool obscureText;

  /// The type of keyboard to use for the text input.
  final TextInputType keyboardType;

  /// The action button to display on the keyboard.
  final TextInputAction textInputAction;

  /// A function to validate the input text.
  final String? Function(String?)? validator;

  /// A callback function that is called when the text changes.
  final void Function(String)? onChanged;

  /// A callback function that is called when the text is submitted.
  final void Function(String)? onSubmitted;

  /// Whether the text field is enabled or disabled.
  final bool enabled;

  /// The maximum number of lines the text field can display.
  final int maxLines;

  /// The minimum number of lines the text field can display.
  final int? minLines;

  /// The maximum number of characters allowed in the text field.
  final int? maxLength;

  /// A list of input formatters to control the input format.
  final List<TextInputFormatter>? inputFormatters;

  /// A node to manage the focus of the text field.
  final FocusNode? focusNode;

  /// Whether the text field should be focused automatically.
  final bool autofocus;

  /// Whether the text field is read-only.
  final bool readOnly;

  /// A callback function that is called when the text field is tapped.
  final VoidCallback? onTap;

  ///
  final double? height;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final TextTheme textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (labelText != null) ...<Widget>[
          Text(
            labelText!,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            validator: validator,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            enabled: enabled,
            maxLines: maxLines,
            minLines: minLines,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            autofocus: autofocus,
            readOnly: readOnly,
            onTap: onTap,
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withAlpha(200),
              ),
              prefixIcon: prefixIcon != null
                  ? Container(
                      margin: const EdgeInsets.only(left: 16, right: 12),
                      child: Icon(
                        prefixIcon,
                        color: context.colorScheme.onSurface,
                        size: 22,
                      ),
                    )
                  : null,
              prefixIconConstraints: prefixIcon != null
                  ? const BoxConstraints(minWidth: 50, maxWidth: 50)
                  : null,
              suffixIcon: suffixIcon != null
                  ? Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: suffixIcon,
                    )
                  : null,
              suffixIconConstraints: suffixIcon != null
                  ? const BoxConstraints(minWidth: 50, maxWidth: 50)
                  : null,
              filled: true,
              fillColor: colorScheme.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: prefixIcon != null ? 0 : 16,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: colorScheme.outline.withAlpha(76),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: colorScheme.outline.withAlpha(76),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: colorScheme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: colorScheme.error, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: colorScheme.outline.withAlpha(51),
                ),
              ),
              errorStyle: textTheme.bodySmall?.copyWith(
                fontSize: 15,
                color: colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
              counterStyle: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withAlpha(153),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
