import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/features/cattle/presentation/widget/custom_container.dart';
import 'package:digital_dairy/features/sales/model/milk_sales_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A card widget that displays details of a milk sale to a buyer.
class SaleCard extends StatelessWidget {
  /// Creates a [SaleCard].
  const SaleCard({required this.sale, super.key});

  /// The sale model to display.
  final MilkSale sale;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // Date indicator
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withAlpha(200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      DateFormat('dd').format(sale.date),
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _getLocalizedShortMonth(sale.date, context),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Sale details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.water_drop_rounded,
                          size: 16,
                          color: Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${sale.quantityLitres.toStringAsFixed(1)} L',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '@ ₹${sale.pricePerLitre.toStringAsFixed(2)}/L',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (sale.notes != null &&
                        sale.notes!.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        sale.notes!,
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

              // Amount
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '₹${(sale.totalAmount ?? 0.0).toStringAsFixed(2)}',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
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
