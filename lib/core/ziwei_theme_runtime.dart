import '../models/ziwei_color_palette.dart';

class ZiweiThemeRuntime {
  static ZiweiColorMode colorMode = ZiweiColorMode.classic;
  static ZiweiColorPalette customPalette = const ZiweiColorPalette();

  static ZiweiColorPalette get activePalette =>
      colorMode == ZiweiColorMode.custom
      ? customPalette
      : const ZiweiColorPalette();

  static void update({
    required ZiweiColorMode mode,
    required ZiweiColorPalette palette,
  }) {
    colorMode = mode;
    customPalette = palette;
  }
}
