// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'destiny_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BaziOptions _$BaziOptionsFromJson(Map<String, dynamic> json) {
  return _BaziOptions.fromJson(json);
}

/// @nodoc
mixin _$BaziOptions {
  SiLingVersion get siLingVersion => throw _privateConstructorUsedError;
  DaYunAlgorithm get daYunAlgorithm => throw _privateConstructorUsedError;
  EarthPalaceAlgorithm get earthPalaceAlgorithm =>
      throw _privateConstructorUsedError;

  /// Serializes this BaziOptions to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BaziOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaziOptionsCopyWith<BaziOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaziOptionsCopyWith<$Res> {
  factory $BaziOptionsCopyWith(
    BaziOptions value,
    $Res Function(BaziOptions) then,
  ) = _$BaziOptionsCopyWithImpl<$Res, BaziOptions>;
  @useResult
  $Res call({
    SiLingVersion siLingVersion,
    DaYunAlgorithm daYunAlgorithm,
    EarthPalaceAlgorithm earthPalaceAlgorithm,
  });
}

/// @nodoc
class _$BaziOptionsCopyWithImpl<$Res, $Val extends BaziOptions>
    implements $BaziOptionsCopyWith<$Res> {
  _$BaziOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaziOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siLingVersion = null,
    Object? daYunAlgorithm = null,
    Object? earthPalaceAlgorithm = null,
  }) {
    return _then(
      _value.copyWith(
            siLingVersion: null == siLingVersion
                ? _value.siLingVersion
                : siLingVersion // ignore: cast_nullable_to_non_nullable
                      as SiLingVersion,
            daYunAlgorithm: null == daYunAlgorithm
                ? _value.daYunAlgorithm
                : daYunAlgorithm // ignore: cast_nullable_to_non_nullable
                      as DaYunAlgorithm,
            earthPalaceAlgorithm: null == earthPalaceAlgorithm
                ? _value.earthPalaceAlgorithm
                : earthPalaceAlgorithm // ignore: cast_nullable_to_non_nullable
                      as EarthPalaceAlgorithm,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BaziOptionsImplCopyWith<$Res>
    implements $BaziOptionsCopyWith<$Res> {
  factory _$$BaziOptionsImplCopyWith(
    _$BaziOptionsImpl value,
    $Res Function(_$BaziOptionsImpl) then,
  ) = __$$BaziOptionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    SiLingVersion siLingVersion,
    DaYunAlgorithm daYunAlgorithm,
    EarthPalaceAlgorithm earthPalaceAlgorithm,
  });
}

/// @nodoc
class __$$BaziOptionsImplCopyWithImpl<$Res>
    extends _$BaziOptionsCopyWithImpl<$Res, _$BaziOptionsImpl>
    implements _$$BaziOptionsImplCopyWith<$Res> {
  __$$BaziOptionsImplCopyWithImpl(
    _$BaziOptionsImpl _value,
    $Res Function(_$BaziOptionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BaziOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siLingVersion = null,
    Object? daYunAlgorithm = null,
    Object? earthPalaceAlgorithm = null,
  }) {
    return _then(
      _$BaziOptionsImpl(
        siLingVersion: null == siLingVersion
            ? _value.siLingVersion
            : siLingVersion // ignore: cast_nullable_to_non_nullable
                  as SiLingVersion,
        daYunAlgorithm: null == daYunAlgorithm
            ? _value.daYunAlgorithm
            : daYunAlgorithm // ignore: cast_nullable_to_non_nullable
                  as DaYunAlgorithm,
        earthPalaceAlgorithm: null == earthPalaceAlgorithm
            ? _value.earthPalaceAlgorithm
            : earthPalaceAlgorithm // ignore: cast_nullable_to_non_nullable
                  as EarthPalaceAlgorithm,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BaziOptionsImpl implements _BaziOptions {
  const _$BaziOptionsImpl({
    this.siLingVersion = SiLingVersion.sanMingTongHui,
    this.daYunAlgorithm = DaYunAlgorithm.precise120,
    this.earthPalaceAlgorithm = EarthPalaceAlgorithm.fireEarth,
  });

  factory _$BaziOptionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BaziOptionsImplFromJson(json);

  @override
  @JsonKey()
  final SiLingVersion siLingVersion;
  @override
  @JsonKey()
  final DaYunAlgorithm daYunAlgorithm;
  @override
  @JsonKey()
  final EarthPalaceAlgorithm earthPalaceAlgorithm;

  @override
  String toString() {
    return 'BaziOptions(siLingVersion: $siLingVersion, daYunAlgorithm: $daYunAlgorithm, earthPalaceAlgorithm: $earthPalaceAlgorithm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BaziOptionsImpl &&
            (identical(other.siLingVersion, siLingVersion) ||
                other.siLingVersion == siLingVersion) &&
            (identical(other.daYunAlgorithm, daYunAlgorithm) ||
                other.daYunAlgorithm == daYunAlgorithm) &&
            (identical(other.earthPalaceAlgorithm, earthPalaceAlgorithm) ||
                other.earthPalaceAlgorithm == earthPalaceAlgorithm));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    siLingVersion,
    daYunAlgorithm,
    earthPalaceAlgorithm,
  );

  /// Create a copy of BaziOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BaziOptionsImplCopyWith<_$BaziOptionsImpl> get copyWith =>
      __$$BaziOptionsImplCopyWithImpl<_$BaziOptionsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BaziOptionsImplToJson(this);
  }
}

abstract class _BaziOptions implements BaziOptions {
  const factory _BaziOptions({
    final SiLingVersion siLingVersion,
    final DaYunAlgorithm daYunAlgorithm,
    final EarthPalaceAlgorithm earthPalaceAlgorithm,
  }) = _$BaziOptionsImpl;

  factory _BaziOptions.fromJson(Map<String, dynamic> json) =
      _$BaziOptionsImpl.fromJson;

  @override
  SiLingVersion get siLingVersion;
  @override
  DaYunAlgorithm get daYunAlgorithm;
  @override
  EarthPalaceAlgorithm get earthPalaceAlgorithm;

  /// Create a copy of BaziOptions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BaziOptionsImplCopyWith<_$BaziOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DestinyProfile _$DestinyProfileFromJson(Map<String, dynamic> json) {
  return _DestinyProfile.fromJson(json);
}

/// @nodoc
mixin _$DestinyProfile {
  DateTime get birthTime => throw _privateConstructorUsedError;
  Gender get gender => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  String get locationName =>
      throw _privateConstructorUsedError; // --- 全局历法开关 ---
  bool get useTrueSolarTime => throw _privateConstructorUsedError;
  RatHourMode get ratHourMode => throw _privateConstructorUsedError;
  AppLanguage get language => throw _privateConstructorUsedError;
  BaziOptions get baziOptions => throw _privateConstructorUsedError;

  /// Serializes this DestinyProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DestinyProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DestinyProfileCopyWith<DestinyProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DestinyProfileCopyWith<$Res> {
  factory $DestinyProfileCopyWith(
    DestinyProfile value,
    $Res Function(DestinyProfile) then,
  ) = _$DestinyProfileCopyWithImpl<$Res, DestinyProfile>;
  @useResult
  $Res call({
    DateTime birthTime,
    Gender gender,
    double longitude,
    double latitude,
    String locationName,
    bool useTrueSolarTime,
    RatHourMode ratHourMode,
    AppLanguage language,
    BaziOptions baziOptions,
  });

  $BaziOptionsCopyWith<$Res> get baziOptions;
}

/// @nodoc
class _$DestinyProfileCopyWithImpl<$Res, $Val extends DestinyProfile>
    implements $DestinyProfileCopyWith<$Res> {
  _$DestinyProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DestinyProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? birthTime = null,
    Object? gender = null,
    Object? longitude = null,
    Object? latitude = null,
    Object? locationName = null,
    Object? useTrueSolarTime = null,
    Object? ratHourMode = null,
    Object? language = null,
    Object? baziOptions = null,
  }) {
    return _then(
      _value.copyWith(
            birthTime: null == birthTime
                ? _value.birthTime
                : birthTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            gender: null == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as Gender,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            locationName: null == locationName
                ? _value.locationName
                : locationName // ignore: cast_nullable_to_non_nullable
                      as String,
            useTrueSolarTime: null == useTrueSolarTime
                ? _value.useTrueSolarTime
                : useTrueSolarTime // ignore: cast_nullable_to_non_nullable
                      as bool,
            ratHourMode: null == ratHourMode
                ? _value.ratHourMode
                : ratHourMode // ignore: cast_nullable_to_non_nullable
                      as RatHourMode,
            language: null == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                      as AppLanguage,
            baziOptions: null == baziOptions
                ? _value.baziOptions
                : baziOptions // ignore: cast_nullable_to_non_nullable
                      as BaziOptions,
          )
          as $Val,
    );
  }

  /// Create a copy of DestinyProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BaziOptionsCopyWith<$Res> get baziOptions {
    return $BaziOptionsCopyWith<$Res>(_value.baziOptions, (value) {
      return _then(_value.copyWith(baziOptions: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DestinyProfileImplCopyWith<$Res>
    implements $DestinyProfileCopyWith<$Res> {
  factory _$$DestinyProfileImplCopyWith(
    _$DestinyProfileImpl value,
    $Res Function(_$DestinyProfileImpl) then,
  ) = __$$DestinyProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime birthTime,
    Gender gender,
    double longitude,
    double latitude,
    String locationName,
    bool useTrueSolarTime,
    RatHourMode ratHourMode,
    AppLanguage language,
    BaziOptions baziOptions,
  });

  @override
  $BaziOptionsCopyWith<$Res> get baziOptions;
}

/// @nodoc
class __$$DestinyProfileImplCopyWithImpl<$Res>
    extends _$DestinyProfileCopyWithImpl<$Res, _$DestinyProfileImpl>
    implements _$$DestinyProfileImplCopyWith<$Res> {
  __$$DestinyProfileImplCopyWithImpl(
    _$DestinyProfileImpl _value,
    $Res Function(_$DestinyProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DestinyProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? birthTime = null,
    Object? gender = null,
    Object? longitude = null,
    Object? latitude = null,
    Object? locationName = null,
    Object? useTrueSolarTime = null,
    Object? ratHourMode = null,
    Object? language = null,
    Object? baziOptions = null,
  }) {
    return _then(
      _$DestinyProfileImpl(
        birthTime: null == birthTime
            ? _value.birthTime
            : birthTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        gender: null == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as Gender,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        locationName: null == locationName
            ? _value.locationName
            : locationName // ignore: cast_nullable_to_non_nullable
                  as String,
        useTrueSolarTime: null == useTrueSolarTime
            ? _value.useTrueSolarTime
            : useTrueSolarTime // ignore: cast_nullable_to_non_nullable
                  as bool,
        ratHourMode: null == ratHourMode
            ? _value.ratHourMode
            : ratHourMode // ignore: cast_nullable_to_non_nullable
                  as RatHourMode,
        language: null == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
                  as AppLanguage,
        baziOptions: null == baziOptions
            ? _value.baziOptions
            : baziOptions // ignore: cast_nullable_to_non_nullable
                  as BaziOptions,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DestinyProfileImpl implements _DestinyProfile {
  const _$DestinyProfileImpl({
    required this.birthTime,
    this.gender = Gender.male,
    this.longitude = 120.0,
    this.latitude = 30.0,
    this.locationName = '北京',
    this.useTrueSolarTime = true,
    this.ratHourMode = RatHourMode.noSplit,
    this.language = AppLanguage.zhCN,
    this.baziOptions = const BaziOptions(),
  });

  factory _$DestinyProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$DestinyProfileImplFromJson(json);

  @override
  final DateTime birthTime;
  @override
  @JsonKey()
  final Gender gender;
  @override
  @JsonKey()
  final double longitude;
  @override
  @JsonKey()
  final double latitude;
  @override
  @JsonKey()
  final String locationName;
  // --- 全局历法开关 ---
  @override
  @JsonKey()
  final bool useTrueSolarTime;
  @override
  @JsonKey()
  final RatHourMode ratHourMode;
  @override
  @JsonKey()
  final AppLanguage language;
  @override
  @JsonKey()
  final BaziOptions baziOptions;

  @override
  String toString() {
    return 'DestinyProfile(birthTime: $birthTime, gender: $gender, longitude: $longitude, latitude: $latitude, locationName: $locationName, useTrueSolarTime: $useTrueSolarTime, ratHourMode: $ratHourMode, language: $language, baziOptions: $baziOptions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DestinyProfileImpl &&
            (identical(other.birthTime, birthTime) ||
                other.birthTime == birthTime) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.useTrueSolarTime, useTrueSolarTime) ||
                other.useTrueSolarTime == useTrueSolarTime) &&
            (identical(other.ratHourMode, ratHourMode) ||
                other.ratHourMode == ratHourMode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.baziOptions, baziOptions) ||
                other.baziOptions == baziOptions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    birthTime,
    gender,
    longitude,
    latitude,
    locationName,
    useTrueSolarTime,
    ratHourMode,
    language,
    baziOptions,
  );

  /// Create a copy of DestinyProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DestinyProfileImplCopyWith<_$DestinyProfileImpl> get copyWith =>
      __$$DestinyProfileImplCopyWithImpl<_$DestinyProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DestinyProfileImplToJson(this);
  }
}

abstract class _DestinyProfile implements DestinyProfile {
  const factory _DestinyProfile({
    required final DateTime birthTime,
    final Gender gender,
    final double longitude,
    final double latitude,
    final String locationName,
    final bool useTrueSolarTime,
    final RatHourMode ratHourMode,
    final AppLanguage language,
    final BaziOptions baziOptions,
  }) = _$DestinyProfileImpl;

  factory _DestinyProfile.fromJson(Map<String, dynamic> json) =
      _$DestinyProfileImpl.fromJson;

  @override
  DateTime get birthTime;
  @override
  Gender get gender;
  @override
  double get longitude;
  @override
  double get latitude;
  @override
  String get locationName; // --- 全局历法开关 ---
  @override
  bool get useTrueSolarTime;
  @override
  RatHourMode get ratHourMode;
  @override
  AppLanguage get language;
  @override
  BaziOptions get baziOptions;

  /// Create a copy of DestinyProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DestinyProfileImplCopyWith<_$DestinyProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
