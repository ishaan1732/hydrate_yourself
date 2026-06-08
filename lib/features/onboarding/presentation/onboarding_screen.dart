import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/double_extensions.dart';
import 'onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  late FixedExtentScrollController _hourWheelCtrl;
  late FixedExtentScrollController _minuteWheelCtrl;
  int _currentPage = 0;
  String? _nameError;
  String? _weightError;

  @override
  void initState() {
    super.initState();
    const initMins = AppConstants.defaultReminderIntervalMinutes;
    _hourWheelCtrl = FixedExtentScrollController(initialItem: initMins ~/ 60);
    _minuteWheelCtrl = FixedExtentScrollController(initialItem: (initMins % 60) ~/ 30);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _weightController.dispose();
    _hourWheelCtrl.dispose();
    _minuteWheelCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => _buildPage(index),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: _previousPage,
                      child: const Text('Back'),
                    ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _currentPage < 2 ? _nextPage : _complete,
                    child: Text(_currentPage < 2 ? 'Next' : 'Complete'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildPage(int index) {
    return switch (index) {
      0 => _buildNameWeightPage(),
      1 => _buildActivityPage(),
      2 => _buildRemindersPage(),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildNameWeightPage() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell us about you 👤',
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'We use this to calculate your daily water goal',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Your name',
              errorText: _nameError,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) =>
                ref.read(onboardingNotifierProvider.notifier).updateName(value),
          ),
          const SizedBox(height: 16),
          Builder(builder: (context) {
            final weightUnit = ref.watch(onboardingNotifierProvider)
                    .value?.weightUnit ??
                AppConstants.unitKg;
            return TextField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Weight ($weightUnit)',
                errorText: _weightError,
                border: const OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                final weight = double.tryParse(value.trim());
                if (weight != null && weight > 0) {
                  ref
                      .read(onboardingNotifierProvider.notifier)
                      .updateWeight(weight);
                }
              },
            );
          }),
          const SizedBox(height: 12),
          Text(
            'Weight unit',
            style: theme.textTheme.labelLarge
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'kg', label: Text('kg')),
              ButtonSegment(value: 'lbs', label: Text('lbs')),
            ],
            selected: {
              ref.watch(onboardingNotifierProvider).value?.weightUnit ??
                  AppConstants.unitKg,
            },
            onSelectionChanged: (val) => ref
                .read(onboardingNotifierProvider.notifier)
                .updateWeightUnit(val.first),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityPage() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activityLevel =
        ref.watch(onboardingNotifierProvider).value?.activityLevel ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Level 🏃',
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'How active are you on a typical day?',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          _buildActivityCard(0, 'Sedentary', 'Mostly sitting, desk work',
              Icons.chair, activityLevel),
          _buildActivityCard(1, 'Light', 'Light walks, standing job',
              Icons.directions_walk, activityLevel),
          _buildActivityCard(2, 'Moderate', 'Regular exercise 3-4x/week',
              Icons.directions_run, activityLevel),
          _buildActivityCard(3, 'Active', 'Daily intense exercise',
              Icons.fitness_center, activityLevel),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    int level,
    String title,
    String description,
    IconData icon,
    int currentActivityLevel,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = currentActivityLevel == level;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => ref
            .read(onboardingNotifierProvider.notifier)
            .updateActivityLevel(level),
        child: Card(
          elevation: 0,
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              color: isSelected ? colorScheme.primary : null,
            ),
            title: Text(title),
            subtitle: Text(description),
          ),
        ),
      ),
    );
  }

  Widget _buildRemindersPage() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notifierState = ref.watch(onboardingNotifierProvider).value;
    final wakeHour = notifierState?.wakeHour ?? AppConstants.defaultWakeHour;
    final wakeMinute = notifierState?.wakeMinute ?? 0;
    final sleepHour = notifierState?.sleepHour ?? AppConstants.defaultSleepHour;
    final sleepMinute = notifierState?.sleepMinute ?? 0;
    final intervalMinutes = notifierState?.reminderIntervalMinutes ??
        AppConstants.defaultReminderIntervalMinutes;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reminder Settings ⏰',
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'We will remind you to drink water throughout the day',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Text('Wake up time', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: wakeHour, minute: wakeMinute),
                helpText: 'Wake up time',
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: false),
                  child: child!,
                ),
              );
              if (picked != null) {
                ref
                    .read(onboardingNotifierProvider.notifier)
                    .updateWakeTime(picked.hour, picked.minute);
              }
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 12),
                  Text(_formatTime(wakeHour, wakeMinute),
                      style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Bedtime', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: sleepHour, minute: sleepMinute),
                helpText: 'Bedtime',
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: false),
                  child: child!,
                ),
              );
              if (picked != null) {
                ref
                    .read(onboardingNotifierProvider.notifier)
                    .updateSleepTime(picked.hour, picked.minute);
              }
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bedtime_outlined),
                  const SizedBox(width: 12),
                  Text(_formatTime(sleepHour, sleepMinute),
                      style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text('Reminder every', style: theme.textTheme.bodyLarge),
              const Spacer(),
              Text(_formatInterval(intervalMinutes),
                  style: theme.textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: Row(
              children: [
                Expanded(
                  child: CupertinoPicker(
                    scrollController: _hourWheelCtrl,
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      final mins = (intervalMinutes % 60 ~/ 30) * 30;
                      final total = index * 60 + (index == 0 && mins == 0 ? 30 : mins);
                      ref
                          .read(onboardingNotifierProvider.notifier)
                          .updateReminderInterval(total);
                    },
                    children: List.generate(
                      9,
                      (i) => Center(child: Text('$i hr')),
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: _minuteWheelCtrl,
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      final mins = index * 30;
                      final hours = intervalMinutes ~/ 60;
                      final total = hours * 60 + mins;
                      ref
                          .read(onboardingNotifierProvider.notifier)
                          .updateReminderInterval(total == 0 ? 30 : total);
                    },
                    children: const [
                      Center(child: Text(':00')),
                      Center(child: Text(':30')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour == 0 ? 12 : hour > 12 ? hour - 12 : hour;
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m $period';
  }

  String _formatInterval(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '$h hr' : '$h hr $m min';
  }

  void _nextPage() {
    FocusScope.of(context).unfocus();
    if (_currentPage == 0) {
      String? nameErr;
      String? weightErr;

      if (_nameController.text.trim().isEmpty) {
        nameErr = 'Please enter your name';
      }

      final weight = double.tryParse(_weightController.text.trim());
      if (weight == null || weight <= 0) {
        weightErr = 'Please enter a valid weight';
      }

      if (nameErr != null || weightErr != null) {
        setState(() {
          _nameError = nameErr;
          _weightError = weightErr;
        });
        return;
      }

      setState(() {
        _nameError = null;
        _weightError = null;
      });
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage++);
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage--);
  }

  Future<void> _complete() async {
    final formData = ref.read(onboardingNotifierProvider).value;
    final name = _nameController.text.trim();
    // Weight entered in user's chosen unit; convert to kg for storage
    final rawWeight = double.tryParse(_weightController.text.trim()) ??
        AppConstants.defaultWeightKg;
    final weightUnit = formData?.weightUnit ?? AppConstants.unitKg;
    final storedWeight = weightUnit == AppConstants.unitLbs
        ? rawWeight.lbsToKg
        : rawWeight;
    await ref.read(onboardingNotifierProvider.notifier).completeOnboarding(
          name: name,
          weightKg: storedWeight,
          weightUnit: weightUnit,
          activityLevel:
              formData?.activityLevel ?? AppConstants.defaultActivityLevel,
          wakeHour: formData?.wakeHour ?? AppConstants.defaultWakeHour,
          wakeMinute: formData?.wakeMinute ?? 0,
          sleepHour: formData?.sleepHour ?? AppConstants.defaultSleepHour,
          sleepMinute: formData?.sleepMinute ?? 0,
          reminderIntervalMinutes: formData?.reminderIntervalMinutes ??
              AppConstants.defaultReminderIntervalMinutes,
        );
    if (mounted) context.go('/home');
  }
}
