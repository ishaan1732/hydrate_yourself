// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DailySummary {
  DateTime get date => throw _privateConstructorUsedError;
  double get totalMl => throw _privateConstructorUsedError;
  int get goalMl => throw _privateConstructorUsedError;
  List<WaterLogModel> get logs => throw _privateConstructorUsedError;

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailySummaryCopyWith<DailySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailySummaryCopyWith<$Res> {
  factory $DailySummaryCopyWith(
    DailySummary value,
    $Res Function(DailySummary) then,
  ) = _$DailySummaryCopyWithImpl<$Res, DailySummary>;
  @useResult
  $Res call({
    DateTime date,
    double totalMl,
    int goalMl,
    List<WaterLogModel> logs,
  });
}

/// @nodoc
class _$DailySummaryCopyWithImpl<$Res, $Val extends DailySummary>
    implements $DailySummaryCopyWith<$Res> {
  _$DailySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalMl = null,
    Object? goalMl = null,
    Object? logs = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalMl: null == totalMl
                ? _value.totalMl
                : totalMl // ignore: cast_nullable_to_non_nullable
                      as double,
            goalMl: null == goalMl
                ? _value.goalMl
                : goalMl // ignore: cast_nullable_to_non_nullable
                      as int,
            logs: null == logs
                ? _value.logs
                : logs // ignore: cast_nullable_to_non_nullable
                      as List<WaterLogModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailySummaryImplCopyWith<$Res>
    implements $DailySummaryCopyWith<$Res> {
  factory _$$DailySummaryImplCopyWith(
    _$DailySummaryImpl value,
    $Res Function(_$DailySummaryImpl) then,
  ) = __$$DailySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime date,
    double totalMl,
    int goalMl,
    List<WaterLogModel> logs,
  });
}

/// @nodoc
class __$$DailySummaryImplCopyWithImpl<$Res>
    extends _$DailySummaryCopyWithImpl<$Res, _$DailySummaryImpl>
    implements _$$DailySummaryImplCopyWith<$Res> {
  __$$DailySummaryImplCopyWithImpl(
    _$DailySummaryImpl _value,
    $Res Function(_$DailySummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalMl = null,
    Object? goalMl = null,
    Object? logs = null,
  }) {
    return _then(
      _$DailySummaryImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalMl: null == totalMl
            ? _value.totalMl
            : totalMl // ignore: cast_nullable_to_non_nullable
                  as double,
        goalMl: null == goalMl
            ? _value.goalMl
            : goalMl // ignore: cast_nullable_to_non_nullable
                  as int,
        logs: null == logs
            ? _value._logs
            : logs // ignore: cast_nullable_to_non_nullable
                  as List<WaterLogModel>,
      ),
    );
  }
}

/// @nodoc

class _$DailySummaryImpl implements _DailySummary {
  const _$DailySummaryImpl({
    required this.date,
    required this.totalMl,
    required this.goalMl,
    required final List<WaterLogModel> logs,
  }) : _logs = logs;

  @override
  final DateTime date;
  @override
  final double totalMl;
  @override
  final int goalMl;
  final List<WaterLogModel> _logs;
  @override
  List<WaterLogModel> get logs {
    if (_logs is EqualUnmodifiableListView) return _logs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_logs);
  }

  @override
  String toString() {
    return 'DailySummary(date: $date, totalMl: $totalMl, goalMl: $goalMl, logs: $logs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailySummaryImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalMl, totalMl) || other.totalMl == totalMl) &&
            (identical(other.goalMl, goalMl) || other.goalMl == goalMl) &&
            const DeepCollectionEquality().equals(other._logs, _logs));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    totalMl,
    goalMl,
    const DeepCollectionEquality().hash(_logs),
  );

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailySummaryImplCopyWith<_$DailySummaryImpl> get copyWith =>
      __$$DailySummaryImplCopyWithImpl<_$DailySummaryImpl>(this, _$identity);
}

abstract class _DailySummary implements DailySummary {
  const factory _DailySummary({
    required final DateTime date,
    required final double totalMl,
    required final int goalMl,
    required final List<WaterLogModel> logs,
  }) = _$DailySummaryImpl;

  @override
  DateTime get date;
  @override
  double get totalMl;
  @override
  int get goalMl;
  @override
  List<WaterLogModel> get logs;

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailySummaryImplCopyWith<_$DailySummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
