import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 新增导入
import 'package:ziwei_core/ziwei_core.dart';
import '../../../core/ui_scale.dart';
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
  static const double _palaceScale = 0.89;

  final Palace palace;
  final ZiWeiPlate plate;
  final ZiweiUIState state;
  final GlobalKey chartRootKey;
  final void Function(int palaceIndex, Rect? rect) onGanRectChanged;
  final void Function(String starKey, Rect? rect) onFlyingTargetRectChanged;
  final void Function(String starPlacementKey, Rect? rect) onSihuaStarRectChanged;
  final void Function(String badgePlacementKey, Rect? rect) onSihuaBadgeRectChanged;

  const PalaceCellWidget({
    super.key,
    required this.palace,
    required this.plate,
    required this.state,
    required this.chartRootKey,
    required this.onGanRectChanged,
    required this.onFlyingTargetRectChanged,
    required this.onSihuaStarRectChanged,
    required this.onSihuaBadgeRectChanged,
  });

  double _ps(num value) => value * _palaceScale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 初始化UI缩放（确保所有自适应尺寸生效）
    UIScale.init(context);
    final chartMode = ref.watch(ziweiChartModeProvider);
    final isFlyingMode = chartMode == ZiweiChartMode.flying;
    final isSihuaMode = chartMode == ZiweiChartMode.sihua;
    final isCompactMode = isFlyingMode || isSihuaMode;
    const canUseFlyingArrow = true;
    final ziweiOptions = ref.watch(
      inputNotifierProvider.select((profile) => profile.ziweiOptions),
    );

    // === 预计算 ===
    final role = plate.getRole(ZiweiScope.origin, palace.index);
    final decade = _findDecade();
    final flowStarDisplay = ziweiOptions.flowStarDisplay;
    final enableFlyingStarHighlightFrame =
        ziweiOptions.animation.enableFlyingStarHighlightFrame;
    final enableFlyingStarArrow = ziweiOptions.animation.enableFlyingStarArrow;
    final flowStars = isCompactMode ? const <FlowStar>[] : _collectOverlayFlowStars();

    // 分类星曜
    final majorStars = palace.stars[StarType.major] ?? [];
    final luckyStars = palace.stars[StarType.lucky] ?? [];
    final badStars = palace.stars[StarType.bad] ?? [];
    final minorStars = palace.stars[StarType.minor] ?? [];
    final changshengStars = palace.stars[StarType.changsheng12] ?? [];
    // 所有顶部可展示星曜（主星 + 吉星 + 煞星 + 乙级）
    final topStars = isCompactMode
        ? _buildFlyingTopStars(
            majorStars: majorStars,
            luckyStars: luckyStars,
            badStars: badStars,
            minorStars: minorStars,
          )
        : [...majorStars, ...luckyStars, ...badStars, ...minorStars];

    // 三组十二神（放在底部左下角）
    final boshiStars = palace.stars[StarType.boshi12] ?? [];
    final suijianStars = palace.stars[StarType.suijian12] ?? [];
    final jiangqianStars = palace.stars[StarType.jiangqian12] ?? [];
    final shenshaLines = isCompactMode
        ? const <_BottomShenshaLine>[]
        : _buildBottomShenshaLines(
            flowStarDisplay: flowStarDisplay,
            boshiStars: boshiStars,
            suijianStars: suijianStars,
            jiangqianStars: jiangqianStars,
          );

    // 获取长生名（右下角）
    final changshengName = !isCompactMode && changshengStars.isNotEmpty
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
              padding: EdgeInsets.symmetric(
                horizontal: _ps(4.ws),
                vertical: _ps(1.5.hs),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: _buildStarGrid(
                      topStars,
                      isFlyingMode: isFlyingMode,
                      isSihuaMode: isSihuaMode,
                      isCompactMode: isCompactMode,
                      canUseFlyingArrow: canUseFlyingArrow,
                      enableFlyingStarHighlightFrame:
                          enableFlyingStarHighlightFrame,
                      enableFlyingStarArrow: enableFlyingStarArrow,
                    ),
                  ),
                  // 取消原有的 Spacer，改为极小的固定间距，让上下结构更紧凑
                  SizedBox(height: _ps(1.hs)),
                  // ======== 底部：宫名与重要堆叠标记 (按照专业布局解耦) ======== (flex: 3)
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: isCompactMode ? _ps(14.ws) : _ps(18.ws),
                      ), // 缩减边距，配合右对齐让布局更紧凑
                      child: isCompactMode
                          ? _buildFlyingBottomSection(role: role)
                          : _buildBottomSection(
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

            // 4. 十二长生 + 干支 + 流曜 (绝对定位在右下角)
            Positioned(
              right: _ps(2.ws),
              bottom: _ps(2.hs),
              child: _buildRightInfoColumn(
                changshengName,
                ganLabel,
                zhiLabel,
                isFlyingMode: isFlyingMode,
                isSihuaMode: isSihuaMode,
                canUseFlyingArrow: canUseFlyingArrow,
                flowStars: flowStars,
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
              fontSize: _ps(32.ts),
              fontWeight: FontWeight.w900,
              color: ZiweiClassicTheme.sihuaJi.withOpacity(0.8), // 淡淡的红印感
            ),
          ),
        ),
      ),
    );
  }

  /// 渲染右下角垂直信息柱 (流曜 + 长生 + 干支)
  Widget _buildRightInfoColumn(
    String changsheng,
    String gan,
    String zhi, {
    required bool isFlyingMode,
    required bool isSihuaMode,
    required bool canUseFlyingArrow,
    required List<FlowStar> flowStars,
    required bool enableFlyingStarArrow,
  }) {
    final previewWidget =
        (isFlyingMode || isSihuaMode) ? _buildFlowPreviewAboveGanzhi() : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 1. 流曜 (竖排，放在最上面)
        if (flowStars.isNotEmpty) _buildVerticalFlowStars(flowStars),
        if (flowStars.isNotEmpty && changsheng.isNotEmpty)
          SizedBox(height: _ps(4.hs)),

        // 2. 十二长生 (灰色，小字辅助)
        if (changsheng.isNotEmpty)
          _buildVerticalText(
            changsheng,
            TextStyle(
              fontSize: _ps(8.5.ts),
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
              height: 1.05,
            ),
          ),
        if (previewWidget != null) ...[
          SizedBox(height: _ps(2.hs)),
          previewWidget,
        ],
        SizedBox(height: _ps(1.hs)),
        // 3. 宫位干支 (宫干单独测量，供飞星连线使用)
        if (gan.isNotEmpty && canUseFlyingArrow && enableFlyingStarArrow)
          _GeometryReporter(
            rootKey: chartRootKey,
            onChanged: (rect) => onGanRectChanged(palace.index, rect),
            child: _buildVerticalText(
              gan,
              TextStyle(
                fontSize: _ps(11.5.ts),
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1.05,
              ),
            ),
          )
        else if (gan.isNotEmpty)
          _buildVerticalText(
            gan,
            TextStyle(
              fontSize: _ps(11.5.ts),
              fontWeight: FontWeight.w900,
              color: Colors.black,
              height: 1.05,
            ),
          ),
        if (zhi.isNotEmpty)
          _buildVerticalText(
            zhi,
            TextStyle(
              fontSize: _ps(11.5.ts),
              fontWeight: FontWeight.w900,
              color: Colors.black,
              height: 1.05,
            ),
          ),
      ],
    );
  }

  Widget? _buildFlowPreviewAboveGanzhi() {
    final hourEntries = _currentPalaceHourPreviewEntries();
    if (hourEntries.isNotEmpty) {
      return _buildSingleLineFlowPreview(
        hourEntries,
        scope: ZiweiScope.hour,
        fontSize: _ps(8.7.ts),
      );
    }

    final dayEntries = _currentPalaceDayPreviewEntries();
    if (dayEntries.isNotEmpty) {
      return _buildSingleLineFlowPreview(
        dayEntries,
        scope: ZiweiScope.day,
        fontSize: _ps(8.8.ts),
      );
    }

    final monthEntries = _currentPalaceMonthPreviewEntries();
    if (monthEntries.isNotEmpty) {
      return _buildSingleLineFlowPreview(
        monthEntries,
        scope: ZiweiScope.month,
        fontSize: _ps(8.9.ts),
      );
    }

    final yearLabels = _currentPalaceYearPreviewLabels();
    if (yearLabels.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: yearLabels
            .map(
              (label) => Padding(
                padding: EdgeInsets.only(bottom: _ps(1.2.hs)),
                child: Text(
                  label,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: _ps(10.6.ts),
                    fontWeight: FontWeight.w700,
                    color: ZiweiClassicTheme.getScopeColor(ZiweiScope.year),
                    height: 1.05,
                  ),
                ),
              ),
            )
            .toList(),
      );
    }

    return null;
  }

  Widget _buildSingleLineFlowPreview(
    List<_FlowPreviewEntry> entries, {
    required ZiweiScope scope,
    required double fontSize,
  }) {
    final color = ZiweiClassicTheme.getScopeColor(scope);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: entries
          .map(
            (entry) => Padding(
              padding: EdgeInsets.only(bottom: _ps(1.4.hs)),
              child: Text(
                '${entry.primaryLabel} ${entry.secondaryLabel}',
                softWrap: false,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: color,
                  height: 1.06,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  List<String> _currentPalaceYearPreviewLabels() {
    if (state.currentDecade == null || state.currentYear != null) {
      return const [];
    }

    if (state.currentDecade!.decadeIndex == 0) {
      return state.manifest.childhoods
          .where(
            (node) => FlowYear.createByYear(node.year, plate).index == palace.index,
          )
          .map((node) => _formatYearPreviewLabel(node.year, node.age))
          .toList();
    }

    final years = state.manifest.currentDecadeYears;
    if (years == null) return const [];
    final effectiveBirthYear = Decade.getEffectiveBirthYear(plate);

    return years
        .where(
          (node) => FlowYear.createByYear(node.year, plate).index == palace.index,
        )
        .map(
          (node) => _formatYearPreviewLabel(
            node.year,
            node.year - effectiveBirthYear + 1,
          ),
        )
        .toList();
  }

  String _formatYearPreviewLabel(int year, int age) {
    return '$year${'年'.tr}$age${'岁'.tr}';
  }

  List<_FlowPreviewEntry> _currentPalaceMonthPreviewEntries() {
    final year = state.currentYear;
    final months = state.manifest.currentYearMonths;
    if (year == null || months == null || state.currentMonth != null) {
      return const [];
    }

    return months
        .where((node) {
          final flowMonth = FlowMonth.create(
            node.month,
            year.year,
            plate,
            sequence: node.month,
            isLeap: node.isLeap,
          );
          return flowMonth.index == palace.index;
        })
        .map(
          (node) => _FlowPreviewEntry(
            primaryLabel: node.displayLabel,
            secondaryLabel: _previewMonthGanzhiLabel(node),
          ),
        )
        .toList();
  }

  List<_FlowPreviewEntry> _currentPalaceDayPreviewEntries() {
    final month = state.currentMonth;
    final days = state.manifest.currentMonthDays;
    if (month == null || days == null || state.currentDay != null) {
      return const [];
    }

    return days
        .where((node) {
          final dayGZ = GanZhi(
            TianGan.fromName(node.stem),
            DiZhi.fromName(node.branch),
          );
          final flowDay = FlowDay.create(node.day, dayGZ, month, plate);
          return flowDay.index == palace.index;
        })
        .map(
          (node) => _FlowPreviewEntry(
            primaryLabel: node.day.lunarDay,
            secondaryLabel: '${node.stem.ganDisplay}${node.branch.zhiDisplay}',
          ),
        )
        .toList();
  }

  List<_FlowPreviewEntry> _currentPalaceHourPreviewEntries() {
    final day = state.currentDay;
    final hours = state.manifest.currentDayHours;
    if (day == null || hours == null) return const [];

    return hours
        .where((node) {
          final flowHour = FlowHour.create(node.hourIndex, day, plate);
          return flowHour.index == palace.index;
        })
        .map(
          (node) => _FlowPreviewEntry(
            primaryLabel: node.hourIndex.hourName,
            secondaryLabel: '${node.stem.ganDisplay}${node.branch.zhiDisplay}',
          ),
        )
        .toList();
  }

  String _previewMonthGanzhiLabel(MonthNode node) {
    final branchIndex = (node.sequence + 1) % 12;
    return '${node.stem.ganDisplay}${DiZhi.values[branchIndex].display}';
  }

  /// 竖排显示流曜 (参考主流紫微软件布局)
  /// 单个星曜竖着排，多颗星往左横向展开
  /// 层级顺序：大限(右) → 流年 → 流月 → 流日 → 流时(左)
  Widget _buildVerticalFlowStars(List<FlowStar> flowStars) {
    // 按scope分组
    final grouped = <ZiweiScope, List<FlowStar>>{};
    for (final star in flowStars) {
      grouped.putIfAbsent(star.scope, () => []).add(star);
    }

    // 定义显示优先级：大限在最右(最靠近长生)，依次往左
    const scopePriority = [
      ZiweiScope.decade,  // 最右边
      ZiweiScope.year,
      ZiweiScope.month,
      ZiweiScope.day,
      ZiweiScope.hour,    // 最左边
    ];

    // 按优先级收集星曜
    final List<_FlowStarItem> items = [];
    for (final scope in scopePriority) {
      final stars = grouped[scope];
      if (stars == null) continue;
      for (final star in stars) {
        items.add(_FlowStarItem(
          name: _flowStarDisplayName(star),
          color: ZiweiClassicTheme.getScopeColor(scope),
        ));
      }
    }

    if (items.isEmpty) return const SizedBox.shrink();

    // 从右到左排列：大限在最右(靠近长生)，流时在最左
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: items.reversed.map((item) {
        return Padding(
          padding: EdgeInsets.only(right: _ps(1.ws)),
          child: _buildVerticalText(
            item.name,
            TextStyle(
              fontSize: _ps(8.ts),
              fontWeight: FontWeight.w500,
              color: item.color,
              height: 1.05,
            ),
          ),
        );
      }).toList(),
    );
  }

  double _estimateRightOverlayConflictHeight(
    List<Star> stars,
    double maxWidth,
    double overlayZoneWidth,
  ) {
    if (stars.isEmpty || maxWidth <= 0) return 0;

    final baseFontSize = _ps(11.5.ts);
    final spacing = _ps(0.5.ws);

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
      final height = _estimateStarColumnHeight(
        star,
        baseFontSize,
        isFlyingMode: false,
      );
      final width = baseFontSize + spacing;
      layouts.add(_StarColumnMetric(cursor, cursor + width, height));
      cursor += width;
    }
    for (final star in secondaryStars) {
      final height = _estimateStarColumnHeight(
        star,
        secondaryFontSize,
        isFlyingMode: false,
      );
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

    return maxConflictHeight > 0 ? maxConflictHeight + _ps(6.hs) : 0;
  }

  double _estimateStarColumnHeight(
    Star star,
    double fontSize, {
    required bool isFlyingMode,
  }) {
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
    final brightnessHeight =
        !isFlyingMode && brightness.isNotEmpty ? (_ps(9.ts) * 1.1) : 0.0;

    double badgeHeight = 0;
    if (star is StaticStar && star.siHuaBuff.isNotEmpty) {
      badgeHeight = fontSize * 0.85;
    }

    return nameHeight + brightnessHeight + badgeHeight + _ps(4.hs);
  }

  /// 顶部星曜区：阶梯式缩放逻辑
  /// 1. 主星与吉星（辅星）字号锁定，保证全局视觉权重一致
  /// 2. 煞星与杂曜执行“自动缩放”，在空间不足时动态缩小
  Widget _buildStarGrid(
    List<Star> stars, {
    required bool isFlyingMode,
    required bool isSihuaMode,
    required bool isCompactMode,
    required bool canUseFlyingArrow,
    required bool enableFlyingStarHighlightFrame,
    required bool enableFlyingStarArrow,
  }) {
    if (stars.isEmpty) return const SizedBox.shrink();

    final shouldResolveFlyingTargets =
        enableFlyingStarHighlightFrame ||
        (canUseFlyingArrow && enableFlyingStarArrow);
    final selectedFlyingTargets = shouldResolveFlyingTargets
        ? _selectedPalaceFlyingTargets()
        : const <String, SiHuaType>{};

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double baseFontSize = isCompactMode
            ? _ps(13.8.ts)
            : _ps(11.5.ts);
        final double spacing = _ps(0.5.ws);

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
        final double primaryTotalWidth = primaryCount * (baseFontSize + spacing);
        final double remainingWidth = maxWidth - primaryTotalWidth;

        double secondaryFontSize = baseFontSize;
        if (secondaryCount > 0) {
          // 仅对杂曜进行空间压缩逻辑
          secondaryFontSize = (remainingWidth / secondaryCount) - spacing;
          if (secondaryFontSize < (isCompactMode ? 10.4 : 8.5)) {
            secondaryFontSize = isCompactMode ? 10.4 : 8.5;
          }
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
                    padding: EdgeInsets.only(right: spacing),
                    child: _buildStarColumn(
                      star,
                      isFlyingMode: isFlyingMode,
                      isSihuaMode: isSihuaMode,
                      isCompactMode: isCompactMode,
                      canUseFlyingArrow: canUseFlyingArrow,
                      fontSize: baseFontSize,
                      baseFontSize: baseFontSize,
                      maxHeight: constraints.maxHeight,
                      flyingHighlightType: selectedFlyingTargets[star.key],
                      enableFlyingStarHighlightFrame:
                          enableFlyingStarHighlightFrame,
                      enableFlyingStarArrow: enableFlyingStarArrow,
                    ),
                  );
                }),
                // B. 杂曜：动态计算字号，优先收缩
                ...secondaryStars.map((star) {
                  return Padding(
                    padding: EdgeInsets.only(right: spacing),
                    child: _buildStarColumn(
                      star,
                      isFlyingMode: isFlyingMode,
                      isSihuaMode: isSihuaMode,
                      isCompactMode: isCompactMode,
                      canUseFlyingArrow: canUseFlyingArrow,
                      fontSize: secondaryFontSize,
                      baseFontSize: baseFontSize,
                      maxHeight: constraints.maxHeight,
                      flyingHighlightType: selectedFlyingTargets[star.key],
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
    {
    required bool isFlyingMode,
    required bool isSihuaMode,
    required bool isCompactMode,
    required bool canUseFlyingArrow,
    required double fontSize,
    required double baseFontSize,
    required double maxHeight,
    required SiHuaType? flyingHighlightType,
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
      final scopeOrder = isCompactMode
          ? const [ZiweiScope.origin]
          : const [
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
          Widget badge = _buildSihuaBadge(
            type,
            scope,
            fontSize,
            useTypeColor: isCompactMode,
            useLetterLabel: isSihuaMode,
          );
          if (isSihuaMode) {
            final badgePlacementKey =
                '${palace.index}:${star.key}:${type.index}';
            badge = _GeometryReporter(
              rootKey: chartRootKey,
              onChanged: (rect) => onSihuaBadgeRectChanged(badgePlacementKey, rect),
              child: badge,
            );
          }
          sihuaBadges.add(badge);
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
    final lineSlotHeight = _starLineSlotHeight(fontSize);
    final charGap = _starCharGap(fontSize);
    final textTopInset = _starTextTopInset(
      baseFontSize: baseFontSize,
      actualFontSize: fontSize,
    );

    Widget nameContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: _ps(1.hs)),
        for (int i = 0; i < characters.length; i++) ...[
          SizedBox(
            height: lineSlotHeight,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: textTopInset),
                child: Text(
                  characters[i],
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: isMajor ? FontWeight.w700 : FontWeight.w400,
                    color: color,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
          if (i < characters.length - 1) SizedBox(height: charGap),
        ],
      ],
    );

    if (flyingHighlightType != null && star is StaticStar) {
      if (enableFlyingStarHighlightFrame) {
        final frameColor = ZiweiClassicTheme.getSihuaColor(flyingHighlightType);
        nameContent = Container(
          padding: EdgeInsets.symmetric(
            horizontal: _ps(1.ws),
            vertical: _ps(1.hs),
          ),
          decoration: BoxDecoration(
            color: frameColor.withOpacity(0.08),
            border: Border.all(color: frameColor, width: _ps(1.2.ws)),
            borderRadius: BorderRadius.circular(_ps(3.ws)),
          ),
          child: nameContent,
        );
      }
      if (canUseFlyingArrow && enableFlyingStarArrow) {
        nameContent = _GeometryReporter(
          rootKey: chartRootKey,
          onChanged: (rect) => onFlyingTargetRectChanged(star.key, rect),
          child: nameContent,
        );
      }
    }

    Widget starColumn = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        nameContent,
        // 亮度
        if (!isCompactMode && brightness.isNotEmpty)
          FittedBox(
            child: Text(
              brightness,
              style: TextStyle(
                fontSize: _ps(10.ts),
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
            padding: EdgeInsets.only(top: _ps(0.5.hs)),
            child: SizedBox(
              width: fontSize,
              height: fontSize,
              child: OverflowBox(
                minHeight: 0,
                maxHeight: 120,
                alignment: Alignment.topCenter,
                child: () {
                  final double badgeTopPadding = _ps(0.5.hs);
                  final double badgeGap = _ps(0.25.hs);

                  // --- 碰撞检测逻辑 ---
                  // 1. 计算星曜及亮度所占高度
                  final double starHeight = characters.length *
                      (fontSize * 1.1 + _ps(1.hs));
                  final double bHeight =
                      !isCompactMode && brightness.isNotEmpty
                      ? (_ps(10.ts) * 1.1)
                      : 0;
                  final double occupiedHeight =
                      starHeight + bHeight + _ps(1.hs);

                  // 2. 计算如果不叠压所需的总高度
                  final double unstackedBadgesHeight =
                      sihuaBadges.length * fontSize +
                      ((sihuaBadges.length - 1).clamp(0, 99) * badgeGap);
                  final double totalUnstackedHeight =
                      occupiedHeight + badgeTopPadding + unstackedBadgesHeight;

                  // 3. 更宽松的堆叠判定：
                  // - 1~3 个四化默认不堆叠，保留辨识度
                  // - 4 个及以上只有在明显超出时才堆叠
                  final bool shouldStack = sihuaBadges.length >= 4 &&
                      totalUnstackedHeight > (maxHeight + fontSize * 0.6);

                  if (!shouldStack) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: sihuaBadges
                          .map(
                            (b) => Padding(
                              padding: EdgeInsets.only(bottom: _ps(0.25.hs)),
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

    if (isSihuaMode && star is StaticStar) {
      final placementKey = '${palace.index}:${star.key}';
      starColumn = _GeometryReporter(
        rootKey: chartRootKey,
        onChanged: (rect) => onSihuaStarRectChanged(placementKey, rect),
        child: starColumn,
      );
    }

    return starColumn;
  }

  List<Star> _buildFlyingTopStars({
    required List<Star> majorStars,
    required List<Star> luckyStars,
    required List<Star> badStars,
    required List<Star> minorStars,
  }) {
    const flyingMinorKeys = {
      'hongluan',
      'tianxi',
      'tianyao',
      'tianxing',
    };

    final flyingMinorStars = minorStars
        .where((star) => flyingMinorKeys.contains(star.key))
        .toList();

    return [...majorStars, ...luckyStars, ...badStars, ...flyingMinorStars];
  }

  double _starLineSlotHeight(double actualFontSize) {
    return actualFontSize * 1.12;
  }

  double _starCharGap(double actualFontSize) {
    return (actualFontSize * 0.06).clamp(_ps(0.15.hs), _ps(0.8.hs));
  }

  double _starTextTopInset({
    required double baseFontSize,
    required double actualFontSize,
  }) {
    final shrink = (baseFontSize - actualFontSize).clamp(0.0, baseFontSize);
    if (shrink < _ps(0.2.ts)) return 0.0;
    return (shrink * 0.28).clamp(0.0, _ps(1.8.hs));
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
  Widget _buildSihuaBadge(
    SiHuaType type,
    ZiweiScope scope,
    double fontSize, {
    bool useTypeColor = false,
    bool useLetterLabel = false,
  }) {
    final color = useTypeColor
        ? ZiweiClassicTheme.getSihuaColor(type)
        : ZiweiClassicTheme.getScopeColor(scope);
    final double badgeSize = fontSize; // 强制与字号一致
    final label = useLetterLabel ? _sihuaLetterLabel(type) : type.display;

    if (useLetterLabel) {
      return SizedBox(
        width: badgeSize,
        height: badgeSize,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: badgeSize * 1.12,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1.0,
            ),
          ),
        ),
      );
    }

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
          label,
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

  String _sihuaLetterLabel(SiHuaType type) {
    switch (type) {
      case SiHuaType.lu:
        return 'A';
      case SiHuaType.quan:
        return 'B';
      case SiHuaType.ke:
        return 'C';
      case SiHuaType.ji:
        return 'D';
    }
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
          width: _ps(20.ws),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: shenshaLines
                .map(
                  (line) => Text(
                    line.name,
                    style:
                        TextStyle(
                          fontSize: _ps(9.5.ts), // 稍微调大点，增强可读性
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

        // 2. 中间：流运五星阵 (3x2布局，字体放大，防爆处理)
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
              // 左侧留白，把宫职往右推
              SizedBox(width: _ps(8.ws)),
              // 左列：流月/流日/流时（竖着，靠右对齐）
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildFixedRoleLabel(
                    ZiweiScope.month,
                    '月',
                    fontSize: _ps(10.ts),
                  ),
                  _buildFixedRoleLabel(
                    ZiweiScope.day,
                    '日',
                    fontSize: _ps(10.ts),
                  ),
                  _buildFixedRoleLabel(
                    ZiweiScope.hour,
                    '时',
                    fontSize: _ps(10.ts),
                  ),
                ],
              ),
              SizedBox(width: _ps(3.ws)),
              // 右列：本命/大限/流年（竖着，本命在最下）
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildFixedRoleLabel(
                    ZiweiScope.year,
                    '年',
                    fontSize: _ps(10.ts),
                  ),
                  _buildFixedRoleLabel(
                    ZiweiScope.decade,
                    state.currentDecade?.decadeIndex == 0 ? '童' : '大',
                    fontSize: _ps(10.ts),
                  ),
                  // 宫位名在最下面
                  Text(
                    role.display,
                    style: TextStyle(
                      fontSize: _ps(10.ts),
                      fontWeight: FontWeight.w700,
                      color: role == PalaceRole.life
                          ? ZiweiClassicTheme.sihuaJi
                          : ZiweiClassicTheme.palaceNameColor,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ),
        ),

        // 3. 右侧原本的位置现在为空，改由外部 Positioned 渲染
      ],
    );
  }

  Widget _buildFlyingBottomSection({required PalaceRole role}) {
    final bottomFontSize = _ps(11.ts);

    return Align(
      alignment: Alignment.bottomRight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildFixedRoleLabel(
                  ZiweiScope.month,
                  '月',
                  fontSize: bottomFontSize,
                ),
                _buildFixedRoleLabel(
                  ZiweiScope.day,
                  '日',
                  fontSize: bottomFontSize,
                ),
                _buildFixedRoleLabel(
                  ZiweiScope.hour,
                  '时',
                  fontSize: bottomFontSize,
                ),
              ],
            ),
            SizedBox(width: _ps(4.ws)),
            Text(
              role.display,
              style: TextStyle(
                fontSize: bottomFontSize,
                fontWeight: FontWeight.w700,
                color: role == PalaceRole.life
                    ? ZiweiClassicTheme.sihuaJi
                    : ZiweiClassicTheme.palaceNameColor,
                height: 1.0,
              ),
            ),
            SizedBox(width: _ps(4.ws)),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildFixedRoleLabel(
                  ZiweiScope.year,
                  '年',
                  fontSize: bottomFontSize,
                ),
                _buildFixedRoleLabel(
                  ZiweiScope.decade,
                  state.currentDecade?.decadeIndex == 0 ? '童' : '大',
                  fontSize: bottomFontSize,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建固定位置的角色标签
  Widget _buildFixedRoleLabel(ZiweiScope scope, String prefix,
      {double fontSize = 10.5}) {
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
    if (!active) return SizedBox(width: fontSize + _ps(8.ws));

    final r = plate.getRole(scope, palace.index);
    final shortName = r.display.isNotEmpty
        ? (r == PalaceRole.friends ? '友' : r.display.substring(0, 1))
        : '';

    return Text(
      "$prefix$shortName",
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: ZiweiClassicTheme.getScopeColor(scope),
        height: 1.0, // 极致紧凑
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
      alignment: const Alignment(0, 0.32), // 稍微上提，避开底部宫职区
      child: Opacity(
        opacity: info.isActive ? 0.24 : 0.12,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _ps(6.0.ws),
            vertical: _ps(2.0.hs),
          ), // 为斜体字与缩放留出安全边距
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              info.text,
              style: TextStyle(
                fontSize: info.fontSize,
                fontWeight: FontWeight.w700,
                color: info.color,
                height: 1.0,
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
        fontSize: _ps(22.ts),
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
        fontSize: _ps(22.ts),
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
        fontSize: _ps(24.ts),
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
        fontSize: _ps(26.ts),
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
        fontSize: _ps(28.ts),
      );
    }

    // 默认：显示大限岁数区间
    return _WatermarkInfo(
      text: '${fallbackDecade.startTime}~${fallbackDecade.endTime}',
      prefix: '',
      color: Colors.grey,
      isActive: false,
      fontSize: _ps(28.ts),
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

class _FlowStarItem {
  final String name;
  final Color color;

  const _FlowStarItem({
    required this.name,
    required this.color,
  });
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

class _FlowPreviewEntry {
  final String primaryLabel;
  final String secondaryLabel;

  const _FlowPreviewEntry({
    required this.primaryLabel,
    required this.secondaryLabel,
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
