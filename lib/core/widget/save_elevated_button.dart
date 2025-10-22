import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

class SaveElevatedButton extends StatelessWidget {
  const SaveElevatedButton({
    required this.label,
    required this.onTap,
    super.key,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      key: key,
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
            style: context.textTheme.labelLarge?.copyWith(
              inherit: false,
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    ),
  );
}
