import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/features/home/cubit/analytics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///
class LoadingCard extends StatelessWidget {
  ///
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) => Card(
    child: Container(
      padding: const EdgeInsets.all(40),
      child: const Center(child: CircularProgressIndicator()),
    ),
  );
}

///
class ErrorCard extends StatelessWidget {
  ///
  const ErrorCard({required this.message, super.key});

  ///
  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Icon(Icons.error_outline, color: colorScheme.error, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: context.textTheme.bodyLarge?.copyWith(
                color: colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.read<AnalyticsCubit>().fetchAnalytics(),
              icon: const Icon(Icons.refresh),
              label: Text(context.strings.retry),
            ),
          ],
        ),
      ),
    );
  }
}

///
class EmptyCard extends StatelessWidget {
  ///
  const EmptyCard({super.key});

  @override
  Widget build(BuildContext context) => Card(
    child: Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Text(
          context.strings.noDataAvailable,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    ),
  );
}
