import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bazi_core/bazi_core.dart';
import 'bazi_provider.dart';
import 'widgets/bazi_header.dart';
import 'widgets/bazi_chart_board.dart';
import 'widgets/bazi_tab_switcher.dart';
import 'widgets/fortune_flow_board.dart';
import 'widgets/tai_ming_shen_board.dart';

// 1. 状态管理 (保留在 View 文件或移动到 Provider)
enum BaziBottomTab { taiMingShen, fortune }

final baziBottomTabProvider = StateProvider<BaziBottomTab>((ref) => BaziBottomTab.fortune);
final selDecadeIdxProvider = StateProvider<int?>((ref) => null);
final selYearIdxProvider = StateProvider<int?>((ref) => null);
final selMonthIdxProvider = StateProvider<int?>((ref) => null);
final selDayIdxProvider = StateProvider<int?>((ref) => null);
final selHourIdxProvider = StateProvider<int?>((ref) => null);

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BaziHeader(chart: baziChart),
            ),
            const SizedBox(height: 24),
            BaziChartBoard(
              chart: baziChart,
              table: fortuneTable,
              currentTab: currentTab,
            ),
            const SizedBox(height: 24),
            const BaziTabSwitcher(),
            const SizedBox(height: 16),
            if (currentTab == BaziBottomTab.taiMingShen)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TaiMingShenBoard(chart: baziChart, dayGan: dayGan),
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
