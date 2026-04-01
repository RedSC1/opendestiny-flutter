import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../providers/ziwei_providers.dart';

class ZiweiToolbarWidget extends ConsumerWidget {
  const ZiweiToolbarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tdrPan = ref.watch(tdrPanProvider);
    final offset = ref.watch(ziweiDateOffsetProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
            width: 0.5,
          ),
          top: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. 定盘：时间偏移量控制
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTimeShiftButton(
                icon: Icons.keyboard_double_arrow_left,
                tooltip: '上一日',
                onPressed: () {
                  ref.read(ziweiDateOffsetProvider.notifier).state =
                      offset - const Duration(days: 1);
                },
              ),
              _buildTimeShiftButton(
                icon: Icons.keyboard_arrow_left,
                tooltip: '上一时辰 (2小时)',
                onPressed: () {
                  ref.read(ziweiDateOffsetProvider.notifier).state =
                      offset - const Duration(hours: 2);
                },
              ),

              // 居中的恢复按钮 (仅在有偏移量时显示)
              if (offset != Duration.zero)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ActionChip(
                    visualDensity: VisualDensity.compact,
                    label: const Text('复原', style: TextStyle(fontSize: 10)),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.errorContainer,
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    onPressed: () {
                      ref.read(ziweiDateOffsetProvider.notifier).state =
                          Duration.zero;
                    },
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '定盘',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

              _buildTimeShiftButton(
                icon: Icons.keyboard_arrow_right,
                tooltip: '下一时辰 (2小时)',
                onPressed: () {
                  ref.read(ziweiDateOffsetProvider.notifier).state =
                      offset + const Duration(hours: 2);
                },
              ),
              _buildTimeShiftButton(
                icon: Icons.keyboard_double_arrow_right,
                tooltip: '下一日',
                onPressed: () {
                  ref.read(ziweiDateOffsetProvider.notifier).state =
                      offset + const Duration(days: 1);
                },
              ),
            ],
          ),

          // 2. 天地人盘选择器
          SegmentedButton<TDRpan>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              textStyle: const TextStyle(fontSize: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            segments: const [
              ButtonSegment(value: TDRpan.tianPan, label: Text('天盘')),
              ButtonSegment(value: TDRpan.diPan, label: Text('地盘')),
              ButtonSegment(value: TDRpan.renPan, label: Text('人盘')),
            ],
            selected: {tdrPan},
            onSelectionChanged: (Set<TDRpan> newSelection) {
              ref.read(tdrPanProvider.notifier).state = newSelection.first;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeShiftButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(), // 移除默认的最小尺寸限制
    );
  }
}
