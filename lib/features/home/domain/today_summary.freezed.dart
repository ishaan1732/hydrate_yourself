// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TodaySummary {
  double get totalMl => throw _privateConstructorUsedError;
  int get goalMl => throw _privateConstructorUsedError;
  List<WaterLogModel> get logs => throw _privateConstructorUsedError;

  /// Create a copy of TodaySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodaySummaryCopyWith<TodaySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodaySummaryCopyWith<$Res> {
  factory $TodaySummaryCopyWith(
    TodaySummary value,
    $Res Function(TodaySummary) then,
  ) = _$TodaySummaryCopyWithImpl<$Res, TodaySummary>;
  @useResult
  $Res call({double totalMl, int goalMl, List<WaterLogModel> logs});
}

/// @nodoc
class _$TodaySummaryCopyWithImpl<$Res, $Val extends TodaySummary>
    implements $TodaySummaryCopyWith<$Res> {
  _$TodaySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodaySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMl = null,
    Object? goalMl = null,
    Object? logs = null,
  }) {
    return _then(
      _value.copyWith(
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
abstract class _$$TodaySummaryImplCopyWith<$Res>
    implements $TodaySummaryCopyWith<$Res> {
  factory _$$TodaySummaryImplCopyWith(
    _$TodaySummaryImpl value,
    $Res Function(_$TodaySummaryImpl) then,
  ) = __$$TodaySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double totalMl, int goalMl, List<WaterLogModel> logs});
}

/// @nodoc
class __$$TodaySummaryImplCopyWithImpl<$Res>
    extends _$TodaySummaryCopyWithImpl<$Res, _$TodaySummaryImpl>
    implements _$$TodaySummaryImplCopyWith<$Res> {
  __$$TodaySummaryImplCopyWithImpl(
    _$TodaySummaryImpl _value,
    $Res Function(_$TodaySummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TodaySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMl = null,
    Object? goalMl = null,
    Object? logs = null,
  }) {
    return _then(
      _$TodaySummaryImpl(
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

class _$TodaySummaryImpl implements _TodaySummary {
  const _$TodaySummaryImpl({
    required this.totalMl,
    required this.goalMl,
    required final List<WaterLogModel> logs,
  }) : _logs = logs;

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
    return 'TodaySummary(totalMl: $totalMl, goalMl: $goalMl, logs: $logs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodaySummaryImpl &&
            (identical(other.totalMl, totalMl) || other.totalMl == totalMl) &&
            (identical(other.goalMl, goalMl) || other.goalMl == goalMl) &&
            const DeepCollectionEquality().equals(other._logs, _logs));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalMl,
    goalMl,
    const DeepCollectionEquality().hash(_logs),
  );

  /// Create a copy of TodaySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodaySummaryImplCopyWith<_$TodaySummaryImpl> get copyWith =>
      __$$TodaySummaryImplCopyWithImpl<_$TodaySummaryImpl>(this, _$identity);
}

abstract class _TodaySummary implements TodaySummary {
  const factory _TodaySummary({
    required final double totalMl,
    required final int goalMl,
    required final List<WaterLogModel> logs,
  }) = _$TodaySummaryImpl;

  @override
  double get totalMl;
  @override
  int get goalMl;
  @override
  List<WaterLogModel> get logs;

  /// Create a copy of TodaySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodaySummaryImplCopyWith<_$TodaySummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
