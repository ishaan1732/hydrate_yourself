import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_yourself/core/utils/hydration_calculator.dart';

void main() {
  group('HydrationCalculator.calculateDailyGoalMl', () {
    test('sedentary 70 kg → 2450 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(70, 0),
        equals(2450),
      );
    });

    test('active 90 kg → capped at 4000 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(90, 3),
        equals(4000),
      );
    });

    test('light activity 50 kg → 1925 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(50, 1),
        equals(1925),
      );
    });

    test('moderate 40 kg → 1680 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(40, 2),
        equals(1680),
      );
    });

    test('very low weight 20 kg → floored at 1500 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(20, 0),
        equals(1500),
      );
    });

    test('unknown activity level 99, 60 kg → default multiplier → 2100 ml',
        () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(60, 99),
        equals(2100),
      );
    });
  });
}
