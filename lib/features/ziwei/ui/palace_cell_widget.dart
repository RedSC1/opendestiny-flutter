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
      onTap: () =>
          ref.read(ziweiUIManagerProvider.notifier).selectPalace(palace.index),
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
            if (decade != null) _buildDynamicWatermark(decade),

            // 1.1 身宫暗纹大水印 (不占位置，低优先级背景)
            if (plate.bodyPalaceIndex == palace.index) _buildBodyWatermark(),

            // 2. 表层：主功能区 (核心内容 Column，内部预置呼吸感)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Column(
                children: [
                  Expanded(flex: 7, child: _buildStarGrid(topStars)),
                  // 取消原有的 Spacer，改为极小的固定间距，让上下结构更紧凑
                  const SizedBox(height: 2),
                  // ======== 底部：宫名与重要堆叠标记 (按照专业布局解耦) ======== (flex: 3)
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 18,
                      ), // 缩减边距，配合右对齐让布局更紧凑
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
                  ),
                ],
              ),
            ),

            // 4. 十二长生 + 干支 (绝对定位在右下角，高度自由向上伸展)
            Positioned(
              right: 2,
              bottom: 2,
              child: _buildRightInfoColumn(changshengName, ganLabel, zhiLabel),
            ),
          ],
        ),
      ),
    );
  }

  /// 渲染身宫背景大水印 (沉底放置，腾出中间留白区给时间数字)
  Widget _buildBodyWatermark() {
    return IgnorePointer(
      child: Container(
        alignment: const Alignment(0, 0.8), // 进一步下沉，彻底避开上方的流运数字
        child: Opacity(
          opacity: 0.12,
          child: Text(
            '身'.tr,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: ZiweiClassicTheme.sihuaJi.withOpacity(0.8), // 淡淡的红印感
            ),
          ),
        ),
      ),
    );
  }

  /// 渲染右下角垂直信息柱 (长生 + 干支)
  Widget _buildRightInfoColumn(String changsheng, String gan, String zhi) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 1. 十二长生 (灰色，小字辅助)
        if (changsheng.isNotEmpty)
          _buildVerticalText(
            changsheng,
            TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
              height: 1.05,
            ),
          ),
        const SizedBox(height: 1),
        // 2. 宫位干支 (大字，深色加粗锚点)
        _buildVerticalText(
          "$gan$zhi",
          const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            color: ZiweiClassicTheme.ganzhiColor,
            height: 1.05,
          ),
        ),
      ],
    );
  }

  /// 顶部星曜区：阶梯式缩放逻辑
  /// 1. 主星与吉星（辅星）字号锁定，保证全局视觉权重一致
  /// 2. 煞星与杂曜执行“自动缩放”，在空间不足时动态缩小
  Widget _buildStarGrid(List<Star> stars) {
    if (stars.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        const double baseFontSize = 11.5;
        const double spacing = 0.5;

        // 1. 分类星曜：重点星曜 (主/吉/煞) 与 次要星曜 (杂曜)
        final primaryStars = stars
            .where(
              (s) =>
                  s.type == StarType.major ||
                  s.type == StarType.lucky ||
                  s.type == StarType.bad,
            )
            .toList();
        final secondaryStars = stars
            .where(
              (s) =>
                  s.type != StarType.major &&
                  s.type != StarType.lucky &&
                  s.type != StarType.bad,
            )
            .toList();

        // 2. 差异化计算比例：主/吉/煞固定字号，杂曜在剩余空间内缩放
        final int primaryCount = primaryStars.length;
        final int secondaryCount = secondaryStars.length;
        final double primaryTotalWidth =
            primaryCount * (baseFontSize + spacing);
        final double remainingWidth = maxWidth - primaryTotalWidth;

        double secondaryFontSize = baseFontSize;
        if (secondaryCount > 0) {
          // 仅对杂曜进行空间压缩逻辑
          secondaryFontSize = (remainingWidth / secondaryCount) - spacing;
          if (secondaryFontSize < 8.5) secondaryFontSize = 8.5;
          if (secondaryFontSize > baseFontSize)
            secondaryFontSize = baseFontSize;
        }

        return Align(
          alignment: Alignment.topLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // A. 重点星曜：始终保持 baseFontSize
                ...primaryStars.map((star) {
                  return Padding(
                    padding: const EdgeInsets.only(right: spacing),
                    child: _buildStarColumn(
                      star,
                      baseFontSize,
                      constraints.maxHeight,
                    ),
                  );
                }),
                // B. 杂曜：动态计算字号，优先收缩
                ...secondaryStars.map((star) {
                  return Padding(
                    padding: const EdgeInsets.only(right: spacing),
                    child: _buildStarColumn(
                      star,
                      secondaryFontSize,
                      constraints.maxHeight,
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 单颗星曜的竖列
  Widget _buildStarColumn(Star star, double fontSize, double maxHeight) {
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
          sihuaBadges.add(_buildSihuaBadge(type, scope, fontSize));
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
          Text(
            characters[i],
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isMajor ? FontWeight.w700 : FontWeight.w400,
              color: color,
              height: 1.1,
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
        // 四化角标 (实心高亮圆扣)
        if (sihuaBadges.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: SizedBox(
              width: fontSize,
              height: fontSize,
              child: OverflowBox(
                minHeight: 0,
                maxHeight: 120,
                alignment: Alignment.topCenter,
                child: () {
                  // --- 碰撞检测逻辑 ---
                  // 1. 计算星曜及亮度所占高度
                  final double starHeight =
                      characters.length * (fontSize * 1.1 + 1.5);
                  final double bHeight = brightness.isNotEmpty ? (9 * 1.1) : 0;
                  final double occupiedHeight = starHeight + bHeight + 2;

                  // 2. 计算如果不叠压所需的总高度
                  final double columnHeight =
                      sihuaBadges.length * (fontSize + 0.5);

                  // 3. 判断是否会超出宫位高度 (即“碰撞”)
                  // 如果不叠压就会超出可用高度，则开启“叠压”模式
                  final bool shouldStack =
                      (occupiedHeight + columnHeight) > maxHeight;

                  if (!shouldStack) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: sihuaBadges
                          .map(
                            (b) => Padding(
                              padding: const EdgeInsets.only(bottom: 0.5),
                              child: b,
                            ),
                          )
                          .toList(),
                    );
                  } else {
                    // 开启“叠压”模式
                    return SizedBox(
                      height:
                          fontSize +
                          (sihuaBadges.length - 1) * (fontSize * 0.55),
                      width: fontSize,
                      child: Stack(
                        children: List.generate(sihuaBadges.length, (i) {
                          final double offset = i * (fontSize * 0.55);
                          return Positioned(
                            top: offset,
                            left: 0,
                            right: 0,
                            child: sihuaBadges[i],
                          );
                        }),
                      ),
                    );
                  }
                }(),
              ),
            ),
          ),
      ],
    );
  }

  /// 构建单个四化圆扣 (动态大小：跟随 fontSize)
  Widget _buildSihuaBadge(SiHuaType type, ZiweiScope scope, double fontSize) {
    final color = ZiweiClassicTheme.getScopeColor(scope);
    final double badgeSize = fontSize; // 强制与字号一致

    return Container(
      width: badgeSize,
      height: badgeSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 1,
            offset: const Offset(0, 0.1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          type.display,
          style: TextStyle(
            fontSize: badgeSize * 0.72, // 动态缩放内部字体
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  /// 底部核心重构：固定两侧宽度，确保中间的宫位名绝对不被挤小。
  Widget _buildBottomSection({
    required PalaceRole role,
    required String ganLabel,
    required String zhiLabel,
    required String changshengName,
    required List<Star> boshiStars,
    required List<Star> suijianStars,
    required List<Star> jiangqianStars,
  }) {
    final shenshaList = [
      ...boshiStars.map(getStarDisplayName),
      ...suijianStars.map(getStarDisplayName),
      ...jiangqianStars.map(getStarDisplayName),
    ].take(3).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 1. 左侧神煞：固定宽度 20px
        SizedBox(
          width: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: shenshaList
                .map(
                  (name) => Text(
                    name,
                    style: const TextStyle(
                      fontSize: 9.5, // 稍微调大点，增强可读性
                      color: ZiweiClassicTheme.minorStarColor,
                      height: 1.1,
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        // 2. 中间：流运五星阵 (增加 FittedBox 防爆处理)
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 第一行：全体向右集结
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildFixedRoleLabel(ZiweiScope.hour, '时'),
                        const SizedBox(width: 3),
                        _buildFixedRoleLabel(ZiweiScope.decade, '大'),
                        const SizedBox(width: 3),
                        _buildFixedRoleLabel(ZiweiScope.month, '月'),
                      ],
                    ),
                    // 第二行：全体向右集结 (原局与流位拉齐)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        _buildFixedRoleLabel(ZiweiScope.day, '日'),
                        const SizedBox(width: 3),
                        Text(
                          role.display,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            color: role == PalaceRole.life
                                ? ZiweiClassicTheme.sihuaJi
                                : ZiweiClassicTheme.palaceNameColor,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 3),
                        _buildFixedRoleLabel(ZiweiScope.year, '年'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 3. 右侧原本的位置现在为空，改由外部 Positioned 渲染
      ],
    );
  }

  /// 构建固定位置的角色标签
  Widget _buildFixedRoleLabel(ZiweiScope scope, String prefix) {
    bool active = false;
    switch (scope) {
      case ZiweiScope.decade:
        active = state.currentDecade != null;
        break;
      case ZiweiScope.year:
        active = state.currentYear != null;
        break;
      case ZiweiScope.month:
        active = state.currentMonth != null;
        break;
      case ZiweiScope.day:
        active = state.currentDay != null;
        break;
      case ZiweiScope.hour:
        active = state.currentHour != null;
        break;
      default:
        break;
    }

    // 关键点：即使不激活也返回 SizedBox，占住坑位
    if (!active) return const SizedBox(width: 22);

    final r = plate.getRole(scope, palace.index);
    final shortName = r.display.isNotEmpty
        ? (r == PalaceRole.friends ? '友' : r.display.substring(0, 1))
        : '';

    // 确定对齐方式
    Alignment align;
    if (scope == ZiweiScope.decade ||
        scope == ZiweiScope.hour ||
        (prefix == '')) {
      align = Alignment.center;
    } else if (scope == ZiweiScope.year || scope == ZiweiScope.month) {
      align = Alignment.centerRight;
    } else {
      align = Alignment.centerLeft;
    }

    return Container(
      alignment: align,
      child: Text(
        "$prefix$shortName",
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: ZiweiClassicTheme.getScopeColor(scope),
          height: 1.0, // 极致紧凑
        ),
      ),
    );
  }

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
      children: text.characters.map((c) => Text(c, style: style)).toList(),
    );
  }

  String _getBrightnessKey(Star star) {
    if (star is StaticStar) {
      final bIndex = star.getBrightness(palace.branch);
      return plate.ruleset.brightnessLabels[bIndex] ?? 'level_none';
    }
    return 'level_none';
  }

  /// 构建动态水印组件 (纯净版数字)
  Widget _buildDynamicWatermark(Decade decade) {
    final info = _getWatermarkInfo(decade);

    return Align(
      alignment: const Alignment(0, 0.5), // 下移至视觉区
      child: Opacity(
        opacity: info.isActive ? 0.35 : 0.18,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0), // 为斜体字留出倾斜空间
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              info.text,
              style: TextStyle(
                fontSize: info.fontSize,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: info.color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 获取当前宫位应该显示的水印信息
  _WatermarkInfo _getWatermarkInfo(Decade decade) {
    // 1. 流时 (紫色)
    if (state.currentHour != null &&
        plate.getRole(ZiweiScope.hour, palace.index) == PalaceRole.life) {
      return _WatermarkInfo(
        text: state.currentHour!.hourIndex.hourName,
        prefix: '时',
        color: ZiweiClassicTheme.getScopeColor(ZiweiScope.hour),
        isActive: true,
        fontSize: 22,
      );
    }
    // 2. 流日 (紫色)
    if (state.currentDay != null &&
        plate.getRole(ZiweiScope.day, palace.index) == PalaceRole.life) {
      return _WatermarkInfo(
        text: state.currentDay!.day.lunarDay,
        prefix: '日',
        color: ZiweiClassicTheme.getScopeColor(ZiweiScope.day),
        isActive: true,
        fontSize: 22,
      );
    }
    // 3. 流月 (橙色)
    if (state.currentMonth != null &&
        plate.getRole(ZiweiScope.month, palace.index) == PalaceRole.life) {
      return _WatermarkInfo(
        text: state.currentMonth!.month.lunarMonth,
        prefix: '月',
        color: ZiweiClassicTheme.getScopeColor(ZiweiScope.month),
        isActive: true,
        fontSize: 24,
      );
    }
    // 4. 流年 (蓝色)
    if (state.currentYear != null &&
        plate.getRole(ZiweiScope.year, palace.index) == PalaceRole.life) {
      return _WatermarkInfo(
        text: '${state.currentYear!.year}',
        prefix: '年',
        color: ZiweiClassicTheme.getScopeColor(ZiweiScope.year),
        isActive: true,
        fontSize: 26,
      );
    }
    // 5. 大限 (绿色)
    if (state.currentDecade != null &&
        plate.getRole(ZiweiScope.decade, palace.index) == PalaceRole.life) {
      return _WatermarkInfo(
        text: '${decade.startTime}~${decade.endTime}',
        prefix: '大',
        color: ZiweiClassicTheme.getScopeColor(ZiweiScope.decade),
        isActive: true,
        fontSize: 28,
      );
    }

    // 默认：显示大限岁数区间
    return _WatermarkInfo(
      text: '${decade.startTime}~${decade.endTime}',
      prefix: '',
      color: Colors.grey,
      isActive: false,
      fontSize: 28,
    );
  }
}

class _WatermarkInfo {
  final String text;
  final String prefix;
  final Color color;
  final bool isActive;
  final double fontSize;

  _WatermarkInfo({
    required this.text,
    required this.prefix,
    required this.color,
    required this.isActive,
    required this.fontSize,
  });
}
