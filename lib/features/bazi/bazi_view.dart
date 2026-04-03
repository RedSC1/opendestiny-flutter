import 'dart:math' as math;

import 'package:bazi_core/bazi_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/device_type.dart';
import '../../core/l10n.dart';
import '../../core/ui_scale.dart';
import '../../models/destiny_profile.dart';
import '../../providers/input_provider.dart';
import 'bazi_provider.dart';
import 'widgets/bazi_chart_board.dart';
import 'widgets/bazi_header.dart';
import 'widgets/bazi_tab_switcher.dart';
import 'widgets/fortune_flow_board.dart';

// 1. 状态管理
enum BaziBottomTab { taiMingShen, fortune }

final baziBottomTabProvider = StateProvider<BaziBottomTab>(
  (ref) => BaziBottomTab.fortune,
);
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
    UIScale.init(context);

    final layout = DeviceDetector.detectLayout(context);
    final baziChart = ref.watch(baziChartProvider);
    final fortuneTable = ref.watch(fortuneTableProvider);
    final currentTab = ref.watch(baziBottomTabProvider);
    final dayGan = baziChart.bazi.day.gan;
    final showInteractions = ref.watch(showInteractionProvider);
    final appSettings = ref.watch(appSettingsProvider);
    final currentCase = ref.watch(currentCaseProvider);

    final fortuneSection = FortuneFlowBoard(
      table: fortuneTable,
      dayMaster: dayGan,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: switch (layout) {
        LayoutClass.mobilePortrait => _buildStackedLayout(
          headerBuilder: (adaptiveScale) => _buildHeaderSection(
            ref,
            baziChart,
            fortuneTable,
            appSettings,
            currentCase,
            showInteractions,
            adaptiveScale,
          ),
          chartBuilder: (maxVisibleHeight, adaptiveScale) => BaziChartBoard(
            chart: baziChart,
            table: fortuneTable,
            currentTab: currentTab,
            maxVisibleHeight: maxVisibleHeight,
            adaptiveScale: adaptiveScale,
          ),
          fortuneSection: fortuneSection,
        ),
        LayoutClass.mobileLandscape => _buildWideLayout(
            maxWidth: 980,
            sideWidth: 320,
            gap: 10,
            headerBuilder: (adaptiveScale) => _buildHeaderSection(
              ref,
              baziChart,
              fortuneTable,
              appSettings,
              currentCase,
              showInteractions,
              adaptiveScale,
            ),
            chartBuilder: (maxVisibleHeight, adaptiveScale) => BaziChartBoard(
              chart: baziChart,
              table: fortuneTable,
              currentTab: currentTab,
              maxVisibleHeight: maxVisibleHeight,
              adaptiveScale: adaptiveScale,
            ),
            fortuneSection: fortuneSection,
          ),
        LayoutClass.tablet => _buildWideLayout(
            maxWidth: 1220,
            sideWidth: 360,
            gap: 14,
            headerBuilder: (adaptiveScale) => _buildHeaderSection(
              ref,
              baziChart,
              fortuneTable,
              appSettings,
              currentCase,
              showInteractions,
              adaptiveScale,
            ),
            chartBuilder: (maxVisibleHeight, adaptiveScale) => BaziChartBoard(
              chart: baziChart,
              table: fortuneTable,
              currentTab: currentTab,
              maxVisibleHeight: maxVisibleHeight,
              adaptiveScale: adaptiveScale,
            ),
            fortuneSection: fortuneSection,
          ),
        LayoutClass.desktop => _buildWideLayout(
            maxWidth: 1500,
            sideWidth: 420,
            gap: 18,
            headerBuilder: (adaptiveScale) => _buildHeaderSection(
              ref,
              baziChart,
              fortuneTable,
              appSettings,
              currentCase,
              showInteractions,
              adaptiveScale,
            ),
            chartBuilder: (maxVisibleHeight, adaptiveScale) => BaziChartBoard(
              chart: baziChart,
              table: fortuneTable,
              currentTab: currentTab,
              maxVisibleHeight: maxVisibleHeight,
              adaptiveScale: adaptiveScale,
            ),
            fortuneSection: fortuneSection,
          ),
      },
    );
  }

  Widget _buildStackedLayout({
    required Widget Function(double adaptiveScale) headerBuilder,
    required Widget Function(double? maxVisibleHeight, double adaptiveScale)
        chartBuilder,
    required Widget fortuneSection,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _AdaptiveBaziMainPanel(
                availableHeight: constraints.maxHeight,
                bottomGap: 16.hs,
                enableWidthScale: false,
                headerBuilder: headerBuilder,
                chartBuilder: chartBuilder,
              ),
              fortuneSection,
              SizedBox(height: 40.hs),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWideLayout({
    required double maxWidth,
    required double sideWidth,
    required double gap,
    required Widget Function(double adaptiveScale) headerBuilder,
    required Widget Function(double? maxVisibleHeight, double adaptiveScale)
        chartBuilder,
    required Widget fortuneSection,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedSideWidth = (constraints.maxWidth * 0.36).clamp(
          250.0,
          sideWidth,
        ).toDouble();

        return SingleChildScrollView(
          padding: EdgeInsets.all(gap),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _AdaptiveBaziMainPanel(
                      availableHeight: constraints.maxHeight - (gap * 2),
                      bottomGap: 24.hs,
                      headerBuilder: headerBuilder,
                      chartBuilder: chartBuilder,
                    ),
                  ),
                  SizedBox(width: gap),
                  SizedBox(
                    width: resolvedSideWidth,
                    child: Padding(
                      padding: EdgeInsets.only(top: 12.hs),
                      child: fortuneSection,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return _buildInfoChipScaled(label, value, 1.0);
  }

  Widget _buildInfoChipScaled(String label, String value, double adaptiveScale) {
    double s(num raw) => raw * adaptiveScale;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: s(10.ts), color: Colors.grey),
        ),
        Flexible(
          child: Text(
            value,
            softWrap: true,
            style: TextStyle(
              fontSize: s(10.ts),
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(
    WidgetRef ref,
    BaziChart baziChart,
    FortuneTable fortuneTable,
    AppSettings appSettings,
    DestinyCase currentCase,
    bool showInteractions,
    double adaptiveScale,
  ) {
    final headerScale = _smoothHeaderScale(adaptiveScale);
    double hs(num raw) => raw * headerScale;

    return Column(
      children: [
        SizedBox(height: hs(12.hs)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hs(14.ws)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: BaziHeader(
              chart: baziChart,
              fortuneTable: fortuneTable,
              showTrueSolarTime: appSettings.useTrueSolarTime,
              currentCase: currentCase,
              appSettings: appSettings,
              adaptiveScale: headerScale,
            ),
          ),
        ),
        if (ref.watch(showProfessionalProvider))
          Padding(
            padding: EdgeInsets.only(left: hs(14.ws), top: hs(6.hs)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '注：神煞功能暂未进行精确人工校对，结果仅供参考。'.tr,
                style: TextStyle(
                  fontSize: hs(11.ts),
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        SizedBox(height: hs(6.hs)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hs(14.ws)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoChipScaled(
                        '起运'.tr,
                        _formatQiYunDt(fortuneTable.fortune.qiYunDt),
                        headerScale,
                      ),
                      if (baziChart.siLing != null) ...[
                        SizedBox(height: hs(3.hs)),
                        _buildInfoChipScaled(
                          '司令'.tr,
                          baziChart.siLing!.gan.display,
                          headerScale,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: hs(6.ws)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BaziTabSwitcher(adaptiveScale: headerScale),
                    SizedBox(height: hs(4.hs)),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: hs(5.ws),
                      runSpacing: hs(5.hs),
                      children: [
                        InkWell(
                          onTap: () {
                            ref.read(showInteractionProvider.notifier).state =
                                !showInteractions;
                          },
                          borderRadius: BorderRadius.circular(hs(7.ws)),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: hs(7.ws),
                              vertical: hs(4.hs),
                            ),
                            decoration: BoxDecoration(
                              color: showInteractions
                                  ? Colors.indigo.shade50
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(hs(7.ws)),
                              border: Border.all(
                                color: showInteractions
                                    ? Colors.indigo.shade200
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '连线图'.tr,
                                  style: TextStyle(
                                    fontSize: hs(11.ts),
                                    fontWeight: FontWeight.w500,
                                    color: showInteractions
                                        ? Colors.indigo.shade800
                                        : Colors.grey.shade800,
                                  ),
                                ),
                                SizedBox(width: hs(3.ws)),
                                Icon(
                                  Icons.hub_outlined,
                                  size: hs(14.ts),
                                  color: showInteractions
                                      ? Colors.indigo.shade700
                                      : Colors.grey.shade700,
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
                          borderRadius: BorderRadius.circular(hs(7.ws)),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: hs(7.ws),
                              vertical: hs(4.hs),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(hs(7.ws)),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '专业模式'.tr,
                                  style: TextStyle(
                                    fontSize: hs(11.ts),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                SizedBox(width: hs(3.ws)),
                                Icon(
                                  ref.watch(showProfessionalProvider)
                                      ? Icons.unfold_less
                                      : Icons.unfold_more,
                                  size: hs(14.ts),
                                  color: Colors.grey.shade700,
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
        ),
        SizedBox(height: hs(12.hs)),
      ],
    );
  }

  double _smoothHeaderScale(double adaptiveScale) {
    if (adaptiveScale >= 0.98) return 1.0;
    final t = ((adaptiveScale - 0.82) / 0.16).clamp(0.0, 1.0);
    final eased = Curves.easeOutCubic.transform(t);
    return 0.75 + (0.25 * eased);
  }

  String _formatQiYunDt(QiYunDt value) {
    if (AppL10nSettings.currentLanguage == AppLanguage.en) {
      return 'After birth ${value.year} years ${value.month} months ${value.day} days ${value.hour} hours ${value.minute} minutes ${value.second} seconds, luck cycle begins';
    }
    return '${'出生后'.tr} ${value.year}${'年'.tr} ${value.month}${'个月'.tr} ${value.day}${'天'.tr} ${value.hour}${'小时'.tr} ${value.minute}${'分钟'.tr} ${value.second}${'秒'.tr} ${'交运'.tr}';
  }
}

class _AdaptiveBaziMainPanel extends StatefulWidget {
  final double availableHeight;
  final double bottomGap;
  final bool enableWidthScale;
  final Widget Function(double adaptiveScale) headerBuilder;
  final Widget Function(double? maxVisibleHeight, double adaptiveScale)
      chartBuilder;

  const _AdaptiveBaziMainPanel({
    required this.availableHeight,
    required this.bottomGap,
    this.enableWidthScale = true,
    required this.headerBuilder,
    required this.chartBuilder,
  });

  @override
  State<_AdaptiveBaziMainPanel> createState() => _AdaptiveBaziMainPanelState();
}

class _AdaptiveBaziMainPanelState extends State<_AdaptiveBaziMainPanel> {
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0;
  bool _measureScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleMeasure();
  }

  @override
  Widget build(BuildContext context) {
    _scheduleMeasure();

    return LayoutBuilder(
      builder: (context, constraints) {
        final heightScale = (widget.availableHeight / 760.0).clamp(
          0.82,
          1.0,
        ).toDouble();
        final widthScale = widget.enableWidthScale
            ? (constraints.maxWidth / 860.0).clamp(
                0.82,
                1.0,
              ).toDouble()
            : 1.0;
        final adaptiveScale = math.min(heightScale, widthScale);

        final estimatedHeaderHeight = _headerHeight > 0
            ? _headerHeight
            : (170.0 * UIScale.scale * adaptiveScale);
        final maxVisibleChartHeight =
            (widget.availableHeight - estimatedHeaderHeight - widget.bottomGap)
                .clamp(180.0, 1000.0)
                .toDouble();

        return Column(
          children: [
            KeyedSubtree(
              key: _headerKey,
              child: widget.headerBuilder(adaptiveScale),
            ),
            widget.chartBuilder(maxVisibleChartHeight, adaptiveScale),
            SizedBox(height: widget.bottomGap),
          ],
        );
      },
    );
  }

  void _scheduleMeasure() {
    if (_measureScheduled) return;
    _measureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureScheduled = false;
      if (!mounted) return;

      final nextHeight = _measureHeight(_headerKey);
      if ((nextHeight - _headerHeight).abs() < 1.0) return;

      setState(() {
        _headerHeight = nextHeight;
      });
    });
  }

  double _measureHeight(GlobalKey key) {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return 0;
    }
    return renderObject.size.height;
  }
}
