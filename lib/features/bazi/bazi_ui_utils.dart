import 'package:flutter/material.dart';
import 'package:bazi_core/bazi_core.dart';

class BaziUIUtils {
  static Color getWuXingColor(WuXing wx) {
    switch (wx) {
      case WuXing.wood: return const Color(0xFF2E7D32);
      case WuXing.fire: return const Color(0xFFC62828);
      case WuXing.earth: return const Color(0xFF8D6E63);
      case WuXing.metal: return const Color(0xFFFBC02D);
      case WuXing.water: return const Color(0xFF1565C0);
    }
  }
}
