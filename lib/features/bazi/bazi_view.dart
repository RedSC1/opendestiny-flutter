import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bazi_core/bazi_core.dart';
import 'bazi_provider.dart';
import 'widgets/bazi_header.dart';
import 'widgets/bazi_chart_board.dart';
import 'widgets/bazi_tab_switcher.dart';
import 'widgets/fortune_flow_board.dart';
import '../../core/l10n.dart';
import '../../providers/input_provider.dart';

// 1. 状态管理
enum BaziBottomTab { taiMingShen, fortune }

final baziBottomTabProvider = StateProvider<BaziBottomTab>((ref) => BaziBottomTab.fortune);
final selDecadeIdxProvider = StateProvider<int?>((ref) => null);
final selYearIdxProvider = StateProvider<int?>((ref) => null);
final selMonthIdxProvider = StateProvider<int?>((ref) => null);
final selDayIdxProvider = StateProvider<int?>((ref) => null);
final selHourIdxProvider = StateProvider<int?>((ref) => null);
final showProfessionalProvider = StateProvider<bool>((ref) => false);
final showInteractionProvider = StateProvider<bool>((ref) => false);

class BaziView extends ConsumerWidget {
  const BaziView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baziChart = ref.watch(baziChartProvider);
    final fortuneTable = ref.watch(fortuneTableProvider);
    final currentTab = ref.watch(baziBottomTabProvider);
    final dayGan = baziChart.bazi.day.gan;
    final showInteractions = ref.watch(showInteractionProvider);
    final appSettings = ref.watch(appSettingsProvider);
    final currentCase = ref.watch(currentCaseProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // 💡 优化后的顶部 Row：日历信息 + 切换开关
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BaziHeader(
                      chart: baziChart,
                      fortuneTable: fortuneTable,
                      showTrueSolarTime: appSettings.useTrueSolarTime,
                      currentCase: currentCase,
                      appSettings: appSettings,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const BaziTabSwitcher(),
                      const SizedBox(height: 6),
                      Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          InkWell(
                            onTap: () {
                              ref.read(showInteractionProvider.notifier).state = !showInteractions;
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                color: showInteractions ? Colors.indigo.shade50 : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: showInteractions ? Colors.indigo.shade200 : Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('连线图'.tr,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: showInteractions ? Colors.indigo.shade800 : Colors.grey.shade800
                                    )
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.hub_outlined,
                                    size: 15,
                                    color: showInteractions ? Colors.indigo.shade700 : Colors.grey.shade700
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              ref.read(showProfessionalProvider.notifier).state =
                                  !ref.read(showProfessionalProvider);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('专业模式'.tr,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade800
                                    )
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    ref.watch(showProfessionalProvider) ? Icons.unfold_less : Icons.unfold_more,
                                    size: 15,
                                    color: Colors.grey.shade700
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (ref.watch(showProfessionalProvider))
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '注：神煞功能暂未进行精确人工校对，结果仅供参考。'.tr,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.red.shade300,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            // 起运 & 司令信息
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoChip('起运'.tr, _formatQiYunDt(fortuneTable.fortune.qiYunDt)),
                  if (baziChart.siLing != null) ...[
                    const SizedBox(height: 4),
                    _buildInfoChip('司令'.tr, baziChart.siLing!.gan.display),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            BaziChartBoard(
              chart: baziChart,
              table: fortuneTable,
              currentTab: currentTab,
            ),
            const SizedBox(height: 16),
            // 💡 主盘下方统一直观地显示流年大运板块
            FortuneFlowBoard(table: fortuneTable, dayMaster: dayGan),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        Flexible(
          child: Text(
            value,
            softWrap: true,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }

  String _formatQiYunDt(QiYunDt value) {
    if (AppL10nSettings.currentLanguage == AppLanguage.en) {
      return 'After birth ${value.year} years ${value.month} months ${value.day} days ${value.hour} hours ${value.minute} minutes ${value.second} seconds, luck cycle begins';
    }
    return '${'出生后'.tr} ${value.year}${'年'.tr} ${value.month}${'个月'.tr} ${value.day}${'天'.tr} ${value.hour}${'小时'.tr} ${value.minute}${'分钟'.tr} ${value.second}${'秒'.tr} ${'交运'.tr}';
  }
}
