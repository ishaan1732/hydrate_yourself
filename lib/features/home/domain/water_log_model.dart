import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:hydrate_yourself/database/app_database.dart';

import '../../../database/tables/drink_types_table.dart';
import '../../../database/tables/water_logs_table.dart';
import 'drink_type_model.dart';

part 'water_log_model.freezed.dart';

@freezed
class WaterLogModel with _$WaterLogModel {
  const factory WaterLogModel({
    required int id,
    required DateTime loggedAt,
    required double amountMl,
    required DrinkTypeModel drinkType,
    String? note,
  }) = _WaterLogModel;

  factory WaterLogModel.fromDrift(
    WaterLogsData log,
    DrinkTypesData drinkType,
  ) =>
      WaterLogModel(
        id: log.id,
        loggedAt: log.loggedAt,
        amountMl: log.amountMl,
        drinkType: DrinkTypeModel.fromDrift(drinkType),
        note: log.note,
      );
}
