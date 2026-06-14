class ChartDataPoint {
  const ChartDataPoint({
    required this.x,
    required this.y,
    required this.label,
  });

  final double x;
  final double y;     // ml (daily) or average daily ml (weekly/monthly)
  final String label; // x-axis label; empty string = no label shown
}

class AnalyticsSummary {
  const AnalyticsSummary({
    required this.averageDailyMl,
    required this.bestDayMl,
    required this.daysGoalMet,
    required this.daysInPeriod,
    required this.totalMl,
    required this.goalMl,
    required this.drinkTypeTotals,
    required this.drinkTypeColors,
    required this.chartPoints,
  });

  final double averageDailyMl;
  final double bestDayMl;
  final int daysGoalMet;
  final int daysInPeriod;
  final double totalMl;
  final int goalMl;
  final Map<String, double> drinkTypeTotals;
  final Map<String, String> drinkTypeColors;
  final List<ChartDataPoint> chartPoints;

  factory AnalyticsSummary.empty() => const AnalyticsSummary(
        averageDailyMl: 0.0,
        bestDayMl: 0.0,
        daysGoalMet: 0,
        daysInPeriod: 30,
        totalMl: 0.0,
        goalMl: 2500,
        drinkTypeTotals: {},
        drinkTypeColors: {},
        chartPoints: [],
      );
}
