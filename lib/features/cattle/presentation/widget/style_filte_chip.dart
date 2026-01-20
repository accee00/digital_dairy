import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

/// A styled filter chip widget with popup menu for selection
class StyledFilterChip extends StatelessWidget {
  /// Creates a styled filter chip
  const StyledFilterChip({
    required this.label,
    required this.selected,
    required this.options,
    required this.onSelected,
    this.backgroundColor,
    this.textColor,
    this.selectedBackgroundColor,
    this.selectedTextColor,
    this.borderRadius,
    super.key,
  });

  /// The label to display before the selected value
  final String label;

  /// The currently selected value
  final String selected;

  /// List of available options
  final List<String> options;

  /// Callback when an option is selected
  final void Function(String) onSelected;

  /// Background color of the chip
  final Color? backgroundColor;

  /// Text color of the chip
  final Color? textColor;

  /// Background color when selected (if different from default)
  final Color? selectedBackgroundColor;

  /// Text color when selected (if different from default)
  final Color? selectedTextColor;

  /// Border radius of the chip
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDefaultSelected =
        selected == 'All' || selected == options.first;

    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => options
          .map(
            (String option) => PopupMenuItem<String>(
              value: option,
              child: Row(
                children: <Widget>[
                  if (option == selected)
                    Icon(Icons.check, size: 18, color: colorScheme.primary),
                  if (option == selected) const SizedBox(width: 8),
                  Text(
                    option,
                    style: TextStyle(
                      fontWeight: option == selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: option == selected ? colorScheme.primary : null,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDefaultSelected
              ? (backgroundColor ?? colorScheme.surfaceContainerHighest)
              : (selectedBackgroundColor ?? colorScheme.primary),
          borderRadius: BorderRadius.circular(borderRadius ?? 20),
          border: Border.all(
            color: isDefaultSelected
                ? colorScheme.outline.withAlpha(76)
                : colorScheme.primary.withAlpha(127),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: <Widget>[
            Text(
              '$label: $selected',
              style: context.textTheme.bodyLarge?.copyWith(
                height: 1,
                fontSize: 13,
                fontWeight: isDefaultSelected
                    ? FontWeight.w500
                    : FontWeight.w600,
                color: isDefaultSelected
                    ? (textColor ?? colorScheme.onSurface)
                    : (selectedTextColor ?? colorScheme.onPrimaryContainer),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              size: 18,
              color: isDefaultSelected
                  ? (textColor ?? colorScheme.onSurface.withAlpha(178))
                  : (selectedTextColor ?? colorScheme.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}
