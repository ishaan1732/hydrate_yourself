class HydrationCalculator {
  HydrationCalculator._();

  static int calculateDailyGoalMl(double weightKg, int activityLevel) {
    final base = weightKg * 35;
    final multiplier = switch (activityLevel) {
      0 => 1.0,
      1 => 1.1,
      2 => 1.2,
      3 => 1.4,
      _ => 1.0,
    };
    return (base * multiplier).clamp(1500, 4000).round();
  }
}
