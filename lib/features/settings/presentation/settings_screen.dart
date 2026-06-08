import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/double_extensions.dart';
import '../../onboarding/domain/user_profile_model.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const List<int> _reminderOptions = [
    30, 60, 90, 120, 150, 180,
    210, 240, 270, 300, 330, 360,
    390, 420, 450, 480,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
        child: settingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) {
            debugPrint('Settings error: $e\n$st');
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Failed to load settings'),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => ref.invalidate(settingsNotifierProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          },
          data: (profile) => profile == null
              ? const Center(child: Text('No profile found'))
              : _buildContent(context, ref, profile),
        ),
      ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, UserProfileModel profile) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section A — Profile
              _buildSectionHeader(context, 'Profile'),
              _buildCard(
                context,
                children: [
                  _buildEditableTile(
                    context,
                    icon: Icons.person_outline,
                    label: 'Name',
                    value: profile.name,
                    onTap: () =>
                        _showEditNameDialog(context, ref, profile.name),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildEditableTile(
                    context,
                    icon: Icons.monitor_weight_outlined,
                    label: 'Weight',
                    value: profile.weightKg.toWeightString(profile.weightUnit),
                    onTap: () =>
                        _showEditWeightDialog(context, ref, profile),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildWeightUnitTile(context, ref, profile),
                  const Divider(height: 1, indent: 56),
                  _buildActivityTile(context, ref, profile.activityLevel),
                  const Divider(height: 1, indent: 56),
                  _buildWakeTimeTile(context, ref, profile),
                  const Divider(height: 1, indent: 56),
                  _buildSleepTimeTile(context, ref, profile),
                ],
              ),

              const SizedBox(height: 8),

              // Section B — Hydration
              _buildSectionHeader(context, 'Hydration'),
              _buildCard(
                context,
                children: [
                  _buildGoalTile(context, ref, profile),
                  const Divider(height: 1, indent: 56),
                  _buildUnitToggleTile(context, ref, profile.unit),
                ],
              ),

              const SizedBox(height: 8),

              // Section C — Reminders
              _buildSectionHeader(context, 'Reminders'),
              _buildCard(
                context,
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_outlined),
                    title: Text(
                      'Enable reminders',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    value: profile.notificationsEnabled,
                    onChanged: (val) => ref
                        .read(settingsNotifierProvider.notifier)
                        .updateNotificationsEnabled(val),
                  ),
                  if (profile.notificationsEnabled) ...[
                    const Divider(height: 1, indent: 56),
                    _buildReminderIntervalTile(
                        context, ref, profile.reminderIntervalMinutes),
                  ],
                ],
              ),

              const SizedBox(height: 8),

              // Section D — About
              _buildSectionHeader(context, 'About'),
              _buildCard(
                context,
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(
                      'Version',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Text(
                      '1.0.0',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(children: children),
    );
  }

  Widget _buildEditableTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right,
              size: 20, color: colorScheme.onSurfaceVariant),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildActivityTile(
      BuildContext context, WidgetRef ref, int currentLevel) {
    final colorScheme = Theme.of(context).colorScheme;
    const labels = ['Sedentary', 'Light', 'Moderate', 'Active'];
    return ListTile(
      leading:
          Icon(Icons.directions_run_outlined, color: colorScheme.primary),
      title: Text(
          'Activity Level', style: Theme.of(context).textTheme.bodyLarge),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labels[currentLevel.clamp(0, 3)],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right,
              size: 20, color: colorScheme.onSurfaceVariant),
        ],
      ),
      onTap: () => _showActivityDialog(context, ref, currentLevel),
    );
  }

  Widget _buildWeightUnitTile(
      BuildContext context, WidgetRef ref, UserProfileModel profile) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(Icons.scale_outlined, color: colorScheme.primary),
      title: Text('Weight Unit', style: Theme.of(context).textTheme.bodyLarge),
      trailing: SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'kg', label: Text('kg')),
          ButtonSegment(value: 'lbs', label: Text('lbs')),
        ],
        selected: {profile.weightUnit},
        onSelectionChanged: (val) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref
                .read(settingsNotifierProvider.notifier)
                .updateWeightUnit(val.first);
          });
        },
        style: const ButtonStyle(
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  Widget _buildWakeTimeTile(
      BuildContext context, WidgetRef ref, UserProfileModel profile) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(Icons.wb_sunny_outlined, color: colorScheme.primary),
      title: Text('Wake up', style: Theme.of(context).textTheme.bodyLarge),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatHour(profile.wakeHour),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 20, color: colorScheme.onSurfaceVariant),
        ],
      ),
      onTap: () => _showTimePicker(
        context,
        title: 'Wake up time',
        currentHour: profile.wakeHour,
        onSelected: (h) =>
            ref.read(settingsNotifierProvider.notifier).updateWakeHour(h),
      ),
    );
  }

  Widget _buildSleepTimeTile(
      BuildContext context, WidgetRef ref, UserProfileModel profile) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(Icons.bedtime_outlined, color: colorScheme.primary),
      title: Text('Bedtime', style: Theme.of(context).textTheme.bodyLarge),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatHour(profile.sleepHour),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 20, color: colorScheme.onSurfaceVariant),
        ],
      ),
      onTap: () => _showTimePicker(
        context,
        title: 'Bedtime',
        currentHour: profile.sleepHour,
        onSelected: (h) =>
            ref.read(settingsNotifierProvider.notifier).updateSleepHour(h),
      ),
    );
  }

  void _showTimePicker(
    BuildContext context, {
    required String title,
    required int currentHour,
    required void Function(int hour) onSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (dialogContext) {
        int selected = currentHour;
        return StatefulBuilder(
          builder: (ctx, setState) => Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 24,
                    itemBuilder: (_, i) {
                      final isSelected = i == selected;
                      return GestureDetector(
                        onTap: () => setState(() => selected = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary.withValues(alpha: 0.15)
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _formatHour(i),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurface,
                                ),
                              ),
                              const Spacer(),
                              if (isSelected)
                                Icon(Icons.check_circle_rounded,
                                    color: colorScheme.primary, size: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      onSelected(selected);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Confirm ${_formatHour(selected)}'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatHour(int hour) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour > 12 ? hour - 12 : hour == 0 ? 12 : hour;
    return '$h:00 $period';
  }

  Widget _buildGoalTile(
      BuildContext context, WidgetRef ref, UserProfileModel profile) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(Icons.flag_outlined, color: colorScheme.primary),
      title:
          Text('Daily Goal', style: Theme.of(context).textTheme.bodyLarge),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            profile.unit == 'oz'
                ? '${profile.dailyGoalMl.toDouble().mlToOz.toStringAsFixed(1)} oz'
                : '${profile.dailyGoalMl} ml',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right,
              size: 20, color: colorScheme.onSurfaceVariant),
        ],
      ),
      onTap: () => _showGoalDialog(context, ref, profile.dailyGoalMl, profile.unit),
    );
  }

  Widget _buildUnitToggleTile(
      BuildContext context, WidgetRef ref, String currentUnit) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading:
          Icon(Icons.straighten_outlined, color: colorScheme.primary),
      title: Text('Unit', style: Theme.of(context).textTheme.bodyLarge),
      trailing: SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'ml', label: Text('ml')),
          ButtonSegment(value: 'oz', label: Text('oz')),
        ],
        selected: {currentUnit},
        onSelectionChanged: (val) {
          ref.read(settingsNotifierProvider.notifier).updateUnit(val.first);
        },
        style: const ButtonStyle(
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  Widget _buildReminderIntervalTile(
      BuildContext context, WidgetRef ref, int currentMinutes) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(Icons.timer_outlined, color: colorScheme.primary),
      title: Text(
          'Remind me every', style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(
        _formatInterval(currentMinutes),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
      ),
      trailing:
          Icon(Icons.chevron_right, size: 20, color: colorScheme.onSurfaceVariant),
      onTap: () => _showReminderPicker(context, ref, currentMinutes),
    );
  }

  void _showEditNameDialog(
      BuildContext context, WidgetRef ref, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(dialogContext);
              ref.read(settingsNotifierProvider.notifier).updateName(name);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditWeightDialog(
      BuildContext context, WidgetRef ref, UserProfileModel profile) {
    final isLbs = profile.weightUnit == AppConstants.unitLbs;
    final controller = TextEditingController(
      text: isLbs
          ? profile.weightKg.kgToLbs.toStringAsFixed(1)
          : profile.weightKg.toStringAsFixed(1),
    );
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Weight'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Weight (${profile.weightUnit})',
            border: const OutlineInputBorder(),
          ),
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val == null || val <= 0) return;
              Navigator.pop(dialogContext);
              ref.read(settingsNotifierProvider.notifier)
                  .updateWeight(val, profile.weightUnit);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showActivityDialog(
      BuildContext context, WidgetRef ref, int currentLevel) {
    const labels = ['Sedentary', 'Light', 'Moderate', 'Active'];
    const icons = [
      Icons.chair,
      Icons.directions_walk,
      Icons.directions_run,
      Icons.fitness_center,
    ];
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Activity Level'),
        content: RadioGroup<int>(
          groupValue: currentLevel,
          onChanged: (val) {
            if (val == null) return;
            Navigator.pop(dialogContext);
            ref
                .read(settingsNotifierProvider.notifier)
                .updateActivityLevel(val);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<int>(
                value: 0,
                title: const Text('Sedentary'),
                secondary: const Icon(Icons.chair),
              ),
              RadioListTile<int>(
                value: 1,
                title: const Text('Light'),
                secondary: const Icon(Icons.directions_walk),
              ),
              RadioListTile<int>(
                value: 2,
                title: const Text('Moderate'),
                secondary: const Icon(Icons.directions_run),
              ),
              RadioListTile<int>(
                value: 3,
                title: const Text('Active'),
                secondary: const Icon(Icons.fitness_center),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showGoalDialog(
      BuildContext context, WidgetRef ref, int currentGoal, String unit) {
    final isOz = unit == AppConstants.unitOz;
    double sliderValue = currentGoal.toDouble();
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          final displayValue = isOz
              ? '${sliderValue.mlToOz.toStringAsFixed(1)} oz'
              : '${sliderValue.round()} ml';
          return AlertDialog(
            title: const Text('Daily Goal'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayValue,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  textAlign: TextAlign.center,
                ),
                Slider(
                  min: AppConstants.minDailyGoalMl.toDouble(),
                  max: AppConstants.maxDailyGoalMl.toDouble(),
                  divisions: 25,
                  value: sliderValue,
                  label: displayValue,
                  onChanged: (val) => setState(() => sliderValue = val),
                ),
                Row(
                  children: [
                    Text(
                      isOz
                          ? '${AppConstants.minDailyGoalMl.toDouble().mlToOz.toStringAsFixed(1)} oz'
                          : '${AppConstants.minDailyGoalMl} ml',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      isOz
                          ? '${AppConstants.maxDailyGoalMl.toDouble().mlToOz.toStringAsFixed(1)} oz'
                          : '${AppConstants.maxDailyGoalMl} ml',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final goal = sliderValue.round();
                  Navigator.pop(dialogContext);
                  ref.read(settingsNotifierProvider.notifier).updateGoal(goal);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showReminderPicker(
      BuildContext context, WidgetRef ref, int currentMinutes) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (dialogContext) {
        int selected = _reminderOptions.contains(currentMinutes)
            ? currentMinutes
            : 90;
        return StatefulBuilder(
          builder: (ctx, setState) => Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Reminder Interval',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "How often to remind you when you haven't logged",
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 340),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _reminderOptions.length,
                    itemBuilder: (_, i) {
                      final option = _reminderOptions[i];
                      final isSelected = option == selected;
                      return GestureDetector(
                        onTap: () => setState(() => selected = option),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary.withValues(alpha: 0.15)
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _formatInterval(option),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurface,
                                ),
                              ),
                              const Spacer(),
                              if (option == 90)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Recommended',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                Icon(Icons.check_circle_rounded,
                                    color: colorScheme.primary, size: 20),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      ref
                          .read(settingsNotifierProvider.notifier)
                          .updateReminderInterval(selected);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                        'Set reminder every ${_formatInterval(selected)}'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatInterval(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return hours == 1 ? '1 hr' : '$hours hrs';
    return '$hours hr $mins min';
  }
}
