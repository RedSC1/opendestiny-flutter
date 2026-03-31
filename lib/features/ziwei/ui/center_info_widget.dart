import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../providers/ziwei_providers.dart';
import 'ziwei_classic_theme.dart';
import 'ziwei_connection_painter.dart';
import '../../../core/l10n.dart';
import '../../../core/ziwei_l10n.dart';

/// 中宫信息面板（经典风格）
class CenterInfoWidget extends ConsumerWidget {
  final ZiweiUIState state;

  const CenterInfoWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plate = state.plate;
    final date = state.date;
    final bazi = date.bazi;

    return Container(
      decoration: BoxDecoration(
        color: ZiweiClassicTheme.cellBgColor,
        border: Border.all(
          color: ZiweiClassicTheme.cellBorderColor,
          width: 0.5,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 连线层：位于文字背景
          if (state.selectedPalaceIndex != null)
            Positioned.fill(
              child: CustomPaint(
                painter: ZiweiCenterConnectionPainter(
                  selectedIndex: state.selectedPalaceIndex!,
                ),
              ),
            ),
          
          // 原有信息内容层
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 行1：五行局
                FittedBox(
                  child: Text(
                    plate.elementBureau.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: ZiweiClassicTheme.palaceNameColor,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // 行2：性别
                Text(
                  (date.gender == Gender.male ? '男命' : '女命').tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ZiweiClassicTheme.decadeAgeColor,
                  ),
                ),
                const SizedBox(height: 4),
                // 行3：命主/身主
                Text(
                  '${'命主'.tr}: ${(plate.mingZhu ?? "").nodeDisplay}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: ZiweiClassicTheme.minorStarColor,
                  ),
                ),
                Text(
                  '${'身主'.tr}: ${(plate.shenZhu ?? "").nodeDisplay}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: ZiweiClassicTheme.minorStarColor,
                  ),
                ),
                const Divider(height: 12, thickness: 0.5),
                // 行4：农历信息
                FittedBox(
                  child: Text(
                    '${'农'.tr}${date.lunar.lunarYear}${'年'.tr}${date.lunar.isLeap ? "闰".tr : ""}${date.lunar.month}${'月'.tr}${date.lunar.day}${'日'.tr}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ZiweiClassicTheme.minorStarColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // 行5：四柱
                FittedBox(
                  child: Text(
                    '${bazi.year.display}  ${bazi.month.display}  ${bazi.day.display}  ${bazi.time.display}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: ZiweiClassicTheme.ganzhiColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
