import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

///
enum SnackbarType {
  ///
  error,

  ///
  success,

  ///
  info,
}

///
void showAppSnackbar(
  BuildContext context, {
  required String message,
  SnackbarType type = SnackbarType.info,
  Duration duration = const Duration(seconds: 3),
}) {
  final Color backgroundColor;
  final IconData icon;

  switch (type) {
    case SnackbarType.error:
      backgroundColor = AppTheme.error;
      icon = Icons.error_outline;
    case SnackbarType.success:
      backgroundColor = AppTheme.success;
      icon = Icons.check_circle_outline;
    case SnackbarType.info:
      backgroundColor = context.colorScheme.primary;
      icon = Icons.info_outline;
  }

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    ),
  );
}
