import 'package:flutter/material.dart';

import '../../../../core/constants/drink_constants.dart';
import '../../../../core/extensions/double_extensions.dart';
import '../../../home/domain/drink_type_model.dart';
import '../../../home/domain/water_log_model.dart';

class LogListTile extends StatelessWidget {
  const LogListTile({super.key, required this.log, this.unit = 'ml'});

  final WaterLogModel log;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: log.drinkType.color.withValues(alpha: 0.15),
        radius: 20,
        child: Icon(
          DrinkConstants.getIconData(log.drinkType.iconName),
          color: log.drinkType.color,
          size: 20,
        ),
      ),
      title: Text(
        unit == 'oz'
            ? '+${log.amountMl.toDouble().toHalfOzString()}'
            : '+${log.amountMl.round()}ml',
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        log.drinkType.name,
        style: theme.textTheme.bodySmall,
      ),
      trailing: Text(
        _formatTime(log.loggedAt),
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12
        ? dt.hour - 12
        : dt.hour == 0
            ? 12
            : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
