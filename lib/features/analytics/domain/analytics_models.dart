class ChartBar {
  const ChartBar({required this.label, required this.totalMl});
  final String label;
  final double totalMl;
}

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
    required this.daysInPeriod,
    required this.totalMl,
    required this.goalMl,
    required this.drinkTypeTotals,
    required this.drinkTypeColors,
    required this.chartBars,
  });

  final double averageDailyMl;
  final double bestDayMl;
  final int daysGoalMet;
  final int daysInPeriod;
  final double totalMl;
  final int goalMl;
  final Map<String, double> drinkTypeTotals;
  final Map<String, String> drinkTypeColors;
  final List<ChartBar> chartBars;

  factory AnalyticsSummary.empty() => const AnalyticsSummary(
        averageDailyMl: 0.0,
        bestDayMl: 0.0,
        daysGoalMet: 0,
        daysInPeriod: 30,
        totalMl: 0.0,
        goalMl: 2500,
        drinkTypeTotals: {},
        drinkTypeColors: {},
        chartBars: [],
      );
}
