class DailyChartPoint {
  const DailyChartPoint({
    required this.date,
    required this.totalMl,
    required this.goalMl,
  });

  final DateTime date;
  final double totalMl;
  final int goalMl;
}

class AnalyticsSummary {
  const AnalyticsSummary({
    required this.averageDailyMl,
    required this.bestDayMl,
    required this.daysGoalMet,
    required this.totalMl30Days,
    required this.goalMl,
    required this.drinkTypeTotals,
    required this.drinkTypeColors,
    required this.dailyChartPoints,
  });

  final double averageDailyMl;
  final double bestDayMl;
  final int daysGoalMet;
  final double totalMl30Days;
  final int goalMl;
  final Map<String, double> drinkTypeTotals;
  final Map<String, String> drinkTypeColors;
  final List<DailyChartPoint> dailyChartPoints;

  factory AnalyticsSummary.empty() => const AnalyticsSummary(
        averageDailyMl: 0.0,
        bestDayMl: 0.0,
        daysGoalMet: 0,
        totalMl30Days: 0.0,
        goalMl: 2500,
        drinkTypeTotals: {},
        drinkTypeColors: {},
        dailyChartPoints: [],
      );
}
