import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bazi_provider.dart';
import 'widgets/bazi_header.dart';
import 'widgets/bazi_chart_board.dart';
import 'widgets/bazi_tab_switcher.dart';
import 'widgets/fortune_flow_board.dart';
import 'widgets/tai_ming_shen_board.dart';
import '../../core/l10n.dart';

// 1. 状态管理
enum BaziBottomTab { taiMingShen, fortune }

final baziBottomTabProvider = StateProvider<BaziBottomTab>((ref) => BaziBottomTab.fortune);
final selDecadeIdxProvider = StateProvider<int?>((ref) => null);
final selYearIdxProvider = StateProvider<int?>((ref) => null);
final selMonthIdxProvider = StateProvider<int?>((ref) => null);
final selDayIdxProvider = StateProvider<int?>((ref) => null);
final selHourIdxProvider = StateProvider<int?>((ref) => null);
final showProfessionalProvider = StateProvider<bool>((ref) => false);

class BaziView extends ConsumerWidget {
  const BaziView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baziChart = ref.watch(baziChartProvider);
    final fortuneTable = ref.watch(fortuneTableProvider);
    final currentTab = ref.watch(baziBottomTabProvider);
    final dayGan = baziChart.bazi.day.gan;

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
                  Expanded(child: BaziHeader(chart: baziChart)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const BaziTabSwitcher(),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          ref.read(showProfessionalProvider.notifier).state =
                              !ref.read(showProfessionalProvider);
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('专业模式', 
                                style: TextStyle(
                                  fontSize: 12, 
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800
                                )
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                ref.watch(showProfessionalProvider) ? Icons.unfold_less : Icons.unfold_more, 
                                size: 16, 
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
            const SizedBox(height: 16), // 缩小间距
            BaziChartBoard(
              chart: baziChart,
              table: fortuneTable,
              currentTab: currentTab,
            ),
            const SizedBox(height: 16),
            // 💡 下方的 TabSwitcher 已经移到顶部，这里直接根据状态显示内容
            if (currentTab == BaziBottomTab.taiMingShen)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TaiMingShenBoard(
                  chart: baziChart, 
                  dayGan: dayGan,
                  showProfessional: ref.watch(showProfessionalProvider),
                ),
              )
            else
              FortuneFlowBoard(table: fortuneTable, dayMaster: dayGan),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
