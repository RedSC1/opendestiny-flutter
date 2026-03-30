// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destiny_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BaziOptionsImpl _$$BaziOptionsImplFromJson(Map<String, dynamic> json) =>
    _$BaziOptionsImpl(
      siLingVersion:
          $enumDecodeNullable(_$SiLingVersionEnumMap, json['siLingVersion']) ??
          SiLingVersion.sanMingTongHui,
      daYunAlgorithm:
          $enumDecodeNullable(
            _$DaYunAlgorithmEnumMap,
            json['daYunAlgorithm'],
          ) ??
          DaYunAlgorithm.precise120,
      earthPalaceAlgorithm:
          $enumDecodeNullable(
            _$EarthPalaceAlgorithmEnumMap,
            json['earthPalaceAlgorithm'],
          ) ??
          EarthPalaceAlgorithm.fireEarth,
    );

Map<String, dynamic> _$$BaziOptionsImplToJson(_$BaziOptionsImpl instance) =>
    <String, dynamic>{
      'siLingVersion': _$SiLingVersionEnumMap[instance.siLingVersion]!,
      'daYunAlgorithm': _$DaYunAlgorithmEnumMap[instance.daYunAlgorithm]!,
      'earthPalaceAlgorithm':
          _$EarthPalaceAlgorithmEnumMap[instance.earthPalaceAlgorithm]!,
    };

const _$SiLingVersionEnumMap = {
  SiLingVersion.sanMingTongHui: 'sanMingTongHui',
  SiLingVersion.common: 'common',
};

const _$DaYunAlgorithmEnumMap = {DaYunAlgorithm.precise120: 'precise120'};

const _$EarthPalaceAlgorithmEnumMap = {
  EarthPalaceAlgorithm.fireEarth: 'fireEarth',
  EarthPalaceAlgorithm.waterEarth: 'waterEarth',
};

_$DestinyProfileImpl _$$DestinyProfileImplFromJson(Map<String, dynamic> json) =>
    _$DestinyProfileImpl(
      birthTime: DateTime.parse(json['birthTime'] as String),
      gender:
          $enumDecodeNullable(_$GenderEnumMap, json['gender']) ?? Gender.male,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 120.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 30.0,
      locationName: json['locationName'] as String? ?? '北京',
      useTrueSolarTime: json['useTrueSolarTime'] as bool? ?? true,
      ratHourMode:
          $enumDecodeNullable(_$RatHourModeEnumMap, json['ratHourMode']) ??
          RatHourMode.noSplit,
      language:
          $enumDecodeNullable(_$AppLanguageEnumMap, json['language']) ??
          AppLanguage.zhCN,
      baziOptions: json['baziOptions'] == null
          ? const BaziOptions()
          : BaziOptions.fromJson(json['baziOptions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DestinyProfileImplToJson(
  _$DestinyProfileImpl instance,
) => <String, dynamic>{
  'birthTime': instance.birthTime.toIso8601String(),
  'gender': _$GenderEnumMap[instance.gender]!,
  'longitude': instance.longitude,
  'latitude': instance.latitude,
  'locationName': instance.locationName,
  'useTrueSolarTime': instance.useTrueSolarTime,
  'ratHourMode': _$RatHourModeEnumMap[instance.ratHourMode]!,
  'language': _$AppLanguageEnumMap[instance.language]!,
  'baziOptions': instance.baziOptions,
};

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};

const _$RatHourModeEnumMap = {
  RatHourMode.noSplit: 'noSplit',
  RatHourMode.todayGan: 'todayGan',
  RatHourMode.tomorrowGan: 'tomorrowGan',
};

const _$AppLanguageEnumMap = {
  AppLanguage.zhCN: 'zhCN',
  AppLanguage.zhTW: 'zhTW',
  AppLanguage.en: 'en',
};
