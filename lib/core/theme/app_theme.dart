import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _build(Brightness.light);
  static ThemeData get darkTheme => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );
    final base = ThemeData(brightness: brightness);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: base.textTheme.apply(fontFamily: 'Nunito'),
    );
  }
}
