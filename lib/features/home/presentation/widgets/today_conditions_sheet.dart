import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/onboarding/domain/user_profile_model.dart';
import '../../domain/today_override.dart';
import '../home_provider.dart';

class TodayConditionsSheet extends ConsumerWidget {
  const TodayConditionsSheet({
    super.key,
    required this.profile,
    required this.onDone,
  });

  final UserProfileModel? profile;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final override = ref.watch(todayOverrideNotifierProvider);

    final profileClimate =
        ClimateType.fromRaw(profile?.climateType ?? 'moderate');
    final profileActivity =
        ActivityLevel.fromRaw(profile?.activityLevel ?? 0);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Today's conditions",
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            "Adjusts today's goal without changing your permanent settings.",
            style: theme.textTheme.bodySmall
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),

          // Climate
          Text(
            'Climate',
            style: theme.textTheme.labelMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Row(
            children: ClimateType.values.map((c) {
              final isActive =
                  (override?.climate ?? profileClimate) == c;
              final isOverridden = override?.climate == c;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: _ConditionOption(
                    emoji: c.emoji,
                    label: c.label,
                    isActive: isActive,
                    isOverridden: isOverridden,
                    onTap: () => ref
                        .read(todayOverrideNotifierProvider.notifier)
                        .setClimate(c),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Activity
          Text(
            'Activity',
            style: theme.textTheme.labelMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Row(
            children: ActivityLevel.values.map((a) {
              final isActive =
                  (override?.activity ?? profileActivity) == a;
              final isOverridden = override?.activity == a;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: _ConditionOption(
                    emoji: a.emoji,
                    label: a.label,
                    isActive: isActive,
                    isOverridden: isOverridden,
                    onTap: () => ref
                        .read(todayOverrideNotifierProvider.notifier)
                        .setActivity(a),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          FilledButton(
            onPressed: onDone,
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _ConditionOption extends StatelessWidget {
  const _ConditionOption({
    required this.emoji,
    required this.label,
    required this.isActive,
    required this.isOverridden,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool isActive;
  // true when this is the active value AND it differs from the profile default
  final bool isOverridden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final Color bgColor;
    final Color labelColor;
    final Color? borderColor;

    if (isActive && isOverridden) {
      bgColor = colorScheme.tertiaryContainer;
      labelColor = colorScheme.onTertiaryContainer;
      borderColor = colorScheme.tertiary;
    } else if (isActive) {
      bgColor = colorScheme.secondaryContainer;
      labelColor = colorScheme.onSecondaryContainer;
      borderColor = colorScheme.secondary;
    } else {
      bgColor = colorScheme.surfaceContainerHighest;
      labelColor = colorScheme.onSurfaceVariant;
      borderColor = null;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: borderColor != null
              ? Border.all(color: borderColor, width: 1.5)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              label,
              style:
                  theme.textTheme.labelSmall?.copyWith(color: labelColor),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
