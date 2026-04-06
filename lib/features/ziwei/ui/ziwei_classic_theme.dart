import 'package:flutter/material.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../../../core/ziwei_l10n.dart';
import '../../../core/ziwei_theme_runtime.dart';

class ZiweiClassicTheme {
  static Color get majorStarColor =>
      ZiweiThemeRuntime.activePalette.majorStarColor;
  static Color get luckyStarColor =>
      ZiweiThemeRuntime.activePalette.luckyStarColor;
  static Color get badStarColor => ZiweiThemeRuntime.activePalette.badStarColor;
  static Color get minorStarColor =>
      ZiweiThemeRuntime.activePalette.minorStarColor;
  static Color get changsheng12Color =>
      ZiweiThemeRuntime.activePalette.changsheng12Color;
  static Color get boshi12Color => ZiweiThemeRuntime.activePalette.boshi12Color;
  static Color get suijian12Color =>
      ZiweiThemeRuntime.activePalette.suijian12Color;
  static Color get jiangqian12Color =>
      ZiweiThemeRuntime.activePalette.jiangqian12Color;

  static Color get sihuaLu => ZiweiThemeRuntime.activePalette.sihuaLuColor;
  static Color get sihuaQuan => ZiweiThemeRuntime.activePalette.sihuaQuanColor;
  static Color get sihuaKe => ZiweiThemeRuntime.activePalette.sihuaKeColor;
  static Color get sihuaJi => ZiweiThemeRuntime.activePalette.sihuaJiColor;

  // --- 布局与功能色 ---
  static const Color palaceNameColor = Color(0xFFC62828); // 宫位名与主色一致
  static const Color decadeAgeColor = Color(0xFF546E7A); // 蓝灰色
  static const Color metaInfoColor = Color(0xFF37474F); // 中宫出生信息/辅助信息
  static const Color subLabelColor = Color(0xFF546E7A); // 大运副标题/年份信息
  static const Color ganzhiColor = Color(0xFFAF601A); // 大地棕
  static Color get changshengColor => changsheng12Color;
  static const Color cellBorderColor = Color(0xFFEEEEEE); // 极浅灰边框 (极细感)
  static const Color cellBgColor = Colors.white; // 纯白背景 (告别米黄)
  static const Color activeTimeBg = Color(0xFFF1F8E9); // 选中的流运背景 (淡绿)
  static const Color timeCellBorder = Color(0xFFECEFF1);
  static const Color timeRowLabelBg = Color(0xFFF5F5F5);

  static Color get scopeOrigin => palaceNameColor;
  static Color get scopeDecade => ZiweiThemeRuntime.activePalette.scopeDecadeColor;
  static Color get scopeSmallLimit =>
      ZiweiThemeRuntime.activePalette.scopeSmallLimitColor;
  static Color get scopeYear => ZiweiThemeRuntime.activePalette.scopeYearColor;
  static Color get scopeMonth => ZiweiThemeRuntime.activePalette.scopeMonthColor;
  static Color get scopeDay => ZiweiThemeRuntime.activePalette.scopeDayColor;
  static Color get scopeHour => ZiweiThemeRuntime.activePalette.scopeHourColor;

  static Color getScopeColor(ZiweiScope scope) {
    switch (scope) {
      case ZiweiScope.origin:
        return scopeOrigin;
      case ZiweiScope.decade:
        return scopeDecade;
      case ZiweiScope.smallLimit:
        return scopeSmallLimit;
      case ZiweiScope.year:
        return scopeYear;
      case ZiweiScope.month:
        return scopeMonth;
      case ZiweiScope.day:
        return scopeDay;
      case ZiweiScope.hour:
        return scopeHour;
    }
  }

  static Color getBrightnessColor(int index) {
    return ZiweiThemeRuntime.activePalette.colorForBrightness(index);
  }

  static Color getSihuaColor(SiHuaType type) => type == SiHuaType.lu
      ? sihuaLu
      : type == SiHuaType.quan
      ? sihuaQuan
      : type == SiHuaType.ke
      ? sihuaKe
      : sihuaJi;

  static Color getStarColor(Star star) {
    if (star is FlowStar) {
      return getScopeColor(star.scope);
    }
    switch (star.type) {
      case StarType.major:
        return majorStarColor;
      case StarType.lucky:
        return luckyStarColor;
      case StarType.bad:
        return badStarColor;
      case StarType.minor:
        return minorStarColor;
      case StarType.changsheng12:
        return changsheng12Color;
      case StarType.boshi12:
        return boshi12Color;
      case StarType.suijian12:
        return suijian12Color;
      case StarType.jiangqian12:
        return jiangqian12Color;
      case StarType.other:
        return minorStarColor;
      case StarType.flow:
        return scopeYear;
      default:
        return minorStarColor;
    }
  }
}

/// 工具方法：获取星曜的中文显示名 (通过 i10n 外挂)
String getStarDisplayName(Star star) => star.display;

/// 获取星曜亮度 (通过 i10n 外挂)
String getStarBrightness(Star star, DiZhi branch, Map<int, String> labels) {
  if (star is StaticStar) {
    final bIndex = star.getBrightness(branch);
    if (bIndex == -1) return '';
    final bKey = labels[bIndex];
    return formatBrightness(bKey ?? 'level_none');
  }
  if (star is FlowStar) {
    final bIndex = star.getBrightness(branch);
    if (bIndex == -1) return '';
    final bKey = labels[bIndex];
    return formatBrightness(bKey ?? 'level_none');
  }
  return '';
}
