import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/theme/app_theme.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///
class QuickActionsCard extends StatelessWidget {
  ///
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.strings.quickActions,
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _ActionButton(
                icon: Icons.add_circle_outline,
                label: context.strings.milkEntry,
                color: AppTheme.primary,
                onPressed: () => context.push(AppRoutes.addMilk),
              ),
              _ActionButton(
                icon: Icons.pets_outlined,
                label: context.strings.newCattle,
                color: AppTheme.secondary,
                onPressed: () => context.push(AppRoutes.addCattle),
              ),
              _ActionButton(
                icon: Icons.account_balance_wallet_outlined,
                label: context.strings.finance,
                color: AppTheme.success,
                onPressed: () {
                  showAppSnackbar(context, message: context.strings.comingSoon);
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onPressed,
    child: Column(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
