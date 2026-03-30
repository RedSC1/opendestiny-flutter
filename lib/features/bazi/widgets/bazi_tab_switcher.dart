import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bazi_view.dart';
import '../../../core/l10n.dart';

class BaziTabSwitcher extends ConsumerWidget {
  const BaziTabSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(baziBottomTabProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SegmentedButton<BaziBottomTab>(
        segments: [
          ButtonSegment(
            value: BaziBottomTab.fortune,
            label: Text('大运流年'.tr),
            icon: const Icon(Icons.trending_up),
          ),
          ButtonSegment(
            value: BaziBottomTab.taiMingShen,
            label: Text('胎命身'.tr),
            icon: const Icon(Icons.hub),
          ),
        ],
        selected: {currentTab},
        onSelectionChanged: (val) => ref.read(baziBottomTabProvider.notifier).state = val.first,
      ),
    );
  }
}
