import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bazi_core/bazi_core.dart';
import '../bazi_view.dart';
import 'bazi_pillar_widget.dart';
import '../../../core/l10n.dart';

class BaziChartBoard extends ConsumerStatefulWidget {
  final BaziChart chart;
  final FortuneTable table;
  final BaziBottomTab currentTab;

  const BaziChartBoard({
    super.key,
    required this.chart,
    required this.table,
    required this.currentTab,
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
    final selD = ref.watch(selDecadeIdxProvider);
    final selY = ref.watch(selYearIdxProvider);
    final selM = ref.watch(selMonthIdxProvider);
    final selDay = ref.watch(selDayIdxProvider);
    final selH = ref.watch(selHourIdxProvider);

    final dayMaster = widget.chart.bazi.day.gan;
    final isEn = AppL10nSettings.currentLanguage == AppLanguage.en;
    final _showProfessional = ref.watch(showProfessionalProvider);

    // --- 全页面弹性伸缩核心逻辑 (必须放在 Pillar 定义之前) ---
    // 提前计算总柱数以确定弹性系数
    int leftCount = 0;
    if (widget.currentTab == BaziBottomTab.taiMingShen) {
      leftCount = 4;
    } else {
      if (selD != null) leftCount++;
      if (selY != null && selD != null) leftCount++;
      if (selM != null && selY != null && selD != null) leftCount++;
      if (selDay != null && selM != null && selY != null && selD != null)
        leftCount++;
      if (selH != null &&
          selDay != null &&
          selM != null &&
          selY != null &&
          selD != null)
        leftCount++;
    }
    final totalPillarsCount = leftCount + 4; // 4 是原局年、月、日、时

    // 归一化：4柱为0，9柱及以上为1
    final normalized = math.max(
      0.0,
      math.min(1.0, (totalPillarsCount - 4) / 5.0),
    );
    final curve = math.cos(normalized * (math.pi / 2)); // 1.0 -> 0.0 的平滑曲线

    // 1. 柱子宽度弹性收缩：从 47px 到 44px (缩小极值差距)
    final double pWidth = isEn ? 70.0 : (44.0 + (47.0 - 44.0) * curve);

    // 2. 柱间距弹性收缩：从 8px 到 6px (保持稳定感)
    final double gap = 6.0 + (8.0 - 6.0) * curve;

    // 3. 侧边距弹性收缩：从 28px 到 6px
    final double elasticMargin = 6.0 + (28.0 - 6.0) * curve;

    // 4. 专业模式下的额外避让 (左侧图例35px固定)
    final double leftBasePadding = _showProfessional ? 35.0 : 0.0;

    final leftPillars = <Widget>[];
    if (widget.currentTab == BaziBottomTab.taiMingShen) {
      leftPillars.addAll([
        BaziPillarWidget(
          label: '身宫',
          gz: widget.chart.shenGong,
          dayMaster: dayMaster,
          width: pWidth,
          showProfessional: _showProfessional,
        ),
        BaziPillarWidget(
          label: '命宫',
          gz: widget.chart.mingGong,
          dayMaster: dayMaster,
          width: pWidth,
          showProfessional: _showProfessional,
        ),
        BaziPillarWidget(
          label: '胎息',
          gz: widget.chart.taiXi,
          dayMaster: dayMaster,
          width: pWidth,
          showProfessional: _showProfessional,
        ),
        BaziPillarWidget(
          label: '胎元',
          gz: widget.chart.taiYuan,
          dayMaster: dayMaster,
          width: pWidth,
          showProfessional: _showProfessional,
        ),
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
        leftPillars.add(
          BaziPillarWidget(
            label: '流时',
            gz: gz,
            dayMaster: dayMaster,
            width: pWidth,
            showProfessional: _showProfessional,
          ),
        );
      }
      if (selDay != null && selM != null && selY != null && selD != null) {
        final gz = widget
            .table
            .decades[selD]
            .years[selY]
            .months[selM]
            .days[selDay]
            .ganZhi;
        leftPillars.add(
          BaziPillarWidget(
            label: '流日',
            gz: gz,
            dayMaster: dayMaster,
            width: pWidth,
            showProfessional: _showProfessional,
          ),
        );
      }
      if (selM != null && selY != null && selD != null) {
        final gz = widget.table.decades[selD].years[selY].months[selM].ganZhi;
        leftPillars.add(
          BaziPillarWidget(
            label: '流月',
            gz: gz,
            dayMaster: dayMaster,
            width: pWidth,
            showProfessional: _showProfessional,
          ),
        );
      }
      if (selY != null && selD != null) {
        final gz = widget.table.decades[selD].years[selY].ganZhi;
        leftPillars.add(
          BaziPillarWidget(
            label: '流年',
            gz: gz,
            dayMaster: dayMaster,
            width: pWidth,
            showProfessional: _showProfessional,
          ),
        );
      }
      if (selD != null) {
        final decade = widget.table.decades[selD];
        final isXiaoYun = decade.index == 0;
        GanZhi displayGz = decade.ganZhi;
        
        if (isXiaoYun) {
           int age = 1; // 默认使用1岁小运兜底
           if (selY != null) {
             final targetYear = decade.years[selY].year;
             age = targetYear - widget.table.fortune.birthday.year + 1;
           }
           displayGz = widget.table.fortune.getXiaoYunByAge(age);
        }

        leftPillars.add(
          BaziPillarWidget(
            label: isXiaoYun ? '小运'.tr : '大运'.tr,
            gz: displayGz,
            dayMaster: dayMaster,
            width: pWidth,
            showProfessional: _showProfessional,
          ),
        );
      }
    }

    final originalPillars = [
      BaziPillarWidget(
        label: '年柱',
        gz: widget.chart.bazi.year,
        dayMaster: dayMaster,
        width: pWidth,
        showProfessional: _showProfessional,
      ),
      BaziPillarWidget(
        label: '月柱',
        gz: widget.chart.bazi.month,
        dayMaster: dayMaster,
        width: pWidth,
        showProfessional: _showProfessional,
      ),
      BaziPillarWidget(
        label: '日元'.tr, // 改为更专业的“日元”或“日主”
        gz: widget.chart.bazi.day,
        dayMaster: dayMaster,
        width: pWidth,
        isDayMaster: true,
        showProfessional: _showProfessional,
      ),
      BaziPillarWidget(
        label: '时柱',
        gz: widget.chart.bazi.time,
        dayMaster: dayMaster,
        width: pWidth,
        showProfessional: _showProfessional,
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Scrollbar(
                controller: _chartScrollController,
                child: SingleChildScrollView(
                  controller: _chartScrollController,
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: leftBasePadding + elasticMargin),
                        ..._buildPillarListWithSpacing(leftPillars, gap),
                        if (leftPillars.isNotEmpty) ...[
                          SizedBox(width: gap),
                          Container(
                            width: 1,
                            height: 160,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(width: gap),
                        ],
                        ..._buildPillarListWithSpacing(originalPillars, gap),
                        SizedBox(width: elasticMargin + 4),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          if (_showProfessional)
            Positioned(
              left: 0,
              top: 113, // 柱名20 + 十神20 +干支大字65 + 间距8 = 113
              child: Container(
                padding: const EdgeInsets.only(left: 4),
                width: 35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFBFBFB),
                      const Color(0xFFFBFBFB).withOpacity(0.9),
                      const Color(0xFFFBFBFB).withOpacity(0.0),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.5, 0.8, 1.0],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 18,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '星运'.tr,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '自坐'.tr,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '空亡'.tr,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '纳音'.tr,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                          ),
                        ),
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
