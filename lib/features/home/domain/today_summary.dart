import 'package:freezed_annotation/freezed_annotation.dart';

import 'water_log_model.dart';

part 'today_summary.freezed.dart';

@freezed
class TodaySummary with _$TodaySummary {
  const factory TodaySummary({
    required double totalMl,
    required int goalMl,
    required List<WaterLogModel> logs,
  }) = _TodaySummary;

  factory TodaySummary.empty(int goalMl) => TodaySummary(
        totalMl: 0.0,
        goalMl: goalMl,
        logs: const [],
      );
}

extension TodaySummaryX on TodaySummary {
  double get percentage => (totalMl / goalMl).clamp(0.0, 1.0);
  bool get isGoalAchieved => totalMl >= goalMl;
  double get remainingMl => (goalMl - totalMl).clamp(0, goalMl).toDouble();
  String get progressLabel {
    final totalL = (totalMl / 1000).toStringAsFixed(1);
    final goalL = (goalMl / 1000).toStringAsFixed(1);
    return '${totalL}L of ${goalL}L';
  }
}
