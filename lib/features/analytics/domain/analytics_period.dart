enum AnalyticsPeriod { week, month, threeMonths, year, allTime }

extension AnalyticsPeriodExtension on AnalyticsPeriod {
  String get label {
    switch (this) {
      case AnalyticsPeriod.week:        return '7 days';
      case AnalyticsPeriod.month:       return '30 days';
      case AnalyticsPeriod.threeMonths: return '3 months';
      case AnalyticsPeriod.year:        return '1 year';
      case AnalyticsPeriod.allTime:     return 'All time';
    }
  }

  DateTime get startDate {
    final now = DateTime.now();
    switch (this) {
      case AnalyticsPeriod.week:
        return now.subtract(const Duration(days: 6));
      case AnalyticsPeriod.month:
        return now.subtract(const Duration(days: 29));
      case AnalyticsPeriod.threeMonths:
        return now.subtract(const Duration(days: 89));
      case AnalyticsPeriod.year:
        return now.subtract(const Duration(days: 364));
      case AnalyticsPeriod.allTime:
        return DateTime(2020, 1, 1);
    }
  }
}
