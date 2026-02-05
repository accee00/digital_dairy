import 'package:cached_network_image/cached_network_image.dart';
import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///
class CattleCard extends StatelessWidget {
  ///
  const CattleCard({required this.cattle, super.key});

  ///
  final Cattle cattle;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push(AppRoutes.cattleDetail, extra: cattle),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // NAME ROW WITH IMAGE
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      (cattle.imageUrl?.isNotEmpty ?? false)
                          ? cattle.imageUrl!
                          : 'https://thumbs.dreamstime.com/b/comic-cow-model-taken-closeup-effect-40822303.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            cattle.name,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              context,
                              cattle.status,
                            ).withAlpha(50),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStatusColor(context, cattle.status),
                            ),
                          ),
                          child: Text(
                            _getLocalizedStatus(cattle.status, context),
                            style: context.textTheme.labelSmall?.copyWith(
                              color: _getStatusColor(context, cattle.status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${context.strings.tag}: ${cattle.tagId} • ${cattle.breed}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Age and this month
          Row(
            children: <Widget>[
              Expanded(
                child: _buildInfoItem(
                  context,
                  context.strings.age,
                  calculateCattleAge(cattle.dob, context),
                  Icons.calendar_today,
                ),
              ),
              if (cattle.gender == 'Female')
                Expanded(
                  child: _buildInfoItem(
                    context,
                    context.strings.thisMonth,
                    '${cattle.thisMonthL}${context.strings.unitLitres}',
                    Icons.water_drop,
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) => Column(
    children: <Widget>[
      Icon(icon, size: 20, color: context.colorScheme.primary),
      const SizedBox(height: 4),
      Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colorScheme.onSurface.withAlpha(120),
        ),
      ),
      Text(
        value,
        style: context.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );

  ///
  String calculateCattleAge(DateTime? dob, BuildContext context) {
    if (dob == null) {
      return '-';
    }

    final DateTime now = DateTime.now();
    int years = now.year - dob.year;
    int months = now.month - dob.month;

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    if (years == 0) {
      return '$months ${context.strings.months}';
    }
    if (months == 0) {
      return '$years ${context.strings.years}';
    }
    return '$years ${context.strings.years} $months ${context.strings.months}';
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Sick':
        return Colors.orange;
      case 'Sold':
        return Colors.blue;
      case 'Dead':
        return Colors.red;
      default:
        return context.colorScheme.onSurface;
    }
  }

  String _getLocalizedStatus(String status, BuildContext context) {
    switch (status) {
      case 'Active':
        return context.strings.active;
      case 'Sick':
        return context.strings.sick;
      case 'Sold':
        return context.strings.sold;
      case 'Dead':
        return context.strings.dead;
      default:
        return status;
    }
  }
}
