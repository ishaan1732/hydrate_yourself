import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/drink_constants.dart';
import '../../../../core/extensions/double_extensions.dart';
import '../../domain/drink_type_model.dart';
import '../../domain/water_log_model.dart';

class UndoLogButton extends StatelessWidget {
  const UndoLogButton({
    super.key,
    required this.lastLog,
    required this.onUndo,
    required this.unit,
  });

  final WaterLogModel lastLog;
  final VoidCallback onUndo;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final amountLabel = unit == 'oz'
        ? '+${lastLog.amountMl.mlToOz.toStringAsFixed(1)} oz · ${lastLog.drinkType.name}'
        : '+${lastLog.amountMl.round()} ml · ${lastLog.drinkType.name}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.surfaceContainerHighest,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: null,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      lastLog.drinkType.color.withValues(alpha: 0.15),
                  child: Icon(
                    DrinkConstants.getIconData(lastLog.drinkType.iconName),
                    size: 16,
                    color: lastLog.drinkType.color,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Last logged',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      amountLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onUndo,
                  icon: const Icon(Icons.undo, size: 16),
                  label: const Text('Undo'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .slideY(begin: 1.0, end: 0.0, duration: 300.ms, curve: Curves.easeOutCubic)
        .fadeIn(duration: 300.ms);
  }
}
