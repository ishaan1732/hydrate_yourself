enum ClimateType {
  cold('cold'),
  moderate('moderate'),
  hot('hot'),
  veryHot('very_hot');

  const ClimateType(this.rawValue);
  final String rawValue;

  static ClimateType fromRaw(String v) => ClimateType.values.firstWhere(
        (e) => e.rawValue == v,
        orElse: () => ClimateType.moderate,
      );

  String get label => switch (this) {
        ClimateType.cold => 'Cold',
        ClimateType.moderate => 'Moderate',
        ClimateType.hot => 'Hot',
        ClimateType.veryHot => 'Very Hot',
      };

  String get emoji => switch (this) {
        ClimateType.cold => '🥶',
        ClimateType.moderate => '🌤️',
        ClimateType.hot => '☀️',
        ClimateType.veryHot => '🔥',
      };
}

enum ActivityLevel {
  sedentary(0),
  light(1),
  moderate(2),
  active(3);

  const ActivityLevel(this.rawValue);
  final int rawValue;

  static ActivityLevel fromRaw(int v) => ActivityLevel.values.firstWhere(
        (e) => e.rawValue == v,
        orElse: () => ActivityLevel.sedentary,
      );

  String get label => switch (this) {
        ActivityLevel.sedentary => 'Sedentary',
        ActivityLevel.light => 'Light',
        ActivityLevel.moderate => 'Moderate',
        ActivityLevel.active => 'Active',
      };

  String get emoji => switch (this) {
        ActivityLevel.sedentary => '🛋️',
        ActivityLevel.light => '🚶',
        ActivityLevel.moderate => '🏃',
        ActivityLevel.active => '⚡',
      };
}

class TodayOverride {
  const TodayOverride({this.climate, this.activity, required this.date});

  final ClimateType? climate;
  final ActivityLevel? activity;
  final String date;

  bool get hasAny => climate != null || activity != null;
}
