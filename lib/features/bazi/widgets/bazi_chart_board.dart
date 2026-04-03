import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bazi_core/bazi_core.dart';
import '../../../core/ui_scale.dart';
import '../bazi_view.dart';
import 'bazi_pillar_widget.dart';
import 'bazi_interaction_painter.dart';
import '../../../core/l10n.dart';
import '../../../providers/input_provider.dart';

final selectedPillarIdxProvider = StateProvider<int?>((ref) => null);

class BaziChartBoard extends ConsumerStatefulWidget {
  final BaziChart chart;
  final FortuneTable table;
  final BaziBottomTab currentTab;
  final double? maxVisibleHeight;
  final double adaptiveScale;

  const BaziChartBoard({
    super.key,
    required this.chart,
    required this.table,
    required this.currentTab,
    this.maxVisibleHeight,
    this.adaptiveScale = 1.0,
  });

  @override
  ConsumerState<BaziChartBoard> createState() => _BaziChartBoardState();
}

class _BaziChartBoardState extends ConsumerState<BaziChartBoard> {
  final ScrollController _chartScrollController = ScrollController();

  @override
  void dispose() {
    _chartScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UIScale.init(context);

    final selD = ref.watch(selDecadeIdxProvider);
    final selY = ref.watch(selYearIdxProvider);
    final selM = ref.watch(selMonthIdxProvider);
    final selDay = ref.watch(selDayIdxProvider);
    final selH = ref.watch(selHourIdxProvider);
    final selectedPillarIdx = ref.watch(selectedPillarIdxProvider);

    final dayMaster = widget.chart.bazi.day.gan;
    final isEn = AppL10nSettings.currentLanguage == AppLanguage.en;
    final _showProfessional = ref.watch(showProfessionalProvider);
    final _showInteraction = ref.watch(showInteractionProvider);
    final chartVisualScale = _resolveChartVisualScale(
      maxVisibleHeight: widget.maxVisibleHeight,
      showProfessional: _showProfessional,
      showInteraction: _showInteraction,
      adaptiveScale: widget.adaptiveScale,
    );

    final earthAlgo = ref.watch(inputNotifierProvider).baziOptions.earthPalaceAlgorithm;

    // --- 准备数据定义 ---
    final leftDefinitions = <({String label, GanZhi gz, PillarType type})>[];
    if (widget.currentTab == BaziBottomTab.taiMingShen) {
      leftDefinitions.addAll([
        (label: '身宫', gz: widget.chart.shenGong, type: PillarType.shenGong),
        (label: '命宫', gz: widget.chart.mingGong, type: PillarType.mingGong),
        (label: '胎息', gz: widget.chart.taiXi, type: PillarType.taiXi),
        (label: '胎元', gz: widget.chart.taiYuan, type: PillarType.taiYuan),
      ]);
    } else {
      if (selH != null &&
          selDay != null &&
          selM != null &&
          selY != null &&
          selD != null) {
        final gz = widget
            .table
            .decades[selD]
            .years[selY]
            .months[selM]
            .days[selDay]
            .hours[selH]
            .ganZhi;
        leftDefinitions.add((label: '流时', gz: gz, type: PillarType.flowHour));
      }
      if (selDay != null && selM != null && selY != null && selD != null) {
        final gz = widget
            .table
            .decades[selD]
            .years[selY]
            .months[selM]
            .days[selDay]
            .ganZhi;
        leftDefinitions.add((label: '流日', gz: gz, type: PillarType.flowDay));
      }
      if (selM != null && selY != null && selD != null) {
        final gz = widget.table.decades[selD].years[selY].months[selM].ganZhi;
        leftDefinitions.add((label: '流月', gz: gz, type: PillarType.flowMonth));
      }
      if (selY != null && selD != null) {
        final gz = widget.table.decades[selD].years[selY].ganZhi;
        leftDefinitions.add((label: '流年', gz: gz, type: PillarType.flowYear));
      }
      if (selD != null) {
        final decade = widget.table.decades[selD];
        final isXiaoYun = decade.index == 0;
        GanZhi displayGz = decade.ganZhi;
        if (isXiaoYun) {
          int age = 1;
          if (selY != null) {
            final targetYear = decade.years[selY].year;
            age = targetYear - widget.table.fortune.birthday.year + 1;
          }
          displayGz = widget.table.fortune.getXiaoYunByAge(age);
        }
        leftDefinitions.add((
          label: isXiaoYun ? '小运'.tr : '大运'.tr,
          gz: displayGz,
          type: PillarType.decade,
        ));
      }
    }

    final originalDefinitions = [
      (label: '年柱', gz: widget.chart.bazi.year, type: PillarType.year),
      (label: '月柱', gz: widget.chart.bazi.month, type: PillarType.month),
      (label: '日元'.tr, gz: widget.chart.bazi.day, type: PillarType.day),
      (label: '时柱', gz: widget.chart.bazi.time, type: PillarType.hour),
    ];

    final leftCount = leftDefinitions.length;
    final totalPillarsCount = leftCount + 4;

    final normalized = math.max(
      0.0,
      math.min(1.0, (totalPillarsCount - 4) / 5.0),
    );
    final curve = math.cos(normalized * (math.pi / 2));
    final double pWidth =
        (isEn ? 70.0 : (41.0 + (47.0 - 41.0) * curve)).ws * chartVisualScale;
    final double gap =
        (4.0 + (8.0 - 4.0) * curve).ws * chartVisualScale;
    final double elasticMargin =
        (4.0 + (28.0 - 4.0) * curve).ws * chartVisualScale;

    final List<({PillarType type, GanZhi gz})> allPillarData = [];

    Widget _buildPillar(
      int globalIdx,
      String label,
      GanZhi gz,
      PillarType type,
    ) {
      allPillarData.add((type: type, gz: gz));

      final pillar = BaziPillarWidget(
        label: label,
        gz: gz,
        dayMaster: dayMaster,
        width: pWidth,
        visualScale: chartVisualScale,
        showProfessional: _showProfessional,
        showInteraction: _showInteraction,
        isDayMaster: type == PillarType.day,
        earthPalaceAlgorithm: earthAlgo,
        shenShas: _showProfessional
            ? ShenShaHelper.getShenSha(widget.chart, gz, type)
            : const [],
      );

      // 💡 只有开启连线图时，才允许“聚焦选中”交互
      if (!_showInteraction) return pillar;

      final isSelected = selectedPillarIdx == globalIdx;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          ref.read(selectedPillarIdxProvider.notifier).state = isSelected
              ? null
              : globalIdx;
        },
        child: Opacity(
          opacity: (selectedPillarIdx == null || isSelected) ? 1.0 : 0.3,
          child: pillar,
        ),
      );
    }

    final leftPillarsWidgets = leftDefinitions
        .asMap()
        .entries
        .map(
          (e) => _buildPillar(e.key, e.value.label, e.value.gz, e.value.type),
        )
        .toList();
    final originalPillarsWidgets = originalDefinitions
        .asMap()
        .entries
        .map(
          (e) => _buildPillar(
            leftCount + e.key,
            e.value.label,
            e.value.gz,
            e.value.type,
          ),
        )
        .toList();

    // --- 计算交互数据 ---
    List<InteractionUIResult> stemInteractions = [];
    List<InteractionUIResult> branchInteractions = [];
    List<double> pillarCenters = [];

    if (_showInteraction) {
      final stems = allPillarData
          .map((p) => InteractionNode(p.type, p.gz.gan))
          .toList();
      final branches = allPillarData
          .map((p) => InteractionNode(p.type, p.gz.zhi))
          .toList();
      final rawStems = BaziInteractionCalculator.calculateStemInteractions(
        stems,
      );
      final rawBranches = BaziInteractionCalculator.calculateBranchInteractions(
        branches,
      );

      List<InteractionUIResult> _mapToUI(
        List<InteractionResult> raw,
        List<InteractionNode> originalNodes,
      ) {
        return raw.map((res) {
          final indices = <int>[];
          for (var node in res.nodes) {
            for (int i = 0; i < originalNodes.length; i++) {
              if (originalNodes[i].pillar == node.pillar &&
                  originalNodes[i].value == node.value) {
                indices.add(i);
                break;
              }
            }
          }
          return InteractionUIResult(
            type: res.type,
            pillarIndices: indices,
            combinedWuXing: res.combinedWuXing,
          );
        }).toList();
      }

      stemInteractions = _mapToUI(rawStems, stems);
      branchInteractions = _mapToUI(rawBranches, branches);

      double currentX =
          (_showProfessional ? 32.0.ws * chartVisualScale : 0.0) +
          elasticMargin;
      for (int i = 0; i < leftPillarsWidgets.length; i++) {
        pillarCenters.add(currentX + pWidth / 2);
        currentX += pWidth + gap;
      }
      if (leftPillarsWidgets.isNotEmpty) {
        currentX += (1.ws * chartVisualScale) + gap;
      }
      for (int i = 0; i < originalPillarsWidgets.length; i++) {
        pillarCenters.add(currentX + pWidth / 2);
        currentX += pWidth + gap;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.hs),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(16.ws),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _chartScrollController,
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_showProfessional)
                        _buildProfessionalLegend(
                          _showInteraction,
                          chartVisualScale,
                        ),
                      SizedBox(width: elasticMargin),
                      ..._buildPillarListWithSpacing(leftPillarsWidgets, gap),
                      if (leftPillarsWidgets.isNotEmpty) ...[
                        SizedBox(width: gap),
                        Container(
                          width: 1.ws,
                          height:
                              (160.hs + (_showInteraction ? 140.hs : 0)) *
                              chartVisualScale,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(width: gap),
                      ],
                      ..._buildPillarListWithSpacing(
                        originalPillarsWidgets,
                        gap,
                      ),
                      SizedBox(width: elasticMargin + 4.ws),
                    ],
                  ),
                  if (_showInteraction)
                    IgnorePointer(
                      child: CustomPaint(
                        size: Size(
                          pillarCenters.isNotEmpty
                              ? pillarCenters.last + pWidth
                              : 0,
                          500.hs * chartVisualScale,
                        ),
                        painter: BaziInteractionPainter(
                          stemInteractions: stemInteractions,
                          branchInteractions: branchInteractions,
                          pillarCenters: pillarCenters,
                          stemCenterY: 105.hs * chartVisualScale,
                          branchCenterY:
                              170.hs * chartVisualScale, // 修改为从字符引出
                          selectedPillarIdx: selectedPillarIdx,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  double _resolveChartVisualScale({
    required double? maxVisibleHeight,
    required bool showProfessional,
    required bool showInteraction,
    required double adaptiveScale,
  }) {
    final defaultScale = adaptiveScale;
    if (maxVisibleHeight == null || maxVisibleHeight <= 0) {
      return defaultScale;
    }

    final estimatedUnits =
        20.0 + // 顶部标签
        20.0 + // 主十神
        (showInteraction ? 60.0 : 0.0) +
        75.0 + // 干支大字
        10.0 +
        (showInteraction ? 80.0 : 0.0) +
        96.0 + // 藏干
        (showProfessional ? 90.0 : 0.0);

    final estimatedFixedPadding = 24.0 * UIScale.scale;
    final availableHeight = (maxVisibleHeight - estimatedFixedPadding).clamp(
      120.0,
      double.infinity,
    );
    final estimatedScaleOneHeight = estimatedUnits * UIScale.scale;
    final scaleByHeight = availableHeight / estimatedScaleOneHeight;

    return scaleByHeight.clamp(0.54, defaultScale).toDouble();
  }

  Widget _buildProfessionalLegend(bool showInteraction, double visualScale) {
    double s(num value) => value * visualScale;

    return SizedBox(
      width: s(32.ws),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 计算偏移逻辑：标签(20)+十神(20)+交互留白(60)+天干地支(75)+间距(10)+中间连线层(80)+藏干高度(96)
          SizedBox(
            height:
                s(20.hs) +
                s(20.hs) +
                (showInteraction ? s(60.hs) : 0) +
                s(75.hs) +
                s(10.hs) +
                (showInteraction ? s(80.hs) : 0) +
                s(96.hs),
          ),
          for (var label in ['星运', '自坐', '空亡', '纳音'])
            SizedBox(
              height: s(20.hs),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label.tr,
                  style: TextStyle(
                    fontSize: s(10.ts),
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildPillarListWithSpacing(
    List<Widget> pillars,
    double spacing,
  ) {
    if (pillars.isEmpty) return [];
    final List<Widget> results = [];
    for (int i = 0; i < pillars.length; i++) {
      results.add(pillars[i]);
      if (i < pillars.length - 1) {
        results.add(SizedBox(width: spacing));
      }
    }
    return results;
  }
}
