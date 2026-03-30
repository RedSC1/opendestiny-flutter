import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bazi_core/bazi_core.dart'; 
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart'; 

part 'destiny_profile.freezed.dart';
part 'destiny_profile.g.dart';

@freezed
class BaziOptions with _$BaziOptions {
  const factory BaziOptions({
    @Default(SiLingVersion.sanMingTongHui) SiLingVersion siLingVersion,
    @Default(DaYunAlgorithm.precise120) DaYunAlgorithm daYunAlgorithm,
    @Default(EarthPalaceAlgorithm.fireEarth) EarthPalaceAlgorithm earthPalaceAlgorithm,
  }) = _BaziOptions;

  factory BaziOptions.fromJson(Map<String, dynamic> json) => _$BaziOptionsFromJson(json);
}

@freezed
class DestinyProfile with _$DestinyProfile {
  const factory DestinyProfile({
    required DateTime birthTime, 
    @Default(Gender.male) Gender gender,
    @Default(120.0) double longitude,
    @Default(30.0) double latitude,
    @Default('北京') String locationName,
    
    // --- 全局历法开关 ---
    @Default(true) bool useTrueSolarTime, 
    @Default(RatHourMode.noSplit) RatHourMode ratHourMode, // ✅ 升级为枚举模式
    
    @Default(BaziOptions()) BaziOptions baziOptions,
  }) = _DestinyProfile;

  factory DestinyProfile.fromJson(Map<String, dynamic> json) => _$DestinyProfileFromJson(json);
}
