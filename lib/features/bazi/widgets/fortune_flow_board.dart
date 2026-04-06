import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bazi_core/bazi_core.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../../../core/ui_scale.dart';
import '../bazi_view.dart';
import 'fortune_card.dart';
import '../../../core/l10n.dart';
import '../../../providers/input_provider.dart';

class FortuneFlowBoard extends ConsumerStatefulWidget {
  final FortuneTable table;
  final TianGan dayMaster;
  final double adaptiveScale;

  const FortuneFlowBoard({
    super.key,
    required this.table,
    required this.dayMaster,
    this.adaptiveScale = 1.0,
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

  void _toggleSelection({
    required StateController<int?> controller,
    required int index,
    required int resetLevel,
  }) {
    final isSame = controller.state == index;
    controller.state = isSame ? null : index;
    _resetFrom(resetLevel);
  }

  @override
  Widget build(BuildContext context) {
    final selD = ref.watch(selDecadeIdxProvider);
    final selY = ref.watch(selYearIdxProvider);
    final selM = ref.watch(selMonthIdxProvider);
    final selDay = ref.watch(selDayIdxProvider);
    final selH = ref.watch(selHourIdxProvider);
    final appSettings = ref.watch(appSettingsProvider);
    final ratHourMode = appSettings.ratHourMode;
    final useAstronomical = appSettings.useAstronomicalYear;

    final now = AstroDateTime.fromDateTime(DateTime.now());
    final currentLichunJD = getSpecificJieQi(now.year, 21);
    final currentBaziYear = now.toJ2000() < currentLichunJD
        ? now.year - 1
        : now.year;

    return LayoutBuilder(
      builder: (context, constraints) {
        final responsiveScale = _resolveResponsiveScale(constraints.maxWidth);
        final effectiveScale =
            (widget.adaptiveScale * responsiveScale).clamp(0.75, 1.0).toDouble();

        return Column(
          children: [
            _FortuneHList(
              controller: _controllers[0],
              label: '大运'.tr,
              itemCount: widget.table.decades.length,
              adaptiveScale: effectiveScale,
              itemBuilder: (context, i) {
                final d = widget.table.decades[i];
                final bool isCurrentDecade =
                    now.isAfter(d.startTime) && now.isBefore(d.endTime);
                final isXiaoYun = d.index == 0;
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
                    top: d.startTime.year.formatYear(useAstronomical),
                    bottom: isXiaoYun
                        ? '1~${d.endAge}${'岁'.tr}'
                        : '${d.startAge}${'虚岁'.tr}',
                  isSel: selD == i,
                  isCur: isCurrentDecade,
                  activeCol: Theme.of(context).colorScheme.primary,
                  isXiaoYunBlock: isXiaoYun,
                  adaptiveScale: effectiveScale,
                  onTap: () {
                    _toggleSelection(
                      controller: ref.read(selDecadeIdxProvider.notifier),
                      index: i,
                      resetLevel: 1,
                    );
                  },
                );
              },
            ),
            if (selD != null)
              _FortuneHList(
                controller: _controllers[1],
                label: '流年小运'.tr,
                itemCount: widget.table.decades[selD].years.length,
                adaptiveScale: effectiveScale,
                itemBuilder: (context, i) {
                  final y = widget.table.decades[selD].years[i];
                  final bool isCurrentYear = y.year == currentBaziYear;
                  final int age = y.year - widget.table.fortune.birthday.year + 1;
                  final GanZhi xiaoYunGz =
                      widget.table.fortune.getXiaoYunByAge(age);

                  return FortuneCard(
                    shiShen: Relationship.getShiShen(
                      widget.dayMaster,
                      y.ganZhi.gan,
                    ).display,
                    gz: y.ganZhi,
                    top: y.year.formatYear(useAstronomical),
                    bottom: xiaoYunGz.display,
                    isSel: selY == i,
                    isCur: isCurrentYear,
                    activeCol: Colors.orange,
                    adaptiveScale: effectiveScale,
                    onTap: () {
                      _toggleSelection(
                        controller: ref.read(selYearIdxProvider.notifier),
                        index: i,
                        resetLevel: 2,
                      );
                    },
                  );
                },
              ),
            if (selD != null && selY != null)
              _FortuneHList(
                controller: _controllers[2],
                label: '流月'.tr,
                itemCount: widget.table.decades[selD].years[selY].months.length,
                adaptiveScale: effectiveScale,
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
                    adaptiveScale: effectiveScale,
                    onTap: () {
                      _toggleSelection(
                        controller: ref.read(selMonthIdxProvider.notifier),
                        index: i,
                        resetLevel: 3,
                      );
                    },
                  );
                },
              ),
            if (selD != null && selY != null && selM != null)
              _FortuneHList(
                controller: _controllers[3],
                label: '流日'.tr,
                itemCount:
                    widget.table.decades[selD].years[selY].months[selM].days.length,
                adaptiveScale: effectiveScale,
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
                    adaptiveScale: effectiveScale,
                    onTap: () {
                      _toggleSelection(
                        controller: ref.read(selDayIdxProvider.notifier),
                        index: i,
                        resetLevel: 4,
                      );
                    },
                  );
                },
              ),
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
                adaptiveScale: effectiveScale,
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
                      if (now.hour >= 23) {
                        isCurrentHour = (i == 12);
                      } else {
                        isCurrentHour =
                            (h.hourIndex == currentHourIdx && i < 12);
                      }
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
                    adaptiveScale: effectiveScale,
                    onTap: () {
                      _toggleSelection(
                        controller: ref.read(selHourIdxProvider.notifier),
                        index: i,
                        resetLevel: 5,
                      );
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }

  double _resolveResponsiveScale(double maxWidth) {
    if (maxWidth <= 0) return 1.0;
    return (maxWidth / 420.0).clamp(0.75, 1.0).toDouble();
  }
}

class _FortuneHList extends StatelessWidget {
  static const double _listScale = 0.9;

  final ScrollController controller;
  final String label;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final double adaptiveScale;

  const _FortuneHList({
    required this.controller,
    required this.label,
    required this.itemCount,
    required this.itemBuilder,
    this.adaptiveScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    double s(num value) => value * _listScale * adaptiveScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: s(20.ws), vertical: s(4.hs)),
          child: Text(
            label,
            style: TextStyle(
              fontSize: s(12.5.ts),
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          height: s(118.hs),
          padding: EdgeInsets.only(bottom: s(2.hs)),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.stylus,
              },
            ),
            child: Scrollbar(
              controller: controller,
              thumbVisibility: true,
              interactive: true,
              thickness: s(6.ws),
              radius: Radius.circular(s(10.ws)),
              child: ListView.builder(
                key: ValueKey('${label}_list'),
                controller: controller,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.symmetric(horizontal: s(16.ws)),
                itemCount: itemCount,
                itemBuilder: itemBuilder,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
