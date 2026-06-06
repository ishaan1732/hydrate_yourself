// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DrinkTypeModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get hydrationCoefficient => throw _privateConstructorUsedError;
  String get iconName => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError;
  bool get isCustom => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  /// Create a copy of DrinkTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DrinkTypeModelCopyWith<DrinkTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DrinkTypeModelCopyWith<$Res> {
  factory $DrinkTypeModelCopyWith(
    DrinkTypeModel value,
    $Res Function(DrinkTypeModel) then,
  ) = _$DrinkTypeModelCopyWithImpl<$Res, DrinkTypeModel>;
  @useResult
  $Res call({
    int id,
    String name,
    double hydrationCoefficient,
    String iconName,
    String colorHex,
    bool isCustom,
    int sortOrder,
  });
}

/// @nodoc
class _$DrinkTypeModelCopyWithImpl<$Res, $Val extends DrinkTypeModel>
    implements $DrinkTypeModelCopyWith<$Res> {
  _$DrinkTypeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DrinkTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? hydrationCoefficient = null,
    Object? iconName = null,
    Object? colorHex = null,
    Object? isCustom = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            hydrationCoefficient: null == hydrationCoefficient
                ? _value.hydrationCoefficient
                : hydrationCoefficient // ignore: cast_nullable_to_non_nullable
                      as double,
            iconName: null == iconName
                ? _value.iconName
                : iconName // ignore: cast_nullable_to_non_nullable
                      as String,
            colorHex: null == colorHex
                ? _value.colorHex
                : colorHex // ignore: cast_nullable_to_non_nullable
                      as String,
            isCustom: null == isCustom
                ? _value.isCustom
                : isCustom // ignore: cast_nullable_to_non_nullable
                      as bool,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DrinkTypeModelImplCopyWith<$Res>
    implements $DrinkTypeModelCopyWith<$Res> {
  factory _$$DrinkTypeModelImplCopyWith(
    _$DrinkTypeModelImpl value,
    $Res Function(_$DrinkTypeModelImpl) then,
  ) = __$$DrinkTypeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    double hydrationCoefficient,
    String iconName,
    String colorHex,
    bool isCustom,
    int sortOrder,
  });
}

/// @nodoc
class __$$DrinkTypeModelImplCopyWithImpl<$Res>
    extends _$DrinkTypeModelCopyWithImpl<$Res, _$DrinkTypeModelImpl>
    implements _$$DrinkTypeModelImplCopyWith<$Res> {
  __$$DrinkTypeModelImplCopyWithImpl(
    _$DrinkTypeModelImpl _value,
    $Res Function(_$DrinkTypeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DrinkTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? hydrationCoefficient = null,
    Object? iconName = null,
    Object? colorHex = null,
    Object? isCustom = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _$DrinkTypeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        hydrationCoefficient: null == hydrationCoefficient
            ? _value.hydrationCoefficient
            : hydrationCoefficient // ignore: cast_nullable_to_non_nullable
                  as double,
        iconName: null == iconName
            ? _value.iconName
            : iconName // ignore: cast_nullable_to_non_nullable
                  as String,
        colorHex: null == colorHex
            ? _value.colorHex
            : colorHex // ignore: cast_nullable_to_non_nullable
                  as String,
        isCustom: null == isCustom
            ? _value.isCustom
            : isCustom // ignore: cast_nullable_to_non_nullable
                  as bool,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$DrinkTypeModelImpl implements _DrinkTypeModel {
  const _$DrinkTypeModelImpl({
    required this.id,
    required this.name,
    required this.hydrationCoefficient,
    required this.iconName,
    required this.colorHex,
    required this.isCustom,
    required this.sortOrder,
  });

  @override
  final int id;
  @override
  final String name;
  @override
  final double hydrationCoefficient;
  @override
  final String iconName;
  @override
  final String colorHex;
  @override
  final bool isCustom;
  @override
  final int sortOrder;

  @override
  String toString() {
    return 'DrinkTypeModel(id: $id, name: $name, hydrationCoefficient: $hydrationCoefficient, iconName: $iconName, colorHex: $colorHex, isCustom: $isCustom, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DrinkTypeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.hydrationCoefficient, hydrationCoefficient) ||
                other.hydrationCoefficient == hydrationCoefficient) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.isCustom, isCustom) ||
                other.isCustom == isCustom) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    hydrationCoefficient,
    iconName,
    colorHex,
    isCustom,
    sortOrder,
  );

  /// Create a copy of DrinkTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DrinkTypeModelImplCopyWith<_$DrinkTypeModelImpl> get copyWith =>
      __$$DrinkTypeModelImplCopyWithImpl<_$DrinkTypeModelImpl>(
        this,
        _$identity,
      );
}

abstract class _DrinkTypeModel implements DrinkTypeModel {
  const factory _DrinkTypeModel({
    required final int id,
    required final String name,
    required final double hydrationCoefficient,
    required final String iconName,
    required final String colorHex,
    required final bool isCustom,
    required final int sortOrder,
  }) = _$DrinkTypeModelImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  double get hydrationCoefficient;
  @override
  String get iconName;
  @override
  String get colorHex;
  @override
  bool get isCustom;
  @override
  int get sortOrder;

  /// Create a copy of DrinkTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DrinkTypeModelImplCopyWith<_$DrinkTypeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
