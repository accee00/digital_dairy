import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/utils/enums.dart';
import 'package:digital_dairy/features/cattle/presentation/widget/custom_container.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A card widget that displays milk log details for a specific cattle.
class CattleMilkLogCard extends StatelessWidget {
  /// Creates a [CattleMilkLogCard].
  const CattleMilkLogCard({required this.milk, super.key});

  /// The milk model to display.
  final MilkModel milk;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: CustomContainer(
      child: Row(
        children: <Widget>[
          // Date indicator
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: context.colorScheme.secondary.withAlpha(100),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  DateFormat('dd').format(milk.date),
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  ),
                ),
                Text(
                  _getLocalizedShortMonth(milk.date, context),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Shift info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      milk.shift == ShiftType.morning
                          ? Icons.wb_sunny_rounded
                          : Icons.nightlight_round,
                      size: 16,
                      color: milk.shift == ShiftType.morning
                          ? Colors.orange
                          : Colors.indigo,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      milk.shift == ShiftType.morning
                          ? context.strings.morning
                          : context.strings.evening,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (milk.notes.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    milk.notes,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Quantity
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: context.colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${milk.quantityInLiter.toStringAsFixed(1)} L',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  String _getLocalizedShortMonth(DateTime date, BuildContext context) {
    switch (date.month) {
      case 1:
        return context.strings.jan;
      case 2:
        return context.strings.feb;
      case 3:
        return context.strings.mar;
      case 4:
        return context.strings.apr;
      case 5:
        return context.strings.may;
      case 6:
        return context.strings.jun;
      case 7:
        return context.strings.jul;
      case 8:
        return context.strings.aug;
      case 9:
        return context.strings.sep;
      case 10:
        return context.strings.oct;
      case 11:
        return context.strings.nov;
      case 12:
        return context.strings.dec;
      default:
        return '';
    }
  }
}
