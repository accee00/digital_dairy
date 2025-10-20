import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

/// A custom header widget for adding new items, featuring a title, subtitle, and an add button.
///
/// This widget is designed to be used in screens where an action is required to add new items.
/// It displays a title and a subtitle on the left and a floating action button on the right.
class HeaderForAdd extends StatelessWidget {
  /// Creates a [HeaderForAdd] widget.
  ///
  /// Requires [title], [subTitle], and [onTap] callback to be provided.
  const HeaderForAdd({
    required this.title,
    required this.subTitle,
    required this.onTap,
    super.key,
  });

  /// The title text which will be displayed in a larger font at the top.
  final String title;

  /// The subtitle text displayed just below the title.
  final String subTitle;

  /// The callback function that is called when the floating action button is pressed.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme theme = context.textTheme;
    final ColorScheme color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: theme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subTitle,
                style: theme.bodyMedium?.copyWith(
                  color: color.onSurface.withAlpha(180),
                ),
              ),
            ],
          ),
          FloatingActionButton.small(
            heroTag: 'header_add_${title.hashCode}',
            onPressed: onTap,
            backgroundColor: color.primary,
            child: const Icon(Icons.add, size: 22, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
