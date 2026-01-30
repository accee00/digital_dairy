import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/theme/app_theme.dart';
import 'package:digital_dairy/features/home/model/analytics_model.dart';
import 'package:flutter/material.dart';

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({required this.analytics, super.key});

  final AnalyticsModel analytics;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String monthName = _getLocalizedMonthName(now.month, context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withAlpha(30),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    color: AppTheme.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        context.strings.monthlySummary,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        monthName,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: _MonthlyItem(
                    icon: Icons.water_drop_rounded,
                    label: context.strings.totalProduction,
                    value: '${analytics.monthTotalMilk.toStringAsFixed(1)} L',
                    color: AppTheme.info,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _MonthlyItem(
                    icon: Icons.account_balance_wallet_rounded,
                    label: context.strings.totalIncome,
                    value: '₹${analytics.monthIncome.toStringAsFixed(0)}',
                    color: AppTheme.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _MonthStat(
                    label: context.strings.avgPerDay,
                    value:
                        '${(analytics.monthTotalMilk / now.day).toStringAsFixed(1)} L',
                    color: context.isDarkMode
                        ? AppTheme.info
                        : AppTheme.primary,
                  ),
                  Container(
                    height: 30,
                    width: 1,
                    color: context.colorScheme.outlineVariant,
                  ),
                  _MonthStat(
                    label: context.strings.days,
                    value: '${now.day}',
                    color: AppTheme.secondary,
                  ),
                  Container(
                    height: 30,
                    width: 1,
                    color: context.colorScheme.outlineVariant,
                  ),
                  _MonthStat(
                    label: context.strings.ratePerLiter,
                    value: analytics.monthTotalMilk > 0
                        ? '₹${(analytics.monthIncome / analytics.monthTotalMilk).toStringAsFixed(0)}'
                        : '₹0',
                    color: AppTheme.success,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedMonthName(int month, BuildContext context) {
    switch (month) {
      case 1:
        return context.strings.january;
      case 2:
        return context.strings.february;
      case 3:
        return context.strings.march;
      case 4:
        return context.strings.april;
      case 5:
        return context.strings.may;
      case 6:
        return context.strings.june;
      case 7:
        return context.strings.july;
      case 8:
        return context.strings.august;
      case 9:
        return context.strings.september;
      case 10:
        return context.strings.october;
      case 11:
        return context.strings.november;
      case 12:
        return context.strings.december;
      default:
        return '';
    }
  }
}

class _MonthlyItem extends StatelessWidget {
  const _MonthlyItem({
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
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
}

class _MonthStat extends StatelessWidget {
  const _MonthStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
