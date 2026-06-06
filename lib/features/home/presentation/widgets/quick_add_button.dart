import 'package:flutter/material.dart';

import '../../../../core/extensions/double_extensions.dart';

class QuickAddButton extends StatelessWidget {
  const QuickAddButton({
    super.key,
    required this.amountMl,
    required this.onTap,
    this.accentColor,
    this.unit = 'ml',
  });

  final int amountMl;
  final VoidCallback onTap;
  final Color? accentColor;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      borderRadius: BorderRadius.circular(16),
      color: colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                unit == 'oz'
                    ? '+${amountMl.toDouble().mlToOz.toStringAsFixed(1)}oz'
                    : amountMl < 1000
                        ? '+${amountMl}ml'
                        : '+${(amountMl / 1000).toStringAsFixed(1)}L',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: accentColor ?? colorScheme.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                unit,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
