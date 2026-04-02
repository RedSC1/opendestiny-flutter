import 'package:flutter/material.dart';
import 'device_type.dart';

/// UI 自适应缩放工具
///
/// 只在手机端生效，平板/桌面保持原样
/// 以 360px 宽度（1080×2400 手机）为基准
/// 用法：fontSize: 10.ts 或 width: 8.ws
class UIScale {
  static double _scaleFactor = 1.0;
  static double _screenWidth = 360.0;

  /// 基准宽度（你的模拟器）
  static const double _baseWidth = 360.0;

  /// 初始化（在 build 中调用）
  static void init(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;

    // 根据屏幕宽度缩放，不管设备类型
    // 小屏手机缩小，大屏手机放大，平板/桌面按实际宽度
    _scaleFactor = (_screenWidth / _baseWidth).clamp(0.85, 1.3);
  }

  /// 获取缩放因子
  static double get scale => _scaleFactor;

  /// 屏幕宽度
  static double get width => _screenWidth;
}

/// 扩展方法，方便使用
extension UIScaleExtension on num {
  /// 文字缩放
  double get ts => this * UIScale.scale;
  /// 宽度缩放
  double get ws => this * UIScale.scale;
  /// 高度缩放
  double get hs => this * UIScale.scale;
}
