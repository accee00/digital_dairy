import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/widgets.dart';

/// A custom container widget that applies consistent styling and padding.
///
/// This widget wraps its [child] with a [Container] that has pre padding,
/// border, and background color based on the current theme's color scheme.
/// Usage example:
/// ```dart
/// CustomContainer(
///   child: Text('Hello World'),
/// )
/// ```
class CustomContainer extends StatelessWidget {
  /// Creates a [CustomContainer] widget.
  ///
  /// Requires a [child] widget to be provided as content.
  const CustomContainer({
    required this.child,
    super.key,
    this.showBorder = true,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  ///
  final bool showBorder;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
    decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      border: showBorder
          ? Border.all(color: context.colorScheme.outline.withAlpha(50))
          : null,
    ),
    child: child,
  );
}
