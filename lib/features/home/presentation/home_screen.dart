import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrate_yourself/features/reminders/data/notification_service.dart';

import '../../../core/constants/app_constants.dart';
import '../../onboarding/domain/user_profile_model.dart';
import '../domain/drink_type_model.dart';
import '../domain/today_summary.dart';
import '../domain/water_log_model.dart';
import '../../reminders/presentation/reminders_provider.dart';
import 'home_provider.dart';
import 'widgets/celebration_overlay.dart';
import 'widgets/custom_add_button.dart';
import 'widgets/custom_amount_sheet.dart';
import 'widgets/drink_type_chip.dart';
import 'widgets/progress_ring.dart';
import 'widgets/quick_add_button.dart';
import 'widgets/undo_log_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationSetupNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final summaryAsync = ref.watch(todaySummaryProvider);
    final drinkTypesAsync = ref.watch(drinkTypesProvider);
    final selectedDrinkTypeId = ref.watch(selectedDrinkTypeIdProvider);
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final unit = profile?.unit ?? AppConstants.unitMl;
    final showCelebration = ref.watch(showCelebrationProvider);
    final lastLogAsync = ref.watch(lastLogProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          SafeArea(
            child: summaryAsync.when(
              loading: () => Column(
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: List.generate(
                        4,
                        (i) => Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            child: Container(
                              height: 72,
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (summary) => _buildContent(
                context,
                ref,
                summary,
                drinkTypesAsync,
                selectedDrinkTypeId,
                unit,
                profile,
                lastLogAsync,
              ),
            ),
          ),
          if (showCelebration)
            CelebrationOverlay(
              isVisible: showCelebration,
              unit: unit,
            ),
        ],
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
    AsyncValue<WaterLogModel?> lastLogAsync,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IconButton(
          icon: Icon(Icons.notifications_active),
          onPressed: () async {
            await NotificationService().showReminderNotification();
          },
        ),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
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

        if (summary.totalMl == 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Tap a button below to log your first drink! 💧',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        // SECTION 3 — Drink type selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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

        const SizedBox(height: 16),

        // SECTION 4 — Quick add buttons + inline custom button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                children: [
                  ...AppConstants.quickAddAmounts.map((amount) => Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          child: QuickAddButton(
                            amountMl: amount,
                            unit: unit,
                            onTap: () => ref
                                .read(homeActionProvider.notifier)
                                .addQuickLog(amount.toDouble()),
                            accentColor: _getSelectedDrinkColor(
                              drinkTypesAsync.valueOrNull,
                              selectedDrinkTypeId,
                            ),
                          ),
                        ),
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CustomAddButton(
                        onTap: () =>
                            _showCustomAmountSheet(context, ref, unit),
                        accentColor: _getSelectedDrinkColor(
                          drinkTypesAsync.valueOrNull,
                          selectedDrinkTypeId,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // SECTION 4b — Undo last log
        lastLogAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (lastLog) => lastLog != null
              ? UndoLogButton(
                  lastLog: lastLog,
                  unit: unit,
                  onUndo: () => ref
                      .read(homeActionProvider.notifier)
                      .deleteLastLog(),
                )
              : const SizedBox.shrink(),
        ),

        const SizedBox(height: 16),
      ],
      ),
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

  void _showCustomAmountSheet(BuildContext context, WidgetRef ref, String unit) {
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
          unit: unit,
          onAdd: (amount) {
            ref.read(homeActionProvider.notifier).addQuickLog(amount);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
