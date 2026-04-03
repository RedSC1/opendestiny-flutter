import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bazi_view.dart';
import '../../../core/l10n.dart';
import '../../../core/ui_scale.dart';

class BaziTabSwitcher extends ConsumerWidget {
  final double adaptiveScale;

  const BaziTabSwitcher({
    super.key,
    this.adaptiveScale = 1.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(baziBottomTabProvider);
    double s(num value) => value * adaptiveScale;

    return SegmentedButton<BaziBottomTab>(
      // 💡 紧凑设计：缩小边距和点击区域
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(
          horizontal: s(2.ws),
          vertical: s(1.hs),
        ),
        minimumSize: Size(s(0), s(28.hs)),
      ),
      segments: [
        ButtonSegment(
          value: BaziBottomTab.fortune,
          label: Text(
            '运'.tr,
            style: TextStyle(fontSize: s(11.ts)),
          ),
          icon: Icon(Icons.trending_up, size: s(14.ts)),
        ),
        ButtonSegment(
          value: BaziBottomTab.taiMingShen,
          label: Text(
            '胎'.tr,
            style: TextStyle(fontSize: s(11.ts)),
          ),
          icon: Icon(Icons.hub, size: s(14.ts)),
        ),
      ],
      selected: {currentTab},
      onSelectionChanged: (val) =>
          ref.read(baziBottomTabProvider.notifier).state = val.first,
    );
  }
}
