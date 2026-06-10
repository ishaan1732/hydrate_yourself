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

    test('active 90 kg → 4400 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
            weightKg: 90, activityLevel: 3),
        equals(4400),
      );
    });

    test('light activity 50 kg → 1950 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
            weightKg: 50, activityLevel: 1),
        equals(1950),
      );
    });

    test('moderate 40 kg → 1700 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
            weightKg: 40, activityLevel: 2),
        equals(1700),
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

    test('female 70 kg sedentary moderate → 2250 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
          weightKg: 70,
          activityLevel: 0,
          gender: 'female',
        ),
        equals(2250),
      );
    });

    test('female pregnant 70 kg sedentary moderate → 2500 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
          weightKg: 70,
          activityLevel: 0,
          gender: 'female',
          isPregnant: true,
          climateType: 'moderate',
        ),
        equals(2500),
      );
    });

    test('female pregnant 90 kg sedentary moderate → 3200 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
          weightKg: 90,
          activityLevel: 0,
          gender: 'female',
          isPregnant: true,
          climateType: 'moderate',
        ),
        equals(3200),
      );
    });

    test('female pregnant 50 kg sedentary moderate → 1800 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
          weightKg: 50,
          activityLevel: 0,
          gender: 'female',
          isPregnant: true,
          climateType: 'moderate',
        ),
        equals(1800),
      );
    });

    test('male 70 kg active very_hot → 4450 ml', () {
      expect(
        HydrationCalculator.calculateDailyGoalMl(
          weightKg: 70,
          activityLevel: 3,
          climateType: 'very_hot',
        ),
        equals(4450),
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
