import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bazi_core/bazi_core.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../bazi_view.dart';
import 'fortune_card.dart';
import '../../../core/l10n.dart';
import '../../../providers/input_provider.dart';

class FortuneFlowBoard extends ConsumerStatefulWidget {
  final FortuneTable table;
  final TianGan dayMaster;

  const FortuneFlowBoard({
    super.key,
    required this.table,
    required this.dayMaster,
  });

  @override
  ConsumerState<FortuneFlowBoard> createState() => _FortuneFlowBoardState();
}

class _FortuneFlowBoardState extends ConsumerState<FortuneFlowBoard> {
  final _controllers = List.generate(5, (i) => ScrollController());

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    super.dispose();
  }

  void _resetFrom(int level) {
    if (level <= 1) ref.read(selYearIdxProvider.notifier).state = null;
    if (level <= 2) ref.read(selMonthIdxProvider.notifier).state = null;
    if (level <= 3) ref.read(selDayIdxProvider.notifier).state = null;
    if (level <= 4) ref.read(selHourIdxProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final selD = ref.watch(selDecadeIdxProvider);
    final selY = ref.watch(selYearIdxProvider);
    final selM = ref.watch(selMonthIdxProvider);
    final selDay = ref.watch(selDayIdxProvider);
    final selH = ref.watch(selHourIdxProvider);
    final ratHourMode = ref.watch(inputNotifierProvider).ratHourMode;

    final now = AstroDateTime.fromDateTime(DateTime.now());
    final currentLichunJD = getSpecificJieQi(now.year, 21);
    final currentBaziYear = now.toJ2000() < currentLichunJD
        ? now.year - 1
        : now.year;

    return Column(
      children: [
        // 1. 大运
        _FortuneHList(
          controller: _controllers[0],
          label: '大运'.tr,
          itemCount: widget.table.decades.length,
          itemBuilder: (context, i) {
            final d = widget.table.decades[i];
            final bool isCurrentDecade =
                now.isAfter(d.startTime) && now.isBefore(d.endTime);
            final isXiaoYun = d.index == 0;

            // 小运的干支取1岁的流年代入兜底显示，因为每年都会变
            final displayGz = isXiaoYun
                ? widget.table.fortune.getXiaoYunByAge(1)
                : d.ganZhi;

            return FortuneCard(
              shiShen: isXiaoYun
                  ? ''
                  : Relationship.getShiShen(
                      widget.dayMaster,
                      displayGz.gan,
                    ).display,
              gz: displayGz,
              top: '${d.startTime.year}',
              bottom: isXiaoYun
                  ? '1~${d.endAge}${'岁'.tr}'
                  : '${d.startAge}${'虚岁'.tr}',
              isSel: selD == i,
              isCur: isCurrentDecade,
              activeCol: Colors.deepPurple,
              isXiaoYunBlock: isXiaoYun,
              onTap: () {
                ref.read(selDecadeIdxProvider.notifier).state = i;
                _resetFrom(1);
              },
            );
          },
        ),

        // 2. 流年
        if (selD != null)
          _FortuneHList(
            controller: _controllers[1],
            label: '流年小运'.tr,
            itemCount: widget.table.decades[selD].years.length,
            itemBuilder: (context, i) {
              final y = widget.table.decades[selD].years[i];
              final bool isCurrentYear = y.year == currentBaziYear;

              // 无论是否是大运，每年都计算并显示小运干支
              final int age = y.year - widget.table.fortune.birthday.year + 1;
              final GanZhi xiaoYunGz = widget.table.fortune.getXiaoYunByAge(
                age,
              );
              final String bottomText = xiaoYunGz.display;

              return FortuneCard(
                shiShen: Relationship.getShiShen(
                  widget.dayMaster,
                  y.ganZhi.gan,
                ).display,
                gz: y.ganZhi,
                top: '${y.year}',
                bottom: bottomText,
                isSel: selY == i,
                isCur: isCurrentYear,
                activeCol: Colors.orange,
                onTap: () {
                  ref.read(selYearIdxProvider.notifier).state = i;
                  _resetFrom(2);
                },
              );
            },
          ),

        // 3. 流月
        if (selD != null && selY != null)
          _FortuneHList(
            controller: _controllers[2],
            label: '流月'.tr,
            itemCount: widget.table.decades[selD].years[selY].months.length,
            itemBuilder: (context, i) {
              final m = widget.table.decades[selD].years[selY].months[i];
              final bool isCurrentMonth =
                  now.isAfter(m.startTime) && now.isBefore(m.endTime);
              return FortuneCard(
                shiShen: Relationship.getShiShen(
                  widget.dayMaster,
                  m.ganZhi.gan,
                ).display,
                gz: m.ganZhi,
                top: '${m.startTime.month}月'.tr,
                bottom: m.jieName.tr,
                isSel: selM == i,
                isCur: isCurrentMonth,
                activeCol: Colors.teal,
                onTap: () {
                  ref.read(selMonthIdxProvider.notifier).state = i;
                  _resetFrom(3);
                },
              );
            },
          ),

        // 4. 流日
        if (selD != null && selY != null && selM != null)
          _FortuneHList(
            controller: _controllers[3],
            label: '流日'.tr,
            itemCount:
                widget.table.decades[selD].years[selY].months[selM].days.length,
            itemBuilder: (context, i) {
              final d =
                  widget.table.decades[selD].years[selY].months[selM].days[i];
              final bool isToday =
                  d.date.year == now.year &&
                  d.date.month == now.month &&
                  d.date.day == now.day;
              return FortuneCard(
                shiShen: Relationship.getShiShen(
                  widget.dayMaster,
                  d.ganZhi.gan,
                ).display,
                gz: d.ganZhi,
                top: '${d.date.day}日'.tr,
                bottom: '流日'.tr,
                isSel: selDay == i,
                isCur: isToday,
                activeCol: Colors.cyan,
                onTap: () {
                  ref.read(selDayIdxProvider.notifier).state = i;
                  _resetFrom(4);
                },
              );
            },
          ),

        // 5. 流时
        if (selD != null && selY != null && selM != null && selDay != null)
          _FortuneHList(
            controller: _controllers[4],
            label: '流时'.tr,
            itemCount: widget
                .table
                .decades[selD]
                .years[selY]
                .months[selM]
                .days[selDay]
                .hours
                .length,
            itemBuilder: (context, i) {
              final dayObj = widget
                  .table
                  .decades[selD]
                  .years[selY]
                  .months[selM]
                  .days[selDay];
              final h = dayObj.hours[i];
              final bool isToday =
                  dayObj.date.year == now.year &&
                  dayObj.date.month == now.month &&
                  dayObj.date.day == now.day;
              bool isCurrentHour = false;
              if (isToday) {
                final currentHourIdx = (now.hour + 1) ~/ 2 % 12;
                if (ratHourMode != RatHourMode.noSplit) {
                  if (now.hour >= 23)
                    isCurrentHour = (i == 12);
                  else
                    isCurrentHour = (h.hourIndex == currentHourIdx && i < 12);
                } else {
                  isCurrentHour = (h.hourIndex == currentHourIdx);
                }
              }
              return FortuneCard(
                shiShen: Relationship.getShiShen(
                  widget.dayMaster,
                  h.ganZhi.gan,
                ).display,
                gz: h.ganZhi,
                top: h.name.tr,
                bottom: '时辰'.tr,
                isSel: selH == i,
                isCur: isCurrentHour,
                activeCol: Colors.blueGrey,
                onTap: () => ref.read(selHourIdxProvider.notifier).state = i,
              );
            },
          ),
      ],
    );
  }
}

class _FortuneHList extends StatelessWidget {
  final ScrollController controller;
  final String label;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const _FortuneHList({
    required this.controller,
    required this.label,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          height: 156,
          padding: const EdgeInsets.only(bottom: 4),
          child: Scrollbar(
            controller: controller,
            thumbVisibility: true,
            interactive: true,
            thickness: 6,
            radius: const Radius.circular(10),
            child: ListView.builder(
              key: ValueKey('${label}_list'),
              controller: controller,
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: itemCount,
              itemBuilder: itemBuilder,
            ),
          ),
        ),
      ],
    );
  }
}
