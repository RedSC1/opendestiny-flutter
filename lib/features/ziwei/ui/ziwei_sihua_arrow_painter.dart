import 'package:flutter/material.dart';
import 'package:ziwei_core/ziwei_core.dart';
import 'dart:math' as math;
import 'ziwei_classic_theme.dart';

class _ArrowTask {
  final bool isCentrifugal;
  final SiHuaType sihuaType;

  _ArrowTask({required this.isCentrifugal, required this.sihuaType});
}

class _PalaceBoundary {
  final Offset outerAnchor;
  final Offset innerAnchor;
  final Offset slideTangent;

  _PalaceBoundary({
    required this.outerAnchor,
    required this.innerAnchor,
    required this.slideTangent,
  });
}

/// 盘面级别的自化箭头绘制器 (离心向外，向心穿心向内)
class ZiweiSihuaArrowPainter extends CustomPainter {
  final ZiWeiPlate plate;
  final double edgeMargin; // 盘面外部留白

  ZiweiSihuaArrowPainter({required this.plate, required this.edgeMargin});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final double innerWidth = size.width - (edgeMargin * 2);
    final double innerHeight = size.height - (edgeMargin * 2);

    final double cellW = innerWidth / 4;
    final double cellH = innerHeight / 4;

    // 1. 收集和路由渲染任务
    Map<DiZhi, List<_ArrowTask>> renderTasks = {
      for (var dz in DiZhi.values) dz: [],
    };

    for (int i = 0; i < 12; i++) {
      final diZhi = DiZhi.values[i];
      final palace = plate.palaces[i];

      for (final starList in palace.stars.values) {
        for (final star in starList) {
          if (star is StaticStar) {
            if (star.selfSiHua != null) {
              // 离心 (本宫触发，向外射出)
              renderTasks[diZhi]!.add(
                _ArrowTask(isCentrifugal: true, sihuaType: star.selfSiHua!),
              );
            }

            if (star.centripetalSiHua != null) {
              // 向心 (对宫触发，从对宫射向本宫)
              final DiZhi oppDiZhi = DiZhi.values[(i + 6) % 12];
              renderTasks[oppDiZhi]!.add(
                _ArrowTask(
                  isCentrifugal: false,
                  sihuaType: star.centripetalSiHua!,
                ),
              );
            }
          }
        }
      }
    }

    // 2. 逐个宫位边缘进行渲染
    for (int i = 0; i < 12; i++) {
      final diZhi = DiZhi.values[i];
      final tasks = renderTasks[diZhi]!;
      if (tasks.isEmpty) continue;

      final Rect cellRect = _getCellRect(
        diZhi,
        cellW,
        cellH,
      ).translate(edgeMargin, edgeMargin);

      final DiZhi oppDiZhi = DiZhi.values[(diZhi.index + 6) % 12];
      final Rect oppRect = _getCellRect(
        oppDiZhi,
        cellW,
        cellH,
      ).translate(edgeMargin, edgeMargin);

      // 计算真实对宫连线的方向 (射击朝向)
      final Offset center = cellRect.center;
      final Offset oppCenter = oppRect.center;
      final Offset outerDir = _normalize(center - oppCenter);

      // 获取当前宫位的标准边框和滑动切线向量
      final _PalaceBoundary boundary = _getBoundary(diZhi, cellRect);

      int centrifugalCount = 0;
      int centripetalCount = 0;

      for (int k = 0; k < tasks.length; k++) {
        final task = tasks[k];
        final int offsetIndex = task.isCentrifugal
            ? centrifugalCount++
            : centripetalCount++;

        _drawArrow(
          canvas: canvas,
          boundary: boundary,
          outerDir: outerNormal(outerDir),
          task: task,
          offsetIndex: offsetIndex,
        );
      }
    }
  }

  Offset outerNormal(Offset dir) => dir;

  void _drawArrow({
    required Canvas canvas,
    required _PalaceBoundary boundary,
    required Offset outerDir,
    required _ArrowTask task,
    required int offsetIndex,
  }) {
    // 调小箭头整体尺寸，避免过度占据空间
    final double arrowLength = 10.0;
    final double strokeWidth = 1.5;
    final double arrowHeadLength = 4.5;

    // 根据索引决定在边线上滑动排开的偏移行程
    final double shiftAmount = _getShiftAmount(offsetIndex, 8.0);

    Offset start, end;

    if (task.isCentrifugal) {
      // 离心 (向外)：以边框外侧的绝对中心出发
      final Offset anchor =
          boundary.outerAnchor + (boundary.slideTangent * shiftAmount);
      final Offset dir = outerDir;

      start = anchor - (dir * 2.0); // 稍微伸进内部一点点起步
      end = anchor + (dir * arrowLength);
    } else {
      // 向心 (向里)：以边框内侧的绝对中心出发，斜指对宫靶心
      final Offset anchor =
          boundary.innerAnchor + (boundary.slideTangent * shiftAmount);
      final Offset dir = -outerDir;

      start = anchor - (dir * 2.0);
      end = anchor + (dir * arrowLength);
    }

    // 绘制
    final Color arrowColor = ZiweiClassicTheme.getSihuaColor(task.sihuaType);
    final Paint paint = Paint()
      ..color = arrowColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);

    _drawArrowHead(canvas, start, end, paint, arrowHeadLength);
  }

  double _getShiftAmount(int index, double baseStep) {
    if (index == 0) return 0;
    int factor = ((index + 1) ~/ 2);
    if (index % 2 == 0) factor = -factor;
    return factor * baseStep;
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
    double headLength,
  ) {
    final double headAngle = math.pi / 6;

    final double angle = math.atan2(end.dy - start.dy, end.dx - start.dx);

    final Offset leftTip = Offset(
      end.dx - headLength * math.cos(angle - headAngle),
      end.dy - headLength * math.sin(angle - headAngle),
    );
    final Offset rightTip = Offset(
      end.dx - headLength * math.cos(angle + headAngle),
      end.dy - headLength * math.sin(angle + headAngle),
    );

    final Path path = Path()
      ..moveTo(leftTip.dx, leftTip.dy)
      ..lineTo(end.dx, end.dy)
      ..lineTo(rightTip.dx, rightTip.dy);

    final Paint headPaint = Paint()
      ..color = paint.color
      ..strokeWidth = paint.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path, headPaint);
  }

  _PalaceBoundary _getBoundary(DiZhi diZhi, Rect rect) {
    final c = rect.center;

    // Corner tanget: perpendicular to the corner diagonal to slide along the corner fan
    Offset tg(double dx, double dy) {
      final n = Offset(dx, dy);
      final l = n.distance;
      return Offset(-n.dy / l, n.dx / l);
    }

    switch (diZhi) {
      case DiZhi.si:
        return _PalaceBoundary(
          outerAnchor: rect.topLeft,
          innerAnchor: rect.bottomRight,
          slideTangent: tg(-1, -1),
        );
      case DiZhi.wu:
      case DiZhi.wei:
        return _PalaceBoundary(
          outerAnchor: Offset(c.dx, rect.top),
          innerAnchor: Offset(c.dx, rect.bottom),
          slideTangent: const Offset(1, 0), // 沿水平边界平移避让
        );
      case DiZhi.shen:
        return _PalaceBoundary(
          outerAnchor: rect.topRight,
          innerAnchor: rect.bottomLeft,
          slideTangent: tg(1, -1),
        );
      case DiZhi.you:
      case DiZhi.xu:
        return _PalaceBoundary(
          outerAnchor: Offset(rect.right, c.dy),
          innerAnchor: Offset(rect.left, c.dy),
          slideTangent: const Offset(0, 1), // 沿垂直边界平移避让
        );
      case DiZhi.hai:
        return _PalaceBoundary(
          outerAnchor: rect.bottomRight,
          innerAnchor: rect.topLeft,
          slideTangent: tg(1, 1),
        );
      case DiZhi.zi:
      case DiZhi.chou:
        return _PalaceBoundary(
          outerAnchor: Offset(c.dx, rect.bottom),
          innerAnchor: Offset(c.dx, rect.top),
          slideTangent: const Offset(1, 0), // 沿水平边界平移避让
        );
      case DiZhi.yin:
        return _PalaceBoundary(
          outerAnchor: rect.bottomLeft,
          innerAnchor: rect.topRight,
          slideTangent: tg(-1, 1),
        );
      case DiZhi.mao:
      case DiZhi.chen:
        return _PalaceBoundary(
          outerAnchor: Offset(rect.left, c.dy),
          innerAnchor: Offset(rect.right, c.dy),
          slideTangent: const Offset(0, 1), // 沿垂直边界平移避让
        );
    }
  }

  Offset _normalize(Offset v) {
    final double l = v.distance;
    if (l == 0) return v;
    return Offset(v.dx / l, v.dy / l);
  }

  Rect _getCellRect(DiZhi diZhi, double cellW, double cellH) {
    int col = 0;
    int row = 0;

    switch (diZhi) {
      case DiZhi.si:
        col = 0;
        row = 0;
        break;
      case DiZhi.wu:
        col = 1;
        row = 0;
        break;
      case DiZhi.wei:
        col = 2;
        row = 0;
        break;
      case DiZhi.shen:
        col = 3;
        row = 0;
        break;

      case DiZhi.chen:
        col = 0;
        row = 1;
        break;
      case DiZhi.you:
        col = 3;
        row = 1;
        break;

      case DiZhi.mao:
        col = 0;
        row = 2;
        break;
      case DiZhi.xu:
        col = 3;
        row = 2;
        break;

      case DiZhi.yin:
        col = 0;
        row = 3;
        break;
      case DiZhi.chou:
        col = 1;
        row = 3;
        break;
      case DiZhi.zi:
        col = 2;
        row = 3;
        break;
      case DiZhi.hai:
        col = 3;
        row = 3;
        break;
    }
    return Rect.fromLTWH(col * cellW, row * cellH, cellW, cellH);
  }

  @override
  bool shouldRepaint(ZiweiSihuaArrowPainter oldDelegate) {
    return true;
  }
}
