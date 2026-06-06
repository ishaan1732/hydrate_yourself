import 'package:flutter/material.dart';

class QuickAddButton extends StatelessWidget {
  const QuickAddButton({
    super.key,
    required this.amountMl,
    required this.onTap,
    this.accentColor,
  });

  final int amountMl;
  final VoidCallback onTap;
  final Color? accentColor;

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
                amountMl < 1000
                    ? '+${amountMl}ml'
                    : '+${(amountMl / 1000)}L',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: accentColor ?? colorScheme.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'ml',
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
