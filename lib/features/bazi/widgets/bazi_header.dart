import 'package:flutter/material.dart';
import 'package:bazi_core/bazi_core.dart';
import '../../../core/l10n.dart';

class BaziHeader extends StatelessWidget {
  final BaziChart chart;
  final bool showTrueSolarTime;

  const BaziHeader({
    super.key,
    required this.chart,
    required this.showTrueSolarTime,
  });

  @override
  Widget build(BuildContext context) {
    final isMale = chart.gender == Gender.male;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isMale ? Colors.blue : Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            isMale ? '乾造'.tr : '坤造'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'公历'.tr}：${chart.time.bjClt}', style: const TextStyle(fontSize: 14)),
            Text('${'农历'.tr}：${chart.lunarDate}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
            if (showTrueSolarTime)
              Text(
                '${'真太阳时'.tr}：${chart.time.solarTime.trueSolarTime}',
                style: const TextStyle(fontSize: 14, color: Colors.deepPurple),
              ),
          ],
        ),
      ],
    );
  }
}
