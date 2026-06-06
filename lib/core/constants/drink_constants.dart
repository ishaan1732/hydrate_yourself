import 'package:flutter/material.dart';

class DrinkConstants {
  DrinkConstants._();

  // Hydration coefficients
  static const double coeffWater = 1.0;
  static const double coeffCoffee = 0.5;
  static const double coeffTea = 0.7;
  static const double coeffJuice = 0.8;
  static const double coeffSoda = 0.7;

  // Icon name strings (match DB seed values)
  static const String iconWater = 'water_drop';
  static const String iconCoffee = 'coffee';
  static const String iconTea = 'emoji_food_beverage';
  static const String iconJuice = 'local_drink';
  static const String iconSoda = 'sports_bar';

  static IconData getIconData(String iconName) {
    return switch (iconName) {
      'water_drop' => Icons.water_drop,
      'coffee' => Icons.coffee,
      'emoji_food_beverage' => Icons.emoji_food_beverage,
      'local_drink' => Icons.local_drink,
      'sports_bar' => Icons.sports_bar,
      _ => Icons.local_drink,
    };
  }
}
