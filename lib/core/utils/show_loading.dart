import 'package:digital_dairy/core/widget/custom_circular_indicator.dart';
import 'package:flutter/material.dart';

/// Displays a non-dismissible loading overlay using a custom loading indicator.
///
/// This function triggers a modal dialog overlay which cannot be dismissed by user interaction,
/// ensuring that the user must wait until the process requiring the loading indicator is complete.
/// Parameters:
///   - `context` (BuildContext): The build context from which this function is invoked.
///
/// Example:
/// ```dart
/// showLoading(context);
/// ```
void showLoading(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useSafeArea: false,
    barrierColor: Colors.transparent,
    builder: (_) => const CustomLoadingIndicator.overlay(),
  );
}
