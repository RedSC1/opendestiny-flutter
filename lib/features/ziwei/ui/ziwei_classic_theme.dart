import 'package:flutter/material.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../../../core/ziwei_l10n.dart';

class ZiweiClassicTheme {
  // --- 星曜核心色盘 (借鉴奇门图) ---
  static const Color majorStarColor = Color(0xFFC62828); // 朱红 (天英/景门色)
  static const Color luckyStarColor = Color(0xFF2E7D32); // 翡翠绿 (天辅/杜门色)
  static const Color badStarColor = Color(0xFF333333); // 玄铁黑 (白虎/惊门色)
  static const Color minorStarColor = Color(0xFF757575); // 石板灰 (杂曜/神煞)

  // --- 四化色 (现代高对比) ---
  static const Color sihuaLu = Color(0xFF2E7D32); // 繁荣绿
  static const Color sihuaQuan = Color(0xFFEF6C00); // 活力橙
  static const Color sihuaKe = Color(0xFF1565C0); // 睿智蓝
  static const Color sihuaJi = Color(0xFFC62828); // 警示红

  // --- 布局与功能色 ---
  static const Color palaceNameColor = Color(0xFFC62828); // 宫位名与主色一致
  static const Color decadeAgeColor = Color(0xFF546E7A); // 蓝灰色
  static const Color ganzhiColor = Color(0xFFAF601A); // 大地棕
  static const Color changshengColor = Color(0xFF9E9E9E); // 中性灰
  static const Color cellBorderColor = Color(0xFFEEEEEE); // 极浅灰边框 (极细感)
  static const Color cellBgColor = Colors.white; // 纯白背景 (告别米黄)
  static const Color activeTimeBg = Color(0xFFF1F8E9); // 选中的流运背景 (淡绿)
  static const Color timeCellBorder = Color(0xFFECEFF1);
  static const Color timeRowLabelBg = Color(0xFFF5F5F5);

  // --- 层级色彩映射 (主流配色) ---
  static const Color scopeOrigin = Color(0xFFC62828); // 本命 (红色)
  static const Color scopeDecade = Color(0xFF2E7D32); // 大限 (深绿)
  static const Color scopeSmallLimit = Color(0xFF0288D1); // 小限 (亮蓝)
  static const Color scopeYear = Color(0xFF1565C0); // 流年 (中蓝)
  static const Color scopeMonth = Color(0xFFEF6C00); // 流月 (活力橙)
  static const Color scopeDay = Color(0xFF7E57C2); // 流日 (淡紫)
  static const Color scopeHour = Color(0xFF607D8B); // 流时 (蓝灰色)

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

  static Color getBrightnessColor(String key) {
    switch (key) {
      case 'level_miao':
        return const Color(0xFFCC0000);
      case 'level_wang':
        return const Color(0xFFCC6600);
      case 'level_de':
        return const Color(0xFF666666);
      case 'level_li':
        return const Color(0xFF999999);
      case 'level_ping':
        return const Color(0xFFAAAAAA);
      case 'level_bu':
        return const Color(0xFF0066CC);
      case 'level_xian':
        return const Color(0xFF339933);
      default:
        return const Color(0xFF607D8B);
    }
  }

  static Color getSihuaColor(SiHuaType type) => type == SiHuaType.lu
      ? sihuaLu
      : type == SiHuaType.quan
      ? sihuaQuan
      : type == SiHuaType.ke
      ? sihuaKe
      : sihuaJi;

  static Color getStarColor(Star star) {
    switch (star.type) {
      case StarType.major:
        return majorStarColor;
      case StarType.lucky:
        return luckyStarColor;
      case StarType.bad:
        return badStarColor;
      case StarType.minor:
        return minorStarColor;
      case StarType.flow:
        return const Color(0xFF9933CC);
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
