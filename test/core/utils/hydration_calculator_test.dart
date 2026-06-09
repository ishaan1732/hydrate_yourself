import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_yourself/core/utils/hydration_calculator.dart';

void main() {
  group('HydrationCalculator.calculateDailyGoalMl', () {
    test('sedentary 70 kg → 2450 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
            weightKg: 70, activityLevel: 0),
        equals(2450),
      );
    });

    test('active 90 kg → 4410 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
            weightKg: 90, activityLevel: 3),
        equals(4410),
      );
    });

    test('light activity 50 kg → 1925 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
            weightKg: 50, activityLevel: 1),
        equals(1925),
      );
    });

    test('moderate 40 kg → 1680 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
            weightKg: 40, activityLevel: 2),
        equals(1680),
      );
    });

    test('very low weight 20 kg → floored at 1500 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
            weightKg: 20, activityLevel: 0),
        equals(1500),
      );
    });

    test('unknown activity level 99, 60 kg → default multiplier → 2100 ml',
        () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
            weightKg: 60, activityLevel: 99),
        equals(2100),
      );
    });

    test('female 70 kg sedentary moderate → 2254 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
          weightKg: 70,
          activityLevel: 0,
          gender: 'female',
        ),
        equals(2254),
      );
    });

    test('female pregnant 70 kg sedentary moderate → 2554 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
          weightKg: 70,
          activityLevel: 0,
          gender: 'female',
          isPregnant: true,
        ),
        equals(2554),
      );
    });

    test('male 70 kg active very_hot → 4459 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
          weightKg: 70,
          activityLevel: 3,
          climateType: 'very_hot',
        ),
        equals(4459),
      );
    });

    test('female 50 kg sedentary cold → floored at 1500 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
          weightKg: 50,
          activityLevel: 0,
          gender: 'female',
          climateType: 'cold',
        ),
        equals(1500),
      );
    });
  });
}
