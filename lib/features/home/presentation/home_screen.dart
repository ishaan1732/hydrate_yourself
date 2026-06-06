import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../onboarding/domain/user_profile_model.dart';
import '../domain/drink_type_model.dart';
import '../domain/today_summary.dart';
import 'home_provider.dart';
import 'widgets/custom_amount_sheet.dart';
import 'widgets/drink_type_chip.dart';
import 'widgets/progress_ring.dart';
import 'widgets/quick_add_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final summaryAsync = ref.watch(todaySummaryProvider);
    final drinkTypesAsync = ref.watch(drinkTypesProvider);
    final selectedDrinkTypeId = ref.watch(selectedDrinkTypeIdProvider);
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final unit = profile?.unit ?? AppConstants.unitMl;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: summaryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (summary) => _buildContent(
            context,
            ref,
            summary,
            drinkTypesAsync,
            selectedDrinkTypeId,
            unit,
            profile,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    TodaySummary summary,
    AsyncValue<List<DrinkTypeModel>> drinkTypesAsync,
    int? selectedDrinkTypeId,
    String unit,
    UserProfileModel? profile,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // SECTION 1 — Greeting header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    profile?.name ?? 'there',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.go('/settings'),
              ),
            ],
          ),
        ),

        // SECTION 2 — Progress ring
        Expanded(
          flex: 4,
          child: Center(
            child: ProgressRing(
              percentage: summary.percentage,
              totalMl: summary.totalMl.round(),
              goalMl: summary.goalMl,
              unit: unit,
              size: 240,
            ),
          ),
        ),

        // SECTION 3 — Drink type selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Drinking',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              drinkTypesAsync.when(
                loading: () => const SizedBox(height: 48),
                error: (_, _) => const SizedBox(height: 48),
                data: (drinkTypes) => SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: drinkTypes.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final dt = drinkTypes[index];
                      final isSelected = selectedDrinkTypeId == null
                          ? index == 0
                          : dt.id == selectedDrinkTypeId;
                      return DrinkTypeChip(
                        drinkType: dt,
                        isSelected: isSelected,
                        onTap: () => ref
                            .read(selectedDrinkTypeIdProvider.notifier)
                            .state = dt.id,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // SECTION 4 — Quick add buttons
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Add',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: AppConstants.quickAddAmounts.map((amount) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: QuickAddButton(
                        amountMl: amount,
                        onTap: () => ref
                            .read(homeActionProvider.notifier)
                            .addQuickLog(amount.toDouble()),
                        accentColor: _getSelectedDrinkColor(
                          drinkTypesAsync.valueOrNull,
                          selectedDrinkTypeId,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // SECTION 5 — Custom amount button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Custom amount'),
              onPressed: () => _showCustomAmountSheet(context, ref),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  Color? _getSelectedDrinkColor(
    List<DrinkTypeModel>? drinkTypes,
    int? selectedId,
  ) {
    if (drinkTypes == null || drinkTypes.isEmpty) return null;
    if (selectedId == null) return drinkTypes.first.color;
    return drinkTypes
        .firstWhere(
          (d) => d.id == selectedId,
          orElse: () => drinkTypes.first,
        )
        .color;
  }

  void _showCustomAmountSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CustomAmountSheet(
          onAdd: (amount) {
            ref.read(homeActionProvider.notifier).addQuickLog(amount);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
