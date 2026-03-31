import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bazi_core/bazi_core.dart'; 
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart'; 
import '../core/l10n.dart'; // ✅ 补上翻译层引用
import 'package:ziwei_core/ziwei_core.dart';

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

class ZiweiFlowStarDisplayOptions {
  final bool showBoshi12;
  final bool showSuijian12;
  final bool showJiangqian12;

  const ZiweiFlowStarDisplayOptions({
    this.showBoshi12 = false,
    this.showSuijian12 = true,
    this.showJiangqian12 = true,
  });

  ZiweiFlowStarDisplayOptions copyWith({
    bool? showBoshi12,
    bool? showSuijian12,
    bool? showJiangqian12,
  }) {
    return ZiweiFlowStarDisplayOptions(
      showBoshi12: showBoshi12 ?? this.showBoshi12,
      showSuijian12: showSuijian12 ?? this.showSuijian12,
      showJiangqian12: showJiangqian12 ?? this.showJiangqian12,
    );
  }

  factory ZiweiFlowStarDisplayOptions.fromJson(Map<String, dynamic> json) {
    return ZiweiFlowStarDisplayOptions(
      showBoshi12: json['showBoshi12'] as bool? ?? false,
      showSuijian12: json['showSuijian12'] as bool? ?? true,
      showJiangqian12: json['showJiangqian12'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'showBoshi12': showBoshi12,
    'showSuijian12': showSuijian12,
    'showJiangqian12': showJiangqian12,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZiweiFlowStarDisplayOptions &&
          other.showBoshi12 == showBoshi12 &&
          other.showSuijian12 == showSuijian12 &&
          other.showJiangqian12 == showJiangqian12;

  @override
  int get hashCode => Object.hash(showBoshi12, showSuijian12, showJiangqian12);
}

class ZiweiAnimationOptions {
  final bool enableFlyingStarHighlightFrame;
  final bool enableFlyingStarArrow;

  const ZiweiAnimationOptions({
    this.enableFlyingStarHighlightFrame = true,
    this.enableFlyingStarArrow = false,
  });

  ZiweiAnimationOptions copyWith({
    bool? enableFlyingStarHighlightFrame,
    bool? enableFlyingStarArrow,
  }) {
    return ZiweiAnimationOptions(
      enableFlyingStarHighlightFrame: enableFlyingStarHighlightFrame ??
          this.enableFlyingStarHighlightFrame,
      enableFlyingStarArrow:
          enableFlyingStarArrow ?? this.enableFlyingStarArrow,
    );
  }

  factory ZiweiAnimationOptions.fromJson(Map<String, dynamic> json) {
    return ZiweiAnimationOptions(
      enableFlyingStarHighlightFrame:
          json['enableFlyingStarHighlightFrame'] as bool? ?? true,
      enableFlyingStarArrow: json['enableFlyingStarArrow'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'enableFlyingStarHighlightFrame': enableFlyingStarHighlightFrame,
    'enableFlyingStarArrow': enableFlyingStarArrow,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZiweiAnimationOptions &&
          other.enableFlyingStarHighlightFrame ==
              enableFlyingStarHighlightFrame &&
          other.enableFlyingStarArrow == enableFlyingStarArrow;

  @override
  int get hashCode =>
      Object.hash(enableFlyingStarHighlightFrame, enableFlyingStarArrow);
}

@freezed
class ZiweiOptions with _$ZiweiOptions {
  const factory ZiweiOptions({
    @Default(LeapMonthRule.splitAt15) LeapMonthRule leapRule,
    @Default(Boundary.lunar) Boundary wuHuDunBasedOn,
    @Default(Boundary.lunar) Boundary siHuaBasedOn,
    @Default(ChildhoodRole.skip) ChildhoodRole childhoodRule,
    @Default(Boundary.lunar) Boundary flowLimitBasedOn,
    @Default(ZiweiFlowStarDisplayOptions()) ZiweiFlowStarDisplayOptions flowStarDisplay,
    @Default(ZiweiAnimationOptions()) ZiweiAnimationOptions animation,
  }) = _ZiweiOptions;

  factory ZiweiOptions.fromJson(Map<String, dynamic> json) => _$ZiweiOptionsFromJson(json);
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
    @Default(RatHourMode.noSplit) RatHourMode ratHourMode,
    @Default(AppLanguage.zhCN) AppLanguage language, 
    
    @Default(BaziOptions()) BaziOptions baziOptions,
    @Default(ZiweiOptions()) ZiweiOptions ziweiOptions,
  }) = _DestinyProfile;

  factory DestinyProfile.fromJson(Map<String, dynamic> json) => _$DestinyProfileFromJson(json);
}
