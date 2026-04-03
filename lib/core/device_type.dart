import 'package:flutter/material.dart';

/// 布局等级
enum LayoutClass {
  /// 手机竖屏
  mobilePortrait,

  /// 手机横屏
  mobileLandscape,

  /// 平板 / 折叠屏展开态 / 中等宽度窗口
  tablet,

  /// 桌面 / Web 宽屏窗口
  desktop,
}

/// 设备类型枚举
enum DeviceType {
  /// 手机（竖屏或横屏手机）
  mobile,

  /// 平板（iPad、Android Tablet 等）
  tablet,

  /// 桌面（Web 大屏、Windows、Mac、Linux）
  desktop,
}

/// 设备类型检测工具
///
/// 主判断使用最短边与宽度，方向只用于区分手机横竖屏。
class DeviceDetector {
  static LayoutClass detectLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final shortestSide = size.shortestSide;
    final isLandscape = width > height;

    if (shortestSide < 600) {
      return isLandscape
          ? LayoutClass.mobileLandscape
          : LayoutClass.mobilePortrait;
    }

    if (width >= 1100) {
      return LayoutClass.desktop;
    }

    return LayoutClass.tablet;
  }

  /// 根据布局等级映射到设备类型
  static DeviceType detect(BuildContext context) {
    switch (detectLayout(context)) {
      case LayoutClass.mobilePortrait:
      case LayoutClass.mobileLandscape:
        return DeviceType.mobile;
      case LayoutClass.tablet:
        return DeviceType.tablet;
      case LayoutClass.desktop:
        return DeviceType.desktop;
    }
  }

  /// 是否是手机（包括横屏手机）
  static bool isMobile(BuildContext context) {
    return detect(context) == DeviceType.mobile;
  }

  /// 是否是手机横屏
  static bool isMobileLandscape(BuildContext context) {
    return detectLayout(context) == LayoutClass.mobileLandscape;
  }

  /// 是否是手机竖屏
  static bool isMobilePortrait(BuildContext context) {
    return detectLayout(context) == LayoutClass.mobilePortrait;
  }

  /// 是否是平板
  static bool isTablet(BuildContext context) {
    return detect(context) == DeviceType.tablet;
  }

  /// 是否是桌面
  static bool isDesktop(BuildContext context) {
    return detect(context) == DeviceType.desktop;
  }
}
