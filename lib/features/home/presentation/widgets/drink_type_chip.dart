import 'package:flutter/material.dart';

import '../../../../core/constants/drink_constants.dart';
import '../../domain/drink_type_model.dart';

class DrinkTypeChip extends StatelessWidget {
  const DrinkTypeChip({
    super.key,
    required this.drinkType,
    required this.isSelected,
    required this.onTap,
  });

  final DrinkTypeModel drinkType;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isSelected
              ? drinkType.color.withValues(alpha: 0.2)
              : colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isSelected ? drinkType.color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Icon(
              DrinkConstants.getIconData(drinkType.iconName),
              size: 18,
              color: isSelected ? drinkType.color : colorScheme.onSurfaceVariant,
            ),
            Text(
              drinkType.name,
              style: theme.textTheme.labelLarge?.copyWith(
                color:
                    isSelected ? drinkType.color : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
