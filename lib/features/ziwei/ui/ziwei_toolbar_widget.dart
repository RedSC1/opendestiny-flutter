import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../../../core/l10n.dart';
import '../../../providers/input_provider.dart';
import '../providers/ziwei_providers.dart';
import '../../../core/ziwei_ai_exporter.dart';

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
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
            width: 0.5,
          ),
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
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
                tooltip: '上一日'.tr,
                onPressed: () {
                  ref.read(ziweiDateOffsetProvider.notifier).state =
                      offset - const Duration(days: 1);
                },
              ),
              _buildTimeShiftButton(
                icon: Icons.keyboard_arrow_left,
                tooltip: '上一时辰 (2小时)'.tr,
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
                    label: Text('复原'.tr, style: const TextStyle(fontSize: 10)),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '定盘'.tr,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

              _buildTimeShiftButton(
                icon: Icons.keyboard_arrow_right,
                tooltip: '下一时辰 (2小时)'.tr,
                onPressed: () {
                  ref.read(ziweiDateOffsetProvider.notifier).state =
                      offset + const Duration(hours: 2);
                },
              ),
              _buildTimeShiftButton(
                icon: Icons.keyboard_double_arrow_right,
                tooltip: '下一日'.tr,
                onPressed: () {
                  ref.read(ziweiDateOffsetProvider.notifier).state =
                      offset + const Duration(days: 1);
                },
              ),
            ],
          ),

          // 2. 天地人盘选择器 + AI 导出
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<TDRpan>(
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(fontSize: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                segments: [
                  ButtonSegment(value: TDRpan.tianPan, label: Text('天盘'.tr)),
                  ButtonSegment(value: TDRpan.diPan, label: Text('地盘'.tr)),
                  ButtonSegment(value: TDRpan.renPan, label: Text('人盘'.tr)),
                ],
                selected: {tdrPan},
                onSelectionChanged: (Set<TDRpan> newSelection) {
                  ref.read(tdrPanProvider.notifier).state = newSelection.first;
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  final plate = ref.read(ziweiUIManagerProvider).plate;
                  final settings = ref.read(appSettingsProvider);
                  final json = ZiweiAiExporter.exportToAiJson(
                    plate,
                    brightnessMode: settings.ziweiOptions.brightnessMode.name,
                  );
                  Clipboard.setData(ClipboardData(text: json));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('已复制紫微 AI 分析数据到剪贴板'.tr),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.smart_toy, color: Colors.blueGrey),
                tooltip: '复制 AI 分析数据'.tr,
                visualDensity: VisualDensity.compact,
              ),
            ],
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
