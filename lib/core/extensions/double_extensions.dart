extension HydrationExtensions on double {
  double get mlToOz => double.parse((this * 0.033814).toStringAsFixed(1));
  double get ozToMl => this / 0.033814;

  String toHydrationString(String unit) {
    if (unit == 'oz') return '${mlToOz.toStringAsFixed(1)}oz';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}L';
    return '${round()}ml';
  }

  // Whole oz — for goals and running totals
  String toWholeOzString() {
    final oz = this * 0.033814;
    return '${oz.round()} oz';
  }

  // 0.5 oz precision — for cup sizes and logged amounts
  String toHalfOzString() {
    final oz = this * 0.033814;
    final rounded = (oz * 2).round() / 2.0;
    if (rounded % 1 == 0) {
      return '${rounded.toInt()} oz';
    }
    return '${rounded.toStringAsFixed(1)} oz';
  }

  // Always comma-formatted ml — never converts to L
  String toMlAmountString() {
    var str = round().toString();
    final parts = <String>[];
    while (str.length > 3) {
      parts.insert(0, str.substring(str.length - 3));
      str = str.substring(0, str.length - 3);
    }
    if (str.isNotEmpty) parts.insert(0, str);
    return '${parts.join(',')} ml';
  }

  // Weight conversions
  double get kgToLbs => this * 2.20462;
  double get lbsToKg => this / 2.20462;

  String toWeightString(String weightUnit) {
    if (weightUnit == 'lbs') return '${kgToLbs.toStringAsFixed(1)} lbs';
    return '${toStringAsFixed(1)} kg';
  }
}
