import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../../../core/ui_scale.dart';
import '../../../providers/input_provider.dart';
import '../providers/ziwei_providers.dart';
import 'center_info_widget.dart';
import 'palace_cell_widget.dart';
import 'ziwei_flying_star_painter.dart';
import 'ziwei_sihua_mode_arrow_painter.dart';
import 'ziwei_sihua_arrow_painter.dart';

class ZiweiChartWidget extends ConsumerStatefulWidget {
  const ZiweiChartWidget({super.key});

  @override
  ConsumerState<ZiweiChartWidget> createState() => _ZiweiChartWidgetState();
}

class _ZiweiChartWidgetState extends ConsumerState<ZiweiChartWidget> {
  static const double _referenceCellWidth = 84.0;
  final GlobalKey _chartRootKey = GlobalKey();
  final Map<int, Rect> _ganRects = {};
  final Map<String, Rect> _flyingTargetRects = {};
  final Map<String, Rect> _sihuaStarRects = {};
  final Map<String, Rect> _sihuaBadgeRects = {};
  bool _refreshScheduled = false;
  Object? _lastPlateToken;
  ZiweiChartMode? _lastChartMode;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ziweiUIManagerProvider);
    final chartMode = ref.watch(ziweiChartModeProvider);
    _resetGeometryCacheIfNeeded(state, chartMode);
    final enableFlyingStarArrow = ref.watch(
      inputNotifierProvider.select(
        (profile) => profile.ziweiOptions.animation.enableFlyingStarArrow,
      ),
    );
    final effectiveFlyingArrowEnabled = enableFlyingStarArrow;
    final flyingTargets = effectiveFlyingArrowEnabled
        ? _selectedPalaceFlyingTargets(state)
        : const <String, SiHuaType>{};
    final sourceRect =
        !effectiveFlyingArrowEnabled || state.selectedPalaceIndex == null
        ? null
        : _ganRects[state.selectedPalaceIndex!];
    final arrowTargets = flyingTargets.entries
        .map((entry) {
          final rect = _flyingTargetRects[entry.key];
          if (rect == null) return null;
          return FlyingStarArrowTarget(rect: rect, sihuaType: entry.value);
        })
        .whereType<FlyingStarArrowTarget>()
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        // 初始化缩放
        UIScale.init(context);

        const double edgeMargin = 12.0;
        final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
        final width = constraints.maxWidth - (edgeMargin * 2);
        final cellWidth = _snapDownToPixel(width / 4, devicePixelRatio);
        // 固定宽高比 1.4，宫格大小随屏幕宽度自然缩放
        final cellHeight = _snapDownToPixel(cellWidth * 1.2, devicePixelRatio);
        final cellScale = (cellWidth / _referenceCellWidth)
            .clamp(0.7, 1.45)
            .toDouble();
        final safeCellScale = (cellScale * 0.996).clamp(0.7, 1.45).toDouble();

        final positions = {
          DiZhi.si: const Offset(0, 0),
          DiZhi.wu: const Offset(1, 0),
          DiZhi.wei: const Offset(2, 0),
          DiZhi.shen: const Offset(3, 0),
          DiZhi.chen: const Offset(0, 1),
          DiZhi.you: const Offset(3, 1),
          DiZhi.mao: const Offset(0, 2),
          DiZhi.xu: const Offset(3, 2),
          DiZhi.yin: const Offset(0, 3),
          DiZhi.chou: const Offset(1, 3),
          DiZhi.zi: const Offset(2, 3),
          DiZhi.hai: const Offset(3, 3),
        };

        return SizedBox(
          key: _chartRootKey,
          width: constraints.maxWidth,
          height: (cellHeight * 4) + (edgeMargin * 2),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ...DiZhi.values.map((dz) {
                final pos = positions[dz]!;
                final palace = state.plate.palaces[dz.index];

                return Positioned(
                  left: pos.dx * cellWidth + edgeMargin,
                  top: pos.dy * cellHeight + edgeMargin,
                  width: cellWidth,
                  height: cellHeight,
                  child: PalaceCellWidget(
                    palace: palace,
                    plate: state.plate,
                    state: state,
                    chartRootKey: _chartRootKey,
                    runtimeScale: safeCellScale,
                    onGanRectChanged: _updateGanRect,
                    onFlyingTargetRectChanged: _updateFlyingTargetRect,
                    onSihuaStarRectChanged: _updateSihuaStarRect,
                    onSihuaBadgeRectChanged: _updateSihuaBadgeRect,
                  ),
                );
              }),
              Positioned(
                left: cellWidth + edgeMargin,
                top: cellHeight + edgeMargin,
                width: cellWidth * 2,
                height: cellHeight * 2,
                child: CenterInfoWidget(state: state),
              ),
              if (chartMode == ZiweiChartMode.sanhe ||
                  chartMode == ZiweiChartMode.flying)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: ZiweiSihuaArrowPainter(
                        plate: state.plate,
                        edgeMargin: edgeMargin,
                        scale: safeCellScale,
                      ),
                    ),
                  ),
                ),
              if (chartMode == ZiweiChartMode.sihua)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: ZiweiSihuaModeArrowPainter(
                        plate: state.plate,
                        edgeMargin: edgeMargin,
                        starRects: _sihuaStarRects,
                        badgeRects: _sihuaBadgeRects,
                        scale: safeCellScale,
                      ),
                    ),
                  ),
                ),
              if (effectiveFlyingArrowEnabled &&
                  (chartMode == ZiweiChartMode.sanhe ||
                      chartMode == ZiweiChartMode.sihua ||
                      chartMode == ZiweiChartMode.flying) &&
                  sourceRect != null &&
                  arrowTargets.isNotEmpty)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: ZiweiFlyingStarPainter(
                        sourceRect: sourceRect,
                        targets: arrowTargets,
                        scale: safeCellScale,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Map<String, SiHuaType> _selectedPalaceFlyingTargets(ZiweiUIState state) {
    final selectedIndex = state.selectedPalaceIndex;
    if (selectedIndex == null || selectedIndex < 0 || selectedIndex >= 12) {
      return const {};
    }

    final selectedStem = state.plate.palaces[selectedIndex].stem;
    if (selectedStem == null) return const {};

    final rule = state.plate.ruleset.siHuaRules[selectedStem];
    if (rule == null || rule.isEmpty) return const {};

    return {
      for (final entry in rule.entries) entry.value: entry.key,
    };
  }

  void _resetGeometryCacheIfNeeded(
    ZiweiUIState state,
    ZiweiChartMode chartMode,
  ) {
    final plateToken = Object.hash(
      state.plate.hashCode,
      state.currentDecade?.decadeIndex,
      state.currentYear?.hashCode,
      state.currentMonth?.hashCode,
      state.currentDay?.hashCode,
      state.currentHour?.hashCode,
    );

    if (_lastPlateToken == plateToken && _lastChartMode == chartMode) {
      return;
    }

    _lastPlateToken = plateToken;
    _lastChartMode = chartMode;
    _ganRects.clear();
    _flyingTargetRects.clear();
    _sihuaStarRects.clear();
    _sihuaBadgeRects.clear();
  }

  void _updateGanRect(int palaceIndex, Rect? rect) {
    if (rect == null) {
      if (_ganRects.remove(palaceIndex) != null) {
        _scheduleRefresh();
      }
      return;
    }

    final oldRect = _ganRects[palaceIndex];
    if (_rectEquals(oldRect, rect)) return;

    _ganRects[palaceIndex] = rect;
    _scheduleRefresh();
  }

  void _updateFlyingTargetRect(String starKey, Rect? rect) {
    if (rect == null) {
      if (_flyingTargetRects.remove(starKey) != null) {
        _scheduleRefresh();
      }
      return;
    }

    final oldRect = _flyingTargetRects[starKey];
    if (_rectEquals(oldRect, rect)) return;

    _flyingTargetRects[starKey] = rect;
    _scheduleRefresh();
  }

  void _updateSihuaStarRect(String starPlacementKey, Rect? rect) {
    if (rect == null) {
      if (_sihuaStarRects.remove(starPlacementKey) != null) {
        _scheduleRefresh();
      }
      return;
    }

    final oldRect = _sihuaStarRects[starPlacementKey];
    if (_rectEquals(oldRect, rect)) return;

    _sihuaStarRects[starPlacementKey] = rect;
    _scheduleRefresh();
  }

  void _updateSihuaBadgeRect(String badgePlacementKey, Rect? rect) {
    if (rect == null) {
      if (_sihuaBadgeRects.remove(badgePlacementKey) != null) {
        _scheduleRefresh();
      }
      return;
    }

    final oldRect = _sihuaBadgeRects[badgePlacementKey];
    if (_rectEquals(oldRect, rect)) return;

    _sihuaBadgeRects[badgePlacementKey] = rect;
    _scheduleRefresh();
  }

  void _scheduleRefresh() {
    if (_refreshScheduled) return;
    _refreshScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshScheduled = false;
      if (!mounted) return;
      setState(() {});
    });
  }

  bool _rectEquals(Rect? a, Rect? b) {
    if (a == null || b == null) return a == b;
    return a.left == b.left &&
        a.top == b.top &&
        a.width == b.width &&
        a.height == b.height;
  }

  double _snapDownToPixel(double value, double devicePixelRatio) {
    return (value * devicePixelRatio).floorToDouble() / devicePixelRatio;
  }
}
