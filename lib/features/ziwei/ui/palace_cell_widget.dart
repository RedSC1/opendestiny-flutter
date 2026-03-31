import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 新增导入
import 'package:ziwei_core/ziwei_core.dart';
import '../providers/ziwei_providers.dart';
import 'ziwei_classic_theme.dart';
import '../../../core/l10n.dart';
import '../../../core/ziwei_l10n.dart';

/// 经典风格的单宫位渲染组件
///
/// 布局分三大区域（从上到下）:
///   ┌─────────────────────────┐
///   │  顶部：星曜区 (横排竖列)    │  ← Expanded, 占主空间
///   │  天 巨 右 天 天 封 年       │
///   │  机 门 弼 魁 府 诰 解       │
///   │  旺 陷    庙 平             │  ← 亮度
///   │     权                     │  ← 四化
///   ├─────────────────────────┤
///   │  中部：流年/小限/大限岁数    │
///   │  流年: 9,21,33,45,57       │
///   │  小限: 3,15,27,39,51       │
///   │       53 ~ 62              │  ← 大限区间
///   ├─────────────────────────┤
///   │ 大耗    疾厄宫        墓   │  ← 底部信息
///   │ 将星                 乙卯  │
///   │ 白虎                       │
///   └─────────────────────────┘
class PalaceCellWidget extends ConsumerWidget {
  final Palace palace;
  final ZiWeiPlate plate;
  final ZiweiUIState state;

  const PalaceCellWidget({
    super.key,
    required this.palace,
    required this.plate,
    required this.state,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // === 预计算 ===
    final role = plate.getRole(ZiweiScope.origin, palace.index);
    final decade = _findDecade();

    // 分类星曜
    final majorStars = palace.stars[StarType.major] ?? [];
    final luckyStars = palace.stars[StarType.lucky] ?? [];
    final badStars = palace.stars[StarType.bad] ?? [];
    final minorStars = palace.stars[StarType.minor] ?? [];
    final changshengStars = palace.stars[StarType.changsheng12] ?? [];
    // 所有顶部可展示星曜（主星 + 吉星 + 煞星 + 乙级）
    final topStars = [...majorStars, ...luckyStars, ...badStars, ...minorStars];

    // 三组十二神（放在底部左下角）
    final boshiStars = palace.stars[StarType.boshi12] ?? [];
    final suijianStars = palace.stars[StarType.suijian12] ?? [];
    final jiangqianStars = palace.stars[StarType.jiangqian12] ?? [];

    // 获取长生名（右下角）
    final changshengName = changshengStars.isNotEmpty
        ? getStarDisplayName(changshengStars.first)
        : '';

    // 宫干支
    final ganLabel = palace.ganzhi.gan.display;
    final zhiLabel = palace.ganzhi.zhi.display;

    final isSelected = state.selectedPalaceIndex == palace.index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque, // 确保空白处也能点
      onTap: () => ref.read(ziweiUIManagerProvider.notifier).selectPalace(palace.index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected 
                ? ZiweiClassicTheme.palaceNameColor 
                : ZiweiClassicTheme.cellBorderColor,
            width: 1.0,
          ),
          color: ZiweiClassicTheme.cellBgColor,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. 底层：动态水印 (跟随流运层级切换内容)
            if (decade != null)
              _buildDynamicWatermark(decade),
            
            // 2. 表层：主功能区
            Column(
              children: [
                // ======== 顶部：星曜横排区 ======== 
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 1, right: 1, top: 1),
                    child: _buildStarGrid(topStars),
                  ),
                ),

                // ======== 底部：宫名 + 干支 + 长生 + 神煞 ========
                Expanded(
                  flex: 3,
                  child: _buildBottomSection(
                    role: role,
                    ganLabel: ganLabel,
                    zhiLabel: zhiLabel,
                    changshengName: changshengName,
                    boshiStars: boshiStars,
                    suijianStars: suijianStars,
                    jiangqianStars: jiangqianStars,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 顶部星曜区：优先保证主星和辅星（吉星）字号一致
  Widget _buildStarGrid(List<Star> stars) {
    if (stars.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        const double baseFontSize = 13.5;
        const double spacing = 1.0;

        // 识别"重点星曜"（主星+吉星）和"次要星曜"（煞星+杂曜）
        final primaryStars = stars
            .where((s) => s.type == StarType.major || s.type == StarType.lucky)
            .toList();
        final secondaryStars = stars
            .where((s) => s.type != StarType.major && s.type != StarType.lucky)
            .toList();

        final int primaryCount = primaryStars.length;
        final int secondaryCount = secondaryStars.length;

        // 估算重点星曜占用的总宽度
        final double primaryTotalWidth =
            primaryCount * (baseFontSize + spacing);

        // 计算分给次要星曜的剩余宽度
        final double remainingWidth = maxWidth - primaryTotalWidth;

        double secondaryFontSize = baseFontSize;
        if (secondaryCount > 0) {
          final double secondaryNeededWidth =
              secondaryCount * (baseFontSize + spacing);
          if (secondaryNeededWidth > remainingWidth) {
            // 空间不足，只压缩次要星曜
            secondaryFontSize = (remainingWidth / secondaryCount) - spacing;
            if (secondaryFontSize < 8.5) secondaryFontSize = 8.5;
          }
        }

        return Align(
          alignment: Alignment.topLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: stars.map((star) {
                final isWeighted =
                    star.type == StarType.major || star.type == StarType.lucky;
                final double actualFontSize = isWeighted
                    ? baseFontSize
                    : secondaryFontSize;

                return Padding(
                  padding: const EdgeInsets.only(right: spacing),
                  child: _buildStarColumn(star, actualFontSize),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  /// 单颗星曜的竖列
  Widget _buildStarColumn(Star star, double fontSize) {
    final name = getStarDisplayName(star);
    final brightness = getStarBrightness(
      star,
      palace.branch,
      plate.ruleset.brightnessLabels,
    );
    final color = ZiweiClassicTheme.getStarColor(star);

    // 收集所有维度的四化信息 (本命、大限、小限、流年、流月、流日、流时)
    final List<Widget> sihuaBadges = [];
    if (star is StaticStar && star.siHuaBuff.isNotEmpty) {
      // 定义渲染顺序
      const scopeOrder = [
        ZiweiScope.origin,
        ZiweiScope.decade,
        ZiweiScope.smallLimit,
        ZiweiScope.year,
        ZiweiScope.month,
        ZiweiScope.day,
        ZiweiScope.hour,
      ];

      for (final scope in scopeOrder) {
        final type = star.siHuaBuff[scope];
        if (type != null) {
          sihuaBadges.add(_buildSihuaBadge(type, scope));
        }
      }
    }

    final isMajor = star.type == StarType.major;
    // ... (chars processing omitted for clarity in this snippet, will be handled in full replace)

    // 如果名字是纯英文（拼音没汉化成功），则不进行竖排拆分，而是缩小显示
    final bool isPinyin = name.contains(RegExp(r'[a-z]'));
    final List<String> characters = isPinyin
        ? [name]
        : name.characters.toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 星名竖排
        for (int i = 0; i < characters.length; i++) ...[
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              characters[i],
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isMajor ? FontWeight.w700 : FontWeight.w400,
                color: color,
                height: 1.1,
              ),
            ),
          ),
          // 字与字之间加点空隙
          if (i < characters.length - 1) const SizedBox(height: 1.5),
        ],
        // 亮度
        if (brightness.isNotEmpty)
          FittedBox(
            child: Text(
              brightness,
              style: TextStyle(
                fontSize: 9,
                color: ZiweiClassicTheme.getBrightnessColor(
                  _getBrightnessKey(star),
                ),
                height: 1.1,
              ),
            ),
          ),
        // 四化角标 (实心高亮圆扣，垂直叠 buff 版)
        if (sihuaBadges.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 1), // 极紧凑顶部
            child: Wrap(
              direction: Axis.vertical, // 竖着叠 buff
              alignment: WrapAlignment.center,
              spacing: 1.0, // 极紧凑圆扣间距
              children: sihuaBadges,
            ),
          ),
      ],
    );
  }

  /// 构建单个四化圆扣 (紧凑印章版)
  Widget _buildSihuaBadge(SiHuaType type, ZiweiScope scope) {
    final color = ZiweiClassicTheme.getScopeColor(scope);
    return Container(
      padding: const EdgeInsets.all(1.2), // 极小内边距，像印章一样紧凑
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 1,
            offset: const Offset(0, 0.5),
          ),
        ],
      ),
      child: Text(
        type.display,
        style: const TextStyle(
          fontSize: 8.5, // 进一步微调，确保由于垂直高度有限不触发缩放
          fontWeight: FontWeight.w900,
          color: Colors.white,
          height: 1.0,
        ),
      ),
    );
  }


  /// 底部信息区 (文墨天机对齐版：三列网格叠位)
  Widget _buildBottomSection({
    required PalaceRole role,
    required String ganLabel,
    required String zhiLabel,
    required String changshengName,
    required List<Star> boshiStars,
    required List<Star> suijianStars,
    required List<Star> jiangqianStars,
  }) {
    final shensha = [
      ...boshiStars.map(getStarDisplayName),
      ...suijianStars.map(getStarDisplayName),
      ...jiangqianStars.map(getStarDisplayName),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 1. 左下角：神煞竖列 (flex: 2)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: shensha
                  .take(3)
                  .map(
                    (name) => FittedBox(
                      alignment: Alignment.bottomLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 9,
                          color: ZiweiClassicTheme.minorStarColor,
                          height: 1.1,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          // 2. 中间：宫位叠位网格 (flex: 5 - 给足面子)
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Col 1: 日 / 月
                  _buildTemporalGridCol([
                    _getRoleInfo(ZiweiScope.day, '日'),
                    _getRoleInfo(ZiweiScope.month, '月'),
                  ]),
                  // Col 2: 大 / 本命
                  _buildTemporalGridCol([
                    _getRoleInfo(ZiweiScope.decade, '大'),
                    _getRoleInfo(ZiweiScope.origin, '', customRole: role),
                  ]),
                  // Col 3: 小 / 年
                  _buildTemporalGridCol([
                    _getRoleInfo(ZiweiScope.smallLimit, '小'),
                    _getRoleInfo(ZiweiScope.year, '年'),
                  ]),
                ],
              ),
            ),
          ),

          // 3. 右下角：长生 + 干支 (全竖排堆叠，极省横向空间)
          Expanded(
            flex: 1,
            child: FittedBox(
              alignment: Alignment.bottomRight,
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (changshengName.isNotEmpty)
                    _buildVerticalText(
                      changshengName,
                      const TextStyle(
                        fontSize: 9,
                        color: ZiweiClassicTheme.changshengColor,
                        height: 1.0,
                      ),
                    ),
                  const SizedBox(height: 1),
                  _buildVerticalText(
                    '$ganLabel$zhiLabel',
                    const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: ZiweiClassicTheme.ganzhiColor,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 这里的 roleInfo 是一个内部辅助类，下面会定义
  Widget _buildTemporalGridCol(List<_RoleDisplayInfo> infos) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: infos.map((info) {
        if (!info.isActive) return const SizedBox(height: 12); // 留出占位，保持对齐
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            info.text,
            style: TextStyle(
              fontSize: 11, // 全员统一字号
              fontWeight: info.isOrigin ? FontWeight.w900 : FontWeight.bold,
              color: info.color,
              height: 1.1,
            ),
          ),
        );
      }).toList(),
    );
  }

  // === 内部辅助 ===

  Decade? _findDecade() {
    for (int i = 1; i <= 12; i++) {
      try {
        final dec = Decade.fromIndex(i, plate);
        if (dec.ganzhi.zhi == palace.branch) return dec;
      } catch (_) {
        break;
      }
    }
    return null;
  }

  Widget _buildVerticalText(String text, TextStyle style) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: text.characters
          .map((c) => Text(
                c,
                style: style,
              ))
          .toList(),
    );
  }

  _RoleDisplayInfo _getRoleInfo(ZiweiScope scope, String prefix,
      {PalaceRole? customRole}) {
    if (scope == ZiweiScope.origin) {
      String name = customRole?.display ?? '';
      // 本命宫位也去掉“宫”字，且主命宫也保持在双字内
      if (name.endsWith('宫')) name = name.substring(0, name.length - 1);
      
      return _RoleDisplayInfo(
        text: name,
        color: customRole == PalaceRole.life
            ? ZiweiClassicTheme.sihuaJi
            : ZiweiClassicTheme.palaceNameColor,
        isActive: true,
        isOrigin: true,
      );
    }

    // 检查对应层级是否激活
    bool active = false;
    switch (scope) {
      case ZiweiScope.decade: active = state.currentDecade != null; break;
      case ZiweiScope.year: active = state.currentYear != null; break;
      case ZiweiScope.month: active = state.currentMonth != null; break;
      case ZiweiScope.day: active = state.currentDay != null; break;
      case ZiweiScope.hour: active = state.currentHour != null; break;
      case ZiweiScope.smallLimit: active = false; break; // 暂时关闭小限
      default: break;
    }

    if (!active) return _RoleDisplayInfo(text: '', color: Colors.transparent);

    final r = plate.getRole(scope, palace.index);
    String name = r.display;

    // 关键瘦身：只取展示名的第一个字 (如：交友宫 -> 友)
    String shortName = name.isNotEmpty ? name.substring(0, 1) : '';

    return _RoleDisplayInfo(
      text: '$prefix$shortName',
      color: ZiweiClassicTheme.getScopeColor(scope),
      isActive: true,
    );
  }

  String _getBrightnessKey(Star star) {
    if (star is StaticStar) {
      final bIndex = star.getBrightness(palace.branch);
      return plate.ruleset.brightnessLabels[bIndex] ?? 'level_none';
    }
    return 'level_none';
  }

  /// 构建动态水印组件
  Widget _buildDynamicWatermark(Decade decade) {
    final info = _getWatermarkInfo(decade);
    return Opacity(
      opacity: info.isActive ? 0.35 : 0.18,
      child: Text(
        info.text,
        style: TextStyle(
          fontSize: info.fontSize,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          color: info.color,
        ),
      ),
    );
  }

  /// 获取当前宫位应该显示的水印信息
  _WatermarkInfo _getWatermarkInfo(Decade decade) {
    // 1. 流时命宫 (紫色)
    if (state.currentHour != null &&
        plate.getRole(ZiweiScope.hour, palace.index) == PalaceRole.life) {
      return _WatermarkInfo(
        text: state.currentHour!.hourIndex.hourName,
        color: ZiweiClassicTheme.getScopeColor(ZiweiScope.hour),
        isActive: true,
        fontSize: 22,
      );
    }
    // 2. 流日命宫 (紫色)
    if (state.currentDay != null &&
        plate.getRole(ZiweiScope.day, palace.index) == PalaceRole.life) {
      return _WatermarkInfo(
        text: state.currentDay!.day.lunarDay,
        color: ZiweiClassicTheme.getScopeColor(ZiweiScope.day),
        isActive: true,
        fontSize: 22,
      );
    }
    // 3. 流月命宫 (橙色)
    if (state.currentMonth != null &&
        plate.getRole(ZiweiScope.month, palace.index) == PalaceRole.life) {
      return _WatermarkInfo(
        text: state.currentMonth!.month.lunarMonth,
        color: ZiweiClassicTheme.getScopeColor(ZiweiScope.month),
        isActive: true,
        fontSize: 24,
      );
    }
    // 4. 流年命宫 (蓝色)
    if (state.currentYear != null &&
        plate.getRole(ZiweiScope.year, palace.index) == PalaceRole.life) {
      return _WatermarkInfo(
        text: '${state.currentYear!.year}',
        color: ZiweiClassicTheme.getScopeColor(ZiweiScope.year),
        isActive: true,
        fontSize: 26,
      );
    }
    // 5. 大限命宫 (绿色)
    if (state.currentDecade != null &&
        plate.getRole(ZiweiScope.decade, palace.index) == PalaceRole.life) {
      return _WatermarkInfo(
        text: '${decade.startTime}~${decade.endTime}',
        color: ZiweiClassicTheme.getScopeColor(ZiweiScope.decade),
        isActive: true,
        fontSize: 28,
      );
    }

    // 默认：显示原局大限岁数区间
    return _WatermarkInfo(
      text: '${decade.startTime}~${decade.endTime}',
      color: Colors.grey,
      isActive: false,
      fontSize: 28,
    );
  }
}

class _WatermarkInfo {
  final String text;
  final Color color;
  final bool isActive;
  final double fontSize;

  _WatermarkInfo({
    required this.text,
    required this.color,
    required this.isActive,
    required this.fontSize,
  });
}

class _RoleDisplayInfo {
  final String text;
  final Color color;
  final bool isActive;
  final bool isOrigin;

  _RoleDisplayInfo({
    required this.text,
    required this.color,
    this.isActive = false,
    this.isOrigin = false,
  });
}
