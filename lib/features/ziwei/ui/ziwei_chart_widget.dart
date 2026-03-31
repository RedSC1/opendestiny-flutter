import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../providers/ziwei_providers.dart';
import 'palace_cell_widget.dart';
import 'center_info_widget.dart';

class ZiweiChartWidget extends ConsumerWidget {
  const ZiweiChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 这里我们只监听这个大盘的整体可用状态。
    // 具体每个宫位的数据如果需要细粒度优化，可以在 PalaceCell 里再局部读取。
    // 但为了刚起步时结构简单，我们可以先一把梭读取整个 state。
    final state = ref.watch(ziweiUIManagerProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        // 让盘面绝对正方形
        final width = constraints.maxWidth;
        final cellWidth = width / 4;
        final cellHeight = cellWidth * 1.05; // 压缩垂直比例，确保流年行不用往下滑

        // 计算 12 个地支宫位的相对坐标 (Row, Column)
        // 0: 巳 (0,0), 1: 午 (0,1), 2: 未 (0,2), 3: 申 (0,3)
        // 4: 辰 (1,0),                        5: 酉 (1,3)
        // 6: 卯 (2,0),                        7: 戌 (2,3)
        // 8: 寅 (3,0), 9: 丑 (3,1), 10: 子 (3,2), 11: 亥 (3,3)
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
          width: cellWidth * 4,
          height: cellHeight * 4,
          child: Stack(
            children: [
              // 1. 底层：十二个小宫位
              ...DiZhi.values.map((dz) {
                final pos = positions[dz]!;
                final palace = state.plate.palaces[dz.index];

                return Positioned(
                  left: pos.dx * cellWidth,
                  top: pos.dy * cellHeight,
                  width: cellWidth,
                  height: cellHeight,
                  child: PalaceCellWidget(
                    palace: palace,
                    plate: state.plate,
                    state: state,
                  ),
                );
              }),

              // 2. 顶层：悬浮的巨大中宫 (占据 1,1 到 2,2，宽宽高高各2格)
              Positioned(
                left: cellWidth,
                top: cellHeight,
                width: cellWidth * 2,
                height: cellHeight * 2,
                child: CenterInfoWidget(state: state),
              ),
            ],
          ),
        );
      },
    );
  }
}
