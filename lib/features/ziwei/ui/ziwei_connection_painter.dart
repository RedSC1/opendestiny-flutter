import 'package:flutter/material.dart';
import 'package:ziwei_core/ziwei_core.dart';
import 'ziwei_classic_theme.dart';

/// 专为中宫(2x2区域)设计的三方四正连线 Painter
///
/// 12 个宫位各自映射到中宫边缘的**独立锚点**，
/// 确保任何三方四正组合都能绘制出正确的几何形状。
class ZiweiCenterConnectionPainter extends CustomPainter {
  final int selectedIndex;

  ZiweiCenterConnectionPainter({required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final List<int> targetIndices = [
      (selectedIndex + 6) % 12, // 对冲
      (selectedIndex + 4) % 12, // 三合 1
      (selectedIndex + 8) % 12, // 三合 2
    ];

    final Paint linePaint = Paint()
      ..color = ZiweiClassicTheme.palaceNameColor.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    // 获取相对中宫的边缘锚点
    final startPoint = _getAnchor(selectedIndex, w, h);
    final pOpposite = _getAnchor(targetIndices[0], w, h);
    final pTrine1 = _getAnchor(targetIndices[1], w, h);
    final pTrine2 = _getAnchor(targetIndices[2], w, h);

    final Path path = Path();

    // 1. 三合三角形
    path.moveTo(startPoint.dx, startPoint.dy);
    path.lineTo(pTrine1.dx, pTrine1.dy);
    path.lineTo(pTrine2.dx, pTrine2.dy);
    path.close();

    // 2. 对冲线
    path.moveTo(startPoint.dx, startPoint.dy);
    path.lineTo(pOpposite.dx, pOpposite.dy);

    canvas.drawPath(path, linePaint);

    // 3. 节点圆点
    final nodePaint = Paint()
      ..color = ZiweiClassicTheme.palaceNameColor.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    for (var p in [startPoint, pOpposite, pTrine1, pTrine2]) {
      canvas.drawCircle(p, 2.0, nodePaint);
    }
  }

  /// 将 12 地支映射到中宫边缘的 12 个**独立锚点**
  ///
  /// 4x4 布局 (来自 ZiweiChartWidget)：
  /// ```
  ///   col0  col1  col2  col3
  /// row0  巳    午    未    申
  /// row1  辰    [中    宫]   酉
  /// row2  卯    [中    宫]   戌
  /// row3  寅    丑    子    亥
  /// ```
  ///
  /// 中宫占据 (col1,row1)~(col3,row3)，即本 painter 的完整画布。
  /// 每个外围宫位映射到它面朝中宫那条边上的对应位置：
  /// - 顶边 (y=0)：巳→(0,0), 午→(w/2,0), 未→(w/2,0) 不行，这样又重叠了
  ///
  /// 正确思路：顶边有 4 个宫(巳午未申)，所以把顶边分成 4 段。
  /// 左边有 4 个宫(巳辰卯寅)，底边 4 个宫(寅丑子亥)，右边 4 个宫(申酉戌亥)。
  /// 角位的宫(巳/申/寅/亥)属于两条边的交汇，放在角点上。
  Offset _getAnchor(int diZhiIndex, double w, double h) {
    final dz = DiZhi.values[diZhiIndex];

    switch (dz) {
      // === 顶边 (y=0)，从左到右 ===
      case DiZhi.si:   return Offset(0, 0);           // 左上角
      case DiZhi.wu:   return Offset(w / 3, 0);       // 顶边 1/3 处
      case DiZhi.wei:  return Offset(w * 2 / 3, 0);   // 顶边 2/3 处
      case DiZhi.shen: return Offset(w, 0);            // 右上角

      // === 右边 (x=w)，从上到下 ===
      case DiZhi.you:  return Offset(w, h / 3);        // 右边 1/3 处
      case DiZhi.xu:   return Offset(w, h * 2 / 3);    // 右边 2/3 处

      // === 底边 (y=h)，从右到左 ===
      case DiZhi.hai:  return Offset(w, h);             // 右下角
      case DiZhi.zi:   return Offset(w * 2 / 3, h);    // 底边 2/3 处
      case DiZhi.chou: return Offset(w / 3, h);         // 底边 1/3 处

      // === 左边 (x=0)，从下到上 ===
      case DiZhi.yin:  return Offset(0, h);             // 左下角
      case DiZhi.mao:  return Offset(0, h * 2 / 3);    // 左边 2/3 处
      case DiZhi.chen: return Offset(0, h / 3);         // 左边 1/3 处
    }
  }

  @override
  bool shouldRepaint(ZiweiCenterConnectionPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }
}
