extension HydrationExtensions on double {
  double get mlToOz => double.parse((this * 0.033814).toStringAsFixed(1));
  double get ozToMl => this / 0.033814;

  String toHydrationString(String unit) {
    if (unit == 'oz') return '${mlToOz.toStringAsFixed(1)}oz';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}L';
    return '${round()}ml';
  }

  // Weight conversions
  double get kgToLbs => this * 2.20462;
  double get lbsToKg => this / 2.20462;

  String toWeightString(String weightUnit) {
    if (weightUnit == 'lbs') return '${kgToLbs.toStringAsFixed(1)} lbs';
    return '${toStringAsFixed(1)} kg';
  }
}
