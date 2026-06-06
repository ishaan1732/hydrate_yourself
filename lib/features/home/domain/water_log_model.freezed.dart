// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WaterLogModel {
  int get id => throw _privateConstructorUsedError;
  DateTime get loggedAt => throw _privateConstructorUsedError;
  double get amountMl => throw _privateConstructorUsedError;
  DrinkTypeModel get drinkType => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Create a copy of WaterLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaterLogModelCopyWith<WaterLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaterLogModelCopyWith<$Res> {
  factory $WaterLogModelCopyWith(
    WaterLogModel value,
    $Res Function(WaterLogModel) then,
  ) = _$WaterLogModelCopyWithImpl<$Res, WaterLogModel>;
  @useResult
  $Res call({
    int id,
    DateTime loggedAt,
    double amountMl,
    DrinkTypeModel drinkType,
    String? note,
  });

  $DrinkTypeModelCopyWith<$Res> get drinkType;
}

/// @nodoc
class _$WaterLogModelCopyWithImpl<$Res, $Val extends WaterLogModel>
    implements $WaterLogModelCopyWith<$Res> {
  _$WaterLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaterLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? loggedAt = null,
    Object? amountMl = null,
    Object? drinkType = null,
    Object? note = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            loggedAt: null == loggedAt
                ? _value.loggedAt
                : loggedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            amountMl: null == amountMl
                ? _value.amountMl
                : amountMl // ignore: cast_nullable_to_non_nullable
                      as double,
            drinkType: null == drinkType
                ? _value.drinkType
                : drinkType // ignore: cast_nullable_to_non_nullable
                      as DrinkTypeModel,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of WaterLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DrinkTypeModelCopyWith<$Res> get drinkType {
    return $DrinkTypeModelCopyWith<$Res>(_value.drinkType, (value) {
      return _then(_value.copyWith(drinkType: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WaterLogModelImplCopyWith<$Res>
    implements $WaterLogModelCopyWith<$Res> {
  factory _$$WaterLogModelImplCopyWith(
    _$WaterLogModelImpl value,
    $Res Function(_$WaterLogModelImpl) then,
  ) = __$$WaterLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    DateTime loggedAt,
    double amountMl,
    DrinkTypeModel drinkType,
    String? note,
  });

  @override
  $DrinkTypeModelCopyWith<$Res> get drinkType;
}

/// @nodoc
class __$$WaterLogModelImplCopyWithImpl<$Res>
    extends _$WaterLogModelCopyWithImpl<$Res, _$WaterLogModelImpl>
    implements _$$WaterLogModelImplCopyWith<$Res> {
  __$$WaterLogModelImplCopyWithImpl(
    _$WaterLogModelImpl _value,
    $Res Function(_$WaterLogModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaterLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? loggedAt = null,
    Object? amountMl = null,
    Object? drinkType = null,
    Object? note = freezed,
  }) {
    return _then(
      _$WaterLogModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        loggedAt: null == loggedAt
            ? _value.loggedAt
            : loggedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        amountMl: null == amountMl
            ? _value.amountMl
            : amountMl // ignore: cast_nullable_to_non_nullable
                  as double,
        drinkType: null == drinkType
            ? _value.drinkType
            : drinkType // ignore: cast_nullable_to_non_nullable
                  as DrinkTypeModel,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$WaterLogModelImpl implements _WaterLogModel {
  const _$WaterLogModelImpl({
    required this.id,
    required this.loggedAt,
    required this.amountMl,
    required this.drinkType,
    this.note,
  });

  @override
  final int id;
  @override
  final DateTime loggedAt;
  @override
  final double amountMl;
  @override
  final DrinkTypeModel drinkType;
  @override
  final String? note;

  @override
  String toString() {
    return 'WaterLogModel(id: $id, loggedAt: $loggedAt, amountMl: $amountMl, drinkType: $drinkType, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaterLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.loggedAt, loggedAt) ||
                other.loggedAt == loggedAt) &&
            (identical(other.amountMl, amountMl) ||
                other.amountMl == amountMl) &&
            (identical(other.drinkType, drinkType) ||
                other.drinkType == drinkType) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, loggedAt, amountMl, drinkType, note);

  /// Create a copy of WaterLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaterLogModelImplCopyWith<_$WaterLogModelImpl> get copyWith =>
      __$$WaterLogModelImplCopyWithImpl<_$WaterLogModelImpl>(this, _$identity);
}

abstract class _WaterLogModel implements WaterLogModel {
  const factory _WaterLogModel({
    required final int id,
    required final DateTime loggedAt,
    required final double amountMl,
    required final DrinkTypeModel drinkType,
    final String? note,
  }) = _$WaterLogModelImpl;

  @override
  int get id;
  @override
  DateTime get loggedAt;
  @override
  double get amountMl;
  @override
  DrinkTypeModel get drinkType;
  @override
  String? get note;

  /// Create a copy of WaterLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaterLogModelImplCopyWith<_$WaterLogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
