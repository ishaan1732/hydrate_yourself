import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:hydrate_yourself/database/app_database.dart';

part 'drink_type_model.freezed.dart';

@freezed
class DrinkTypeModel with _$DrinkTypeModel {
  const factory DrinkTypeModel({
    required int id,
    required String name,
    required double hydrationCoefficient,
    required String iconName,
    required String colorHex,
    required bool isCustom,
    required int sortOrder,
  }) = _DrinkTypeModel;

  factory DrinkTypeModel.fromDrift(DrinkTypesData data) => DrinkTypeModel(
        id: data.id,
        name: data.name,
        hydrationCoefficient: data.hydrationCoefficient,
        iconName: data.iconName,
        colorHex: data.colorHex,
        isCustom: data.isCustom,
        sortOrder: data.sortOrder,
      );
}

extension DrinkTypeModelX on DrinkTypeModel {
  Color get color {
    final hex = colorHex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
