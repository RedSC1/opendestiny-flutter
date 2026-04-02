import 'package:flutter/material.dart';

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
/// 使用宽高比判断：
/// - 高/宽 > 1.3：手机竖屏
/// - 宽/高 > 1.6：手机横屏或桌面横屏（需结合宽度）
/// - 其他：平板
class DeviceDetector {
  /// 根据宽高比和屏幕尺寸判断设备类型
  static DeviceType detect(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final aspectRatio = width / height;

    // 明显竖屏（手机）
    if (height > width * 1.3) {
      return DeviceType.mobile;
    }

    // 明显横屏
    if (width > height * 1.5) {
      // 横屏时按宽度判断是手机还是桌面
      if (width < 900) {
        return DeviceType.mobile; // 手机横屏
      }
      return DeviceType.desktop; // 桌面横屏
    }

    // 接近正方形（折叠屏、平板竖屏等）
    // 按最短边判断
    final shortestSide = width < height ? width : height;
    if (shortestSide < 600) {
      return DeviceType.mobile;
    } else if (shortestSide < 1000) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// 是否是手机（包括横屏手机）
  static bool isMobile(BuildContext context) {
    return detect(context) == DeviceType.mobile;
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
