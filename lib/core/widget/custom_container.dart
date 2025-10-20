import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

/// A custom container widget that applies a linear gradient based on the current theme's color scheme.
///
/// This widget takes a single child widget and applies a gradient background
/// that blends the primary, surface, and secondary colors of the current theme.
/// The gradient starts from the top left and ends at the bottom right.
///
/// The `child` parameter is required and it should be the widget that you want to display
/// inside this container.

class CustomScaffoldContainer extends StatelessWidget {
  /// Creates a [CustomScaffoldContainer] widget.
  ///
  /// The [child] parameter must not be null.
  const CustomScaffoldContainer({required this.child, super.key});

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colorScheme.primary.withAlpha(100),
            colorScheme.surface,
            colorScheme.secondary.withAlpha(90),
          ],
        ),
      ),
      child: child,
    );
  }
}
