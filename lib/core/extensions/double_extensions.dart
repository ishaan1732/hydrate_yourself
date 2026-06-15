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

// Adaptive formatter for the analytics Total Intake stat card and tooltip.
// Under 10,000 ml → comma-formatted ml ("8,400 ml").
// 10,000 ml and above → litres with 1 decimal ("22.4 L", "1,642.5 L").
String formatAnalyticsTotal(int totalMl, bool isOzMode) {
  if (isOzMode) {
    final oz = totalMl / 29.5735;
    return '${oz.toStringAsFixed(1)} oz';
  }
  if (totalMl < 10000) {
    return totalMl.toDouble().toMlAmountString();
  }
  final litres = totalMl / 1000.0;
  if (litres >= 1000) {
    final formatted = litres.toStringAsFixed(1);
    final dotIndex = formatted.indexOf('.');
    final intPart = int.parse(formatted.substring(0, dotIndex));
    final decPart = formatted.substring(dotIndex + 1);
    return '${_commaInt(intPart)}.$decPart L';
  }
  return '${litres.toStringAsFixed(1)} L';
}

String _commaInt(int value) {
  var str = value.toString();
  final parts = <String>[];
  while (str.length > 3) {
    parts.insert(0, str.substring(str.length - 3));
    str = str.substring(0, str.length - 3);
  }
  if (str.isNotEmpty) parts.insert(0, str);
  return parts.join(',');
}
