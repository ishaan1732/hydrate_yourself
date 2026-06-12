import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/double_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../onboarding/domain/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../reminders/data/notification_service.dart';
import '../../reminders/presentation/reminders_provider.dart';
import '../domain/today_override.dart';
import '../domain/today_summary.dart';
import '../domain/water_log_model.dart';
import 'home_provider.dart';
import 'widgets/celebration_overlay.dart';
import 'widgets/cup_size_sheet.dart';
import 'widgets/drink_type_sheet.dart';
import 'widgets/jumbo_widget.dart';
import 'widgets/today_conditions_sheet.dart';
import 'widgets/water_wave.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationSetupNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final summaryAsync = ref.watch(todaySummaryProvider);
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final unit = profile?.unit ?? AppConstants.unitMl;
    final showCelebration = ref.watch(showCelebrationProvider);
    final jumboAmountAsync = ref.watch(jumboTapAmountProvider);
    final jumboAmount = jumboAmountAsync.valueOrNull ?? 250;
    final selectedDrinkTypeId = ref.watch(selectedDrinkTypeIdProvider);
    final lastLogAsync = ref.watch(lastLogProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // LAYER 1: Full screen wave
          if (summaryAsync.valueOrNull != null)
            Positioned.fill(
              child: WaterWave(
                fillPercent: summaryAsync.valueOrNull!.percentage,
                waveColor: colorScheme.primary,
              ),
            ),

          // LAYER 2: Celebration (above wave, below content)
          if (showCelebration)
            CelebrationOverlay(
              isVisible: showCelebration,
              unit: unit,
            ),

          // LAYER 3: Content
          SafeArea(
            child: Builder(
              builder: (context) {
                if (summaryAsync.isLoading &&
                    summaryAsync.valueOrNull == null) {
                  return _buildSkeleton(context);
                }
                if (summaryAsync.hasError &&
                    summaryAsync.valueOrNull == null) {
                  return Center(
                      child: Text('Error: ${summaryAsync.error}'));
                }
                final summary = summaryAsync.valueOrNull!;
                return _buildContent(
                  context, ref, summary, unit, jumboAmount,
                  profile, selectedDrinkTypeId, lastLogAsync,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    TodaySummary summary,
    String unit,
    int jumboAmount,
    UserProfileModel? profile,
    int? selectedDrinkTypeId,
    AsyncValue<WaterLogModel?> lastLogAsync,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final cupSize =
          prefs.getInt(AppConstants.prefLastCupSizeMl) ?? jumboAmount;
      await NotificationService().showProgressNotification(
        totalMl: summary.totalMl.round(),
        goalMl: summary.goalMl,
        unit: unit,
        cupSizeMl: cupSize,
      );
    });
    return Column(
      children: [
        _buildHeader(context, profile),
        _buildProgressText(context, summary, unit),
        Expanded(
          child: Center(
            child: JumboWidget(
              tapAmount: jumboAmount,
              unit: unit,
              onTap: () => ref
                  .read(homeActionProvider.notifier)
                  .addQuickLog(jumboAmount.toDouble()),
            ),
          ),
        ),
        _buildConditionsPill(context, ref, profile),
        _buildActionBar(
          context,
          ref,
          unit,
          selectedDrinkTypeId,
          lastLogAsync,
          jumboAmount,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, UserProfileModel? profile) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              Text(
                profile?.name ?? 'there',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: unit == 'oz'
                      ? '${(summary.totalMl * 0.033814).round()}'
                      : _formatMl(summary.totalMl.round()),
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    letterSpacing: -1,
                  ),
                ),
                TextSpan(
                  text: unit == 'oz' ? ' oz' : ' ml',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            summary.isGoalAchieved
                ? '🎉 Goal achieved!'
                : unit == 'oz'
                    ? '${(summary.remainingMl * 0.033814).round()} oz to go · '
                        'goal ${(summary.goalMl * 0.033814).round()} oz'
                    : '${_formatMl(summary.remainingMl.round())} ml to go · '
                        'goal ${_formatMl(summary.goalMl)} ml',
            style: theme.textTheme.bodySmall?.copyWith(
              color: summary.isGoalAchieved
                  ? AppColors.goalAchieved
                  : colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              final pct = summary.percentage.clamp(0.0, 1.0);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${(pct * 100).round()}%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(context, summary.percentage),
                      ),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 3),
                  SizedBox(
                    height: 12,
                    child: Stack(
                      children: [
                        for (final t in [0.25, 0.50, 0.75])
                          Positioned(
                            left: barWidth * t - 0.75,
                            top: 0,
                            bottom: 0,
                            child: SizedBox(
                              width: 1.5,
                              child: ColoredBox(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Always-visible conditions pill ─────────────────────────────────────────

  Widget _buildConditionsPill(
    BuildContext context,
    WidgetRef ref,
    UserProfileModel? profile,
  ) {
    final override = ref.watch(todayOverrideNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final profileClimate =
        ClimateType.fromRaw(profile?.climateType ?? 'moderate');
    final profileActivity =
        ActivityLevel.fromRaw(profile?.activityLevel ?? 0);

    final hasClimateOverride = override?.climate != null;
    final hasActivityOverride = override?.activity != null;
    final displayClimate = override?.climate ?? profileClimate;
    final displayActivity = override?.activity ?? profileActivity;

    final muted = theme.textTheme.labelSmall?.copyWith(
      color: colorScheme.onSurface.withValues(alpha: 0.6),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _openConditionsSheet(context, ref, profile),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 13,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 6),

                  // Climate slot
                  if (hasClimateOverride)
                    _OverrideChip(
                      label: '${displayClimate.emoji} ${displayClimate.label}',
                      colorScheme: colorScheme,
                      onClear: () => ref
                          .read(todayOverrideNotifierProvider.notifier)
                          .clearClimate(),
                    )
                  else
                    Text(
                      '${displayClimate.emoji} ${displayClimate.label}',
                      style: muted,
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Text(
                      '·',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.4),
                      ),
                    ),
                  ),

                  // Activity slot
                  if (hasActivityOverride)
                    _OverrideChip(
                      label:
                          '${displayActivity.emoji} ${displayActivity.label}',
                      colorScheme: colorScheme,
                      onClear: () => ref
                          .read(todayOverrideNotifierProvider.notifier)
                          .clearActivity(),
                    )
                  else
                    Text(
                      '${displayActivity.emoji} ${displayActivity.label}',
                      style: muted,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openConditionsSheet(
    BuildContext context,
    WidgetRef ref,
    UserProfileModel? profile,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    final notifier = ref.read(todayOverrideNotifierProvider.notifier);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => TodayConditionsSheet(
        profile: profile,
        onDone: () {
          Navigator.of(sheetCtx).pop();
          final activeOverride = ref.read(todayOverrideNotifierProvider);
          if (activeOverride != null && activeOverride.hasAny) {
            messenger.showSnackBar(
              SnackBar(
                content: const Text('Override active for today'),
                action: SnackBarAction(
                  label: 'Apply permanently',
                  onPressed: notifier.makePermanent,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // ── Action bar ─────────────────────────────────────────────────────────────

  Widget _buildActionBar(
    BuildContext context,
    WidgetRef ref,
    String unit,
    int? selectedDrinkTypeId,
    AsyncValue<WaterLogModel?> lastLogAsync,
    int jumboAmount,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final lastLog = lastLogAsync.valueOrNull;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.local_drink_outlined,
              label: unit == 'oz'
                  ? jumboAmount.toDouble().toHalfOzString()
                  : '$jumboAmount ml',
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (dialogContext) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: CupSizeSheet(
                    currentSizeMl: jumboAmount,
                    unit: unit,
                    onSizeSelected: (ml) {
                      ref.read(jumboTapAmountProvider.notifier).setAmount(ml);
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: _buildDrinkTypeButton(context, ref, selectedDrinkTypeId),
          ),
          const SizedBox(width: 10),

          IconButton(
            icon: const Icon(Icons.undo_rounded),
            color: colorScheme.error,
            iconSize: 20,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            onPressed: lastLog != null
                ? () => ref.read(homeActionProvider.notifier).deleteLastLog()
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDrinkTypeButton(
    BuildContext context,
    WidgetRef ref,
    int? selectedId,
  ) {
    return ref.watch(drinkTypesProvider).when(
          loading: () => const _ActionButton(
            icon: Icons.water_drop_outlined,
            label: 'Drink Type',
            onTap: null,
          ),
          error: (_, _) => const _ActionButton(
            icon: Icons.water_drop_outlined,
            label: 'Drink Type',
            onTap: null,
          ),
          data: (drinkTypes) {
            if (drinkTypes.isEmpty) {
              return const _ActionButton(
                icon: Icons.water_drop_outlined,
                label: 'Drink Type',
                onTap: null,
              );
            }
            final selected = selectedId != null
                ? drinkTypes.firstWhere(
                    (d) => d.id == selectedId,
                    orElse: () => drinkTypes.first,
                  )
                : drinkTypes.first;

            return _ActionButton(
              iconWidget: Text(
                _emojiForDrink(selected.iconName),
                style: const TextStyle(fontSize: 22),
              ),
              label: selected.name,
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (dialogContext) => DrinkTypeSheet(
                  selectedDrinkTypeId: selectedId ?? drinkTypes.first.id,
                  onDrinkSelected: (drink) {
                    ref
                        .read(selectedDrinkTypeIdProvider.notifier)
                        .state = drink.id;
                  },
                ),
              ),
            );
          },
        );
  }

  Widget _buildSkeleton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(height: 60),
        Center(
          child: Container(
            width: 190,
            height: 160,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 0 : 5,
                    right: i == 2 ? 0 : 5,
                  ),
                  child: Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
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

  String _formatMl(int ml) {
    if (ml >= 1000) {
      final thousands = ml ~/ 1000;
      final remainder = ml % 1000;
      return '$thousands,${remainder.toString().padLeft(3, '0')}';
    }
    return ml.toString();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  Color _getProgressColor(BuildContext context, double pct) {
    if (pct >= 1.0) return AppColors.goalAchieved;
    if (pct >= 0.5) return Theme.of(context).colorScheme.primary;
    return AppColors.goalWarning;
  }

  String _emojiForDrink(String iconName) {
    return switch (iconName) {
      'water_drop' => '💧',
      'coffee' => '☕',
      'emoji_food_beverage' => '🍵',
      'local_drink' => '🥤',
      'sports_bar' => '🫧',
      _ => iconName,
    };
  }
}

// ── Override chip (inside pill) ───────────────────────────────────────────────

class _OverrideChip extends StatelessWidget {
  const _OverrideChip({
    required this.label,
    required this.colorScheme,
    required this.onClear,
  });

  final String label;
  final ColorScheme colorScheme;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 2, 3, 2),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: onClear,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(
                Icons.close_rounded,
                size: 12,
                color: colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action button ─────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    this.icon,
    this.iconWidget,
    required this.label,
    required this.onTap,
    this.isDisabled = false,
    this.color,
  });

  final IconData? icon;
  final Widget? iconWidget;
  final String label;
  final VoidCallback? onTap;
  final bool isDisabled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedOpacity(
        opacity: isDisabled ? 0.35 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconWidget != null)
                iconWidget!
              else
                Icon(
                  icon!,
                  size: 20,
                  color: color ?? colorScheme.onSurfaceVariant,
                ),
              const SizedBox(height: 5),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color ?? colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
