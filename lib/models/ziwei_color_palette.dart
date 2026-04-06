import 'package:flutter/material.dart';
import 'package:ziwei_core/ziwei_core.dart';

enum ZiweiColorMode { classic, custom }

const Map<int, int> _defaultBrightnessColors = {
  6: 0xFFCC0000,
  5: 0xFFCC6600,
  4: 0xFF666666,
  3: 0xFF999999,
  2: 0xFFAAAAAA,
  1: 0xFF0066CC,
  0: 0xFF339933,
};

class ZiweiColorPalette {
  final int majorStar;
  final int luckyStar;
  final int badStar;
  final int minorStar;
  final int changsheng12;
  final int boshi12;
  final int suijian12;
  final int jiangqian12;

  final int sihuaLu;
  final int sihuaQuan;
  final int sihuaKe;
  final int sihuaJi;

  final Map<int, int> brightnessColors;

  final int scopeDecade;
  final int scopeSmallLimit;
  final int scopeYear;
  final int scopeMonth;
  final int scopeDay;
  final int scopeHour;

  const ZiweiColorPalette({
    this.majorStar = 0xFFC62828,
    this.luckyStar = 0xFF1B5E20,
    this.badStar = 0xFF111111,
    this.minorStar = 0xFF616161,
    this.changsheng12 = 0xFF9E9E9E,
    this.boshi12 = 0xFF616161,
    this.suijian12 = 0xFF616161,
    this.jiangqian12 = 0xFF616161,
    this.sihuaLu = 0xFF2E7D32,
    this.sihuaQuan = 0xFFEF6C00,
    this.sihuaKe = 0xFF1565C0,
    this.sihuaJi = 0xFFC62828,
    this.brightnessColors = _defaultBrightnessColors,
    this.scopeDecade = 0xFF2E7D32,
    this.scopeSmallLimit = 0xFF0288D1,
    this.scopeYear = 0xFF1565C0,
    this.scopeMonth = 0xFFEF6C00,
    this.scopeDay = 0xFF7E57C2,
    this.scopeHour = 0xFF607D8B,
  });

  factory ZiweiColorPalette.fromJson(Map<String, dynamic> json) {
    int readInt(String key, int fallback) {
      final value = json[key];
      return value is int ? value : fallback;
    }

    final brightnessColors = _readBrightnessColors(json);

    return ZiweiColorPalette(
      majorStar: readInt('majorStar', 0xFFC62828),
      luckyStar: readInt('luckyStar', 0xFF1B5E20),
      badStar: readInt('badStar', 0xFF111111),
      minorStar: readInt('minorStar', 0xFF616161),
      changsheng12: readInt('changsheng12', 0xFF9E9E9E),
      boshi12: readInt('boshi12', 0xFF616161),
      suijian12: readInt('suijian12', 0xFF616161),
      jiangqian12: readInt('jiangqian12', 0xFF616161),
      sihuaLu: readInt('sihuaLu', 0xFF2E7D32),
      sihuaQuan: readInt('sihuaQuan', 0xFFEF6C00),
      sihuaKe: readInt('sihuaKe', 0xFF1565C0),
      sihuaJi: readInt('sihuaJi', 0xFFC62828),
      brightnessColors: brightnessColors,
      scopeDecade: readInt('scopeDecade', 0xFF2E7D32),
      scopeSmallLimit: readInt('scopeSmallLimit', 0xFF0288D1),
      scopeYear: readInt('scopeYear', 0xFF1565C0),
      scopeMonth: readInt('scopeMonth', 0xFFEF6C00),
      scopeDay: readInt('scopeDay', 0xFF7E57C2),
      scopeHour: readInt('scopeHour', 0xFF607D8B),
    );
  }

  static Map<int, int> _readBrightnessColors(Map<String, dynamic> json) {
    final raw = json['brightnessColors'];
    if (raw is Map) {
      final parsed = <int, int>{};
      for (final entry in raw.entries) {
        final index = int.tryParse(entry.key.toString());
        final value = entry.value;
        if (index == null || value is! int) {
          continue;
        }
        parsed[index] = value;
      }
      if (parsed.isNotEmpty) {
        return parsed;
      }
    }

    final legacy = <int, int>{};
    void addLegacy(int index, String key, int fallback) {
      legacy[index] = json[key] is int ? json[key] as int : fallback;
    }

    if (json.containsKey('brightnessMiao') ||
        json.containsKey('brightnessWang') ||
        json.containsKey('brightnessDe') ||
        json.containsKey('brightnessLi') ||
        json.containsKey('brightnessPing') ||
        json.containsKey('brightnessBu') ||
        json.containsKey('brightnessXian')) {
      addLegacy(6, 'brightnessMiao', _defaultBrightnessColors[6]!);
      addLegacy(5, 'brightnessWang', _defaultBrightnessColors[5]!);
      addLegacy(4, 'brightnessDe', _defaultBrightnessColors[4]!);
      addLegacy(3, 'brightnessLi', _defaultBrightnessColors[3]!);
      addLegacy(2, 'brightnessPing', _defaultBrightnessColors[2]!);
      addLegacy(1, 'brightnessBu', _defaultBrightnessColors[1]!);
      addLegacy(0, 'brightnessXian', _defaultBrightnessColors[0]!);
      return legacy;
    }

    return _defaultBrightnessColors;
  }

  Map<String, dynamic> toJson() => {
    'majorStar': majorStar,
    'luckyStar': luckyStar,
    'badStar': badStar,
    'minorStar': minorStar,
    'changsheng12': changsheng12,
    'boshi12': boshi12,
    'suijian12': suijian12,
    'jiangqian12': jiangqian12,
    'sihuaLu': sihuaLu,
    'sihuaQuan': sihuaQuan,
    'sihuaKe': sihuaKe,
    'sihuaJi': sihuaJi,
    'brightnessColors': brightnessColors.map(
      (key, value) => MapEntry(key.toString(), value),
    ),
    'scopeDecade': scopeDecade,
    'scopeSmallLimit': scopeSmallLimit,
    'scopeYear': scopeYear,
    'scopeMonth': scopeMonth,
    'scopeDay': scopeDay,
    'scopeHour': scopeHour,
  };

  ZiweiColorPalette copyWith({
    int? majorStar,
    int? luckyStar,
    int? badStar,
    int? minorStar,
    int? changsheng12,
    int? boshi12,
    int? suijian12,
    int? jiangqian12,
    int? sihuaLu,
    int? sihuaQuan,
    int? sihuaKe,
    int? sihuaJi,
    Map<int, int>? brightnessColors,
    int? scopeDecade,
    int? scopeSmallLimit,
    int? scopeYear,
    int? scopeMonth,
    int? scopeDay,
    int? scopeHour,
  }) {
    return ZiweiColorPalette(
      majorStar: majorStar ?? this.majorStar,
      luckyStar: luckyStar ?? this.luckyStar,
      badStar: badStar ?? this.badStar,
      minorStar: minorStar ?? this.minorStar,
      changsheng12: changsheng12 ?? this.changsheng12,
      boshi12: boshi12 ?? this.boshi12,
      suijian12: suijian12 ?? this.suijian12,
      jiangqian12: jiangqian12 ?? this.jiangqian12,
      sihuaLu: sihuaLu ?? this.sihuaLu,
      sihuaQuan: sihuaQuan ?? this.sihuaQuan,
      sihuaKe: sihuaKe ?? this.sihuaKe,
      sihuaJi: sihuaJi ?? this.sihuaJi,
      brightnessColors: brightnessColors ?? this.brightnessColors,
      scopeDecade: scopeDecade ?? this.scopeDecade,
      scopeSmallLimit: scopeSmallLimit ?? this.scopeSmallLimit,
      scopeYear: scopeYear ?? this.scopeYear,
      scopeMonth: scopeMonth ?? this.scopeMonth,
      scopeDay: scopeDay ?? this.scopeDay,
      scopeHour: scopeHour ?? this.scopeHour,
    );
  }

  ZiweiColorPalette copyWithBrightnessColor(int index, int color) {
    return copyWith(
      brightnessColors: {
        ...brightnessColors,
        index: color,
      },
    );
  }

  Color get majorStarColor => Color(majorStar);
  Color get luckyStarColor => Color(luckyStar);
  Color get badStarColor => Color(badStar);
  Color get minorStarColor => Color(minorStar);
  Color get changsheng12Color => Color(changsheng12);
  Color get boshi12Color => Color(boshi12);
  Color get suijian12Color => Color(suijian12);
  Color get jiangqian12Color => Color(jiangqian12);
  Color get sihuaLuColor => Color(sihuaLu);
  Color get sihuaQuanColor => Color(sihuaQuan);
  Color get sihuaKeColor => Color(sihuaKe);
  Color get sihuaJiColor => Color(sihuaJi);
  Color get scopeDecadeColor => Color(scopeDecade);
  Color get scopeSmallLimitColor => Color(scopeSmallLimit);
  Color get scopeYearColor => Color(scopeYear);
  Color get scopeMonthColor => Color(scopeMonth);
  Color get scopeDayColor => Color(scopeDay);
  Color get scopeHourColor => Color(scopeHour);

  int brightnessColorValue(int index) {
    final custom = brightnessColors[index];
    if (custom != null) {
      return custom;
    }
    if (index < 0) {
      return minorStar;
    }
    if (index >= 6) {
      return _defaultBrightnessColors[6]!;
    }
    if (index == 0) {
      return _defaultBrightnessColors[0]!;
    }
    return _defaultBrightnessColors[index] ?? minorStar;
  }

  Color colorForBrightness(int index) => Color(brightnessColorValue(index));

  Color colorForScope(ZiweiScope scope) {
    switch (scope) {
      case ZiweiScope.origin:
        return majorStarColor;
      case ZiweiScope.decade:
        return scopeDecadeColor;
      case ZiweiScope.smallLimit:
        return scopeSmallLimitColor;
      case ZiweiScope.year:
        return scopeYearColor;
      case ZiweiScope.month:
        return scopeMonthColor;
      case ZiweiScope.day:
        return scopeDayColor;
      case ZiweiScope.hour:
        return scopeHourColor;
    }
  }

  Color colorForSihua(SiHuaType type) {
    switch (type) {
      case SiHuaType.lu:
        return sihuaLuColor;
      case SiHuaType.quan:
        return sihuaQuanColor;
      case SiHuaType.ke:
        return sihuaKeColor;
      case SiHuaType.ji:
        return sihuaJiColor;
    }
  }

  Color colorForStaticStarType(StarType type) {
    switch (type) {
      case StarType.major:
        return majorStarColor;
      case StarType.lucky:
        return luckyStarColor;
      case StarType.bad:
        return badStarColor;
      case StarType.changsheng12:
        return changsheng12Color;
      case StarType.boshi12:
        return boshi12Color;
      case StarType.suijian12:
        return suijian12Color;
      case StarType.jiangqian12:
        return jiangqian12Color;
      case StarType.minor:
      case StarType.other:
      case StarType.unknown:
        return minorStarColor;
      case StarType.flow:
        return scopeYearColor;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZiweiColorPalette &&
          other.majorStar == majorStar &&
          other.luckyStar == luckyStar &&
          other.badStar == badStar &&
          other.minorStar == minorStar &&
          other.changsheng12 == changsheng12 &&
          other.boshi12 == boshi12 &&
          other.suijian12 == suijian12 &&
          other.jiangqian12 == jiangqian12 &&
          other.sihuaLu == sihuaLu &&
          other.sihuaQuan == sihuaQuan &&
          other.sihuaKe == sihuaKe &&
          other.sihuaJi == sihuaJi &&
          _mapEquals(other.brightnessColors, brightnessColors) &&
          other.scopeDecade == scopeDecade &&
          other.scopeSmallLimit == scopeSmallLimit &&
          other.scopeYear == scopeYear &&
          other.scopeMonth == scopeMonth &&
          other.scopeDay == scopeDay &&
          other.scopeHour == scopeHour;

  @override
  int get hashCode => Object.hash(
    majorStar,
    luckyStar,
    badStar,
    minorStar,
    changsheng12,
    boshi12,
    suijian12,
    jiangqian12,
    sihuaLu,
    sihuaQuan,
    sihuaKe,
    sihuaJi,
    Object.hashAllUnordered(
      brightnessColors.entries.map((entry) => Object.hash(entry.key, entry.value)),
    ),
    scopeDecade,
    scopeSmallLimit,
    scopeYear,
    scopeMonth,
    scopeDay,
    scopeHour,
  );
}

bool _mapEquals(Map<int, int> a, Map<int, int> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (final entry in a.entries) {
    if (b[entry.key] != entry.value) {
      return false;
    }
  }
  return true;
}
