import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/device_type.dart';
import 'responsive_ziwei_chart.dart';
import 'ziwei_time_flow_table.dart';
import 'ziwei_toolbar_widget.dart';

class ZiweiView extends ConsumerWidget {
  const ZiweiView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = DeviceDetector.detectLayout(context);
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.aspectRatio;

    switch (layout) {
      case LayoutClass.mobilePortrait:
        return const _AdaptiveStackedZiweiLayout(
          maxWidth: 850,
          minChartWidth: 260,
          estimatedToolbarHeight: 56,
          estimatedTimeFlowHeight: 126,
          maxReservedTimeFlowHeight: 132,
        );
      case LayoutClass.mobileLandscape:
        return _buildWideLayout(
          maxWidth: 980,
          sideWidth: 300,
          gap: 10,
        );
      case LayoutClass.tablet:
        if (aspectRatio < 1.28) {
          return const _AdaptiveStackedZiweiLayout(
            maxWidth: 1080,
            minChartWidth: 320,
            estimatedToolbarHeight: 56,
            estimatedTimeFlowHeight: 126,
            maxReservedTimeFlowHeight: 132,
          );
        }
        return _buildWideLayout(
          maxWidth: 1180,
          sideWidth: 340,
          gap: 14,
        );
      case LayoutClass.desktop:
        if (aspectRatio < 1.18) {
          return const _AdaptiveStackedZiweiLayout(
            maxWidth: 1220,
            minChartWidth: 320,
            estimatedToolbarHeight: 56,
            estimatedTimeFlowHeight: 126,
            maxReservedTimeFlowHeight: 132,
          );
        }
        return _buildWideLayout(
          maxWidth: 1460,
          sideWidth: 400,
          gap: 18,
        );
    }
  }

  Widget _buildWideLayout({
    required double maxWidth,
    required double sideWidth,
    required double gap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedSideWidth = (constraints.maxWidth * 0.35).clamp(
          240.0,
          sideWidth,
        ).toDouble();
        const chartEdgeMargin = 24.0;
        const chartHeightRatio = 1.2;
        final verticalPadding = gap * 2;
        final chartMaxWidthByHeight =
            ((constraints.maxHeight - verticalPadding - chartEdgeMargin) /
                    chartHeightRatio)
                .clamp(240.0, constraints.maxWidth)
                .toDouble();

        return SingleChildScrollView(
          padding: EdgeInsets.all(gap),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: chartMaxWidthByHeight,
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ResponsiveZiweiChart(),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(width: gap),
                  Flexible(
                    child: SizedBox(
                      width: resolvedSideWidth,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ZiweiToolbarWidget(),
                          SizedBox(height: 10),
                          ZiweiTimeFlowTable(),
                        ],
                      ),
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
}

class _AdaptiveStackedZiweiLayout extends StatefulWidget {
  final double maxWidth;
  final double minChartWidth;
  final double estimatedToolbarHeight;
  final double estimatedTimeFlowHeight;
  final double maxReservedTimeFlowHeight;

  const _AdaptiveStackedZiweiLayout({
    required this.maxWidth,
    required this.minChartWidth,
    required this.estimatedToolbarHeight,
    required this.estimatedTimeFlowHeight,
    required this.maxReservedTimeFlowHeight,
  });

  @override
  State<_AdaptiveStackedZiweiLayout> createState() =>
      _AdaptiveStackedZiweiLayoutState();
}

class _AdaptiveStackedZiweiLayoutState
    extends State<_AdaptiveStackedZiweiLayout> {
  final GlobalKey _toolbarKey = GlobalKey();
  final GlobalKey _timeFlowKey = GlobalKey();
  double _toolbarHeight = 0;
  double _timeFlowHeight = 0;
  bool _measureScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleMeasure();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _scheduleMeasure();

        const chartVerticalMargin = 24.0;
        final effectiveToolbarHeight = _toolbarHeight > 0
            ? _toolbarHeight
            : widget.estimatedToolbarHeight;
        final effectiveTimeFlowHeight = (_timeFlowHeight > 0
                ? _timeFlowHeight
                : widget.estimatedTimeFlowHeight)
            .clamp(0.0, widget.maxReservedTimeFlowHeight);
        final reservedHeight = effectiveToolbarHeight +
            effectiveTimeFlowHeight +
            10;
        final availableChartHeight =
            (constraints.maxHeight - reservedHeight - chartVerticalMargin)
                .clamp(widget.minChartWidth * 1.2, widget.maxWidth * 1.2)
                .toDouble();
        final chartMaxWidth = (availableChartHeight / 1.2)
            .clamp(widget.minChartWidth, widget.maxWidth)
            .toDouble();

        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widget.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: chartMaxWidth),
                    child: const ResponsiveZiweiChart(),
                  ),
                  KeyedSubtree(
                    key: _toolbarKey,
                    child: const ZiweiToolbarWidget(),
                  ),
                  KeyedSubtree(
                    key: _timeFlowKey,
                    child: const ZiweiTimeFlowTable(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
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

      final toolbarHeight = _measureHeight(_toolbarKey);
      final timeFlowHeight = _measureHeight(_timeFlowKey);
      final toolbarDelta = (toolbarHeight - _toolbarHeight).abs();
      final timeFlowDelta = (timeFlowHeight - _timeFlowHeight).abs();
      if (toolbarDelta < 1.0 && timeFlowDelta < 1.0) {
        return;
      }

      setState(() {
        _toolbarHeight = toolbarHeight;
        _timeFlowHeight = timeFlowHeight;
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
