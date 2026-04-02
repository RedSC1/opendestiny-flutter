import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/device_type.dart';
import 'bazi_view.dart';

/// 响应式八字布局
///
/// - mobile: 单页垂直滚动（原有布局）
/// - desktop: 左右分栏（左边八字盘，右边大运详情）
class ResponsiveBaziView extends ConsumerWidget {
  const ResponsiveBaziView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceType = DeviceDetector.detect(context);

    // 目前所有设备都用手机布局，后续拆分
    switch (deviceType) {
      case DeviceType.mobile:
        return const BaziView();
      case DeviceType.tablet:
        return const BaziView(); // TODO: 平板布局
      case DeviceType.desktop:
        return const BaziView(); // TODO: 桌面左右分栏
    }
  }
}
