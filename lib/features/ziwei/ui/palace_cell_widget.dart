import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 新增导入
import 'package:ziwei_core/ziwei_core.dart';
import '../providers/ziwei_providers.dart';
import 'ziwei_classic_theme.dart';
import '../../../core/l10n.dart';
import '../../../core/ziwei_l10n.dart';
import '../../../models/destiny_profile.dart';
import '../../../providers/input_provider.dart';

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
  final GlobalKey chartRootKey;
  final void Function(int palaceIndex, Rect? rect) onGanRectChanged;
  final void Function(String starKey, Rect? rect) onFlyingTargetRectChanged;

  const PalaceCellWidget({
    super.key,
    required this.palace,
    required this.plate,
    required this.state,
    required this.chartRootKey,
    required this.onGanRectChanged,
    required this.onFlyingTargetRectChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // === 预计算 ===
    final role = plate.getRole(ZiweiScope.origin, palace.index);
    final decade = _findDecade();
    final flowStarDisplay = ref.watch(
      inputNotifierProvider.select(
        (profile) => profile.ziweiOptions.flowStarDisplay,
      ),
    );
    final enableFlyingStarHighlightFrame = ref.watch(
      inputNotifierProvider.select(
        (profile) =>
            profile.ziweiOptions.animation.enableFlyingStarHighlightFrame,
      ),
    );
    final enableFlyingStarArrow = ref.watch(
      inputNotifierProvider.select(
        (profile) => profile.ziweiOptions.animation.enableFlyingStarArrow,
      ),
    );
    final flowStars = _collectOverlayFlowStars();

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
    final shenshaLines = _buildBottomShenshaLines(
      flowStarDisplay: flowStarDisplay,
      boshiStars: boshiStars,
      suijianStars: suijianStars,
      jiangqianStars: jiangqianStars,
    );

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
                  Expanded(
                    flex: 7,
                    child: _buildStarGrid(
                      topStars,
                      enableFlyingStarHighlightFrame:
                          enableFlyingStarHighlightFrame,
                      enableFlyingStarArrow: enableFlyingStarArrow,
                    ),
                  ),
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
                        shenshaLines: shenshaLines,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (flowStars.isNotEmpty)
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return IgnorePointer(
                      child: Padding(
                        padding: _buildFlowOverlayPadding(
                          constraints,
                          topStars,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: _buildFlowStarOverlay(flowStars),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // 4. 十二长生 + 干支 (绝对定位在右下角，高度自由向上伸展)
            Positioned(
              right: 2,
              bottom: 2,
              child: _buildRightInfoColumn(
                changshengName,
                ganLabel,
                zhiLabel,
                enableFlyingStarArrow: enableFlyingStarArrow,
              ),
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
  Widget _buildRightInfoColumn(
    String changsheng,
    String gan,
    String zhi, {
    required bool enableFlyingStarArrow,
  }) {
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
        // 2. 宫位干支 (宫干单独测量，供飞星连线使用)
        if (gan.isNotEmpty && enableFlyingStarArrow)
          _GeometryReporter(
            rootKey: chartRootKey,
            onChanged: (rect) => onGanRectChanged(palace.index, rect),
            child: _buildVerticalText(
              gan,
              const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1.05,
              ),
            ),
          )
        else if (gan.isNotEmpty)
          _buildVerticalText(
            gan,
            const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              height: 1.05,
            ),
          ),
        if (zhi.isNotEmpty)
          _buildVerticalText(
            zhi,
            const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              height: 1.05,
            ),
          ),
      ],
    );
  }

  Widget _buildFlowStarOverlay(List<FlowStar> flowStars) {
    final grouped = <ZiweiScope, List<FlowStar>>{};
    for (final star in flowStars) {
      grouped.putIfAbsent(star.scope, () => []).add(star);
    }

    final scopes = grouped.keys.toList()
      ..sort((a, b) => _flowScopeOrder(a).compareTo(_flowScopeOrder(b)));

    return Opacity(
      opacity: 0.92,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 78),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: scopes.map((scope) {
              final text = grouped[scope]!
                  .map(_flowStarDisplayName)
                  .where((name) => name.isNotEmpty)
                  .join(' ');

              if (text.isEmpty) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(bottom: 1.5),
                child: Text(
                  text,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: ZiweiClassicTheme.getScopeColor(scope),
                    height: 1.0,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  EdgeInsets _buildFlowOverlayPadding(
    BoxConstraints constraints,
    List<Star> topStars,
  ) {
    const baseLeft = 40.0;
    const baseTop = 30.0;
    const baseRight = 18.0;
    const baseBottom = 24.0;
    const overlayZoneWidth = 78.0;

    final contentWidth = (constraints.maxWidth - 8)
        .clamp(0.0, double.infinity)
        .toDouble();
    final estimatedTopHeight = _estimateRightOverlayConflictHeight(
      topStars,
      contentWidth,
      overlayZoneWidth,
    );
    final adaptiveTop = estimatedTopHeight > 0
        ? estimatedTopHeight + 8
        : baseTop;
    final topInset = adaptiveTop > baseTop ? adaptiveTop : baseTop;

    return const EdgeInsets.fromLTRB(
      baseLeft,
      0,
      baseRight,
      baseBottom,
    ).copyWith(top: topInset);
  }

  double _estimateRightOverlayConflictHeight(
    List<Star> stars,
    double maxWidth,
    double overlayZoneWidth,
  ) {
    if (stars.isEmpty || maxWidth <= 0) return 0;

    const baseFontSize = 11.5;
    const spacing = 0.5;

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

    final primaryTotalWidth = primaryStars.length * (baseFontSize + spacing);
    final remainingWidth = maxWidth - primaryTotalWidth;

    var secondaryFontSize = baseFontSize;
    if (secondaryStars.isNotEmpty) {
      secondaryFontSize = (remainingWidth / secondaryStars.length) - spacing;
      if (secondaryFontSize < 8.5) secondaryFontSize = 8.5;
      if (secondaryFontSize > baseFontSize) secondaryFontSize = baseFontSize;
    }

    final layouts = <_StarColumnMetric>[];
    double cursor = 0;

    for (final star in primaryStars) {
      final height = _estimateStarColumnHeight(star, baseFontSize);
      final width = baseFontSize + spacing;
      layouts.add(_StarColumnMetric(cursor, cursor + width, height));
      cursor += width;
    }
    for (final star in secondaryStars) {
      final height = _estimateStarColumnHeight(star, secondaryFontSize);
      final width = secondaryFontSize + spacing;
      layouts.add(_StarColumnMetric(cursor, cursor + width, height));
      cursor += width;
    }

    final conflictStart = maxWidth - overlayZoneWidth;
    if (cursor <= conflictStart) return 0;

    double maxConflictHeight = 0;
    for (final layout in layouts) {
      if (layout.right > conflictStart && layout.height > maxConflictHeight) {
        maxConflictHeight = layout.height;
      }
    }

    return maxConflictHeight > 0 ? maxConflictHeight + 6 : 0;
  }

  double _estimateStarColumnHeight(Star star, double fontSize) {
    final name = getStarDisplayName(star);
    final isPinyin = name.contains(RegExp(r'[a-z]'));
    final charCount = isPinyin ? 1 : name.characters.length;

    final nameHeight =
        charCount * (fontSize * 1.1) + ((charCount - 1).clamp(0, 99) * 1.5);

    final brightness = getStarBrightness(
      star,
      palace.branch,
      plate.ruleset.brightnessLabels,
    );
    final brightnessHeight = brightness.isNotEmpty ? (9 * 1.1) : 0.0;

    double badgeHeight = 0;
    if (star is StaticStar && star.siHuaBuff.isNotEmpty) {
      badgeHeight = fontSize * 0.85;
    }

    return nameHeight + brightnessHeight + badgeHeight + 4;
  }

  /// 顶部星曜区：阶梯式缩放逻辑
  /// 1. 主星与吉星（辅星）字号锁定，保证全局视觉权重一致
  /// 2. 煞星与杂曜执行“自动缩放”，在空间不足时动态缩小
  Widget _buildStarGrid(
    List<Star> stars, {
    required bool enableFlyingStarHighlightFrame,
    required bool enableFlyingStarArrow,
  }) {
    if (stars.isEmpty) return const SizedBox.shrink();

    final selectedFlyingTargets =
        (enableFlyingStarHighlightFrame || enableFlyingStarArrow)
        ? _selectedPalaceFlyingTargets()
        : const <String, SiHuaType>{};

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
                      selectedFlyingTargets[star.key],
                      enableFlyingStarHighlightFrame:
                          enableFlyingStarHighlightFrame,
                      enableFlyingStarArrow: enableFlyingStarArrow,
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
                      selectedFlyingTargets[star.key],
                      enableFlyingStarHighlightFrame:
                          enableFlyingStarHighlightFrame,
                      enableFlyingStarArrow: enableFlyingStarArrow,
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
  Widget _buildStarColumn(
    Star star,
    double fontSize,
    double maxHeight,
    SiHuaType? flyingHighlightType, {
    required bool enableFlyingStarHighlightFrame,
    required bool enableFlyingStarArrow,
  }) {
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

    Widget nameContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
          if (i < characters.length - 1) const SizedBox(height: 1.5),
        ],
      ],
    );

    if (flyingHighlightType != null && star is StaticStar) {
      if (enableFlyingStarHighlightFrame) {
        final frameColor = ZiweiClassicTheme.getSihuaColor(flyingHighlightType);
        nameContent = Container(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          decoration: BoxDecoration(
            color: frameColor.withOpacity(0.08),
            border: Border.all(color: frameColor, width: 1.2),
            borderRadius: BorderRadius.circular(3),
          ),
          child: nameContent,
        );
      }
      if (enableFlyingStarArrow) {
        nameContent = _GeometryReporter(
          rootKey: chartRootKey,
          onChanged: (rect) => onFlyingTargetRectChanged(star.key, rect),
          child: nameContent,
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        nameContent,
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

  Map<String, SiHuaType> _selectedPalaceFlyingTargets() {
    final selectedIndex = state.selectedPalaceIndex;
    if (selectedIndex == null || selectedIndex < 0 || selectedIndex >= 12) {
      return const {};
    }

    final selectedStem = plate.palaces[selectedIndex].stem;
    if (selectedStem == null) return const {};

    final rule = plate.ruleset.siHuaRules[selectedStem];
    if (rule == null || rule.isEmpty) return const {};

    return {for (final entry in rule.entries) entry.value: entry.key};
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
    required List<_BottomShenshaLine> shenshaLines,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 1. 左侧神煞：固定宽度 20px
        SizedBox(
          width: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: shenshaLines
                .map(
                  (line) => Text(
                    line.name,
                    style:
                        const TextStyle(
                          fontSize: 9.5, // 稍微调大点，增强可读性
                          height: 1.1,
                        ).copyWith(
                          color: line.color,
                          fontWeight: line.isFlow
                              ? FontWeight.w700
                              : FontWeight.w400,
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
                        _buildFixedRoleLabel(
                          ZiweiScope.decade,
                          state.currentDecade?.decadeIndex == 0 ? '童' : '大',
                        ),
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

  List<FlowStar> _collectOverlayFlowStars() {
    final stars = palace.stars[StarType.flow] ?? const [];
    return stars
        .whereType<FlowStar>()
        .where((star) => !_isExcludedOverlayFlowStar(star))
        .toList()
      ..sort((a, b) {
        final scopeCompare = _flowScopeOrder(
          a.scope,
        ).compareTo(_flowScopeOrder(b.scope));
        if (scopeCompare != 0) return scopeCompare;
        return _flowStarDisplayName(a).compareTo(_flowStarDisplayName(b));
      });
  }

  bool _isExcludedOverlayFlowStar(FlowStar star) {
    if (_isBottomShenshaFlowStar(star)) {
      return true;
    }
    return false;
  }

  List<_BottomShenshaLine> _buildBottomShenshaLines({
    required ZiweiFlowStarDisplayOptions flowStarDisplay,
    required List<Star> boshiStars,
    required List<Star> suijianStars,
    required List<Star> jiangqianStars,
  }) {
    return [
      _resolveBottomShenshaLine(
        originStars: boshiStars,
        flowEnabled: flowStarDisplay.showBoshi12,
        groupSuffix: '_boshi12',
      ),
      _resolveBottomShenshaLine(
        originStars: suijianStars,
        flowEnabled: flowStarDisplay.showSuijian12,
        groupSuffix: '_suijian12',
      ),
      _resolveBottomShenshaLine(
        originStars: jiangqianStars,
        flowEnabled: flowStarDisplay.showJiangqian12,
        groupSuffix: '_jiangqian12',
      ),
    ];
  }

  _BottomShenshaLine _resolveBottomShenshaLine({
    required List<Star> originStars,
    required bool flowEnabled,
    required String groupSuffix,
  }) {
    if (flowEnabled) {
      final flowStar = _findActiveBottomShenshaFlowStar(groupSuffix);
      if (flowStar != null) {
        return _BottomShenshaLine(
          name: _flowBottomShenshaName(flowStar),
          color: ZiweiClassicTheme.getScopeColor(flowStar.scope),
          isFlow: true,
        );
      }
    }

    final originName = originStars.isNotEmpty
        ? getStarDisplayName(originStars.first)
        : '';
    return _BottomShenshaLine(
      name: originName,
      color: ZiweiClassicTheme.minorStarColor,
      isFlow: false,
    );
  }

  FlowStar? _findActiveBottomShenshaFlowStar(String groupSuffix) {
    final flowStars = palace.stars[StarType.flow] ?? const [];
    final activeScopes = _bottomShenshaScopePriority();

    for (final scope in activeScopes) {
      for (final star in flowStars.whereType<FlowStar>()) {
        if (star.scope == scope && star.key.endsWith(groupSuffix)) {
          return star;
        }
      }
    }

    return null;
  }

  List<ZiweiScope> _bottomShenshaScopePriority() {
    if (state.currentHour != null) {
      return const [
        ZiweiScope.hour,
        ZiweiScope.day,
        ZiweiScope.month,
        ZiweiScope.year,
        ZiweiScope.decade,
      ];
    }
    if (state.currentDay != null) {
      return const [
        ZiweiScope.day,
        ZiweiScope.month,
        ZiweiScope.year,
        ZiweiScope.decade,
      ];
    }
    if (state.currentMonth != null) {
      return const [ZiweiScope.month, ZiweiScope.year, ZiweiScope.decade];
    }
    if (state.currentYear != null) {
      return const [ZiweiScope.year, ZiweiScope.decade];
    }
    if (state.currentDecade != null) {
      return const [ZiweiScope.decade];
    }
    return const [];
  }

  bool _isBottomShenshaFlowStar(FlowStar star) {
    return star.key.endsWith('_boshi12') ||
        star.key.endsWith('_suijian12') ||
        star.key.endsWith('_jiangqian12');
  }

  String _flowBottomShenshaName(FlowStar star) {
    final baseKey = star.key.replaceFirst('flow_${star.scope.name}_', '');
    return formatFlowShortName(baseKey);
  }

  int _flowScopeOrder(ZiweiScope scope) {
    switch (scope) {
      case ZiweiScope.hour:
        return 0;
      case ZiweiScope.day:
        return 1;
      case ZiweiScope.month:
        return 2;
      case ZiweiScope.smallLimit:
        return 3;
      case ZiweiScope.year:
        return 4;
      case ZiweiScope.decade:
        return 5;
      case ZiweiScope.origin:
        return 6;
    }
  }

  String _flowStarDisplayName(FlowStar star) {
    return star.overlayDisplay;
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
    if (star is FlowStar) {
      final bIndex = star.getBrightness(palace.branch);
      return plate.ruleset.brightnessLabels[bIndex] ?? 'level_none';
    }
    return 'level_none';
  }

  /// 构建动态水印组件 (纯净版数字)
  Widget _buildDynamicWatermark(Decade fallbackDecade) {
    final info = _getWatermarkInfo(fallbackDecade);

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
  _WatermarkInfo _getWatermarkInfo(Decade fallbackDecade) {
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
      final currentDecade = state.currentDecade!;
      final isChildhood = currentDecade.decadeIndex == 0;
      return _WatermarkInfo(
        text: isChildhood
            ? (state.currentYear == null
                  ? '童限'.tr
                  : '${currentDecade.startTime}${'岁'.tr}')
            : '${currentDecade.startTime}~${currentDecade.endTime}',
        prefix: isChildhood ? '童' : '大',
        color: ZiweiClassicTheme.getScopeColor(ZiweiScope.decade),
        isActive: true,
        fontSize: 28,
      );
    }

    // 默认：显示大限岁数区间
    return _WatermarkInfo(
      text: '${fallbackDecade.startTime}~${fallbackDecade.endTime}',
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

class _StarColumnMetric {
  final double left;
  final double right;
  final double height;

  const _StarColumnMetric(this.left, this.right, this.height);
}

class _BottomShenshaLine {
  final String name;
  final Color color;
  final bool isFlow;

  const _BottomShenshaLine({
    required this.name,
    required this.color,
    required this.isFlow,
  });
}

class _GeometryReporter extends StatefulWidget {
  final GlobalKey rootKey;
  final ValueChanged<Rect?> onChanged;
  final Widget child;

  const _GeometryReporter({
    required this.rootKey,
    required this.onChanged,
    required this.child,
  });

  @override
  State<_GeometryReporter> createState() => _GeometryReporterState();
}

class _GeometryReporterState extends State<_GeometryReporter> {
  bool _scheduled = false;

  @override
  Widget build(BuildContext context) {
    _scheduleReport();
    return widget.child;
  }

  void _scheduleReport() {
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (!mounted) return;

      final object = context.findRenderObject();
      final rootObject = widget.rootKey.currentContext?.findRenderObject();
      if (object is! RenderBox || rootObject is! RenderBox) {
        widget.onChanged(null);
        return;
      }

      final topLeft = object.localToGlobal(Offset.zero, ancestor: rootObject);
      widget.onChanged(topLeft & object.size);
    });
  }

  @override
  void dispose() {
    widget.onChanged(null);
    super.dispose();
  }
}
