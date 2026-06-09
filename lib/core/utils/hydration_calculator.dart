class HydrationCalculator {
  HydrationCalculator._();

  static int calculateDailyGoalMl({
    required double weightKg,
    required int activityLevel,
    String gender = 'male',
    bool isPregnant = false,
    String climateType = 'moderate',
  }) {
    double base = weightKg * 35.0;

    final double activityMultiplier;
    switch (activityLevel) {
      case 0:
        activityMultiplier = 1.0;
        break;
      case 1:
        activityMultiplier = 1.1;
        break;
      case 2:
        activityMultiplier = 1.2;
        break;
      case 3:
        activityMultiplier = 1.4;
        break;
      default:
        activityMultiplier = 1.0;
    }
    base *= activityMultiplier;

    if (gender == 'female') {
      base *= 0.92;
    }

    if (isPregnant && gender == 'female') {
      base += 300;
    }

    final double climateMultiplier;
    switch (climateType) {
      case 'cold':
        climateMultiplier = 0.9;
        break;
      case 'moderate':
        climateMultiplier = 1.0;
        break;
      case 'hot':
        climateMultiplier = 1.15;
        break;
      case 'very_hot':
        climateMultiplier = 1.30;
        break;
      default:
        climateMultiplier = 1.0;
    }
    base *= climateMultiplier;

    return base.round().clamp(1500, 4500);
  }

  static String genderLabel(String gender) {
    switch (gender) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      case 'other':
        return 'Other';
      default:
        return 'Male';
    }
  }

  static String climateLabel(String climate) {
    switch (climate) {
      case 'cold':
        return 'Cold';
      case 'moderate':
        return 'Moderate';
      case 'hot':
        return 'Hot';
      case 'very_hot':
        return 'Very Hot';
      default:
        return 'Moderate';
    }
  }

  static String climateEmoji(String climate) {
    switch (climate) {
      case 'cold':
        return '🥶';
      case 'moderate':
        return '🌤️';
      case 'hot':
        return '☀️';
      case 'very_hot':
        return '🔥';
      default:
        return '🌤️';
    }
  }
}
