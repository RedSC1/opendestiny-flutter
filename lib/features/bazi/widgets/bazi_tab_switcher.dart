import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bazi_view.dart';
import '../../../core/l10n.dart';
import '../../../core/ui_scale.dart';

class BaziTabSwitcher extends ConsumerWidget {
  const BaziTabSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(baziBottomTabProvider);

    return SegmentedButton<BaziBottomTab>(
      // 💡 紧凑设计：缩小边距和点击区域
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(horizontal: 2.ws, vertical: 1.hs),
      ),
      segments: [
        ButtonSegment(
          value: BaziBottomTab.fortune,
          label: Text('运'.tr, style: TextStyle(fontSize: 11.ts)), // 缩短文字
          icon: Icon(Icons.trending_up, size: 14.ts),
        ),
        ButtonSegment(
          value: BaziBottomTab.taiMingShen,
          label: Text('胎'.tr, style: TextStyle(fontSize: 11.ts)), // 缩短文字
          icon: Icon(Icons.hub, size: 14.ts),
        ),
      ],
      selected: {currentTab},
      onSelectionChanged: (val) => ref.read(baziBottomTabProvider.notifier).state = val.first,
    );
  }
}
