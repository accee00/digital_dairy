import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

/// A custom styled elevated button specifically designed for "save" actions.
///
///
/// Parameters:
///   - `label`: The text label displayed on the button.
///   - `onTap`: The callback function that is called when the button is tapped.
class SaveElevatedButton extends StatelessWidget {
  /// Creates a [SaveElevatedButton].
  ///
  /// Requires a [label] to display on the button and an [onTap] callback
  /// to handle the button press.
  const SaveElevatedButton({
    required this.label,
    required this.onTap,
    super.key,
  });

  /// The text label that appears on the button.
  final String label;

  /// The callback function to execute when the button is pressed.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.save),
          const SizedBox(width: 8),
          Text(
            label,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    ),
  );
}
