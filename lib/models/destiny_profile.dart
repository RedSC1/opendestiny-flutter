import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bazi_core/bazi_core.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../core/l10n.dart'; // ✅ 补上翻译层引用
import 'package:ziwei_core/ziwei_core.dart';

part 'destiny_profile.freezed.dart';
part 'destiny_profile.g.dart';

enum BirthCalendarType { solar, lunar }

BirthCalendarType? _birthCalendarTypeFromJson(Object? value) {
  switch (value) {
    case 'solar':
      return BirthCalendarType.solar;
    case 'lunar':
      return BirthCalendarType.lunar;
    default:
      return null;
  }
}

String _birthCalendarTypeToJson(BirthCalendarType value) {
  switch (value) {
    case BirthCalendarType.solar:
      return 'solar';
    case BirthCalendarType.lunar:
      return 'lunar';
  }
}

RatHourMode? _ratHourModeFromJson(Object? value) {
  switch (value) {
    case 'noSplit':
      return RatHourMode.noSplit;
    case 'todayGan':
      return RatHourMode.todayGan;
    case 'tomorrowGan':
      return RatHourMode.tomorrowGan;
    default:
      return null;
  }
}

String _ratHourModeToJson(RatHourMode value) {
  switch (value) {
    case RatHourMode.noSplit:
      return 'noSplit';
    case RatHourMode.todayGan:
      return 'todayGan';
    case RatHourMode.tomorrowGan:
      return 'tomorrowGan';
  }
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _formatLunarDayLabel(int day) {
  if (AppL10nSettings.currentLanguage == AppLanguage.en) {
    return 'Day $day';
  }
  if (day <= 0 || day > 30) {
    return day.toString();
  }
  if (day == 10) return '初十';
  if (day == 20) return '二十';
  if (day == 30) return '三十';
  const units = ['', '一', '二', '三', '四', '五', '六', '七', '八', '九'];
  if (day < 10) return '初${units[day]}';
  if (day < 20) return '十${units[day % 10]}';
  return '廿${units[day % 10]}';
}

String _formatCaseLunarMonth(LunarBirthInput lunar) {
  final raw = lunar.month.trim();
  final hasLeapPrefix = raw.startsWith('闰') || raw.startsWith('閏');
  if (lunar.isLeap && !hasLeapPrefix) {
    return '${'闰'.tr}$raw';
  }
  return raw;
}

class TimePackConfig {
  final double longitude;
  final double latitude;
  final String locationName;
  final double timeZone;

  const TimePackConfig({
    this.longitude = 120.0,
    this.latitude = 30.0,
    this.locationName = '中国标准时间',
    this.timeZone = 8.0,
  });

  TimePackConfig copyWith({
    double? longitude,
    double? latitude,
    String? locationName,
    double? timeZone,
  }) {
    return TimePackConfig(
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      locationName: locationName ?? this.locationName,
      timeZone: timeZone ?? this.timeZone,
    );
  }

  factory TimePackConfig.fromJson(Map<String, dynamic> json) {
    return TimePackConfig(
      longitude: (json['longitude'] as num?)?.toDouble() ?? 120.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 30.0,
      locationName: json['locationName'] as String? ?? '中国标准时间',
      timeZone: (json['timeZone'] as num?)?.toDouble() ?? 8.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'longitude': longitude,
    'latitude': latitude,
    'locationName': locationName,
    'timeZone': timeZone,
  };

  Location get location => Location(longitude, latitude);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimePackConfig &&
          other.longitude == longitude &&
          other.latitude == latitude &&
          other.locationName == locationName &&
          other.timeZone == timeZone;

  @override
  int get hashCode => Object.hash(longitude, latitude, locationName, timeZone);
}

class SolarBirthInput {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;

  const SolarBirthInput({
    required this.year,
    required this.month,
    required this.day,
    this.hour = 0,
    this.minute = 0,
    this.second = 0,
  });

  factory SolarBirthInput.now() {
    final now = DateTime.now();
    return SolarBirthInput(
      year: now.year,
      month: now.month,
      day: now.day,
      hour: now.hour,
      minute: now.minute,
      second: now.second,
    );
  }

  SolarBirthInput copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
  }) {
    return SolarBirthInput(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      second: second ?? this.second,
    );
  }

  factory SolarBirthInput.fromJson(Map<String, dynamic> json) {
    return SolarBirthInput(
      year: json['year'] as int? ?? DateTime.now().year,
      month: json['month'] as int? ?? DateTime.now().month,
      day: json['day'] as int? ?? DateTime.now().day,
      hour: json['hour'] as int? ?? 0,
      minute: json['minute'] as int? ?? 0,
      second: json['second'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month,
    'day': day,
    'hour': hour,
    'minute': minute,
    'second': second,
  };

  AstroDateTime toAstroDateTime() =>
      AstroDateTime(year, month, day, hour, minute, second);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SolarBirthInput &&
          other.year == year &&
          other.month == month &&
          other.day == day &&
          other.hour == hour &&
          other.minute == minute &&
          other.second == second;

  @override
  int get hashCode => Object.hash(year, month, day, hour, minute, second);
}

class LunarBirthInput {
  final int year;
  final String month;
  final int day;
  final int hour;
  final int minute;
  final int second;
  final bool isLeap;

  const LunarBirthInput({
    required this.year,
    required this.month,
    required this.day,
    this.hour = 0,
    this.minute = 0,
    this.second = 0,
    this.isLeap = false,
  });

  LunarBirthInput copyWith({
    int? year,
    String? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    bool? isLeap,
  }) {
    return LunarBirthInput(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      second: second ?? this.second,
      isLeap: isLeap ?? this.isLeap,
    );
  }

  factory LunarBirthInput.fromJson(Map<String, dynamic> json) {
    return LunarBirthInput(
      year: json['year'] as int? ?? DateTime.now().year,
      month: json['month'] as String? ?? '正',
      day: json['day'] as int? ?? 1,
      hour: json['hour'] as int? ?? 0,
      minute: json['minute'] as int? ?? 0,
      second: json['second'] as int? ?? 0,
      isLeap: json['isLeap'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month,
    'day': day,
    'hour': hour,
    'minute': minute,
    'second': second,
    'isLeap': isLeap,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LunarBirthInput &&
          other.year == year &&
          other.month == month &&
          other.day == day &&
          other.hour == hour &&
          other.minute == minute &&
          other.second == second &&
          other.isLeap == isLeap;

  @override
  int get hashCode =>
      Object.hash(year, month, day, hour, minute, second, isLeap);
}

class BirthInput {
  final BirthCalendarType calendarType;
  final SolarBirthInput solar;
  final LunarBirthInput lunar;
  final TimePackConfig timeConfig;

  const BirthInput({
    this.calendarType = BirthCalendarType.solar,
    this.solar = const SolarBirthInput(year: 2000, month: 1, day: 1, hour: 12),
    this.lunar = const LunarBirthInput(
      year: 2000,
      month: '正',
      day: 1,
      hour: 12,
    ),
    this.timeConfig = const TimePackConfig(),
  });

  factory BirthInput.now() {
    return BirthInput(solar: SolarBirthInput.now());
  }

  BirthInput copyWith({
    BirthCalendarType? calendarType,
    SolarBirthInput? solar,
    LunarBirthInput? lunar,
    TimePackConfig? timeConfig,
    double? longitude,
    double? latitude,
    String? locationName,
    double? timeZone,
  }) {
    return BirthInput(
      calendarType: calendarType ?? this.calendarType,
      solar: solar ?? this.solar,
      lunar: lunar ?? this.lunar,
      timeConfig: (timeConfig ?? this.timeConfig).copyWith(
        longitude: longitude,
        latitude: latitude,
        locationName: locationName,
        timeZone: timeZone,
      ),
    );
  }

  factory BirthInput.fromJson(Map<String, dynamic> json) {
    final legacyTimeConfig = TimePackConfig(
      longitude: (json['longitude'] as num?)?.toDouble() ?? 120.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 30.0,
      locationName: json['locationName'] as String? ?? '中国标准时间',
      timeZone: (json['timeZone'] as num?)?.toDouble() ?? 8.0,
    );

    return BirthInput(
      calendarType:
          _birthCalendarTypeFromJson(json['calendarType']) ??
          BirthCalendarType.solar,
      solar: json['solar'] == null
          ? BirthInput.now().solar
          : SolarBirthInput.fromJson(json['solar'] as Map<String, dynamic>),
      lunar: json['lunar'] == null
          ? const LunarBirthInput(year: 2000, month: '正', day: 1, hour: 12)
          : LunarBirthInput.fromJson(json['lunar'] as Map<String, dynamic>),
      timeConfig: json['timeConfig'] == null
          ? legacyTimeConfig
          : TimePackConfig.fromJson(json['timeConfig'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'calendarType': _birthCalendarTypeToJson(calendarType),
    'solar': solar.toJson(),
    'lunar': lunar.toJson(),
    'timeConfig': timeConfig.toJson(),
  };

  double get longitude => timeConfig.longitude;

  double get latitude => timeConfig.latitude;

  String get locationName => timeConfig.locationName;

  double get timeZone => timeConfig.timeZone;

  Location get location => timeConfig.location;

  LunarDate get rawLunarDate => LunarDate.fromString(
    lunar.year,
    lunar.month,
    lunar.day,
    isLeap: lunar.isLeap,
  );

  AstroDateTime get lunarClockTime {
    final base = rawLunarDate.toSolar;
    return AstroDateTime(
      base.year,
      base.month,
      base.day,
      lunar.hour,
      lunar.minute,
      lunar.second,
    );
  }

  AstroDateTime get activeClockTime => calendarType == BirthCalendarType.lunar
      ? lunarClockTime
      : solar.toAstroDateTime();

  String caseSummaryText(bool useAstronomical) {
    if (calendarType == BirthCalendarType.lunar) {
      final yearStr = lunar.year.formatYear(useAstronomical);
      return '${'农历'.tr} $yearStr${'年'.tr} ${_formatCaseLunarMonth(lunar)}${'月'.tr} ${_formatLunarDayLabel(lunar.day)} ${_twoDigits(lunar.hour)}:${_twoDigits(lunar.minute)}';
    }

    final yearStr = solar.year.formatYear(useAstronomical);
    if (AppL10nSettings.currentLanguage == AppLanguage.en) {
      return '${'Solar'.tr} $yearStr-${_twoDigits(solar.month)}-${_twoDigits(solar.day)} ${_twoDigits(solar.hour)}:${_twoDigits(solar.minute)}';
    }
    return '${'公历'.tr} $yearStr-${_twoDigits(solar.month)}-${_twoDigits(solar.day)} ${_twoDigits(solar.hour)}:${_twoDigits(solar.minute)}';
  }

  TimePack toTimePack({
    required bool useTrueSolarTime,
    required RatHourMode ratHourMode,
  }) {
    return TimePack.createBySolarTime(
      clockTime: activeClockTime,
      timezone: timeZone,
      location: location,
      ratHourMode: ratHourMode,
      useTrueSolarTime: useTrueSolarTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BirthInput &&
          other.calendarType == calendarType &&
          other.solar == solar &&
          other.lunar == lunar &&
          other.timeConfig == timeConfig;

  @override
  int get hashCode => Object.hash(calendarType, solar, lunar, timeConfig);
}

@freezed
class BaziOptions with _$BaziOptions {
  const factory BaziOptions({
    @Default(SiLingVersion.sanMingTongHui) SiLingVersion siLingVersion,
    @Default(DaYunAlgorithm.precise120) DaYunAlgorithm daYunAlgorithm,
    @Default(EarthPalaceAlgorithm.fireEarth)
    EarthPalaceAlgorithm earthPalaceAlgorithm,
  }) = _BaziOptions;

  factory BaziOptions.fromJson(Map<String, dynamic> json) =>
      _$BaziOptionsFromJson(json);
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
  final bool enablePalaceHighlightEffect;

  const ZiweiAnimationOptions({
    this.enableFlyingStarHighlightFrame = true,
    this.enableFlyingStarArrow = false,
    this.enablePalaceHighlightEffect = true,
  });

  ZiweiAnimationOptions copyWith({
    bool? enableFlyingStarHighlightFrame,
    bool? enableFlyingStarArrow,
    bool? enablePalaceHighlightEffect,
  }) {
    return ZiweiAnimationOptions(
      enableFlyingStarHighlightFrame:
          enableFlyingStarHighlightFrame ?? this.enableFlyingStarHighlightFrame,
      enableFlyingStarArrow:
          enableFlyingStarArrow ?? this.enableFlyingStarArrow,
      enablePalaceHighlightEffect:
          enablePalaceHighlightEffect ?? this.enablePalaceHighlightEffect,
    );
  }

  factory ZiweiAnimationOptions.fromJson(Map<String, dynamic> json) {
    return ZiweiAnimationOptions(
      enableFlyingStarHighlightFrame:
          json['enableFlyingStarHighlightFrame'] as bool? ?? true,
      enableFlyingStarArrow: json['enableFlyingStarArrow'] as bool? ?? false,
      enablePalaceHighlightEffect:
          json['enablePalaceHighlightEffect'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'enableFlyingStarHighlightFrame': enableFlyingStarHighlightFrame,
    'enableFlyingStarArrow': enableFlyingStarArrow,
    'enablePalaceHighlightEffect': enablePalaceHighlightEffect,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZiweiAnimationOptions &&
          other.enableFlyingStarHighlightFrame ==
              enableFlyingStarHighlightFrame &&
          other.enableFlyingStarArrow == enableFlyingStarArrow &&
          other.enablePalaceHighlightEffect == enablePalaceHighlightEffect;

  @override
  int get hashCode => Object.hash(
    enableFlyingStarHighlightFrame,
    enableFlyingStarArrow,
    enablePalaceHighlightEffect,
  );
}

class ZiweiModeDisplayOptions {
  final bool showCenterBazi;
  final bool showBodyPalace;
  final bool showLaiYinPalace;
  final ZiweiAnimationOptions animation;

  const ZiweiModeDisplayOptions({
    this.showCenterBazi = true,
    this.showBodyPalace = true,
    this.showLaiYinPalace = false,
    this.animation = const ZiweiAnimationOptions(),
  });

  ZiweiModeDisplayOptions copyWith({
    bool? showCenterBazi,
    bool? showBodyPalace,
    bool? showLaiYinPalace,
    ZiweiAnimationOptions? animation,
  }) {
    return ZiweiModeDisplayOptions(
      showCenterBazi: showCenterBazi ?? this.showCenterBazi,
      showBodyPalace: showBodyPalace ?? this.showBodyPalace,
      showLaiYinPalace: showLaiYinPalace ?? this.showLaiYinPalace,
      animation: animation ?? this.animation,
    );
  }

  factory ZiweiModeDisplayOptions.fromJson(Map<String, dynamic> json) {
    return ZiweiModeDisplayOptions(
      showCenterBazi: json['showCenterBazi'] as bool? ?? true,
      showBodyPalace: json['showBodyPalace'] as bool? ?? true,
      showLaiYinPalace: json['showLaiYinPalace'] as bool? ?? false,
      animation: json['animation'] == null
          ? const ZiweiAnimationOptions()
          : ZiweiAnimationOptions.fromJson(
              json['animation'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    'showCenterBazi': showCenterBazi,
    'showBodyPalace': showBodyPalace,
    'showLaiYinPalace': showLaiYinPalace,
    'animation': animation.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZiweiModeDisplayOptions &&
          other.showCenterBazi == showCenterBazi &&
          other.showBodyPalace == showBodyPalace &&
          other.showLaiYinPalace == showLaiYinPalace &&
          other.animation == animation;

  @override
  int get hashCode =>
      Object.hash(showCenterBazi, showBodyPalace, showLaiYinPalace, animation);
}

enum ZiweiCustomProfileType { siHua, brightness, stars }

class ZiweiCustomProfile {
  final String id;
  final String name;
  final String json;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ZiweiCustomProfile({
    required this.id,
    required this.name,
    required this.json,
    required this.createdAt,
    required this.updatedAt,
  });

  ZiweiCustomProfile copyWith({
    String? id,
    String? name,
    String? json,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ZiweiCustomProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      json: json ?? this.json,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ZiweiCustomProfile.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return ZiweiCustomProfile(
      id: json['id'] as String? ?? 'profile_${now.microsecondsSinceEpoch}',
      name: json['name'] as String? ?? '未命名流派',
      json: json['json'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? now,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? now,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'json': json,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZiweiCustomProfile &&
          other.id == id &&
          other.name == name &&
          other.json == json &&
          other.createdAt == createdAt &&
          other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(id, name, json, createdAt, updatedAt);
}

enum ZiweiSiHuaMode { builtin, custom }

enum ZiweiBrightnessMode { builtin, custom }

enum ZiweiStarsMode { builtin, custom }

@freezed
class ZiweiOptions with _$ZiweiOptions {
  const factory ZiweiOptions({
    @Default(LeapMonthRule.splitAt15) LeapMonthRule leapRule,
    @Default(Boundary.lunar) Boundary wuHuDunBasedOn,
    @Default(Boundary.lunar) Boundary siHuaBasedOn,
    @Default(ChildhoodRole.skip) ChildhoodRole childhoodRule,
    @Default(Boundary.lunar) Boundary flowLimitBasedOn,
    @Default(ZiweiSiHuaMode.builtin) ZiweiSiHuaMode siHuaMode,
    @Default('') String customSiHuaJson,
    @Default(<ZiweiCustomProfile>[]) List<ZiweiCustomProfile> siHuaProfiles,
    @Default('') String activeSiHuaProfileId,
    @Default(ZiweiBrightnessMode.builtin) ZiweiBrightnessMode brightnessMode,
    @Default('') String customBrightnessJson,
    @Default(<ZiweiCustomProfile>[]) List<ZiweiCustomProfile> brightnessProfiles,
    @Default('') String activeBrightnessProfileId,
    @Default(ZiweiStarsMode.builtin) ZiweiStarsMode starsMode,
    @Default('') String customStarsJson,
    @Default(<ZiweiCustomProfile>[]) List<ZiweiCustomProfile> starsProfiles,
    @Default('') String activeStarsProfileId,
    @Default(ZiweiModeDisplayOptions(
      showCenterBazi: false,
      showBodyPalace: false,
      showLaiYinPalace: true,
    ))
    ZiweiModeDisplayOptions sihuaDisplay,
    @Default(ZiweiModeDisplayOptions(
      showBodyPalace: false,
      showLaiYinPalace: true,
    ))
    ZiweiModeDisplayOptions flyingDisplay,
    @Default(true) bool showCenterBazi,
    @Default(true) bool showBodyPalace,
    @Default(false) bool showLaiYinPalace,
    @Default(false) bool hideCenterBirthInfo,
    @Default(true) bool enableHistorical,
    @Default(ZiweiFlowStarDisplayOptions())
    ZiweiFlowStarDisplayOptions flowStarDisplay,
    @Default(ZiweiAnimationOptions()) ZiweiAnimationOptions animation,
  }) = _ZiweiOptions;

  factory ZiweiOptions.fromJson(Map<String, dynamic> json) =>
      _$ZiweiOptionsFromJson(json);
}

class AppSettings {
  final AppLanguage language;
  final bool useTrueSolarTime;
  final bool useAstronomicalYear;
  final RatHourMode ratHourMode;
  final BaziOptions baziOptions;
  final ZiweiOptions ziweiOptions;

  const AppSettings({
    this.language = AppLanguage.zhCN,
    this.useTrueSolarTime = true,
    this.useAstronomicalYear = true,
    this.ratHourMode = RatHourMode.noSplit,
    this.baziOptions = const BaziOptions(),
    this.ziweiOptions = const ZiweiOptions(),
  });

  AppSettings copyWith({
    AppLanguage? language,
    bool? useTrueSolarTime,
    bool? useAstronomicalYear,
    RatHourMode? ratHourMode,
    BaziOptions? baziOptions,
    ZiweiOptions? ziweiOptions,
  }) {
    return AppSettings(
      language: language ?? this.language,
      useTrueSolarTime: useTrueSolarTime ?? this.useTrueSolarTime,
      useAstronomicalYear: useAstronomicalYear ?? this.useAstronomicalYear,
      ratHourMode: ratHourMode ?? this.ratHourMode,
      baziOptions: baziOptions ?? this.baziOptions,
      ziweiOptions: ziweiOptions ?? this.ziweiOptions,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      language:
          $enumDecodeNullable(_$AppLanguageEnumMap, json['language']) ??
          AppLanguage.zhCN,
      useTrueSolarTime: json['useTrueSolarTime'] as bool? ?? true,
      useAstronomicalYear: json['useAstronomicalYear'] as bool? ?? true,
      ratHourMode:
          _ratHourModeFromJson(json['ratHourMode']) ?? RatHourMode.noSplit,
      baziOptions: json['baziOptions'] == null
          ? const BaziOptions()
          : BaziOptions.fromJson(json['baziOptions'] as Map<String, dynamic>),
      ziweiOptions: json['ziweiOptions'] == null
          ? const ZiweiOptions()
          : ZiweiOptions.fromJson(json['ziweiOptions'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'language': _$AppLanguageEnumMap[language]!,
    'useTrueSolarTime': useTrueSolarTime,
    'useAstronomicalYear': useAstronomicalYear,
    'ratHourMode': _ratHourModeToJson(ratHourMode),
    'baziOptions': baziOptions.toJson(),
    'ziweiOptions': ziweiOptions.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          other.language == language &&
          other.useTrueSolarTime == useTrueSolarTime &&
          other.ratHourMode == ratHourMode &&
          other.baziOptions == baziOptions &&
          other.ziweiOptions == ziweiOptions;

  @override
  int get hashCode => Object.hash(
    language,
    useTrueSolarTime,
    ratHourMode,
    baziOptions,
    ziweiOptions,
  );
}

class DestinyCase {
  final String id;
  final String name;
  final BirthInput birthInput;
  final Gender gender;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;

  DestinyCase({
    required this.id,
    this.name = '未命名案例',
    this.birthInput = const BirthInput(),
    this.gender = Gender.male,
    this.note = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? createdAt ?? DateTime.now();

  factory DestinyCase.initial({String id = 'default', String name = '默认案例'}) {
    final now = DateTime.now();
    return DestinyCase(
      id: id,
      name: name,
      birthInput: BirthInput.now(),
      createdAt: now,
      updatedAt: now,
    );
  }

  DestinyCase copyWith({
    String? id,
    String? name,
    BirthInput? birthInput,
    Gender? gender,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool touchUpdatedAt = false,
  }) {
    return DestinyCase(
      id: id ?? this.id,
      name: name ?? this.name,
      birthInput: birthInput ?? this.birthInput,
      gender: gender ?? this.gender,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt:
          updatedAt ?? (touchUpdatedAt ? DateTime.now() : this.updatedAt),
    );
  }

  factory DestinyCase.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return DestinyCase(
      id: json['id'] as String? ?? 'default',
      name: json['name'] as String? ?? '未命名案例',
      birthInput: json['birthInput'] == null
          ? BirthInput.now()
          : BirthInput.fromJson(json['birthInput'] as Map<String, dynamic>),
      gender:
          $enumDecodeNullable(_$GenderEnumMap, json['gender']) ?? Gender.male,
      note: json['note'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? now,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? now,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'birthInput': birthInput.toJson(),
    'gender': _$GenderEnumMap[gender]!,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  CaseSummary toSummary() => CaseSummary(
    id: id,
    name: name,
    birthInput: birthInput,
    note: note,
    updatedAt: updatedAt,
  );

  factory DestinyCase.fromProfile(
    DestinyProfile profile, {
    String id = 'default',
    String name = '默认案例',
    String note = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DestinyCase(
      id: id,
      name: name,
      birthInput: profile.birthInput,
      gender: profile.gender,
      note: note,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DestinyCase &&
          other.id == id &&
          other.name == name &&
          other.birthInput == birthInput &&
          other.gender == gender &&
          other.note == note &&
          other.createdAt == createdAt &&
          other.updatedAt == updatedAt;

  @override
  int get hashCode =>
      Object.hash(id, name, birthInput, gender, note, createdAt, updatedAt);
}

class CaseSummary {
  final String id;
  final String name;
  final BirthInput birthInput;
  final String? note;
  final DateTime updatedAt;

  const CaseSummary({
    required this.id,
    required this.name,
    required this.birthInput,
    this.note,
    required this.updatedAt,
  });

  String getSubtitle(bool useAstronomical) {
    if (note != null && note!.isNotEmpty) return note!;
    return birthInput.caseSummaryText(useAstronomical);
  }
}

class CurrentCaseState {
  final String? currentCaseId;
  final DestinyCase? currentCase;
  final bool isDirty;
  final bool isSaving;
  final String? errorMessage;

  const CurrentCaseState({
    this.currentCaseId,
    this.currentCase,
    this.isDirty = false,
    this.isSaving = false,
    this.errorMessage,
  });

  CurrentCaseState copyWith({
    String? currentCaseId,
    DestinyCase? currentCase,
    bool? isDirty,
    bool? isSaving,
    String? errorMessage,
  }) {
    return CurrentCaseState(
      currentCaseId: currentCaseId ?? this.currentCaseId,
      currentCase: currentCase ?? this.currentCase,
      isDirty: isDirty ?? this.isDirty,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@freezed
class DestinyProfile with _$DestinyProfile {
  const factory DestinyProfile({
    @Default(BirthInput()) BirthInput birthInput,
    @Default(Gender.male) Gender gender,
    @Default(AppLanguage.zhCN) AppLanguage language,

    @Default(BaziOptions()) BaziOptions baziOptions,
    @Default(ZiweiOptions()) ZiweiOptions ziweiOptions,
  }) = _DestinyProfile;

  factory DestinyProfile.fromJson(Map<String, dynamic> json) =>
      _$DestinyProfileFromJson(json);
}
