import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../providers/ziwei_providers.dart';
import 'palace_cell_widget.dart';
import 'center_info_widget.dart';
import 'ziwei_sihua_arrow_painter.dart';

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
        const double edgeMargin = 12.0; // 稍微调小一点，之前 20 太大了。留出 12px 够放一个“身”字标签了。
        final width = constraints.maxWidth - (edgeMargin * 2);
        final cellWidth = width / 4;
        final cellHeight = cellWidth * 1.05; // 压缩垂直比例，确保流年行不用往下滑

        // 计算 12 个地支宫位的相对坐标 (Row, Column)
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
          width: constraints.maxWidth,
          height: (cellHeight * 4) + (edgeMargin * 2),
          child: Stack(
            clipBehavior: Clip.none, // 允许子组件（如身宫标记）超出宫位边界绘制
            children: [
              // 1. 底层：十二个小宫位
              ...DiZhi.values.map((dz) {
                final pos = positions[dz]!;
                final palace = state.plate.palaces[dz.index];

                return Positioned(
                  left: pos.dx * cellWidth + edgeMargin,
                  top: pos.dy * cellHeight + edgeMargin,
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
                left: cellWidth + edgeMargin,
                top: cellHeight + edgeMargin,
                width: cellWidth * 2,
                height: cellHeight * 2,
                child: CenterInfoWidget(state: state),
              ),

              // 3. 超顶层：跨宫位的自化箭头
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: ZiweiSihuaArrowPainter(
                      plate: state.plate,
                      edgeMargin: edgeMargin,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
