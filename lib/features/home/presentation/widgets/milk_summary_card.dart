import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/theme/app_theme.dart';
import 'package:digital_dairy/features/home/model/analytics_model.dart';
import 'package:flutter/material.dart';

/// A card that displays a summary of today's milk production and income.
class MilkSummaryCard extends StatelessWidget {
  /// Creates a [MilkSummaryCard].
  const MilkSummaryCard({required this.analytics, super.key});

  /// The analytics model containing data to display.
  final AnalyticsModel analytics;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      context.strings.todaysSummary,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.strings.milkProductionOverview,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.insert_chart_outlined,
                  color: colorScheme.primary,
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.wb_sunny_rounded,
                    label: context.strings.morning,
                    value: '${analytics.todayMorningMilk.toStringAsFixed(1)} L',
                    color: AppTheme.warning,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.nightlight_round,
                    label: context.strings.evening,
                    value: '${analytics.todayEveningMilk.toStringAsFixed(1)} L',
                    color: context.isDarkMode
                        ? AppTheme.primaryLight
                        : AppTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.format_list_bulleted_rounded,
                    label: context.strings.total,
                    value: '${analytics.todayTotalMilk.toStringAsFixed(1)} L',
                    color: AppTheme.info,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.currency_rupee_rounded,
                    label: context.strings.income,
                    value: '₹${analytics.todayIncome.toStringAsFixed(0)}',
                    color: AppTheme.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withAlpha(15),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: context.textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
