import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../../../providers/input_provider.dart';
import '../providers/ziwei_providers.dart';
import 'center_info_widget.dart';
import 'palace_cell_widget.dart';
import 'ziwei_flying_star_painter.dart';
import 'ziwei_sihua_arrow_painter.dart';

class ZiweiChartWidget extends ConsumerStatefulWidget {
  const ZiweiChartWidget({super.key});

  @override
  ConsumerState<ZiweiChartWidget> createState() => _ZiweiChartWidgetState();
}

class _ZiweiChartWidgetState extends ConsumerState<ZiweiChartWidget> {
  final GlobalKey _chartRootKey = GlobalKey();
  final Map<int, Rect> _ganRects = {};
  final Map<String, Rect> _flyingTargetRects = {};

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ziweiUIManagerProvider);
    final enableFlyingStarArrow = ref.watch(
      inputNotifierProvider.select(
        (profile) => profile.ziweiOptions.animation.enableFlyingStarArrow,
      ),
    );
    final flyingTargets = enableFlyingStarArrow
        ? _selectedPalaceFlyingTargets(state)
        : const <String, SiHuaType>{};
    final sourceRect = !enableFlyingStarArrow || state.selectedPalaceIndex == null
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
        const double edgeMargin = 12.0;
        final width = constraints.maxWidth - (edgeMargin * 2);
        final cellWidth = width / 4;
        final cellHeight = cellWidth * 1.05;

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
                    onGanRectChanged: _updateGanRect,
                    onFlyingTargetRectChanged: _updateFlyingTargetRect,
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
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: ZiweiSihuaArrowPainter(
                      plate: state.plate,
                      edgeMargin: edgeMargin,
                    ),
                  ),
                ),
              ),
              if (sourceRect != null && arrowTargets.isNotEmpty)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: ZiweiFlyingStarPainter(
                        sourceRect: sourceRect,
                        targets: arrowTargets,
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

  void _updateGanRect(int palaceIndex, Rect? rect) {
    if (rect == null) {
      if (_ganRects.remove(palaceIndex) != null && mounted) {
        setState(() {});
      }
      return;
    }

    final oldRect = _ganRects[palaceIndex];
    if (_rectEquals(oldRect, rect)) return;

    _ganRects[palaceIndex] = rect;
    if (mounted) setState(() {});
  }

  void _updateFlyingTargetRect(String starKey, Rect? rect) {
    if (rect == null) {
      if (_flyingTargetRects.remove(starKey) != null && mounted) {
        setState(() {});
      }
      return;
    }

    final oldRect = _flyingTargetRects[starKey];
    if (_rectEquals(oldRect, rect)) return;

    _flyingTargetRects[starKey] = rect;
    if (mounted) setState(() {});
  }

  bool _rectEquals(Rect? a, Rect? b) {
    if (a == null || b == null) return a == b;
    return a.left == b.left &&
        a.top == b.top &&
        a.width == b.width &&
        a.height == b.height;
  }
}
