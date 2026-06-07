import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/double_extensions.dart';
import '../../onboarding/domain/user_profile_model.dart';
import '../../reminders/presentation/reminders_provider.dart';
import '../domain/drink_type_model.dart';
import '../domain/today_summary.dart';
import '../domain/water_log_model.dart';
import 'home_provider.dart';
import 'widgets/celebration_overlay.dart';
import 'widgets/custom_add_button.dart';
import 'widgets/custom_amount_sheet.dart';
import 'widgets/drink_type_chip.dart';
import 'widgets/jumbo_widget.dart';
import 'widgets/quick_add_button.dart';
import 'widgets/undo_log_button.dart';
import 'widgets/water_wave_painter.dart';

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
    final jumboTapAmount = ref.watch(jumboTapAmountProvider);

    final fillPercent = summaryAsync.valueOrNull?.percentage ?? 0.0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Layer 1 — animated wave background
          Positioned.fill(
            child: WaterWavePainter(
              fillPercent: fillPercent,
              waveColor: colorScheme.primary,
            ),
          ),

          // Layer 2 — scrollable content
          SafeArea(
            child: summaryAsync.when(
              loading: () => _buildSkeleton(context, colorScheme),
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
                jumboTapAmount,
              ),
            ),
          ),

          // Layer 3 — celebration overlay
          if (showCelebration)
            CelebrationOverlay(
              isVisible: showCelebration,
              unit: unit,
            ),
        ],
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          width: 200,
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 80),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
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
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
    int jumboTapAmount,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, profile),
          const SizedBox(height: 16),

          // Jumbo mascot — tap to log
          Center(
            child: JumboWidget(
              tapAmount: jumboTapAmount,
              onTap: () => ref
                  .read(homeActionProvider.notifier)
                  .addQuickLog(jumboTapAmount.toDouble()),
            ),
          ),
          const SizedBox(height: 24),

          // Progress text + linear bar
          _buildProgressText(context, summary, unit),
          const SizedBox(height: 24),

          // Drink type selector
          _buildDrinkTypeSelector(
              context, ref, drinkTypesAsync, selectedDrinkTypeId),
          const SizedBox(height: 16),

          // Quick add row
          _buildQuickAddRow(
              context, ref, drinkTypesAsync, selectedDrinkTypeId, unit),
          const SizedBox(height: 8),

          // Undo last log
          lastLogAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (lastLog) => lastLog != null
                ? UndoLogButton(
                    lastLog: lastLog,
                    unit: unit,
                    onUndo: () =>
                        ref.read(homeActionProvider.notifier).deleteLastLog(),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserProfileModel? profile) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
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
    );
  }

  Widget _buildProgressText(
    BuildContext context,
    TodaySummary summary,
    String unit,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final totalDisplay = unit == 'oz'
        ? '${summary.totalMl.mlToOz.toStringAsFixed(1)} oz'
        : '${summary.totalMl.round()} ml';
    final goalDisplay = unit == 'oz'
        ? '${summary.goalMl.toDouble().mlToOz.toStringAsFixed(1)} oz'
        : '${summary.goalMl} ml';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                totalDisplay,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                ' of $goalDisplay',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              Text(
                '${(summary.percentage * 100).round()}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: summary.isGoalAchieved
                      ? const Color(0xFF2ECC71)
                      : colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: summary.percentage,
              minHeight: 6,
              backgroundColor:
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              valueColor: AlwaysStoppedAnimation<Color>(
                summary.isGoalAchieved
                    ? const Color(0xFF2ECC71)
                    : colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrinkTypeSelector(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<DrinkTypeModel>> drinkTypesAsync,
    int? selectedDrinkTypeId,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Drinking',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
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
    );
  }

  Widget _buildQuickAddRow(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<DrinkTypeModel>> drinkTypesAsync,
    int? selectedDrinkTypeId,
    String unit,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = _getSelectedDrinkColor(
      drinkTypesAsync.valueOrNull,
      selectedDrinkTypeId,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Add',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...AppConstants.quickAddAmounts.map((amount) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: QuickAddButton(
                        amountMl: amount,
                        unit: unit,
                        onTap: () => ref
                            .read(homeActionProvider.notifier)
                            .addQuickLog(amount.toDouble()),
                        accentColor: accentColor,
                      ),
                    ),
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: CustomAddButton(
                    onTap: () => _showCustomAmountSheet(context, ref, unit),
                    accentColor: accentColor,
                  ),
                ),
              ),
            ],
          ),
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

  void _showCustomAmountSheet(
      BuildContext context, WidgetRef ref, String unit) {
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
