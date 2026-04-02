import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bazi_core/bazi_core.dart';
import '../../core/ui_scale.dart';
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
    // 初始化UI缩放
    UIScale.init(context);

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
            SizedBox(height: 12.hs),
            // 💡 优化后的顶部 Row：日历信息 + 切换开关
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.ws),
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
                ],
              ),
            ),
            if (ref.watch(showProfessionalProvider))
              Padding(
                padding: EdgeInsets.only(left: 14.ws, top: 6.hs),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '注：神煞功能暂未进行精确人工校对，结果仅供参考。'.tr,
                    style: TextStyle(
                      fontSize: 11.ts,
                      color: Colors.red.shade300,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 6.hs),
            // 起运 & 司令信息 + 功能按钮
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.ws),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoChip('起运'.tr, _formatQiYunDt(fortuneTable.fortune.qiYunDt)),
                          if (baziChart.siLing != null) ...[
                          SizedBox(height: 3.hs),
                          _buildInfoChip('司令'.tr, baziChart.siLing!.gan.display),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 6.ws),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const BaziTabSwitcher(),
                      SizedBox(height: 4.hs),
                      Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 5.ws,
                        runSpacing: 5.hs,
                        children: [
                          InkWell(
                            onTap: () {
                              ref.read(showInteractionProvider.notifier).state = !showInteractions;
                            },
                            borderRadius: BorderRadius.circular(7.ws),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 7.ws, vertical: 4.hs),
                              decoration: BoxDecoration(
                                color: showInteractions ? Colors.indigo.shade50 : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(7.ws),
                                border: Border.all(color: showInteractions ? Colors.indigo.shade200 : Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('连线图'.tr,
                                    style: TextStyle(
                                      fontSize: 11.ts,
                                      fontWeight: FontWeight.w500,
                                      color: showInteractions ? Colors.indigo.shade800 : Colors.grey.shade800
                                    )
                                  ),
                                  SizedBox(width: 3.ws),
                                  Icon(
                                    Icons.hub_outlined,
                                    size: 14.ts,
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
                            borderRadius: BorderRadius.circular(7.ws),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 7.ws, vertical: 4.hs),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(7.ws),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('专业模式'.tr,
                                    style: TextStyle(
                                      fontSize: 11.ts,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade800
                                    )
                                  ),
                                  SizedBox(width: 3.ws),
                                  Icon(
                                    ref.watch(showProfessionalProvider) ? Icons.unfold_less : Icons.unfold_more,
                                    size: 14.ts,
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
            SizedBox(height: 12.hs),
            BaziChartBoard(
              chart: baziChart,
              table: fortuneTable,
              currentTab: currentTab,
            ),
            SizedBox(height: 16.hs),
            // 💡 主盘下方统一直观地显示流年大运板块
            FortuneFlowBoard(table: fortuneTable, dayMaster: dayGan),
            SizedBox(height: 40.hs),
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
          style: TextStyle(fontSize: 10.ts, color: Colors.grey),
        ),
        Flexible(
          child: Text(
            value,
            softWrap: true,
            style: TextStyle(
              fontSize: 10.ts,
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
