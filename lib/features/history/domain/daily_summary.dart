import 'package:freezed_annotation/freezed_annotation.dart';

import '../../home/domain/water_log_model.dart';

part 'daily_summary.freezed.dart';

@freezed
class DailySummary with _$DailySummary {
  const factory DailySummary({
    required DateTime date,
    required double totalMl,
    required int goalMl,
    required List<WaterLogModel> logs,
  }) = _DailySummary;
}

extension DailySummaryX on DailySummary {
  double get percentage => (totalMl / goalMl).clamp(0.0, 1.0);
  bool get goalAchieved => totalMl >= goalMl;
}
