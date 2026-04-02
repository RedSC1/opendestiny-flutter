import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ziwei_core/ziwei_core.dart';

enum _RouteStyle { top, bottom, left, right }

class _InwardBucket {
  final DiZhi a;
  final DiZhi b;
  final Set<SiHuaType> aToB = <SiHuaType>{};
  final Set<SiHuaType> bToA = <SiHuaType>{};

  _InwardBucket({required this.a, required this.b});
}

class _OutwardTask {
  final DiZhi palace;
  final SiHuaType type;
  final int laneIndex;
  final String starPlacementKey;
  final String badgePlacementKey;

  const _OutwardTask({
    required this.palace,
    required this.type,
    required this.laneIndex,
    required this.starPlacementKey,
    required this.badgePlacementKey,
  });
}

class _Boundary {
  final Offset innerAnchor;
  final Offset outerAnchor;
  final Offset slideTangent;
  final _RouteStyle routeStyle;

  const _Boundary({
    required this.innerAnchor,
    required this.outerAnchor,
    required this.slideTangent,
    required this.routeStyle,
  });
}

class ZiweiSihuaModeArrowPainter extends CustomPainter {
  static const Color _lineColor = Color(0xB05F6770);

  final ZiWeiPlate plate;
  final double edgeMargin;
  final Map<String, Rect> starRects;
  final Map<String, Rect> badgeRects;

  const ZiweiSihuaModeArrowPainter({
    required this.plate,
    required this.edgeMargin,
    required this.starRects,
    required this.badgeRects,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final innerWidth = size.width - (edgeMargin * 2);
    final innerHeight = size.height - (edgeMargin * 2);
    final cellW = innerWidth / 4;
    final cellH = innerHeight / 4;
    final outerGuideRect = Rect.fromLTWH(
      edgeMargin - 10,
      edgeMargin - 10,
      innerWidth + 20,
      innerHeight + 20,
    );

    final inwardBuckets = <String, _InwardBucket>{};
    final outwardLaneCounts = <DiZhi, int>{for (final dz in DiZhi.values) dz: 0};
    final outwardTasks = <_OutwardTask>[];
    final outwardSeen = <String>{};

    for (int i = 0; i < 12; i++) {
      final target = DiZhi.values[i];
      final source = DiZhi.values[(i + 6) % 12];
      final palace = plate.palaces[i];

      for (final starList in palace.stars.values) {
        for (final star in starList) {
          if (star is! StaticStar) continue;

          if (star.centripetalSiHua != null) {
            final type = star.centripetalSiHua!;
            final a = source.index < target.index ? source : target;
            final b = source.index < target.index ? target : source;
            final bucketKey = '${a.index}:${b.index}';
            final bucket = inwardBuckets.putIfAbsent(
              bucketKey,
              () => _InwardBucket(a: a, b: b),
            );
            if (source == a) {
              bucket.aToB.add(type);
            } else {
              bucket.bToA.add(type);
            }
          }

          if (star.selfSiHua != null) {
            final type = star.selfSiHua!;
            final outwardKey = '${target.index}:${type.index}';
            if (!outwardSeen.add(outwardKey)) continue;
            final laneIndex = outwardLaneCounts[target]!;
            outwardLaneCounts[target] = laneIndex + 1;
            outwardTasks.add(
              _OutwardTask(
                palace: target,
                type: type,
                laneIndex: laneIndex,
                starPlacementKey: '${i}:${star.key}',
                badgePlacementKey: '${i}:${star.key}:${type.index}',
              ),
            );
          }
        }
      }
    }

    final inwardConnections = inwardBuckets.values.toList()
      ..sort((x, y) => x.a.index.compareTo(y.a.index));

    for (final bucket in inwardConnections) {
      _drawInwardConnection(
        canvas,
        cellW: cellW,
        cellH: cellH,
        bucket: bucket,
      );
    }

    for (final task in outwardTasks) {
      final cellRect = _getCellRect(task.palace, cellW, cellH).translate(
        edgeMargin,
        edgeMargin,
      );
      _drawOutwardTask(
        canvas,
        task: task,
        cellRect: cellRect,
        outerGuideRect: outerGuideRect,
      );
    }
  }

  void _drawInwardConnection(
    Canvas canvas, {
    required double cellW,
    required double cellH,
    required _InwardBucket bucket,
  }) {
    final aRect = _getCellRect(bucket.a, cellW, cellH).translate(
      edgeMargin,
      edgeMargin,
    );
    final bRect = _getCellRect(bucket.b, cellW, cellH).translate(
      edgeMargin,
      edgeMargin,
    );
    final aBoundary = _getBoundary(bucket.a, aRect);
    final bBoundary = _getBoundary(bucket.b, bRect);

    final startAnchor = aBoundary.innerAnchor;
    final endAnchor = bBoundary.innerAnchor;
    final direction = _normalize(endAnchor - startAnchor);
    if (direction.distance == 0) return;

    final start = startAnchor + (direction * 3.0);
    final end = endAnchor - (direction * 3.0);
    final paint = Paint()
      ..color = _lineColor
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);

    final aToB = bucket.aToB.toList()..sort((x, y) => x.index.compareTo(y.index));
    final bToA = bucket.bToA.toList()..sort((x, y) => x.index.compareTo(y.index));

    if (aToB.isNotEmpty) {
      _drawArrowHead(canvas, start, end, paint, 5.0);
      _drawLabelList(
        canvas,
        endPoint: end,
        direction: direction,
        types: aToB,
      );
    }

    if (bToA.isNotEmpty) {
      _drawArrowHead(canvas, end, start, paint, 5.0);
      _drawLabelList(
        canvas,
        endPoint: start,
        direction: -direction,
        types: bToA,
      );
    }
  }

  void _drawOutwardTask(
    Canvas canvas, {
    required _OutwardTask task,
    required Rect cellRect,
    required Rect outerGuideRect,
  }) {
    final boundary = _getBoundary(task.palace, cellRect);
    final anchor = _resolveOutwardAnchor(task, cellRect, boundary);
    final paint = Paint()
      ..color = _lineColor
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    if (boundary.routeStyle == _RouteStyle.top ||
        boundary.routeStyle == _RouteStyle.bottom) {
      final end = boundary.routeStyle == _RouteStyle.top
          ? Offset(anchor.dx, outerGuideRect.top)
          : Offset(anchor.dx, outerGuideRect.bottom);
      canvas.drawLine(anchor, end, paint);
      final direction = _normalize(end - anchor);
      _drawArrowHead(canvas, anchor, end, paint, 5.0);
      _drawLabelList(
        canvas,
        endPoint: end,
        direction: direction,
        types: [task.type],
      );
      return;
    }

    final safeBottom = _palaceObstacleBottom(task.palace.index, cellRect);
    final bendY = math.max(anchor.dy + 10.0, safeBottom + 6.0 + task.laneIndex * 12.0);
    final endX =
        boundary.routeStyle == _RouteStyle.left ? outerGuideRect.left : outerGuideRect.right;
    final firstBend = Offset(anchor.dx, bendY);
    final end = Offset(endX, bendY);

    final path = Path()
      ..moveTo(anchor.dx, anchor.dy)
      ..lineTo(firstBend.dx, firstBend.dy)
      ..lineTo(end.dx, end.dy);
    canvas.drawPath(path, paint);

    final direction = _normalize(end - firstBend);
    _drawArrowHead(canvas, firstBend, end, paint, 5.0);
    _drawLabelList(
      canvas,
      endPoint: end,
      direction: direction,
      types: [task.type],
      laneIndex: task.laneIndex,
    );
  }

  Offset _resolveOutwardAnchor(
    _OutwardTask task,
    Rect cellRect,
    _Boundary boundary,
  ) {
    final badgeRect = badgeRects[task.badgePlacementKey];
    if (badgeRect != null) {
      return Offset(
        badgeRect.center.dx,
        (badgeRect.bottom + 2.0).clamp(cellRect.top, cellRect.bottom),
      );
    }

    final starRect = starRects[task.starPlacementKey];
    if (starRect != null) {
      return Offset(
        starRect.center.dx,
        (starRect.bottom + 2.0).clamp(cellRect.top, cellRect.bottom),
      );
    }

    return boundary.outerAnchor + (boundary.slideTangent * _getShiftAmount(task.laneIndex, 7.0));
  }

  double _palaceObstacleBottom(int palaceIndex, Rect cellRect) {
    final prefix = '$palaceIndex:';
    var bottom = cellRect.top;

    for (final entry in starRects.entries) {
      if (entry.key.startsWith(prefix) && entry.value.bottom > bottom) {
        bottom = entry.value.bottom;
      }
    }
    for (final entry in badgeRects.entries) {
      if (entry.key.startsWith(prefix) && entry.value.bottom > bottom) {
        bottom = entry.value.bottom;
      }
    }

    return bottom.clamp(cellRect.top, cellRect.bottom);
  }

  void _drawLabelList(
    Canvas canvas, {
    required Offset endPoint,
    required Offset direction,
    required List<SiHuaType> types,
    int laneIndex = 0,
  }) {
    if (types.isEmpty) return;

    final dir = _normalize(direction);
    final normal = Offset(-dir.dy, dir.dx);
    final centeredOffset = (types.length - 1) / 2.0;
    final alongOffset = 3.0 + laneIndex * 1.2;
    final sideBase = 7.0;

    for (int i = 0; i < types.length; i++) {
      final type = types[i];
      final textPainter = TextPainter(
        text: TextSpan(
          text: _labelFor(type),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: _labelColor(type),
            height: 1.0,
            shadows: const [
              Shadow(color: Colors.white, blurRadius: 2),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final spread = (i - centeredOffset) * 7.0;
      final sideOffset = sideBase + spread;
      final offset =
          endPoint -
          (dir * alongOffset) +
          (normal * sideOffset);

      textPainter.paint(
        canvas,
        Offset(
          offset.dx - textPainter.width / 2,
          offset.dy - textPainter.height / 2,
        ),
      );
    }
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

    final left = Offset(
      end.dx - headLength * math.cos(angle - headAngle),
      end.dy - headLength * math.sin(angle - headAngle),
    );
    final right = Offset(
      end.dx - headLength * math.cos(angle + headAngle),
      end.dy - headLength * math.sin(angle + headAngle),
    );

    final path = Path()
      ..moveTo(left.dx, left.dy)
      ..lineTo(end.dx, end.dy)
      ..lineTo(right.dx, right.dy);

    canvas.drawPath(
      path,
      Paint()
        ..color = paint.color
        ..strokeWidth = paint.strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  String _labelFor(SiHuaType type) {
    switch (type) {
      case SiHuaType.lu:
        return 'A';
      case SiHuaType.quan:
        return 'B';
      case SiHuaType.ke:
        return 'C';
      case SiHuaType.ji:
        return 'D';
    }
  }

  Color _labelColor(SiHuaType type) {
    switch (type) {
      case SiHuaType.lu:
        return const Color(0xFF2E7D32);
      case SiHuaType.quan:
        return const Color(0xFFEF6C00);
      case SiHuaType.ke:
        return const Color(0xFF1565C0);
      case SiHuaType.ji:
        return const Color(0xFFC62828);
    }
  }

  double _getShiftAmount(int index, double baseStep) {
    if (index == 0) return 0;
    var factor = ((index + 1) ~/ 2);
    if (index.isEven) factor = -factor;
    return factor * baseStep;
  }

  _Boundary _getBoundary(DiZhi diZhi, Rect rect) {
    final c = rect.center;

    Offset tg(double dx, double dy) {
      final n = Offset(dx, dy);
      final l = n.distance;
      return Offset(-n.dy / l, n.dx / l);
    }

    switch (diZhi) {
      case DiZhi.si:
        return _Boundary(
          innerAnchor: rect.bottomRight,
          outerAnchor: rect.topLeft,
          slideTangent: tg(-1, -1),
          routeStyle: _RouteStyle.top,
        );
      case DiZhi.wu:
      case DiZhi.wei:
        return _Boundary(
          innerAnchor: Offset(c.dx, rect.bottom),
          outerAnchor: Offset(c.dx, rect.top),
          slideTangent: const Offset(1, 0),
          routeStyle: _RouteStyle.top,
        );
      case DiZhi.shen:
        return _Boundary(
          innerAnchor: rect.bottomLeft,
          outerAnchor: rect.topRight,
          slideTangent: tg(1, -1),
          routeStyle: _RouteStyle.top,
        );
      case DiZhi.you:
      case DiZhi.xu:
        return _Boundary(
          innerAnchor: Offset(rect.left, c.dy),
          outerAnchor: Offset(rect.right, c.dy),
          slideTangent: const Offset(0, 1),
          routeStyle: _RouteStyle.right,
        );
      case DiZhi.hai:
        return _Boundary(
          innerAnchor: rect.topLeft,
          outerAnchor: rect.bottomRight,
          slideTangent: tg(1, 1),
          routeStyle: _RouteStyle.bottom,
        );
      case DiZhi.zi:
      case DiZhi.chou:
        return _Boundary(
          innerAnchor: Offset(c.dx, rect.top),
          outerAnchor: Offset(c.dx, rect.bottom),
          slideTangent: const Offset(1, 0),
          routeStyle: _RouteStyle.bottom,
        );
      case DiZhi.yin:
        return _Boundary(
          innerAnchor: rect.topRight,
          outerAnchor: rect.bottomLeft,
          slideTangent: tg(-1, 1),
          routeStyle: _RouteStyle.bottom,
        );
      case DiZhi.mao:
      case DiZhi.chen:
        return _Boundary(
          innerAnchor: Offset(rect.right, c.dy),
          outerAnchor: Offset(rect.left, c.dy),
          slideTangent: const Offset(0, 1),
          routeStyle: _RouteStyle.left,
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
  bool shouldRepaint(covariant ZiweiSihuaModeArrowPainter oldDelegate) {
    return true;
  }
}
