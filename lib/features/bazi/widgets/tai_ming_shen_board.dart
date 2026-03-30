import 'package:flutter/material.dart';
import 'package:bazi_core/bazi_core.dart';
import 'bazi_pillar_widget.dart';

class TaiMingShenBoard extends StatelessWidget {
  final BaziChart chart;
  final TianGan dayGan;

  const TaiMingShenBoard({
    super.key,
    required this.chart,
    required this.dayGan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BaziPillarWidget(label: '胎元', gz: chart.taiYuan, dayMaster: dayGan, width: 70),
          BaziPillarWidget(label: '胎息', gz: chart.taiXi, dayMaster: dayGan, width: 70),
          BaziPillarWidget(label: '命宫', gz: chart.mingGong, dayMaster: dayGan, width: 70),
          BaziPillarWidget(label: '身宫', gz: chart.shenGong, dayMaster: dayGan, width: 70),
        ],
      ),
    );
  }
}
