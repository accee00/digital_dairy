import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

/// Transparent loading indicator that can be used as overlay
class CustomLoadingIndicator extends StatelessWidget {
  ///
  const CustomLoadingIndicator({
    super.key,
    this.message,
    this.size,
    this.color,
    this.showOverlay = false,
    this.overlayColor,
  });

  ///
  const CustomLoadingIndicator.large({
    super.key,
    this.message = 'Loading...',
    this.color,
    this.showOverlay = false,
    this.overlayColor,
  }) : size = 60.0;

  ///
  const CustomLoadingIndicator.small({
    super.key,
    this.message,
    this.color,
    this.showOverlay = false,
    this.overlayColor,
  }) : size = 24.0;

  /// Overlay variant with semi-transparent background
  const CustomLoadingIndicator.overlay({
    super.key,
    this.message,
    this.size,
    this.color,
    this.overlayColor,
  }) : showOverlay = true;

  ///
  final String? message;

  ///
  final double? size;

  ///
  final Color? color;

  ///
  final bool showOverlay;

  ///
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) => Stack(
    children: <Widget>[
      if (showOverlay) Container(color: Colors.black54),
      Center(
        child: Container(
          width: size ?? 48,
          height: size ?? 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? context.colorScheme.primary,
          ),
          padding: const EdgeInsets.all(12),
          child: CircularProgressIndicator(
            color: color ?? context.colorScheme.onPrimary,
            strokeWidth: 3,
          ),
        ),
      ),
    ],
  );
}
