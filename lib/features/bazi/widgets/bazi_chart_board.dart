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
    final double pWidth = isEn ? 70 : 50;

    final leftPillars = <Widget>[];
    if (widget.currentTab == BaziBottomTab.taiMingShen) {
      leftPillars.addAll([
        BaziPillarWidget(label: '身宫', gz: widget.chart.shenGong, dayMaster: dayMaster, width: pWidth),
        BaziPillarWidget(label: '命宫', gz: widget.chart.mingGong, dayMaster: dayMaster, width: pWidth),
        BaziPillarWidget(label: '胎息', gz: widget.chart.taiXi, dayMaster: dayMaster, width: pWidth),
        BaziPillarWidget(label: '胎元', gz: widget.chart.taiYuan, dayMaster: dayMaster, width: pWidth),
      ]);
    } else {
      if (selH != null && selDay != null && selM != null && selY != null && selD != null) {
        leftPillars.add(BaziPillarWidget(label: '流时', gz: widget.table.decades[selD].years[selY].months[selM].days[selDay].hours[selH].ganZhi, dayMaster: dayMaster, width: pWidth));
      }
      if (selDay != null && selM != null && selY != null && selD != null) {
        leftPillars.add(BaziPillarWidget(label: '流日', gz: widget.table.decades[selD].years[selY].months[selM].days[selDay].ganZhi, dayMaster: dayMaster, width: pWidth));
      }
      if (selM != null && selY != null && selD != null) {
        leftPillars.add(BaziPillarWidget(label: '流月', gz: widget.table.decades[selD].years[selY].months[selM].ganZhi, dayMaster: dayMaster, width: pWidth));
      }
      if (selY != null && selD != null) {
        leftPillars.add(BaziPillarWidget(label: '流年', gz: widget.table.decades[selD].years[selY].ganZhi, dayMaster: dayMaster, width: pWidth));
      }
      if (selD != null) {
        leftPillars.add(BaziPillarWidget(label: '大运', gz: widget.table.decades[selD].ganZhi, dayMaster: dayMaster, width: pWidth));
      }
    }

    final originalPillars = [
      BaziPillarWidget(label: '年柱', gz: widget.chart.bazi.year, dayMaster: dayMaster, width: pWidth),
      BaziPillarWidget(label: '月柱', gz: widget.chart.bazi.month, dayMaster: dayMaster, width: pWidth),
      BaziPillarWidget(label: '日柱', gz: widget.chart.bazi.day, dayMaster: dayMaster, width: pWidth, isDayMaster: true),
      BaziPillarWidget(label: '时柱', gz: widget.chart.bazi.time, dayMaster: dayMaster, width: pWidth),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: LayoutBuilder(
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: [
                    const SizedBox(width: 4),
                    ...leftPillars,
                    if (leftPillars.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4), 
                        width: 1, 
                        height: 160, 
                        color: Colors.grey.shade300
                      ),
                    ...originalPillars,
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
