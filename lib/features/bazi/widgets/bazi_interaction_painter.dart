import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:bazi_core/bazi_core.dart';
import '../../../core/ui_scale.dart';

/// 连线图层：负责绘制天干地支之间的刑冲合害
class InteractionUIResult {
  final BaziInteraction type;
  final List<int> pillarIndices;
  final WuXing? combinedWuXing;
  InteractionUIResult({required this.type, required this.pillarIndices, this.combinedWuXing});
}

class BaziInteractionPainter extends CustomPainter {
  final List<InteractionUIResult> stemInteractions;
  final List<InteractionUIResult> branchInteractions;
  final List<double> pillarCenters; // 各柱中心点的 X 坐标
  final double stemCenterY;         // 天干字符中心 Y 坐标
  final double branchCenterY;       // 地支字符中心 Y 坐标
  final int? selectedPillarIdx;     // 新增：当前选中的柱子索引

  BaziInteractionPainter({
    required this.stemInteractions,
    required this.branchInteractions,
    required this.pillarCenters,
    required this.stemCenterY,
    required this.branchCenterY,
    this.selectedPillarIdx,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. 绘制天干关系 (顶部折线 - 从字顶引出)
    _drawGroupedSteppedLines(
      canvas,
      stemInteractions,
      pillarCenters,
      stemCenterY,
      true,
    );

    // 2. 绘制地支关系 (中部折线 - 从字底引出)
    _drawGroupedSteppedLines(
      canvas,
      branchInteractions,
      pillarCenters,
      branchCenterY,
      false,
    );
  }

  /// 按支柱组合归类绘图，解决重叠问题
  void _drawGroupedSteppedLines(
    Canvas canvas,
    List<InteractionUIResult> results,
    List<double> centers,
    double baseY,
    bool isTop,
  ) {
    final Map<String, List<InteractionUIResult>> grouped = {};
    for (var res in results) {
      final sortedIndices = [...res.pillarIndices]..sort();
      final key = sortedIndices.join(',');
      grouped.putIfAbsent(key, () => []).add(res);
    }

    grouped.forEach((key, groupResults) {
      for (int i = 0; i < groupResults.length; i++) {
        final double offset = i * 14.0.hs;
        _drawSingleRoundedSteppedLine(
          canvas, 
          groupResults[i], 
          centers, 
          baseY, 
          isTop, 
          verticalOffset: offset,
          groupIndex: i, // 传递索引用于标签避让
        );
      }
    });
  }

  void _drawSingleRoundedSteppedLine(
    Canvas canvas,
    InteractionUIResult result,
    List<double> centers,
    double baseY,
    bool isTop, 
    {double verticalOffset = 0, int groupIndex = 0}
  ) {
    if (result.pillarIndices.length < 2) return;

    final List<double> xCoords = result.pillarIndices
        .where((idx) => idx >= 0 && idx < centers.length)
        .map((idx) => centers[idx])
        .toSet()
        .toList()
      ..sort();
    
    if (xCoords.length < 2) return;

    final startX = xCoords.first;
    final endX = xCoords.last;
    final spanIndices = (result.pillarIndices.reduce(math.max) - result.pillarIndices.reduce(math.min)).abs();
    
    // 阶梯高度
    final double levelHeight = 6.0.hs + (spanIndices * 12.0.hs) + verticalOffset;
    final double zenithY = isTop ? (baseY - levelHeight) : (baseY + levelHeight);

    final isRelevant = selectedPillarIdx == null || result.pillarIndices.contains(selectedPillarIdx);
    
    // 动态透明度逻辑
    double lineOpacity = 0.7;
    if (selectedPillarIdx != null) {
      lineOpacity = isRelevant ? 1.0 : 0.05;
    } else {
      lineOpacity = 0.25; // 默认淡化
    }

    final color = _getInteractionColor(result.type);
    final paint = Paint()
      ..color = color.withOpacity(lineOpacity) 
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = isRelevant ? 1.2.ws : 0.8.ws;

    final radius = 6.0.ws;

    for (var x in xCoords) {
      final path = Path();
      path.moveTo(x, baseY);
      path.lineTo(x, zenithY + (isTop ? radius : -radius));
      path.quadraticBezierTo(x, zenithY, x + (x == startX ? radius : -radius), zenithY);
      canvas.drawPath(path, paint);
    }
    
    canvas.drawLine(Offset(startX + radius, zenithY), Offset(endX - radius, zenithY), paint);

    // 只有在聚焦模式下（或全量模式下显示日元相关？）显示文字
    // 这里简单处理：只有选中且相关时，或者全量显示时较淡的文字
    if (isRelevant && (selectedPillarIdx != null)) {
      double xFraction = 0.5;
      if (groupIndex == 1) xFraction = 0.3;
      if (groupIndex == 2) xFraction = 0.7;
      if (groupIndex >= 3) xFraction = 0.2 + (groupIndex % 4) * 0.15;

      final labelX = startX + (endX - startX) * xFraction;
      _drawLabel(canvas, result, Offset(labelX, zenithY), color, opacity: lineOpacity);
    }
  }

  void _drawLabel(Canvas canvas, InteractionUIResult result, Offset offset, Color color, {double opacity = 1.0}) {
    final text = result.type.display;
    final textStyle = TextStyle(
      fontSize: 8.5.ts, // 缩小字号
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final rect = Rect.fromCenter(
      center: offset,
      width: textPainter.width + 6.ws,
      height: textPainter.height + 2.hs,
    );
    
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(3.ws));
    canvas.drawRRect(rrect, Paint()..color = color.withOpacity(0.9));
    
    textPainter.paint(canvas, offset - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  Color _getInteractionColor(BaziInteraction type) {
    switch (type) {
      case BaziInteraction.stemCombination:
      case BaziInteraction.branchCombination:
      case BaziInteraction.branchTripleCombination:
      case BaziInteraction.branchHalfCombination:
      case BaziInteraction.branchArchingCombination:
      case BaziInteraction.branchTripleDirection:
        return const Color(0xFF4CAF50); // 翠绿
      case BaziInteraction.stemClash:
      case BaziInteraction.branchClash:
      case BaziInteraction.branchPunishment:
      case BaziInteraction.branchTriplePunishment:
      case BaziInteraction.branchSelfPunishment:
        return const Color(0xFFFF5252); // 亮红 (冲)
      case BaziInteraction.branchHarm:
      case BaziInteraction.branchDestruction:
        return Colors.orangeAccent; // 橙色
      default:
        return Colors.blueGrey;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 扩展方便显示
extension BaziInteractionExt on BaziInteraction {
  String get display {
    switch (this) {
      case BaziInteraction.stemCombination: return '合';
      case BaziInteraction.stemClash: return '冲';
      case BaziInteraction.stemRestraint: return '克';
      case BaziInteraction.branchCombination: return '合';
      case BaziInteraction.branchTripleCombination: return '三合';
      case BaziInteraction.branchHalfCombination: return '半合';
      case BaziInteraction.branchArchingCombination: return '拱合';
      case BaziInteraction.branchTripleDirection: return '三会';
      case BaziInteraction.branchClash: return '冲';
      case BaziInteraction.branchPunishment: return '刑';
      case BaziInteraction.branchTriplePunishment: return '三刑';
      case BaziInteraction.branchSelfPunishment: return '自刑';
      case BaziInteraction.branchHarm: return '害';
      case BaziInteraction.branchDestruction: return '破';
      case BaziInteraction.branchHiddenCombination: return '暗合';
      case BaziInteraction.branchSeverance: return '绝';
    }
  }
}
