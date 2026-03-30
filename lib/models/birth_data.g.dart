// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'birth_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BirthDataImpl _$$BirthDataImplFromJson(Map<String, dynamic> json) =>
    _$BirthDataImpl(
      birthTime: DateTime.parse(json['birthTime'] as String),
      gender:
          $enumDecodeNullable(_$GenderEnumMap, json['gender']) ?? Gender.male,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 120.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 30.0,
      locationName: json['locationName'] as String? ?? '北京',
      isLMT: json['isLMT'] as bool? ?? true,
    );

Map<String, dynamic> _$$BirthDataImplToJson(_$BirthDataImpl instance) =>
    <String, dynamic>{
      'birthTime': instance.birthTime.toIso8601String(),
      'gender': _$GenderEnumMap[instance.gender]!,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'locationName': instance.locationName,
      'isLMT': instance.isLMT,
    };

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};
