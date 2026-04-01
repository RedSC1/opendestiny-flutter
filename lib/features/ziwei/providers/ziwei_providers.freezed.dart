// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ziwei_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ZiweiUIState {
  ZiWeiPlate get plate =>
      throw _privateConstructorUsedError; // 当前最终渲染盘 (本命 or 包含流星的盘)
  ZiweiDate get date => throw _privateConstructorUsedError; // 基础日期
  ZiweiRuleset get ruleset => throw _privateConstructorUsedError; // 基础规则
  TimelineManifest get manifest =>
      throw _privateConstructorUsedError; // 当前流运清单快照
  Decade? get currentDecade => throw _privateConstructorUsedError; // 游标：大限 / 童限
  FlowYear? get currentYear => throw _privateConstructorUsedError; // 游标：流年
  FlowMonth? get currentMonth => throw _privateConstructorUsedError; // 游标：流月
  bool? get currentMonthIsLeap =>
      throw _privateConstructorUsedError; // 游标：流月是否闰月
  FlowDay? get currentDay => throw _privateConstructorUsedError; // 游标：流日
  FlowHour? get currentHour => throw _privateConstructorUsedError; // 游标：流时
  int? get selectedPalaceIndex => throw _privateConstructorUsedError;

  /// Create a copy of ZiweiUIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ZiweiUIStateCopyWith<ZiweiUIState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZiweiUIStateCopyWith<$Res> {
  factory $ZiweiUIStateCopyWith(
    ZiweiUIState value,
    $Res Function(ZiweiUIState) then,
  ) = _$ZiweiUIStateCopyWithImpl<$Res, ZiweiUIState>;
  @useResult
  $Res call({
    ZiWeiPlate plate,
    ZiweiDate date,
    ZiweiRuleset ruleset,
    TimelineManifest manifest,
    Decade? currentDecade,
    FlowYear? currentYear,
    FlowMonth? currentMonth,
    bool? currentMonthIsLeap,
    FlowDay? currentDay,
    FlowHour? currentHour,
    int? selectedPalaceIndex,
  });
}

/// @nodoc
class _$ZiweiUIStateCopyWithImpl<$Res, $Val extends ZiweiUIState>
    implements $ZiweiUIStateCopyWith<$Res> {
  _$ZiweiUIStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ZiweiUIState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plate = null,
    Object? date = null,
    Object? ruleset = null,
    Object? manifest = null,
    Object? currentDecade = freezed,
    Object? currentYear = freezed,
    Object? currentMonth = freezed,
    Object? currentMonthIsLeap = freezed,
    Object? currentDay = freezed,
    Object? currentHour = freezed,
    Object? selectedPalaceIndex = freezed,
  }) {
    return _then(
      _value.copyWith(
            plate: null == plate
                ? _value.plate
                : plate // ignore: cast_nullable_to_non_nullable
                      as ZiWeiPlate,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as ZiweiDate,
            ruleset: null == ruleset
                ? _value.ruleset
                : ruleset // ignore: cast_nullable_to_non_nullable
                      as ZiweiRuleset,
            manifest: null == manifest
                ? _value.manifest
                : manifest // ignore: cast_nullable_to_non_nullable
                      as TimelineManifest,
            currentDecade: freezed == currentDecade
                ? _value.currentDecade
                : currentDecade // ignore: cast_nullable_to_non_nullable
                      as Decade?,
            currentYear: freezed == currentYear
                ? _value.currentYear
                : currentYear // ignore: cast_nullable_to_non_nullable
                      as FlowYear?,
            currentMonth: freezed == currentMonth
                ? _value.currentMonth
                : currentMonth // ignore: cast_nullable_to_non_nullable
                      as FlowMonth?,
            currentMonthIsLeap: freezed == currentMonthIsLeap
                ? _value.currentMonthIsLeap
                : currentMonthIsLeap // ignore: cast_nullable_to_non_nullable
                      as bool?,
            currentDay: freezed == currentDay
                ? _value.currentDay
                : currentDay // ignore: cast_nullable_to_non_nullable
                      as FlowDay?,
            currentHour: freezed == currentHour
                ? _value.currentHour
                : currentHour // ignore: cast_nullable_to_non_nullable
                      as FlowHour?,
            selectedPalaceIndex: freezed == selectedPalaceIndex
                ? _value.selectedPalaceIndex
                : selectedPalaceIndex // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ZiweiUIStateImplCopyWith<$Res>
    implements $ZiweiUIStateCopyWith<$Res> {
  factory _$$ZiweiUIStateImplCopyWith(
    _$ZiweiUIStateImpl value,
    $Res Function(_$ZiweiUIStateImpl) then,
  ) = __$$ZiweiUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ZiWeiPlate plate,
    ZiweiDate date,
    ZiweiRuleset ruleset,
    TimelineManifest manifest,
    Decade? currentDecade,
    FlowYear? currentYear,
    FlowMonth? currentMonth,
    bool? currentMonthIsLeap,
    FlowDay? currentDay,
    FlowHour? currentHour,
    int? selectedPalaceIndex,
  });
}

/// @nodoc
class __$$ZiweiUIStateImplCopyWithImpl<$Res>
    extends _$ZiweiUIStateCopyWithImpl<$Res, _$ZiweiUIStateImpl>
    implements _$$ZiweiUIStateImplCopyWith<$Res> {
  __$$ZiweiUIStateImplCopyWithImpl(
    _$ZiweiUIStateImpl _value,
    $Res Function(_$ZiweiUIStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ZiweiUIState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plate = null,
    Object? date = null,
    Object? ruleset = null,
    Object? manifest = null,
    Object? currentDecade = freezed,
    Object? currentYear = freezed,
    Object? currentMonth = freezed,
    Object? currentMonthIsLeap = freezed,
    Object? currentDay = freezed,
    Object? currentHour = freezed,
    Object? selectedPalaceIndex = freezed,
  }) {
    return _then(
      _$ZiweiUIStateImpl(
        plate: null == plate
            ? _value.plate
            : plate // ignore: cast_nullable_to_non_nullable
                  as ZiWeiPlate,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as ZiweiDate,
        ruleset: null == ruleset
            ? _value.ruleset
            : ruleset // ignore: cast_nullable_to_non_nullable
                  as ZiweiRuleset,
        manifest: null == manifest
            ? _value.manifest
            : manifest // ignore: cast_nullable_to_non_nullable
                  as TimelineManifest,
        currentDecade: freezed == currentDecade
            ? _value.currentDecade
            : currentDecade // ignore: cast_nullable_to_non_nullable
                  as Decade?,
        currentYear: freezed == currentYear
            ? _value.currentYear
            : currentYear // ignore: cast_nullable_to_non_nullable
                  as FlowYear?,
        currentMonth: freezed == currentMonth
            ? _value.currentMonth
            : currentMonth // ignore: cast_nullable_to_non_nullable
                  as FlowMonth?,
        currentMonthIsLeap: freezed == currentMonthIsLeap
            ? _value.currentMonthIsLeap
            : currentMonthIsLeap // ignore: cast_nullable_to_non_nullable
                  as bool?,
        currentDay: freezed == currentDay
            ? _value.currentDay
            : currentDay // ignore: cast_nullable_to_non_nullable
                  as FlowDay?,
        currentHour: freezed == currentHour
            ? _value.currentHour
            : currentHour // ignore: cast_nullable_to_non_nullable
                  as FlowHour?,
        selectedPalaceIndex: freezed == selectedPalaceIndex
            ? _value.selectedPalaceIndex
            : selectedPalaceIndex // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$ZiweiUIStateImpl implements _ZiweiUIState {
  const _$ZiweiUIStateImpl({
    required this.plate,
    required this.date,
    required this.ruleset,
    required this.manifest,
    this.currentDecade,
    this.currentYear,
    this.currentMonth,
    this.currentMonthIsLeap,
    this.currentDay,
    this.currentHour,
    this.selectedPalaceIndex,
  });

  @override
  final ZiWeiPlate plate;
  // 当前最终渲染盘 (本命 or 包含流星的盘)
  @override
  final ZiweiDate date;
  // 基础日期
  @override
  final ZiweiRuleset ruleset;
  // 基础规则
  @override
  final TimelineManifest manifest;
  // 当前流运清单快照
  @override
  final Decade? currentDecade;
  // 游标：大限 / 童限
  @override
  final FlowYear? currentYear;
  // 游标：流年
  @override
  final FlowMonth? currentMonth;
  // 游标：流月
  @override
  final bool? currentMonthIsLeap;
  // 游标：流月是否闰月
  @override
  final FlowDay? currentDay;
  // 游标：流日
  @override
  final FlowHour? currentHour;
  // 游标：流时
  @override
  final int? selectedPalaceIndex;

  @override
  String toString() {
    return 'ZiweiUIState(plate: $plate, date: $date, ruleset: $ruleset, manifest: $manifest, currentDecade: $currentDecade, currentYear: $currentYear, currentMonth: $currentMonth, currentMonthIsLeap: $currentMonthIsLeap, currentDay: $currentDay, currentHour: $currentHour, selectedPalaceIndex: $selectedPalaceIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZiweiUIStateImpl &&
            (identical(other.plate, plate) || other.plate == plate) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.ruleset, ruleset) || other.ruleset == ruleset) &&
            (identical(other.manifest, manifest) ||
                other.manifest == manifest) &&
            (identical(other.currentDecade, currentDecade) ||
                other.currentDecade == currentDecade) &&
            (identical(other.currentYear, currentYear) ||
                other.currentYear == currentYear) &&
            (identical(other.currentMonth, currentMonth) ||
                other.currentMonth == currentMonth) &&
            (identical(other.currentMonthIsLeap, currentMonthIsLeap) ||
                other.currentMonthIsLeap == currentMonthIsLeap) &&
            (identical(other.currentDay, currentDay) ||
                other.currentDay == currentDay) &&
            (identical(other.currentHour, currentHour) ||
                other.currentHour == currentHour) &&
            (identical(other.selectedPalaceIndex, selectedPalaceIndex) ||
                other.selectedPalaceIndex == selectedPalaceIndex));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    plate,
    date,
    ruleset,
    manifest,
    currentDecade,
    currentYear,
    currentMonth,
    currentMonthIsLeap,
    currentDay,
    currentHour,
    selectedPalaceIndex,
  );

  /// Create a copy of ZiweiUIState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZiweiUIStateImplCopyWith<_$ZiweiUIStateImpl> get copyWith =>
      __$$ZiweiUIStateImplCopyWithImpl<_$ZiweiUIStateImpl>(this, _$identity);
}

abstract class _ZiweiUIState implements ZiweiUIState {
  const factory _ZiweiUIState({
    required final ZiWeiPlate plate,
    required final ZiweiDate date,
    required final ZiweiRuleset ruleset,
    required final TimelineManifest manifest,
    final Decade? currentDecade,
    final FlowYear? currentYear,
    final FlowMonth? currentMonth,
    final bool? currentMonthIsLeap,
    final FlowDay? currentDay,
    final FlowHour? currentHour,
    final int? selectedPalaceIndex,
  }) = _$ZiweiUIStateImpl;

  @override
  ZiWeiPlate get plate; // 当前最终渲染盘 (本命 or 包含流星的盘)
  @override
  ZiweiDate get date; // 基础日期
  @override
  ZiweiRuleset get ruleset; // 基础规则
  @override
  TimelineManifest get manifest; // 当前流运清单快照
  @override
  Decade? get currentDecade; // 游标：大限 / 童限
  @override
  FlowYear? get currentYear; // 游标：流年
  @override
  FlowMonth? get currentMonth; // 游标：流月
  @override
  bool? get currentMonthIsLeap; // 游标：流月是否闰月
  @override
  FlowDay? get currentDay; // 游标：流日
  @override
  FlowHour? get currentHour; // 游标：流时
  @override
  int? get selectedPalaceIndex;

  /// Create a copy of ZiweiUIState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZiweiUIStateImplCopyWith<_$ZiweiUIStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
