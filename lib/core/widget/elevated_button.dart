import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height = 56,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.elevation = 4,
    this.borderRadius = 12,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.padding,
  });

  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double elevation;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final TextTheme textTheme = context.textTheme;

    final Color effectiveBackgroundColor =
        backgroundColor ??
        (isOutlined ? Colors.transparent : colorScheme.primary);
    final Color effectiveForegroundColor =
        foregroundColor ??
        (isOutlined ? colorScheme.primary : colorScheme.onPrimary);
    final Color effectiveBorderColor =
        borderColor ?? (isOutlined ? colorScheme.primary : Colors.transparent);

    Widget buildButtonContent() {
      if (isLoading) {
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveForegroundColor),
          ),
        );
      }

      if (icon != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 20, color: effectiveForegroundColor),
            const SizedBox(width: 8),
            Text(
              text,
              style: textTheme.labelLarge?.copyWith(
                color: effectiveForegroundColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
                letterSpacing: 0.5,
              ),
            ),
          ],
        );
      }

      return Text(
        text,
        style: textTheme.labelLarge?.copyWith(
          color: effectiveForegroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: 0.5,
        ),
      );
    }

    if (isOutlined) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: onPressed != null && !isLoading
              ? <BoxShadow>[
                  BoxShadow(
                    color: effectiveBorderColor.withAlpha(60),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: effectiveBackgroundColor,
            foregroundColor: effectiveForegroundColor,
            side: BorderSide(color: effectiveBorderColor, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: 0,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: buildButtonContent(),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: onPressed != null && !isLoading
            ? <BoxShadow>[
                BoxShadow(
                  color: effectiveBackgroundColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style:
            ElevatedButton.styleFrom(
              backgroundColor: effectiveBackgroundColor,
              foregroundColor: effectiveForegroundColor,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: effectiveBorderColor != Colors.transparent
                    ? BorderSide(color: effectiveBorderColor)
                    : BorderSide.none,
              ),
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ).copyWith(
              overlayColor: WidgetStateColor.resolveWith((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.white.withOpacity(0.1);
                }
                if (states.contains(WidgetState.hovered)) {
                  return Colors.white.withOpacity(0.05);
                }
                return Colors.red;
              }),
            ),
        child: buildButtonContent(),
      ),
    );
  }
}

/// Extension for quick button variants
extension CustomElevatedButtonVariants on CustomElevatedButton {
  ///
  static CustomElevatedButton primary({
    required VoidCallback? onPressed,
    required String text,
    IconData? icon,
    bool isLoading = false,
    double? width,
    double height = 56,
  }) => CustomElevatedButton(
    onPressed: onPressed,
    text: text,
    icon: icon,
    isLoading: isLoading,
    width: width,
    height: height,
  );

  ///
  static CustomElevatedButton secondary({
    required VoidCallback? onPressed,
    required String text,
    IconData? icon,
    bool isLoading = false,
    double? width,
    double height = 56,
  }) => CustomElevatedButton(
    onPressed: onPressed,
    text: text,
    icon: icon,
    isLoading: isLoading,
    isOutlined: true,
    width: width,
    height: height,
  );

  ///
  static CustomElevatedButton small({
    required VoidCallback? onPressed,
    required String text,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) => CustomElevatedButton(
    onPressed: onPressed,
    text: text,
    icon: icon,
    isLoading: isLoading,
    width: width,
    height: 40,
    fontSize: 14,
    borderRadius: 8,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  ///
  static CustomElevatedButton large({
    required VoidCallback? onPressed,
    required String text,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) => CustomElevatedButton(
    onPressed: onPressed,
    text: text,
    icon: icon,
    isLoading: isLoading,
    width: width,
    height: 64,
    fontSize: 18,
    borderRadius: 16,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
  );
}
