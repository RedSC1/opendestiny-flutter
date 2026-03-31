import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziwei_core/ziwei_core.dart';
import 'package:ziwei_core/src/models/timeline_node.dart';
import '../providers/ziwei_providers.dart';
import '../../../core/l10n.dart';
import '../../../core/ziwei_l10n.dart';
import 'time_flow_row.dart';
import 'ziwei_classic_theme.dart';

/// 紫微流运五行时间控制台 (大/流/月/日/时)
/// 完全基于内核 TimelineProvider 驱动，保证历法严谨性
class ZiweiTimeFlowTable extends ConsumerWidget {
  const ZiweiTimeFlowTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ziweiUIManagerProvider);
    final manager = ref.read(ziweiUIManagerProvider.notifier);

    // 从响应式状态中读取快照
    final manifest = state.manifest;
    final decadeItems = <_MacroLimitItem>[
      if (manifest.childhoods.isNotEmpty) const _MacroLimitItem.childhood(),
      ...manifest.decades.map(_MacroLimitItem.decade),
    ];

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 大限行（第一个入口可为童限）
          TimeFlowRow<_MacroLimitItem>(
            label: '大限'.tr,
            items: decadeItems,
            selectedItem: null,
            activeColor: ZiweiClassicTheme.getScopeColor(ZiweiScope.decade),
            itemLabelBuilder: (item) => item.label.tr,
            itemSubLabelBuilder: (item) => item.subLabel.tr,
            isSelectedBuilder: (item, _) => item.isChildhood
                ? state.currentDecade?.decadeIndex == 0
                : state.currentDecade?.decadeIndex == item.decade!.index,
            onItemSelected: (item) {
              if (item.isChildhood) {
                manager.selectChildhoodDecade();
              } else {
                manager.selectDecade(item.decade!);
              }
            },
          ),
          
          // 2. 流年行（童限时展开童限年份，普通大限时展开十年流年）
          if (state.currentDecade?.decadeIndex == 0)
            TimeFlowRow<ChildhoodNode>(
              label: '流年'.tr,
              items: manifest.childhoods,
              selectedItem: null,
              activeColor: ZiweiClassicTheme.getScopeColor(ZiweiScope.year),
              itemLabelBuilder: (c) => '${c.age}${'岁'.tr}',
              itemSubLabelBuilder: (c) => '${c.stem.ganDisplay}${c.branch.zhiDisplay}',
              isSelectedBuilder: (item, _) => state.currentYear?.year == item.year,
              onItemSelected: (c) => manager.selectChildhood(c),
            )
          else if (manifest.currentDecadeYears != null)
            TimeFlowRow<YearNode>(
              label: '流年'.tr,
              items: manifest.currentDecadeYears!,
              selectedItem: null,
              activeColor: ZiweiClassicTheme.getScopeColor(ZiweiScope.year),
              itemLabelBuilder: (y) => '${y.year}',
              itemSubLabelBuilder: (y) => '${y.stem.ganDisplay}${y.branch.zhiDisplay}',
              isSelectedBuilder: (item, _) => 
                  state.currentYear?.year == item.year,
              onItemSelected: (y) => manager.selectYear(y),
            ),
            
          // 3. 流月行 (选中流年后出现)
          if (manifest.currentYearMonths != null)
            TimeFlowRow<MonthNode>(
              label: '流月'.tr,
              items: manifest.currentYearMonths!,
              selectedItem: null,
              activeColor: ZiweiClassicTheme.getScopeColor(ZiweiScope.month),
              itemLabelBuilder: (m) => m.displayLabel,
              itemSubLabelBuilder: (m) =>
                  '${m.stem.ganDisplay}${_flowMonthBranchDisplay(m)}',
              isSelectedBuilder: (item, _) =>
                  state.currentMonth?.month == item.month &&
                  state.currentMonthIsLeap == item.isLeap,
              onItemSelected: (m) => manager.selectMonth(m),
            ),

          // 4. 流日行 (选中流月后出现)
          if (manifest.currentMonthDays != null)
            TimeFlowRow<DayNode>(
              label: '流日'.tr,
              items: manifest.currentMonthDays!,
              selectedItem: null,
              activeColor: ZiweiClassicTheme.getScopeColor(ZiweiScope.day),
              itemLabelBuilder: (d) => d.day.lunarDay,
              itemSubLabelBuilder: (d) => '${d.stem.ganDisplay}${d.branch.zhiDisplay}',
              isSelectedBuilder: (item, _) => 
                  state.currentDay?.day == item.day,
              onItemSelected: (d) => manager.selectDay(d),
            ),

          // 5. 流时行 (选中流日后出现)
          if (manifest.currentDayHours != null)
            TimeFlowRow<HourNode>(
              label: '流时'.tr,
              items: manifest.currentDayHours!,
              selectedItem: null,
              activeColor: ZiweiClassicTheme.getScopeColor(ZiweiScope.hour),
              itemLabelBuilder: (h) => h.hourIndex.hourName,
              itemSubLabelBuilder: (h) => '${h.stem.ganDisplay}${h.branch.zhiDisplay}',
              isSelectedBuilder: (item, _) => 
                  state.currentHour?.hourIndex == item.hourIndex,
              onItemSelected: (h) => manager.selectHour(h),
            ),
          
          // 底部：重置与状态提示
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (manifest.status.isHistoricalRedZone)
                  Expanded(
                    child: Text(
                      manifest.status.note.tr,
                      style: const TextStyle(
                        fontSize: 10, 
                        color: Colors.orange, 
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else
                  const Spacer(),
                
                if (state.currentDecade != null)
                  TextButton.icon(
                    onPressed: () => manager.resetToOrigin(),
                    icon: const Icon(Icons.refresh, size: 12),
                    label: Text(
                      '回到本命盘'.tr, 
                      style: const TextStyle(
                        fontSize: 10, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: ZiweiClassicTheme.palaceNameColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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

class _MacroLimitItem {
  final bool isChildhood;
  final DecadeNode? decade;
  final String label;
  final String subLabel;

  const _MacroLimitItem._({
    required this.isChildhood,
    required this.decade,
    required this.label,
    required this.subLabel,
  });

  const _MacroLimitItem.childhood()
    : this._(
        isChildhood: true,
        decade: null,
        label: '童限',
        subLabel: '起运前',
      );

  factory _MacroLimitItem.decade(DecadeNode decade) {
    return _MacroLimitItem._(
      isChildhood: false,
      decade: decade,
      label: '${decade.startAge}~${decade.endAge}',
      subLabel: '${decade.stem.ganDisplay}${decade.branch.zhiDisplay}',
    );
  }
}

String _flowMonthBranchDisplay(MonthNode node) {
  final branchIndex = (node.sequence + 1) % 12;
  return DiZhi.values[branchIndex].display;
}
