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

_$ZiweiOptionsImpl _$$ZiweiOptionsImplFromJson(Map<String, dynamic> json) =>
    _$ZiweiOptionsImpl(
      leapRule:
          $enumDecodeNullable(_$LeapMonthRuleEnumMap, json['leapRule']) ??
          LeapMonthRule.splitAt15,
      wuHuDunBasedOn:
          $enumDecodeNullable(_$BoundaryEnumMap, json['wuHuDunBasedOn']) ??
          Boundary.lunar,
      siHuaBasedOn:
          $enumDecodeNullable(_$BoundaryEnumMap, json['siHuaBasedOn']) ??
          Boundary.lunar,
      childhoodRule:
          $enumDecodeNullable(_$ChildhoodRoleEnumMap, json['childhoodRule']) ??
          ChildhoodRole.skip,
      flowLimitBasedOn:
          $enumDecodeNullable(_$BoundaryEnumMap, json['flowLimitBasedOn']) ??
          Boundary.lunar,
      siHuaMode:
          $enumDecodeNullable(_$ZiweiSiHuaModeEnumMap, json['siHuaMode']) ??
          ZiweiSiHuaMode.builtin,
      customSiHuaJson: json['customSiHuaJson'] as String? ?? '',
      flowStarDisplay: json['flowStarDisplay'] == null
          ? const ZiweiFlowStarDisplayOptions()
          : ZiweiFlowStarDisplayOptions.fromJson(
              json['flowStarDisplay'] as Map<String, dynamic>,
            ),
      animation: json['animation'] == null
          ? const ZiweiAnimationOptions()
          : ZiweiAnimationOptions.fromJson(
              json['animation'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$ZiweiOptionsImplToJson(_$ZiweiOptionsImpl instance) =>
    <String, dynamic>{
      'leapRule': _$LeapMonthRuleEnumMap[instance.leapRule]!,
      'wuHuDunBasedOn': _$BoundaryEnumMap[instance.wuHuDunBasedOn]!,
      'siHuaBasedOn': _$BoundaryEnumMap[instance.siHuaBasedOn]!,
      'childhoodRule': _$ChildhoodRoleEnumMap[instance.childhoodRule]!,
      'flowLimitBasedOn': _$BoundaryEnumMap[instance.flowLimitBasedOn]!,
      'siHuaMode': _$ZiweiSiHuaModeEnumMap[instance.siHuaMode]!,
      'customSiHuaJson': instance.customSiHuaJson,
      'flowStarDisplay': instance.flowStarDisplay,
      'animation': instance.animation,
    };

const _$LeapMonthRuleEnumMap = {
  LeapMonthRule.asPrevious: 'asPrevious',
  LeapMonthRule.asNext: 'asNext',
  LeapMonthRule.splitAt15: 'splitAt15',
};

const _$BoundaryEnumMap = {Boundary.lunar: 'lunar', Boundary.solar: 'solar'};

const _$ChildhoodRoleEnumMap = {
  ChildhoodRole.skip: 'skip',
  ChildhoodRole.regular: 'regular',
};

const _$ZiweiSiHuaModeEnumMap = {
  ZiweiSiHuaMode.builtin: 'builtin',
  ZiweiSiHuaMode.custom: 'custom',
};

_$DestinyProfileImpl _$$DestinyProfileImplFromJson(Map<String, dynamic> json) =>
    _$DestinyProfileImpl(
      birthInput: json['birthInput'] == null
          ? const BirthInput()
          : BirthInput.fromJson(json['birthInput'] as Map<String, dynamic>),
      gender:
          $enumDecodeNullable(_$GenderEnumMap, json['gender']) ?? Gender.male,
      language:
          $enumDecodeNullable(_$AppLanguageEnumMap, json['language']) ??
          AppLanguage.zhCN,
      baziOptions: json['baziOptions'] == null
          ? const BaziOptions()
          : BaziOptions.fromJson(json['baziOptions'] as Map<String, dynamic>),
      ziweiOptions: json['ziweiOptions'] == null
          ? const ZiweiOptions()
          : ZiweiOptions.fromJson(json['ziweiOptions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DestinyProfileImplToJson(
  _$DestinyProfileImpl instance,
) => <String, dynamic>{
  'birthInput': instance.birthInput,
  'gender': _$GenderEnumMap[instance.gender]!,
  'language': _$AppLanguageEnumMap[instance.language]!,
  'baziOptions': instance.baziOptions,
  'ziweiOptions': instance.ziweiOptions,
};

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};

const _$AppLanguageEnumMap = {
  AppLanguage.zhCN: 'zhCN',
  AppLanguage.zhTW: 'zhTW',
  AppLanguage.en: 'en',
};
