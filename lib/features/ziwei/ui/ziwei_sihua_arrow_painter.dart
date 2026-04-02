import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ziwei_core/ziwei_core.dart';

import 'ziwei_classic_theme.dart';

class _ArrowTask {
  final bool isCentrifugal;
  final SiHuaType sihuaType;

  const _ArrowTask({required this.isCentrifugal, required this.sihuaType});
}

class _PalaceBoundary {
  final Offset outerAnchor;
  final Offset innerAnchor;
  final Offset slideTangent;

  const _PalaceBoundary({
    required this.outerAnchor,
    required this.innerAnchor,
    required this.slideTangent,
  });
}

/// 三合盘 / 飞星盘共用的自化箭头层
/// 这里只按引擎给出的 selfSiHua / centripetalSiHua 直接路由渲染，
/// 不做额外业务判定，避免前端再次“改写规则”。
class ZiweiSihuaArrowPainter extends CustomPainter {
  final ZiWeiPlate plate;
  final double edgeMargin;

  const ZiweiSihuaArrowPainter({
    required this.plate,
    required this.edgeMargin,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final innerWidth = size.width - (edgeMargin * 2);
    final innerHeight = size.height - (edgeMargin * 2);
    final cellW = innerWidth / 4;
    final cellH = innerHeight / 4;

    final renderTasks = <DiZhi, List<_ArrowTask>>{
      for (final dz in DiZhi.values) dz: [],
    };

    for (int i = 0; i < 12; i++) {
      final diZhi = DiZhi.values[i];
      final palace = plate.palaces[i];

      for (final starList in palace.stars.values) {
        for (final star in starList) {
          if (star is! StaticStar) continue;

          if (star.selfSiHua != null) {
            renderTasks[diZhi]!.add(
              _ArrowTask(
                isCentrifugal: true,
                sihuaType: star.selfSiHua!,
              ),
            );
          }

          if (star.centripetalSiHua != null) {
            final oppositeDiZhi = DiZhi.values[(i + 6) % 12];
            renderTasks[oppositeDiZhi]!.add(
              _ArrowTask(
                isCentrifugal: false,
                sihuaType: star.centripetalSiHua!,
              ),
            );
          }
        }
      }
    }

    for (int i = 0; i < 12; i++) {
      final diZhi = DiZhi.values[i];
      final tasks = renderTasks[diZhi]!;
      if (tasks.isEmpty) continue;

      final cellRect = _getCellRect(diZhi, cellW, cellH).translate(
        edgeMargin,
        edgeMargin,
      );
      final oppositeDiZhi = DiZhi.values[(diZhi.index + 6) % 12];
      final oppositeRect = _getCellRect(oppositeDiZhi, cellW, cellH).translate(
        edgeMargin,
        edgeMargin,
      );

      final outerDir = _normalize(cellRect.center - oppositeRect.center);
      final boundary = _getBoundary(diZhi, cellRect);

      var centrifugalCount = 0;
      var centripetalCount = 0;

      for (final task in tasks) {
        final offsetIndex = task.isCentrifugal
            ? centrifugalCount++
            : centripetalCount++;
        _drawArrow(
          canvas: canvas,
          boundary: boundary,
          outerDir: outerDir,
          task: task,
          offsetIndex: offsetIndex,
        );
      }
    }
  }

  void _drawArrow({
    required Canvas canvas,
    required _PalaceBoundary boundary,
    required Offset outerDir,
    required _ArrowTask task,
    required int offsetIndex,
  }) {
    const arrowLength = 10.0;
    const strokeWidth = 1.5;
    const arrowHeadLength = 4.5;
    final shiftAmount = _getShiftAmount(offsetIndex, 8.0);

    late final Offset start;
    late final Offset end;

    if (task.isCentrifugal) {
      final anchor = boundary.outerAnchor + (boundary.slideTangent * shiftAmount);
      start = anchor - (outerDir * 2.0);
      end = anchor + (outerDir * arrowLength);
    } else {
      final anchor = boundary.innerAnchor + (boundary.slideTangent * shiftAmount);
      final dir = -outerDir;
      start = anchor - (dir * 2.0);
      end = anchor + (dir * arrowLength);
    }

    final paint = Paint()
      ..color = ZiweiClassicTheme.getSihuaColor(task.sihuaType)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
    _drawArrowHead(canvas, start, end, paint, arrowHeadLength);
  }

  double _getShiftAmount(int index, double baseStep) {
    if (index == 0) return 0;
    var factor = ((index + 1) ~/ 2);
    if (index.isEven) factor = -factor;
    return factor * baseStep;
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
    double headLength,
  ) {
    const headAngle = math.pi / 6;
    final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);

    final leftTip = Offset(
      end.dx - headLength * math.cos(angle - headAngle),
      end.dy - headLength * math.sin(angle - headAngle),
    );
    final rightTip = Offset(
      end.dx - headLength * math.cos(angle + headAngle),
      end.dy - headLength * math.sin(angle + headAngle),
    );

    final path = Path()
      ..moveTo(leftTip.dx, leftTip.dy)
      ..lineTo(end.dx, end.dy)
      ..lineTo(rightTip.dx, rightTip.dy);

    final headPaint = Paint()
      ..color = paint.color
      ..strokeWidth = paint.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path, headPaint);
  }

  _PalaceBoundary _getBoundary(DiZhi diZhi, Rect rect) {
    final c = rect.center;

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
          slideTangent: const Offset(1, 0),
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
          slideTangent: const Offset(0, 1),
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
          slideTangent: const Offset(1, 0),
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
          slideTangent: const Offset(0, 1),
        );
    }
  }

  Offset _normalize(Offset v) {
    final l = v.distance;
    if (l == 0) return v;
    return Offset(v.dx / l, v.dy / l);
  }

  Rect _getCellRect(DiZhi diZhi, double cellW, double cellH) {
    switch (diZhi) {
      case DiZhi.si:
        return Rect.fromLTWH(0, 0, cellW, cellH);
      case DiZhi.wu:
        return Rect.fromLTWH(cellW, 0, cellW, cellH);
      case DiZhi.wei:
        return Rect.fromLTWH(cellW * 2, 0, cellW, cellH);
      case DiZhi.shen:
        return Rect.fromLTWH(cellW * 3, 0, cellW, cellH);
      case DiZhi.chen:
        return Rect.fromLTWH(0, cellH, cellW, cellH);
      case DiZhi.you:
        return Rect.fromLTWH(cellW * 3, cellH, cellW, cellH);
      case DiZhi.mao:
        return Rect.fromLTWH(0, cellH * 2, cellW, cellH);
      case DiZhi.xu:
        return Rect.fromLTWH(cellW * 3, cellH * 2, cellW, cellH);
      case DiZhi.yin:
        return Rect.fromLTWH(0, cellH * 3, cellW, cellH);
      case DiZhi.chou:
        return Rect.fromLTWH(cellW, cellH * 3, cellW, cellH);
      case DiZhi.zi:
        return Rect.fromLTWH(cellW * 2, cellH * 3, cellW, cellH);
      case DiZhi.hai:
        return Rect.fromLTWH(cellW * 3, cellH * 3, cellW, cellH);
    }
  }

  @override
  bool shouldRepaint(covariant ZiweiSihuaArrowPainter oldDelegate) {
    return oldDelegate.plate != plate || oldDelegate.edgeMargin != edgeMargin;
  }
}
