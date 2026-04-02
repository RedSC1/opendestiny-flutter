import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/device_type.dart';
import 'ziwei_chart_widget.dart';

/// 响应式紫微盘布局
///
/// 根据设备类型自动选择布局：
/// - mobile: 紧凑布局（下拉菜单、窄宫格、竖排版）
/// - tablet/desktop: 完整布局（后续实现）
class ResponsiveZiweiChart extends ConsumerWidget {
  const ResponsiveZiweiChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceType = DeviceDetector.detect(context);

    // TODO: 后续拆分不同设备的布局
    switch (deviceType) {
      case DeviceType.mobile:
        return const ZiweiChartWidget();
      case DeviceType.tablet:
        // 暂时 fallback 到手机布局
        return const ZiweiChartWidget();
      case DeviceType.desktop:
        // 暂时 fallback 到手机布局，后续实现桌面布局
        return const ZiweiChartWidget();
    }
  }
}
