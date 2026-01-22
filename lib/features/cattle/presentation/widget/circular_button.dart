import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

///
class CircularButton extends StatelessWidget {
  ///
  const CircularButton({
    required this.iconColor,
    required this.icon,
    required this.onTap,
    super.key,
  });

  ///
  final VoidCallback onTap;

  ///
  final IconData icon;

  ///
  final Color iconColor;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: context.colorScheme.surface,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: context.colorScheme.primary.withAlpha(160),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: iconColor),
    ),
  );
}
