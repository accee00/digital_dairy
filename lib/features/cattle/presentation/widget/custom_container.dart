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
  const CustomContainer({required this.child, super.key});

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.colorScheme.surface.withAlpha(200),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
    ),
    child: child,
  );
}
