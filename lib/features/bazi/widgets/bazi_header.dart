import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bazi_core/bazi_core.dart';
import '../../../core/l10n.dart';
import '../../../core/bazi_ai_exporter.dart';
import '../../../models/destiny_profile.dart';

class BaziHeader extends StatelessWidget {
  final BaziChart chart;
  final FortuneTable fortuneTable;
  final bool showTrueSolarTime;
  final DestinyCase currentCase;
  final AppSettings appSettings;

  const BaziHeader({
    super.key,
    required this.chart,
    required this.fortuneTable,
    required this.showTrueSolarTime,
    required this.currentCase,
    required this.appSettings,
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
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${'公历'.tr}：${chart.time.bjClt}',
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${'农历'.tr}：${chart.lunarDate}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (showTrueSolarTime)
                Text(
                  '${'真太阳时'.tr}：${chart.time.solarTime.trueSolarTime}',
                  style: const TextStyle(fontSize: 14, color: Colors.deepPurple),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            final json = BaziAiExporter.exportToAiJson(
              chart: chart,
              destinyCase: currentCase,
              settings: appSettings,
              fortuneTable: fortuneTable,
            );
            Clipboard.setData(ClipboardData(text: json));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('已复制 AI 命盘 JSON 到剪贴板'.tr),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          icon: const Icon(Icons.smart_toy, color: Colors.blueGrey),
          tooltip: '复制 AI 命盘 JSON'.tr,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
