import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

class HeaderForAdd extends StatelessWidget {
  const HeaderForAdd({
    required this.title,
    required this.subTitle,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.textTheme;
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            onPressed: onTap,
            backgroundColor: color.primary,
            child: const Icon(Icons.add, size: 22, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
