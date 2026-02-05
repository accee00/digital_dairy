import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

///
class AppEmptyState extends StatelessWidget {
  ///
  const AppEmptyState({
    required this.title,
    super.key,
    this.message,
    this.icon,
    this.onRetry,
    this.retryText,
  });

  ///
  factory AppEmptyState.sliver({
    required String title,
    String? message,
    IconData? icon,
    VoidCallback? onRetry,
    String? retryText,
  }) => _SliverAppEmptyState(
    title: title,
    message: message,
    icon: icon,
    onRetry: onRetry,
    retryText: retryText,
  );

  ///
  final String title;

  ///
  final String? message;

  ///
  final IconData? icon;

  ///
  final VoidCallback? onRetry;

  ///
  final String? retryText;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(
            icon,
            size: 64,
            color: context.colorScheme.onSurface.withAlpha(100),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          title,
          style: context.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        if (message != null) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            message!,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(150),
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (onRetry != null) ...<Widget>[
          const SizedBox(height: 16),
          if (retryText != null && retryText!.toLowerCase().contains('clear'))
            OutlinedButton(
              onPressed: onRetry,
              child: Text(retryText ?? context.strings.retry),
            )
          else
            ElevatedButton(
              onPressed: onRetry,
              child: Text(retryText ?? context.strings.retry),
            ),
        ],
      ],
    ),
  );
}

class _SliverAppEmptyState extends AppEmptyState {
  const _SliverAppEmptyState({
    required super.title,
    super.message,
    super.icon,
    super.onRetry,
    super.retryText,
  });

  @override
  Widget build(BuildContext context) =>
      SliverFillRemaining(child: super.build(context));
}
