import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ziwei_core/ziwei_core.dart';

import 'ziwei_classic_theme.dart';

class FlyingStarArrowTarget {
  final Rect rect;
  final SiHuaType sihuaType;

  const FlyingStarArrowTarget({
    required this.rect,
    required this.sihuaType,
  });
}

class ZiweiFlyingStarPainter extends CustomPainter {
  final Rect sourceRect;
  final List<FlyingStarArrowTarget> targets;

  const ZiweiFlyingStarPainter({
    required this.sourceRect,
    required this.targets,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (targets.isEmpty) return;

    final sourceCenter = sourceRect.center;

    for (final target in targets) {
      final targetCenter = target.rect.center;
      final direction = targetCenter - sourceCenter;
      if (direction.distance == 0) continue;

      final unit = _normalize(direction);
      final hiddenDistance =
          (math.max(sourceRect.width, sourceRect.height) / 2) + 2.0;
      final startAnchor = sourceCenter + unit * hiddenDistance;
      final endAnchor = _edgeAnchor(target.rect, -direction);

      final paint = Paint()
        ..color = ZiweiClassicTheme.getSihuaColor(target.sihuaType)
        ..strokeWidth = 1.6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(startAnchor, endAnchor, paint);
      _drawArrowHead(canvas, startAnchor, endAnchor, paint);
    }
  }

  Offset _edgeAnchor(Rect rect, Offset direction) {
    final center = rect.center;
    final dx = direction.dx;
    final dy = direction.dy;

    if (dx == 0 && dy == 0) return center;

    final halfWidth = rect.width / 2;
    final halfHeight = rect.height / 2;
    final tx = dx == 0 ? double.infinity : halfWidth / dx.abs();
    final ty = dy == 0 ? double.infinity : halfHeight / dy.abs();
    final t = math.min(tx, ty);

    return Offset(center.dx + dx * t, center.dy + dy * t);
  }

  Offset _normalize(Offset vector) {
    final distance = vector.distance;
    if (distance == 0) return Offset.zero;
    return Offset(vector.dx / distance, vector.dy / distance);
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
  ) {
    const headLength = 7.0;
    const headAngle = math.pi / 7;
    final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);

    final left = Offset(
      end.dx - headLength * math.cos(angle - headAngle),
      end.dy - headLength * math.sin(angle - headAngle),
    );
    final right = Offset(
      end.dx - headLength * math.cos(angle + headAngle),
      end.dy - headLength * math.sin(angle + headAngle),
    );

    canvas.drawLine(end, left, paint);
    canvas.drawLine(end, right, paint);
  }

  @override
  bool shouldRepaint(covariant ZiweiFlyingStarPainter oldDelegate) {
    if (oldDelegate.sourceRect != sourceRect) return true;
    if (oldDelegate.targets.length != targets.length) return true;

    for (int i = 0; i < targets.length; i++) {
      final oldTarget = oldDelegate.targets[i];
      final target = targets[i];
      if (oldTarget.rect != target.rect ||
          oldTarget.sihuaType != target.sihuaType) {
        return true;
      }
    }

    return false;
  }
}
