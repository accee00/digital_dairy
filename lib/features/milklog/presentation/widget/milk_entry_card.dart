import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/utils/enums.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A card widget that displays milk entry details.
class MilkEntryCard extends StatelessWidget {
  /// Creates a [MilkEntryCard].
  const MilkEntryCard({required this.milkEntry, super.key});

  /// The milk entry model to display.
  final MilkModel milkEntry;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _showMilkEntryDetail(context, milkEntry),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                milkEntry.cattle?.name ?? milkEntry.cattleId,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getShiftColor(
                    milkEntry.shift.value,
                    context,
                  ).withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      milkEntry.shift == ShiftType.morning
                          ? Icons.wb_sunny
                          : Icons.nights_stay,
                      size: 14,
                      color: _getShiftColor(
                        milkEntry.shift.displayVal,
                        context,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      milkEntry.shift.displayVal,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: _getShiftColor(milkEntry.shift.value, context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Icon(
                Icons.water_drop,
                size: 16,
                color: context.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '${milkEntry.quantityInLiter.toStringAsFixed(1)}L',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.calendar_today,
                size: 16,
                color: context.colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDate(milkEntry.date, context),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ],
          ),
          if (milkEntry.notes.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              milkEntry.notes,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withAlpha(120),
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ),
  );

  void _showMilkEntryDetail(BuildContext context, MilkModel milkEntry) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: context.colorScheme.surface,
        title: Row(
          children: <Widget>[
            const Icon(Icons.local_drink_rounded),
            const SizedBox(width: 8),
            Text(
              context.strings.milkScreenEntryDetail,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDetailRow(
              '🐄 ${context.strings.milkScreenEntryCattle}',
              milkEntry.cattle?.name ?? milkEntry.cattleId,
              context,
            ),
            _buildDetailRow(
              '📅 ${context.strings.milkScreenEntryDate}',
              _formatFullDate(milkEntry.date, context),
              context,
            ),
            _buildDetailRow(
              '⏰ ${context.strings.milkScreenEntryShift}',
              milkEntry.shift.displayVal,
              context,
            ),
            _buildDetailRow(
              '🥛 ${context.strings.milkScreenEntryQuantity}',
              '${milkEntry.quantityInLiter.toStringAsFixed(2)} L',
              context,
            ),
            if (milkEntry.notes.isNotEmpty) ...<Widget>[
              const Divider(height: 20),
              _buildDetailRow(
                '📝 ${context.strings.milkScreenEntryNotes}',
                milkEntry.notes,
                context,
              ),
            ],
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          FilledButton.icon(
            onPressed: () => context.pop(),
            label: Text(context.strings.milkScreenClose),
            icon: const Icon(Icons.close),
          ),
          FilledButton.icon(
            onPressed: () {
              context
                ..pop()
                ..pushNamed(AppRoutes.editMilk, extra: milkEntry);
            },
            icon: const Icon(Icons.edit),
            label: Text(context.strings.milkScreenEdit),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: context.textTheme.bodyMedium?.copyWith(fontSize: 15),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: context.textTheme.bodyMedium?.copyWith(fontSize: 15),
              ),
            ),
          ],
        ),
      );

  Color _getShiftColor(String shift, BuildContext context) {
    switch (shift) {
      case 'Morning':
        return Colors.orange;
      case 'Evening':
        return Colors.indigo;
      default:
        return context.colorScheme.primary;
    }
  }

  String _formatDate(DateTime date, BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateTime entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate.isAtSameMomentAs(today)) {
      return context.strings.milkScreenToday;
    }
    if (entryDate.isAtSameMomentAs(yesterday)) {
      return context.strings.milkScreenYesterday;
    }

    final String month = _formatMonthName(date.month, context);
    return '${date.day} $month';
  }

  String _formatFullDate(DateTime date, BuildContext context) {
    final String month = _formatMonthName(date.month, context);
    return '${date.day} $month ${date.year}';
  }

  String _formatMonthName(int month, BuildContext context) => switch (month) {
    1 => context.strings.jan,
    2 => context.strings.feb,
    3 => context.strings.mar,
    4 => context.strings.apr,
    5 => context.strings.may,
    6 => context.strings.jun,
    7 => context.strings.jul,
    8 => context.strings.aug,
    9 => context.strings.sep,
    10 => context.strings.oct,
    11 => context.strings.nov,
    12 => context.strings.dec,
    _ => '',
  };
}
