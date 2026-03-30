// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'birth_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BirthData _$BirthDataFromJson(Map<String, dynamic> json) {
  return _BirthData.fromJson(json);
}

/// @nodoc
mixin _$BirthData {
  DateTime get birthTime => throw _privateConstructorUsedError; // 出生时间（公历）
  Gender get gender => throw _privateConstructorUsedError; // 性别
  double get longitude => throw _privateConstructorUsedError; // 经度
  double get latitude => throw _privateConstructorUsedError; // 纬度
  String get locationName => throw _privateConstructorUsedError; // 出生地点
  bool get isLMT => throw _privateConstructorUsedError;

  /// Serializes this BirthData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BirthData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BirthDataCopyWith<BirthData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BirthDataCopyWith<$Res> {
  factory $BirthDataCopyWith(BirthData value, $Res Function(BirthData) then) =
      _$BirthDataCopyWithImpl<$Res, BirthData>;
  @useResult
  $Res call({
    DateTime birthTime,
    Gender gender,
    double longitude,
    double latitude,
    String locationName,
    bool isLMT,
  });
}

/// @nodoc
class _$BirthDataCopyWithImpl<$Res, $Val extends BirthData>
    implements $BirthDataCopyWith<$Res> {
  _$BirthDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BirthData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? birthTime = null,
    Object? gender = null,
    Object? longitude = null,
    Object? latitude = null,
    Object? locationName = null,
    Object? isLMT = null,
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
            isLMT: null == isLMT
                ? _value.isLMT
                : isLMT // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BirthDataImplCopyWith<$Res>
    implements $BirthDataCopyWith<$Res> {
  factory _$$BirthDataImplCopyWith(
    _$BirthDataImpl value,
    $Res Function(_$BirthDataImpl) then,
  ) = __$$BirthDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime birthTime,
    Gender gender,
    double longitude,
    double latitude,
    String locationName,
    bool isLMT,
  });
}

/// @nodoc
class __$$BirthDataImplCopyWithImpl<$Res>
    extends _$BirthDataCopyWithImpl<$Res, _$BirthDataImpl>
    implements _$$BirthDataImplCopyWith<$Res> {
  __$$BirthDataImplCopyWithImpl(
    _$BirthDataImpl _value,
    $Res Function(_$BirthDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BirthData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? birthTime = null,
    Object? gender = null,
    Object? longitude = null,
    Object? latitude = null,
    Object? locationName = null,
    Object? isLMT = null,
  }) {
    return _then(
      _$BirthDataImpl(
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
        isLMT: null == isLMT
            ? _value.isLMT
            : isLMT // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BirthDataImpl implements _BirthData {
  const _$BirthDataImpl({
    required this.birthTime,
    this.gender = Gender.male,
    this.longitude = 120.0,
    this.latitude = 30.0,
    this.locationName = '北京',
    this.isLMT = true,
  });

  factory _$BirthDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BirthDataImplFromJson(json);

  @override
  final DateTime birthTime;
  // 出生时间（公历）
  @override
  @JsonKey()
  final Gender gender;
  // 性别
  @override
  @JsonKey()
  final double longitude;
  // 经度
  @override
  @JsonKey()
  final double latitude;
  // 纬度
  @override
  @JsonKey()
  final String locationName;
  // 出生地点
  @override
  @JsonKey()
  final bool isLMT;

  @override
  String toString() {
    return 'BirthData(birthTime: $birthTime, gender: $gender, longitude: $longitude, latitude: $latitude, locationName: $locationName, isLMT: $isLMT)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BirthDataImpl &&
            (identical(other.birthTime, birthTime) ||
                other.birthTime == birthTime) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.isLMT, isLMT) || other.isLMT == isLMT));
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
    isLMT,
  );

  /// Create a copy of BirthData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BirthDataImplCopyWith<_$BirthDataImpl> get copyWith =>
      __$$BirthDataImplCopyWithImpl<_$BirthDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BirthDataImplToJson(this);
  }
}

abstract class _BirthData implements BirthData {
  const factory _BirthData({
    required final DateTime birthTime,
    final Gender gender,
    final double longitude,
    final double latitude,
    final String locationName,
    final bool isLMT,
  }) = _$BirthDataImpl;

  factory _BirthData.fromJson(Map<String, dynamic> json) =
      _$BirthDataImpl.fromJson;

  @override
  DateTime get birthTime; // 出生时间（公历）
  @override
  Gender get gender; // 性别
  @override
  double get longitude; // 经度
  @override
  double get latitude; // 纬度
  @override
  String get locationName; // 出生地点
  @override
  bool get isLMT;

  /// Create a copy of BirthData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BirthDataImplCopyWith<_$BirthDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
