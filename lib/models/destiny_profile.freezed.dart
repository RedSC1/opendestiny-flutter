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

ZiweiOptions _$ZiweiOptionsFromJson(Map<String, dynamic> json) {
  return _ZiweiOptions.fromJson(json);
}

/// @nodoc
mixin _$ZiweiOptions {
  LeapMonthRule get leapRule => throw _privateConstructorUsedError;
  Boundary get wuHuDunBasedOn => throw _privateConstructorUsedError;
  Boundary get siHuaBasedOn => throw _privateConstructorUsedError;
  ChildhoodRole get childhoodRule => throw _privateConstructorUsedError;
  Boundary get flowLimitBasedOn => throw _privateConstructorUsedError;
  ZiweiSiHuaMode get siHuaMode => throw _privateConstructorUsedError;
  String get customSiHuaJson => throw _privateConstructorUsedError;
  List<ZiweiCustomProfile> get siHuaProfiles =>
      throw _privateConstructorUsedError;
  String get activeSiHuaProfileId => throw _privateConstructorUsedError;
  ZiweiMastersMode get mastersMode => throw _privateConstructorUsedError;
  String get customMastersJson => throw _privateConstructorUsedError;
  List<ZiweiCustomProfile> get mastersProfiles =>
      throw _privateConstructorUsedError;
  String get activeMastersProfileId => throw _privateConstructorUsedError;
  ZiweiBrightnessMode get brightnessMode => throw _privateConstructorUsedError;
  String get customBrightnessJson => throw _privateConstructorUsedError;
  List<ZiweiCustomProfile> get brightnessProfiles =>
      throw _privateConstructorUsedError;
  String get activeBrightnessProfileId => throw _privateConstructorUsedError;
  ZiweiStarsMode get starsMode => throw _privateConstructorUsedError;
  String get customStarsJson => throw _privateConstructorUsedError;
  List<ZiweiCustomProfile> get starsProfiles =>
      throw _privateConstructorUsedError;
  String get activeStarsProfileId => throw _privateConstructorUsedError;
  ZiweiModeDisplayOptions get sihuaDisplay =>
      throw _privateConstructorUsedError;
  ZiweiModeDisplayOptions get flyingDisplay =>
      throw _privateConstructorUsedError;
  bool get showCenterBazi => throw _privateConstructorUsedError;
  bool get showBodyPalace => throw _privateConstructorUsedError;
  bool get showLaiYinPalace => throw _privateConstructorUsedError;
  bool get hideCenterBirthInfo => throw _privateConstructorUsedError;
  bool get enableHistorical => throw _privateConstructorUsedError;
  ZiweiFlowStarDisplayOptions get flowStarDisplay =>
      throw _privateConstructorUsedError;
  ZiweiAnimationOptions get animation => throw _privateConstructorUsedError;

  /// Serializes this ZiweiOptions to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ZiweiOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ZiweiOptionsCopyWith<ZiweiOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZiweiOptionsCopyWith<$Res> {
  factory $ZiweiOptionsCopyWith(
    ZiweiOptions value,
    $Res Function(ZiweiOptions) then,
  ) = _$ZiweiOptionsCopyWithImpl<$Res, ZiweiOptions>;
  @useResult
  $Res call({
    LeapMonthRule leapRule,
    Boundary wuHuDunBasedOn,
    Boundary siHuaBasedOn,
    ChildhoodRole childhoodRule,
    Boundary flowLimitBasedOn,
    ZiweiSiHuaMode siHuaMode,
    String customSiHuaJson,
    List<ZiweiCustomProfile> siHuaProfiles,
    String activeSiHuaProfileId,
    ZiweiMastersMode mastersMode,
    String customMastersJson,
    List<ZiweiCustomProfile> mastersProfiles,
    String activeMastersProfileId,
    ZiweiBrightnessMode brightnessMode,
    String customBrightnessJson,
    List<ZiweiCustomProfile> brightnessProfiles,
    String activeBrightnessProfileId,
    ZiweiStarsMode starsMode,
    String customStarsJson,
    List<ZiweiCustomProfile> starsProfiles,
    String activeStarsProfileId,
    ZiweiModeDisplayOptions sihuaDisplay,
    ZiweiModeDisplayOptions flyingDisplay,
    bool showCenterBazi,
    bool showBodyPalace,
    bool showLaiYinPalace,
    bool hideCenterBirthInfo,
    bool enableHistorical,
    ZiweiFlowStarDisplayOptions flowStarDisplay,
    ZiweiAnimationOptions animation,
  });
}

/// @nodoc
class _$ZiweiOptionsCopyWithImpl<$Res, $Val extends ZiweiOptions>
    implements $ZiweiOptionsCopyWith<$Res> {
  _$ZiweiOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ZiweiOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leapRule = null,
    Object? wuHuDunBasedOn = null,
    Object? siHuaBasedOn = null,
    Object? childhoodRule = null,
    Object? flowLimitBasedOn = null,
    Object? siHuaMode = null,
    Object? customSiHuaJson = null,
    Object? siHuaProfiles = null,
    Object? activeSiHuaProfileId = null,
    Object? mastersMode = null,
    Object? customMastersJson = null,
    Object? mastersProfiles = null,
    Object? activeMastersProfileId = null,
    Object? brightnessMode = null,
    Object? customBrightnessJson = null,
    Object? brightnessProfiles = null,
    Object? activeBrightnessProfileId = null,
    Object? starsMode = null,
    Object? customStarsJson = null,
    Object? starsProfiles = null,
    Object? activeStarsProfileId = null,
    Object? sihuaDisplay = null,
    Object? flyingDisplay = null,
    Object? showCenterBazi = null,
    Object? showBodyPalace = null,
    Object? showLaiYinPalace = null,
    Object? hideCenterBirthInfo = null,
    Object? enableHistorical = null,
    Object? flowStarDisplay = null,
    Object? animation = null,
  }) {
    return _then(
      _value.copyWith(
            leapRule: null == leapRule
                ? _value.leapRule
                : leapRule // ignore: cast_nullable_to_non_nullable
                      as LeapMonthRule,
            wuHuDunBasedOn: null == wuHuDunBasedOn
                ? _value.wuHuDunBasedOn
                : wuHuDunBasedOn // ignore: cast_nullable_to_non_nullable
                      as Boundary,
            siHuaBasedOn: null == siHuaBasedOn
                ? _value.siHuaBasedOn
                : siHuaBasedOn // ignore: cast_nullable_to_non_nullable
                      as Boundary,
            childhoodRule: null == childhoodRule
                ? _value.childhoodRule
                : childhoodRule // ignore: cast_nullable_to_non_nullable
                      as ChildhoodRole,
            flowLimitBasedOn: null == flowLimitBasedOn
                ? _value.flowLimitBasedOn
                : flowLimitBasedOn // ignore: cast_nullable_to_non_nullable
                      as Boundary,
            siHuaMode: null == siHuaMode
                ? _value.siHuaMode
                : siHuaMode // ignore: cast_nullable_to_non_nullable
                      as ZiweiSiHuaMode,
            customSiHuaJson: null == customSiHuaJson
                ? _value.customSiHuaJson
                : customSiHuaJson // ignore: cast_nullable_to_non_nullable
                      as String,
            siHuaProfiles: null == siHuaProfiles
                ? _value.siHuaProfiles
                : siHuaProfiles // ignore: cast_nullable_to_non_nullable
                      as List<ZiweiCustomProfile>,
            activeSiHuaProfileId: null == activeSiHuaProfileId
                ? _value.activeSiHuaProfileId
                : activeSiHuaProfileId // ignore: cast_nullable_to_non_nullable
                      as String,
            mastersMode: null == mastersMode
                ? _value.mastersMode
                : mastersMode // ignore: cast_nullable_to_non_nullable
                      as ZiweiMastersMode,
            customMastersJson: null == customMastersJson
                ? _value.customMastersJson
                : customMastersJson // ignore: cast_nullable_to_non_nullable
                      as String,
            mastersProfiles: null == mastersProfiles
                ? _value.mastersProfiles
                : mastersProfiles // ignore: cast_nullable_to_non_nullable
                      as List<ZiweiCustomProfile>,
            activeMastersProfileId: null == activeMastersProfileId
                ? _value.activeMastersProfileId
                : activeMastersProfileId // ignore: cast_nullable_to_non_nullable
                      as String,
            brightnessMode: null == brightnessMode
                ? _value.brightnessMode
                : brightnessMode // ignore: cast_nullable_to_non_nullable
                      as ZiweiBrightnessMode,
            customBrightnessJson: null == customBrightnessJson
                ? _value.customBrightnessJson
                : customBrightnessJson // ignore: cast_nullable_to_non_nullable
                      as String,
            brightnessProfiles: null == brightnessProfiles
                ? _value.brightnessProfiles
                : brightnessProfiles // ignore: cast_nullable_to_non_nullable
                      as List<ZiweiCustomProfile>,
            activeBrightnessProfileId: null == activeBrightnessProfileId
                ? _value.activeBrightnessProfileId
                : activeBrightnessProfileId // ignore: cast_nullable_to_non_nullable
                      as String,
            starsMode: null == starsMode
                ? _value.starsMode
                : starsMode // ignore: cast_nullable_to_non_nullable
                      as ZiweiStarsMode,
            customStarsJson: null == customStarsJson
                ? _value.customStarsJson
                : customStarsJson // ignore: cast_nullable_to_non_nullable
                      as String,
            starsProfiles: null == starsProfiles
                ? _value.starsProfiles
                : starsProfiles // ignore: cast_nullable_to_non_nullable
                      as List<ZiweiCustomProfile>,
            activeStarsProfileId: null == activeStarsProfileId
                ? _value.activeStarsProfileId
                : activeStarsProfileId // ignore: cast_nullable_to_non_nullable
                      as String,
            sihuaDisplay: null == sihuaDisplay
                ? _value.sihuaDisplay
                : sihuaDisplay // ignore: cast_nullable_to_non_nullable
                      as ZiweiModeDisplayOptions,
            flyingDisplay: null == flyingDisplay
                ? _value.flyingDisplay
                : flyingDisplay // ignore: cast_nullable_to_non_nullable
                      as ZiweiModeDisplayOptions,
            showCenterBazi: null == showCenterBazi
                ? _value.showCenterBazi
                : showCenterBazi // ignore: cast_nullable_to_non_nullable
                      as bool,
            showBodyPalace: null == showBodyPalace
                ? _value.showBodyPalace
                : showBodyPalace // ignore: cast_nullable_to_non_nullable
                      as bool,
            showLaiYinPalace: null == showLaiYinPalace
                ? _value.showLaiYinPalace
                : showLaiYinPalace // ignore: cast_nullable_to_non_nullable
                      as bool,
            hideCenterBirthInfo: null == hideCenterBirthInfo
                ? _value.hideCenterBirthInfo
                : hideCenterBirthInfo // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableHistorical: null == enableHistorical
                ? _value.enableHistorical
                : enableHistorical // ignore: cast_nullable_to_non_nullable
                      as bool,
            flowStarDisplay: null == flowStarDisplay
                ? _value.flowStarDisplay
                : flowStarDisplay // ignore: cast_nullable_to_non_nullable
                      as ZiweiFlowStarDisplayOptions,
            animation: null == animation
                ? _value.animation
                : animation // ignore: cast_nullable_to_non_nullable
                      as ZiweiAnimationOptions,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ZiweiOptionsImplCopyWith<$Res>
    implements $ZiweiOptionsCopyWith<$Res> {
  factory _$$ZiweiOptionsImplCopyWith(
    _$ZiweiOptionsImpl value,
    $Res Function(_$ZiweiOptionsImpl) then,
  ) = __$$ZiweiOptionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LeapMonthRule leapRule,
    Boundary wuHuDunBasedOn,
    Boundary siHuaBasedOn,
    ChildhoodRole childhoodRule,
    Boundary flowLimitBasedOn,
    ZiweiSiHuaMode siHuaMode,
    String customSiHuaJson,
    List<ZiweiCustomProfile> siHuaProfiles,
    String activeSiHuaProfileId,
    ZiweiMastersMode mastersMode,
    String customMastersJson,
    List<ZiweiCustomProfile> mastersProfiles,
    String activeMastersProfileId,
    ZiweiBrightnessMode brightnessMode,
    String customBrightnessJson,
    List<ZiweiCustomProfile> brightnessProfiles,
    String activeBrightnessProfileId,
    ZiweiStarsMode starsMode,
    String customStarsJson,
    List<ZiweiCustomProfile> starsProfiles,
    String activeStarsProfileId,
    ZiweiModeDisplayOptions sihuaDisplay,
    ZiweiModeDisplayOptions flyingDisplay,
    bool showCenterBazi,
    bool showBodyPalace,
    bool showLaiYinPalace,
    bool hideCenterBirthInfo,
    bool enableHistorical,
    ZiweiFlowStarDisplayOptions flowStarDisplay,
    ZiweiAnimationOptions animation,
  });
}

/// @nodoc
class __$$ZiweiOptionsImplCopyWithImpl<$Res>
    extends _$ZiweiOptionsCopyWithImpl<$Res, _$ZiweiOptionsImpl>
    implements _$$ZiweiOptionsImplCopyWith<$Res> {
  __$$ZiweiOptionsImplCopyWithImpl(
    _$ZiweiOptionsImpl _value,
    $Res Function(_$ZiweiOptionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ZiweiOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leapRule = null,
    Object? wuHuDunBasedOn = null,
    Object? siHuaBasedOn = null,
    Object? childhoodRule = null,
    Object? flowLimitBasedOn = null,
    Object? siHuaMode = null,
    Object? customSiHuaJson = null,
    Object? siHuaProfiles = null,
    Object? activeSiHuaProfileId = null,
    Object? mastersMode = null,
    Object? customMastersJson = null,
    Object? mastersProfiles = null,
    Object? activeMastersProfileId = null,
    Object? brightnessMode = null,
    Object? customBrightnessJson = null,
    Object? brightnessProfiles = null,
    Object? activeBrightnessProfileId = null,
    Object? starsMode = null,
    Object? customStarsJson = null,
    Object? starsProfiles = null,
    Object? activeStarsProfileId = null,
    Object? sihuaDisplay = null,
    Object? flyingDisplay = null,
    Object? showCenterBazi = null,
    Object? showBodyPalace = null,
    Object? showLaiYinPalace = null,
    Object? hideCenterBirthInfo = null,
    Object? enableHistorical = null,
    Object? flowStarDisplay = null,
    Object? animation = null,
  }) {
    return _then(
      _$ZiweiOptionsImpl(
        leapRule: null == leapRule
            ? _value.leapRule
            : leapRule // ignore: cast_nullable_to_non_nullable
                  as LeapMonthRule,
        wuHuDunBasedOn: null == wuHuDunBasedOn
            ? _value.wuHuDunBasedOn
            : wuHuDunBasedOn // ignore: cast_nullable_to_non_nullable
                  as Boundary,
        siHuaBasedOn: null == siHuaBasedOn
            ? _value.siHuaBasedOn
            : siHuaBasedOn // ignore: cast_nullable_to_non_nullable
                  as Boundary,
        childhoodRule: null == childhoodRule
            ? _value.childhoodRule
            : childhoodRule // ignore: cast_nullable_to_non_nullable
                  as ChildhoodRole,
        flowLimitBasedOn: null == flowLimitBasedOn
            ? _value.flowLimitBasedOn
            : flowLimitBasedOn // ignore: cast_nullable_to_non_nullable
                  as Boundary,
        siHuaMode: null == siHuaMode
            ? _value.siHuaMode
            : siHuaMode // ignore: cast_nullable_to_non_nullable
                  as ZiweiSiHuaMode,
        customSiHuaJson: null == customSiHuaJson
            ? _value.customSiHuaJson
            : customSiHuaJson // ignore: cast_nullable_to_non_nullable
                  as String,
        siHuaProfiles: null == siHuaProfiles
            ? _value._siHuaProfiles
            : siHuaProfiles // ignore: cast_nullable_to_non_nullable
                  as List<ZiweiCustomProfile>,
        activeSiHuaProfileId: null == activeSiHuaProfileId
            ? _value.activeSiHuaProfileId
            : activeSiHuaProfileId // ignore: cast_nullable_to_non_nullable
                  as String,
        mastersMode: null == mastersMode
            ? _value.mastersMode
            : mastersMode // ignore: cast_nullable_to_non_nullable
                  as ZiweiMastersMode,
        customMastersJson: null == customMastersJson
            ? _value.customMastersJson
            : customMastersJson // ignore: cast_nullable_to_non_nullable
                  as String,
        mastersProfiles: null == mastersProfiles
            ? _value._mastersProfiles
            : mastersProfiles // ignore: cast_nullable_to_non_nullable
                  as List<ZiweiCustomProfile>,
        activeMastersProfileId: null == activeMastersProfileId
            ? _value.activeMastersProfileId
            : activeMastersProfileId // ignore: cast_nullable_to_non_nullable
                  as String,
        brightnessMode: null == brightnessMode
            ? _value.brightnessMode
            : brightnessMode // ignore: cast_nullable_to_non_nullable
                  as ZiweiBrightnessMode,
        customBrightnessJson: null == customBrightnessJson
            ? _value.customBrightnessJson
            : customBrightnessJson // ignore: cast_nullable_to_non_nullable
                  as String,
        brightnessProfiles: null == brightnessProfiles
            ? _value._brightnessProfiles
            : brightnessProfiles // ignore: cast_nullable_to_non_nullable
                  as List<ZiweiCustomProfile>,
        activeBrightnessProfileId: null == activeBrightnessProfileId
            ? _value.activeBrightnessProfileId
            : activeBrightnessProfileId // ignore: cast_nullable_to_non_nullable
                  as String,
        starsMode: null == starsMode
            ? _value.starsMode
            : starsMode // ignore: cast_nullable_to_non_nullable
                  as ZiweiStarsMode,
        customStarsJson: null == customStarsJson
            ? _value.customStarsJson
            : customStarsJson // ignore: cast_nullable_to_non_nullable
                  as String,
        starsProfiles: null == starsProfiles
            ? _value._starsProfiles
            : starsProfiles // ignore: cast_nullable_to_non_nullable
                  as List<ZiweiCustomProfile>,
        activeStarsProfileId: null == activeStarsProfileId
            ? _value.activeStarsProfileId
            : activeStarsProfileId // ignore: cast_nullable_to_non_nullable
                  as String,
        sihuaDisplay: null == sihuaDisplay
            ? _value.sihuaDisplay
            : sihuaDisplay // ignore: cast_nullable_to_non_nullable
                  as ZiweiModeDisplayOptions,
        flyingDisplay: null == flyingDisplay
            ? _value.flyingDisplay
            : flyingDisplay // ignore: cast_nullable_to_non_nullable
                  as ZiweiModeDisplayOptions,
        showCenterBazi: null == showCenterBazi
            ? _value.showCenterBazi
            : showCenterBazi // ignore: cast_nullable_to_non_nullable
                  as bool,
        showBodyPalace: null == showBodyPalace
            ? _value.showBodyPalace
            : showBodyPalace // ignore: cast_nullable_to_non_nullable
                  as bool,
        showLaiYinPalace: null == showLaiYinPalace
            ? _value.showLaiYinPalace
            : showLaiYinPalace // ignore: cast_nullable_to_non_nullable
                  as bool,
        hideCenterBirthInfo: null == hideCenterBirthInfo
            ? _value.hideCenterBirthInfo
            : hideCenterBirthInfo // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableHistorical: null == enableHistorical
            ? _value.enableHistorical
            : enableHistorical // ignore: cast_nullable_to_non_nullable
                  as bool,
        flowStarDisplay: null == flowStarDisplay
            ? _value.flowStarDisplay
            : flowStarDisplay // ignore: cast_nullable_to_non_nullable
                  as ZiweiFlowStarDisplayOptions,
        animation: null == animation
            ? _value.animation
            : animation // ignore: cast_nullable_to_non_nullable
                  as ZiweiAnimationOptions,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ZiweiOptionsImpl implements _ZiweiOptions {
  const _$ZiweiOptionsImpl({
    this.leapRule = LeapMonthRule.splitAt15,
    this.wuHuDunBasedOn = Boundary.lunar,
    this.siHuaBasedOn = Boundary.lunar,
    this.childhoodRule = ChildhoodRole.skip,
    this.flowLimitBasedOn = Boundary.lunar,
    this.siHuaMode = ZiweiSiHuaMode.builtin,
    this.customSiHuaJson = '',
    final List<ZiweiCustomProfile> siHuaProfiles = const <ZiweiCustomProfile>[],
    this.activeSiHuaProfileId = '',
    this.mastersMode = ZiweiMastersMode.builtin,
    this.customMastersJson = '',
    final List<ZiweiCustomProfile> mastersProfiles =
        const <ZiweiCustomProfile>[],
    this.activeMastersProfileId = '',
    this.brightnessMode = ZiweiBrightnessMode.builtin,
    this.customBrightnessJson = '',
    final List<ZiweiCustomProfile> brightnessProfiles =
        const <ZiweiCustomProfile>[],
    this.activeBrightnessProfileId = '',
    this.starsMode = ZiweiStarsMode.builtin,
    this.customStarsJson = '',
    final List<ZiweiCustomProfile> starsProfiles = const <ZiweiCustomProfile>[],
    this.activeStarsProfileId = '',
    this.sihuaDisplay = const ZiweiModeDisplayOptions(
      showCenterBazi: false,
      showBodyPalace: false,
      showLaiYinPalace: true,
    ),
    this.flyingDisplay = const ZiweiModeDisplayOptions(
      showBodyPalace: false,
      showLaiYinPalace: true,
    ),
    this.showCenterBazi = true,
    this.showBodyPalace = true,
    this.showLaiYinPalace = false,
    this.hideCenterBirthInfo = false,
    this.enableHistorical = true,
    this.flowStarDisplay = const ZiweiFlowStarDisplayOptions(),
    this.animation = const ZiweiAnimationOptions(),
  }) : _siHuaProfiles = siHuaProfiles,
       _mastersProfiles = mastersProfiles,
       _brightnessProfiles = brightnessProfiles,
       _starsProfiles = starsProfiles;

  factory _$ZiweiOptionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ZiweiOptionsImplFromJson(json);

  @override
  @JsonKey()
  final LeapMonthRule leapRule;
  @override
  @JsonKey()
  final Boundary wuHuDunBasedOn;
  @override
  @JsonKey()
  final Boundary siHuaBasedOn;
  @override
  @JsonKey()
  final ChildhoodRole childhoodRule;
  @override
  @JsonKey()
  final Boundary flowLimitBasedOn;
  @override
  @JsonKey()
  final ZiweiSiHuaMode siHuaMode;
  @override
  @JsonKey()
  final String customSiHuaJson;
  final List<ZiweiCustomProfile> _siHuaProfiles;
  @override
  @JsonKey()
  List<ZiweiCustomProfile> get siHuaProfiles {
    if (_siHuaProfiles is EqualUnmodifiableListView) return _siHuaProfiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_siHuaProfiles);
  }

  @override
  @JsonKey()
  final String activeSiHuaProfileId;
  @override
  @JsonKey()
  final ZiweiMastersMode mastersMode;
  @override
  @JsonKey()
  final String customMastersJson;
  final List<ZiweiCustomProfile> _mastersProfiles;
  @override
  @JsonKey()
  List<ZiweiCustomProfile> get mastersProfiles {
    if (_mastersProfiles is EqualUnmodifiableListView) return _mastersProfiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mastersProfiles);
  }

  @override
  @JsonKey()
  final String activeMastersProfileId;
  @override
  @JsonKey()
  final ZiweiBrightnessMode brightnessMode;
  @override
  @JsonKey()
  final String customBrightnessJson;
  final List<ZiweiCustomProfile> _brightnessProfiles;
  @override
  @JsonKey()
  List<ZiweiCustomProfile> get brightnessProfiles {
    if (_brightnessProfiles is EqualUnmodifiableListView)
      return _brightnessProfiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_brightnessProfiles);
  }

  @override
  @JsonKey()
  final String activeBrightnessProfileId;
  @override
  @JsonKey()
  final ZiweiStarsMode starsMode;
  @override
  @JsonKey()
  final String customStarsJson;
  final List<ZiweiCustomProfile> _starsProfiles;
  @override
  @JsonKey()
  List<ZiweiCustomProfile> get starsProfiles {
    if (_starsProfiles is EqualUnmodifiableListView) return _starsProfiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_starsProfiles);
  }

  @override
  @JsonKey()
  final String activeStarsProfileId;
  @override
  @JsonKey()
  final ZiweiModeDisplayOptions sihuaDisplay;
  @override
  @JsonKey()
  final ZiweiModeDisplayOptions flyingDisplay;
  @override
  @JsonKey()
  final bool showCenterBazi;
  @override
  @JsonKey()
  final bool showBodyPalace;
  @override
  @JsonKey()
  final bool showLaiYinPalace;
  @override
  @JsonKey()
  final bool hideCenterBirthInfo;
  @override
  @JsonKey()
  final bool enableHistorical;
  @override
  @JsonKey()
  final ZiweiFlowStarDisplayOptions flowStarDisplay;
  @override
  @JsonKey()
  final ZiweiAnimationOptions animation;

  @override
  String toString() {
    return 'ZiweiOptions(leapRule: $leapRule, wuHuDunBasedOn: $wuHuDunBasedOn, siHuaBasedOn: $siHuaBasedOn, childhoodRule: $childhoodRule, flowLimitBasedOn: $flowLimitBasedOn, siHuaMode: $siHuaMode, customSiHuaJson: $customSiHuaJson, siHuaProfiles: $siHuaProfiles, activeSiHuaProfileId: $activeSiHuaProfileId, mastersMode: $mastersMode, customMastersJson: $customMastersJson, mastersProfiles: $mastersProfiles, activeMastersProfileId: $activeMastersProfileId, brightnessMode: $brightnessMode, customBrightnessJson: $customBrightnessJson, brightnessProfiles: $brightnessProfiles, activeBrightnessProfileId: $activeBrightnessProfileId, starsMode: $starsMode, customStarsJson: $customStarsJson, starsProfiles: $starsProfiles, activeStarsProfileId: $activeStarsProfileId, sihuaDisplay: $sihuaDisplay, flyingDisplay: $flyingDisplay, showCenterBazi: $showCenterBazi, showBodyPalace: $showBodyPalace, showLaiYinPalace: $showLaiYinPalace, hideCenterBirthInfo: $hideCenterBirthInfo, enableHistorical: $enableHistorical, flowStarDisplay: $flowStarDisplay, animation: $animation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZiweiOptionsImpl &&
            (identical(other.leapRule, leapRule) ||
                other.leapRule == leapRule) &&
            (identical(other.wuHuDunBasedOn, wuHuDunBasedOn) ||
                other.wuHuDunBasedOn == wuHuDunBasedOn) &&
            (identical(other.siHuaBasedOn, siHuaBasedOn) ||
                other.siHuaBasedOn == siHuaBasedOn) &&
            (identical(other.childhoodRule, childhoodRule) ||
                other.childhoodRule == childhoodRule) &&
            (identical(other.flowLimitBasedOn, flowLimitBasedOn) ||
                other.flowLimitBasedOn == flowLimitBasedOn) &&
            (identical(other.siHuaMode, siHuaMode) ||
                other.siHuaMode == siHuaMode) &&
            (identical(other.customSiHuaJson, customSiHuaJson) ||
                other.customSiHuaJson == customSiHuaJson) &&
            const DeepCollectionEquality().equals(
              other._siHuaProfiles,
              _siHuaProfiles,
            ) &&
            (identical(other.activeSiHuaProfileId, activeSiHuaProfileId) ||
                other.activeSiHuaProfileId == activeSiHuaProfileId) &&
            (identical(other.mastersMode, mastersMode) ||
                other.mastersMode == mastersMode) &&
            (identical(other.customMastersJson, customMastersJson) ||
                other.customMastersJson == customMastersJson) &&
            const DeepCollectionEquality().equals(
              other._mastersProfiles,
              _mastersProfiles,
            ) &&
            (identical(other.activeMastersProfileId, activeMastersProfileId) ||
                other.activeMastersProfileId == activeMastersProfileId) &&
            (identical(other.brightnessMode, brightnessMode) ||
                other.brightnessMode == brightnessMode) &&
            (identical(other.customBrightnessJson, customBrightnessJson) ||
                other.customBrightnessJson == customBrightnessJson) &&
            const DeepCollectionEquality().equals(
              other._brightnessProfiles,
              _brightnessProfiles,
            ) &&
            (identical(
                  other.activeBrightnessProfileId,
                  activeBrightnessProfileId,
                ) ||
                other.activeBrightnessProfileId == activeBrightnessProfileId) &&
            (identical(other.starsMode, starsMode) ||
                other.starsMode == starsMode) &&
            (identical(other.customStarsJson, customStarsJson) ||
                other.customStarsJson == customStarsJson) &&
            const DeepCollectionEquality().equals(
              other._starsProfiles,
              _starsProfiles,
            ) &&
            (identical(other.activeStarsProfileId, activeStarsProfileId) ||
                other.activeStarsProfileId == activeStarsProfileId) &&
            (identical(other.sihuaDisplay, sihuaDisplay) ||
                other.sihuaDisplay == sihuaDisplay) &&
            (identical(other.flyingDisplay, flyingDisplay) ||
                other.flyingDisplay == flyingDisplay) &&
            (identical(other.showCenterBazi, showCenterBazi) ||
                other.showCenterBazi == showCenterBazi) &&
            (identical(other.showBodyPalace, showBodyPalace) ||
                other.showBodyPalace == showBodyPalace) &&
            (identical(other.showLaiYinPalace, showLaiYinPalace) ||
                other.showLaiYinPalace == showLaiYinPalace) &&
            (identical(other.hideCenterBirthInfo, hideCenterBirthInfo) ||
                other.hideCenterBirthInfo == hideCenterBirthInfo) &&
            (identical(other.enableHistorical, enableHistorical) ||
                other.enableHistorical == enableHistorical) &&
            (identical(other.flowStarDisplay, flowStarDisplay) ||
                other.flowStarDisplay == flowStarDisplay) &&
            (identical(other.animation, animation) ||
                other.animation == animation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    leapRule,
    wuHuDunBasedOn,
    siHuaBasedOn,
    childhoodRule,
    flowLimitBasedOn,
    siHuaMode,
    customSiHuaJson,
    const DeepCollectionEquality().hash(_siHuaProfiles),
    activeSiHuaProfileId,
    mastersMode,
    customMastersJson,
    const DeepCollectionEquality().hash(_mastersProfiles),
    activeMastersProfileId,
    brightnessMode,
    customBrightnessJson,
    const DeepCollectionEquality().hash(_brightnessProfiles),
    activeBrightnessProfileId,
    starsMode,
    customStarsJson,
    const DeepCollectionEquality().hash(_starsProfiles),
    activeStarsProfileId,
    sihuaDisplay,
    flyingDisplay,
    showCenterBazi,
    showBodyPalace,
    showLaiYinPalace,
    hideCenterBirthInfo,
    enableHistorical,
    flowStarDisplay,
    animation,
  ]);

  /// Create a copy of ZiweiOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZiweiOptionsImplCopyWith<_$ZiweiOptionsImpl> get copyWith =>
      __$$ZiweiOptionsImplCopyWithImpl<_$ZiweiOptionsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ZiweiOptionsImplToJson(this);
  }
}

abstract class _ZiweiOptions implements ZiweiOptions {
  const factory _ZiweiOptions({
    final LeapMonthRule leapRule,
    final Boundary wuHuDunBasedOn,
    final Boundary siHuaBasedOn,
    final ChildhoodRole childhoodRule,
    final Boundary flowLimitBasedOn,
    final ZiweiSiHuaMode siHuaMode,
    final String customSiHuaJson,
    final List<ZiweiCustomProfile> siHuaProfiles,
    final String activeSiHuaProfileId,
    final ZiweiMastersMode mastersMode,
    final String customMastersJson,
    final List<ZiweiCustomProfile> mastersProfiles,
    final String activeMastersProfileId,
    final ZiweiBrightnessMode brightnessMode,
    final String customBrightnessJson,
    final List<ZiweiCustomProfile> brightnessProfiles,
    final String activeBrightnessProfileId,
    final ZiweiStarsMode starsMode,
    final String customStarsJson,
    final List<ZiweiCustomProfile> starsProfiles,
    final String activeStarsProfileId,
    final ZiweiModeDisplayOptions sihuaDisplay,
    final ZiweiModeDisplayOptions flyingDisplay,
    final bool showCenterBazi,
    final bool showBodyPalace,
    final bool showLaiYinPalace,
    final bool hideCenterBirthInfo,
    final bool enableHistorical,
    final ZiweiFlowStarDisplayOptions flowStarDisplay,
    final ZiweiAnimationOptions animation,
  }) = _$ZiweiOptionsImpl;

  factory _ZiweiOptions.fromJson(Map<String, dynamic> json) =
      _$ZiweiOptionsImpl.fromJson;

  @override
  LeapMonthRule get leapRule;
  @override
  Boundary get wuHuDunBasedOn;
  @override
  Boundary get siHuaBasedOn;
  @override
  ChildhoodRole get childhoodRule;
  @override
  Boundary get flowLimitBasedOn;
  @override
  ZiweiSiHuaMode get siHuaMode;
  @override
  String get customSiHuaJson;
  @override
  List<ZiweiCustomProfile> get siHuaProfiles;
  @override
  String get activeSiHuaProfileId;
  @override
  ZiweiMastersMode get mastersMode;
  @override
  String get customMastersJson;
  @override
  List<ZiweiCustomProfile> get mastersProfiles;
  @override
  String get activeMastersProfileId;
  @override
  ZiweiBrightnessMode get brightnessMode;
  @override
  String get customBrightnessJson;
  @override
  List<ZiweiCustomProfile> get brightnessProfiles;
  @override
  String get activeBrightnessProfileId;
  @override
  ZiweiStarsMode get starsMode;
  @override
  String get customStarsJson;
  @override
  List<ZiweiCustomProfile> get starsProfiles;
  @override
  String get activeStarsProfileId;
  @override
  ZiweiModeDisplayOptions get sihuaDisplay;
  @override
  ZiweiModeDisplayOptions get flyingDisplay;
  @override
  bool get showCenterBazi;
  @override
  bool get showBodyPalace;
  @override
  bool get showLaiYinPalace;
  @override
  bool get hideCenterBirthInfo;
  @override
  bool get enableHistorical;
  @override
  ZiweiFlowStarDisplayOptions get flowStarDisplay;
  @override
  ZiweiAnimationOptions get animation;

  /// Create a copy of ZiweiOptions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZiweiOptionsImplCopyWith<_$ZiweiOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DestinyProfile _$DestinyProfileFromJson(Map<String, dynamic> json) {
  return _DestinyProfile.fromJson(json);
}

/// @nodoc
mixin _$DestinyProfile {
  BirthInput get birthInput => throw _privateConstructorUsedError;
  Gender get gender => throw _privateConstructorUsedError;
  AppLanguage get language => throw _privateConstructorUsedError;
  BaziOptions get baziOptions => throw _privateConstructorUsedError;
  ZiweiOptions get ziweiOptions => throw _privateConstructorUsedError;

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
    BirthInput birthInput,
    Gender gender,
    AppLanguage language,
    BaziOptions baziOptions,
    ZiweiOptions ziweiOptions,
  });

  $BaziOptionsCopyWith<$Res> get baziOptions;
  $ZiweiOptionsCopyWith<$Res> get ziweiOptions;
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
    Object? birthInput = null,
    Object? gender = null,
    Object? language = null,
    Object? baziOptions = null,
    Object? ziweiOptions = null,
  }) {
    return _then(
      _value.copyWith(
            birthInput: null == birthInput
                ? _value.birthInput
                : birthInput // ignore: cast_nullable_to_non_nullable
                      as BirthInput,
            gender: null == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as Gender,
            language: null == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                      as AppLanguage,
            baziOptions: null == baziOptions
                ? _value.baziOptions
                : baziOptions // ignore: cast_nullable_to_non_nullable
                      as BaziOptions,
            ziweiOptions: null == ziweiOptions
                ? _value.ziweiOptions
                : ziweiOptions // ignore: cast_nullable_to_non_nullable
                      as ZiweiOptions,
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

  /// Create a copy of DestinyProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ZiweiOptionsCopyWith<$Res> get ziweiOptions {
    return $ZiweiOptionsCopyWith<$Res>(_value.ziweiOptions, (value) {
      return _then(_value.copyWith(ziweiOptions: value) as $Val);
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
    BirthInput birthInput,
    Gender gender,
    AppLanguage language,
    BaziOptions baziOptions,
    ZiweiOptions ziweiOptions,
  });

  @override
  $BaziOptionsCopyWith<$Res> get baziOptions;
  @override
  $ZiweiOptionsCopyWith<$Res> get ziweiOptions;
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
    Object? birthInput = null,
    Object? gender = null,
    Object? language = null,
    Object? baziOptions = null,
    Object? ziweiOptions = null,
  }) {
    return _then(
      _$DestinyProfileImpl(
        birthInput: null == birthInput
            ? _value.birthInput
            : birthInput // ignore: cast_nullable_to_non_nullable
                  as BirthInput,
        gender: null == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as Gender,
        language: null == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
                  as AppLanguage,
        baziOptions: null == baziOptions
            ? _value.baziOptions
            : baziOptions // ignore: cast_nullable_to_non_nullable
                  as BaziOptions,
        ziweiOptions: null == ziweiOptions
            ? _value.ziweiOptions
            : ziweiOptions // ignore: cast_nullable_to_non_nullable
                  as ZiweiOptions,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DestinyProfileImpl implements _DestinyProfile {
  const _$DestinyProfileImpl({
    this.birthInput = const BirthInput(),
    this.gender = Gender.male,
    this.language = AppLanguage.zhCN,
    this.baziOptions = const BaziOptions(),
    this.ziweiOptions = const ZiweiOptions(),
  });

  factory _$DestinyProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$DestinyProfileImplFromJson(json);

  @override
  @JsonKey()
  final BirthInput birthInput;
  @override
  @JsonKey()
  final Gender gender;
  @override
  @JsonKey()
  final AppLanguage language;
  @override
  @JsonKey()
  final BaziOptions baziOptions;
  @override
  @JsonKey()
  final ZiweiOptions ziweiOptions;

  @override
  String toString() {
    return 'DestinyProfile(birthInput: $birthInput, gender: $gender, language: $language, baziOptions: $baziOptions, ziweiOptions: $ziweiOptions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DestinyProfileImpl &&
            (identical(other.birthInput, birthInput) ||
                other.birthInput == birthInput) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.baziOptions, baziOptions) ||
                other.baziOptions == baziOptions) &&
            (identical(other.ziweiOptions, ziweiOptions) ||
                other.ziweiOptions == ziweiOptions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    birthInput,
    gender,
    language,
    baziOptions,
    ziweiOptions,
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
    final BirthInput birthInput,
    final Gender gender,
    final AppLanguage language,
    final BaziOptions baziOptions,
    final ZiweiOptions ziweiOptions,
  }) = _$DestinyProfileImpl;

  factory _DestinyProfile.fromJson(Map<String, dynamic> json) =
      _$DestinyProfileImpl.fromJson;

  @override
  BirthInput get birthInput;
  @override
  Gender get gender;
  @override
  AppLanguage get language;
  @override
  BaziOptions get baziOptions;
  @override
  ZiweiOptions get ziweiOptions;

  /// Create a copy of DestinyProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DestinyProfileImplCopyWith<_$DestinyProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
