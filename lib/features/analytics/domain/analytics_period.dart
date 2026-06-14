enum AnalyticsPeriod { week, month, threeMonths, year, allTime }

enum DataGranularity { daily, weekly, monthly }

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
        return now.subtract(const Duration(days: 7));
      case AnalyticsPeriod.month:
        return now.subtract(const Duration(days: 30));
      case AnalyticsPeriod.threeMonths:
        return now.subtract(const Duration(days: 90));
      case AnalyticsPeriod.year:
        return now.subtract(const Duration(days: 365));
      case AnalyticsPeriod.allTime:
        return DateTime(2020, 1, 1);
    }
  }

  DataGranularity get granularity {
    switch (this) {
      case AnalyticsPeriod.week:        return DataGranularity.daily;
      case AnalyticsPeriod.month:       return DataGranularity.daily;
      case AnalyticsPeriod.threeMonths: return DataGranularity.weekly;
      case AnalyticsPeriod.year:        return DataGranularity.monthly;
      case AnalyticsPeriod.allTime:     return DataGranularity.monthly;
    }
  }
}
