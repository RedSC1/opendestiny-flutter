import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../../../core/ui_scale.dart';
import '../../../core/l10n.dart';
import '../../../providers/input_provider.dart';
import '../providers/ziwei_providers.dart';
import '../../../core/ziwei_ai_exporter.dart';

class ZiweiToolbarWidget extends ConsumerWidget {
  const ZiweiToolbarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 初始化UI缩放
    UIScale.init(context);

    final tdrPan = ref.watch(tdrPanProvider);
    final chartMode = ref.watch(ziweiChartModeProvider);
    final offset = ref.watch(ziweiDateOffsetProvider);
    final panNames = {
      TDRpan.tianPan: '天盘'.tr,
      TDRpan.diPan: '地盘'.tr,
      TDRpan.renPan: '人盘'.tr,
    };
    final chartModeNames = {
      ZiweiChartMode.sanhe: '三合'.tr,
      ZiweiChartMode.sihua: '四化'.tr,
      ZiweiChartMode.flying: '飞星'.tr,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.ws, vertical: 3.hs),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 时间偏移控制
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
                    tooltip: '上一时辰'.tr,
                    onPressed: () {
                      ref.read(ziweiDateOffsetProvider.notifier).state =
                          offset - const Duration(hours: 2);
                    },
                  ),

                  // 恢复按钮或定盘文字
                  if (offset != Duration.zero)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.ws),
                      child: ActionChip(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        labelPadding: EdgeInsets.symmetric(horizontal: 2.ws),
                        label: Text(
                          '复原'.tr,
                          style: TextStyle(fontSize: 9.5.ts),
                        ),
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
                      padding: EdgeInsets.symmetric(horizontal: 5.ws),
                      child: Text(
                        '定盘'.tr,
                        style: TextStyle(
                          fontSize: 10.5.ts,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                  _buildTimeShiftButton(
                    icon: Icons.keyboard_arrow_right,
                    tooltip: '下一时辰'.tr,
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

                  SizedBox(width: 6.ws),

                  // 天地人盘下拉菜单
                  PopupMenuButton<TDRpan>(
                    initialValue: tdrPan,
                    tooltip: '切换天地人盘'.tr,
                    onSelected: (value) {
                      ref.read(tdrPanProvider.notifier).state = value;
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: TDRpan.tianPan,
                        child: Text('天盘'.tr),
                      ),
                      PopupMenuItem(
                        value: TDRpan.diPan,
                        child: Text('地盘'.tr),
                      ),
                      PopupMenuItem(
                        value: TDRpan.renPan,
                        child: Text('人盘'.tr),
                      ),
                    ],
                    child: Chip(
                      visualDensity: const VisualDensity(
                        horizontal: -2,
                        vertical: -2,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 2.ws),
                      label: Text(
                        panNames[tdrPan]!,
                        style: TextStyle(fontSize: 10.ts),
                      ),
                      avatar: Icon(Icons.unfold_more, size: 14.ts),
                    ),
                  ),

                  SizedBox(width: 3.ws),

                  PopupMenuButton<ZiweiChartMode>(
                    initialValue: chartMode,
                    tooltip: '切换盘式'.tr,
                    onSelected: (value) {
                      ref.read(ziweiChartModeProvider.notifier).state = value;
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: ZiweiChartMode.sanhe,
                        child: Text('三合'.tr),
                      ),
                      PopupMenuItem(
                        value: ZiweiChartMode.sihua,
                        child: Text('四化'.tr),
                      ),
                      PopupMenuItem(
                        value: ZiweiChartMode.flying,
                        child: Text('飞星'.tr),
                      ),
                    ],
                    child: Chip(
                      visualDensity: const VisualDensity(
                        horizontal: -2,
                        vertical: -2,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 2.ws),
                      label: Text(
                        chartModeNames[chartMode]!,
                        style: TextStyle(fontSize: 10.ts),
                      ),
                      avatar: Icon(Icons.tune, size: 14.ts),
                    ),
                  ),

                  SizedBox(width: 2.ws),

                  // AI 导出按钮
                  IconButton(
                    onPressed: () => _copyAiData(context, ref),
                    icon: Icon(
                      Icons.smart_toy,
                      size: 16.ts,
                      color: Colors.blueGrey,
                    ),
                    tooltip: '复制 AI 数据'.tr,
                    visualDensity: const VisualDensity(
                      horizontal: -2,
                      vertical: -2,
                    ),
                    padding: EdgeInsets.all(2.ws),
                    constraints: BoxConstraints(
                      minWidth: 28.ws,
                      minHeight: 28.hs,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _copyAiData(BuildContext context, WidgetRef ref) {
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
  }

  Widget _buildTimeShiftButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 17.ts),
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
      padding: EdgeInsets.all(2.ws),
      constraints: BoxConstraints(minWidth: 24.ws, minHeight: 24.hs),
    );
  }
}
