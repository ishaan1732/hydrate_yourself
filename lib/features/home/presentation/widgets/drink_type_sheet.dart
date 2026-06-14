import 'dart:math' show max;
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/drink_constants.dart';
import '../../../../database/app_database.dart';
import '../../../../database/database_provider.dart';
import '../../domain/drink_type_model.dart';
import '../home_provider.dart';
import 'add_custom_drink_sheet.dart';

class DrinkTypeSheet extends ConsumerWidget {
  const DrinkTypeSheet({
    super.key,
    required this.selectedDrinkTypeId,
    required this.onDrinkSelected,
  });

  final int? selectedDrinkTypeId;
  final void Function(DrinkTypeModel) onDrinkSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drinkTypesAsync = ref.watch(drinkTypesProvider);
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.70,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Drink Type',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            drinkTypesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (drinkTypes) => Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: drinkTypes.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    if (index == drinkTypes.length) {
                      return _buildAddCustomButton(context, ref);
                    }
                    final dt = drinkTypes[index];
                    final isSelected = dt.id == selectedDrinkTypeId ||
                        (selectedDrinkTypeId == null && index == 0);
                    return _DrinkTile(
                      drinkType: dt,
                      isSelected: isSelected,
                      onTap: () {
                        onDrinkSelected(dt);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCustomButton(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () async {
        int? newlyCreatedId;
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (dialogContext) => AddCustomDrinkSheet(
            onAdd: (name, emoji, coefficient, colorHex) async {
              final dao = ref.read(drinkTypesDaoProvider);
              final existing = await dao.getAllDrinkTypes();
              final maxSort = existing.isEmpty
                  ? 0
                  : existing.map((e) => e.sortOrder).reduce(max);

              final newId = await dao.insertDrinkType(DrinkTypesCompanion(
                name: Value(name),
                hydrationCoefficient: Value(coefficient),
                iconName: Value(emoji),
                colorHex: Value(colorHex),
                isCustom: const Value(true),
                sortOrder: Value(maxSort + 1),
              ));

              ref.read(selectedDrinkTypeIdProvider.notifier).state = newId;
              newlyCreatedId = newId;
            },
          ),
        );
        // AddCustomDrinkSheet has closed; if a drink was created, also close
        // DrinkTypeSheet so the home screen reflects the selection immediately.
        if (context.mounted && newlyCreatedId != null) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1.5,
          ),
          color: colorScheme.surface,
        ),
        child: Row(
          children: [
            Icon(Icons.add_rounded, color: colorScheme.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Add custom drink',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
            Expanded(
              child: Text(
                'Set hydration index',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.end,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colorScheme.outlineVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrinkTile extends StatelessWidget {
  const _DrinkTile({
    required this.drinkType,
    required this.isSelected,
    required this.onTap,
  });

  final DrinkTypeModel drinkType;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? drinkType.color.withValues(alpha: 0.15)
              : colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isSelected ? drinkType.color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: drinkType.color.withValues(alpha: 0.2),
              ),
              child: drinkType.iconName.isEmpty
                  ? null
                  : Center(
                      child: DrinkConstants.isEmoji(drinkType.iconName)
                          ? Text(drinkType.iconName,
                              style: const TextStyle(fontSize: 16))
                          : Icon(
                              DrinkConstants.getIconData(drinkType.iconName),
                              color: drinkType.color,
                              size: 18,
                            ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drinkType.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '×${drinkType.hydrationCoefficient.toStringAsFixed(1)} hydration',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded,
                  color: drinkType.color, size: 20),
          ],
        ),
      ),
    );
  }
}
