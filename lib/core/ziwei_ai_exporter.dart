import 'dart:convert';
import 'package:ziwei_core/ziwei_core.dart';
import 'l10n.dart';
import 'ziwei_l10n.dart';

class ZiweiAiExporter {
  static String exportToAiJson(ZiWeiPlate plate, {String? brightnessMode}) {
    final palaces = <Map<String, dynamic>>[];

    for (int i = 0; i < 12; i++) {
      final palace = plate.palaces[i];
      final role = plate.getRole(ZiweiScope.origin, i);
      final palaceJson = <String, dynamic>{
        'palace': role.display,
        'branch': palace.branch.display,
        'stem': palace.stem?.display ?? '',
      };

      _putStars(
        palaceJson,
        'main_stars',
        _formatStars(palace.stars[StarType.major], palace, plate),
      );
      _putStars(palaceJson, 'assistant_stars', [
        ..._formatStars(palace.stars[StarType.lucky], palace, plate),
        ..._formatStars(palace.stars[StarType.bad], palace, plate),
      ]);
      _putStars(
        palaceJson,
        'minor_stars',
        _formatStars(palace.stars[StarType.minor], palace, plate),
      );
      _putStars(
        palaceJson,
        'misc_stars',
        _formatStars(palace.stars[StarType.other], palace, plate),
      );
      _putStars(
        palaceJson,
        'changsheng_12',
        _formatStars(palace.stars[StarType.changsheng12], palace, plate),
      );
      _putStars(
        palaceJson,
        'boshi_12',
        _formatStars(palace.stars[StarType.boshi12], palace, plate),
      );
      _putStars(
        palaceJson,
        'jiangqian_12',
        _formatStars(palace.stars[StarType.jiangqian12], palace, plate),
      );
      _putStars(
        palaceJson,
        'suijian_12',
        _formatStars(palace.stars[StarType.suijian12], palace, plate),
      );
      _putStars(
        palaceJson,
        'flow_stars',
        _formatStars(palace.stars[StarType.flow], palace, plate),
      );

      palaces.add(palaceJson);
    }

    final result = <String, dynamic>{
      'schema_version': 'ziwei_ai_v3',
      'plate_summary': {
        'five_element_bureau': plate.elementBureau.label.tr,
        'ming_master': plate.mingZhu?.nodeDisplay ?? '无'.tr,
        'shen_master': plate.shenZhu?.nodeDisplay ?? '无'.tr,
      },
      'calc_settings': {
        'tdr_pan': plate.tdrPan.name,
        'brightness_mode': brightnessMode ?? _brightnessMode(plate),
        'brightness_labels': {
          for (final entry in plate.ruleset.brightnessLabels.entries)
            entry.key.toString(): entry.value,
        },
        'brightness_label_display_map': {
          for (final entry in plate.ruleset.brightnessLabels.entries)
            entry.value: formatBrightness(entry.value),
        },
      },
      'palaces': palaces,
    };

    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(result);
  }

  static void _putStars(
    Map<String, dynamic> target,
    String key,
    List<String> stars,
  ) {
    if (stars.isNotEmpty) {
      target[key] = stars;
    }
  }

  static List<String> _formatStars(
    List<Star>? stars,
    Palace palace,
    ZiWeiPlate plate,
  ) {
    if (stars == null || stars.isEmpty) {
      return const [];
    }
    return stars.map((star) => _formatStar(star, palace, plate)).toList();
  }

  static String _formatStar(Star star, Palace palace, ZiWeiPlate plate) {
    var text = star.display;
    final brightness = _brightness(star, palace, plate);
    if (brightness.isNotEmpty) {
      text += '($brightness)';
    }

    if (star is StaticStar) {
      final originSiHua = star.siHuaBuff[ZiweiScope.origin];
      if (originSiHua != null) {
        text += '[化${_siHua(originSiHua)}]';
      }
      if (star.selfSiHua != null) {
        text += '[自化${_siHua(star.selfSiHua!)}]';
      }
      if (star.centripetalSiHua != null) {
        text += '[向心${_siHua(star.centripetalSiHua!)}]';
      }
    }

    return text;
  }

  static String _brightness(Star star, Palace palace, ZiWeiPlate plate) {
    int index = -1;
    if (star is StaticStar) {
      index = star.getBrightness(palace.branch);
    } else if (star is FlowStar) {
      index = star.getBrightness(palace.branch);
    }
    if (index == -1) {
      return '';
    }

    final key = plate.ruleset.brightnessLabels[index];
    if (key == null || key == 'level_none') {
      return '';
    }
    return formatBrightness(key);
  }

  static String _brightnessMode(ZiWeiPlate plate) {
    final keys = plate.ruleset.brightnessLabels.keys.toList()..sort();
    final values = [
      for (final key in keys) plate.ruleset.brightnessLabels[key],
    ];
    const builtinKeys = [-1, 0, 1, 2, 3, 4, 5, 6];
    const builtinValues = [
      'level_none',
      'level_xian',
      'level_bu',
      'level_ping',
      'level_li',
      'level_de',
      'level_wang',
      'level_miao',
    ];
    if (keys.length == builtinKeys.length) {
      var matched = true;
      for (int i = 0; i < builtinKeys.length; i++) {
        if (keys[i] != builtinKeys[i] || values[i] != builtinValues[i]) {
          matched = false;
          break;
        }
      }
      if (matched) {
        return 'builtin';
      }
    }
    return 'custom';
  }

  static String _siHua(SiHuaType type) {
    switch (type) {
      case SiHuaType.lu:
        return '禄';
      case SiHuaType.quan:
        return '权';
      case SiHuaType.ke:
        return '科';
      case SiHuaType.ji:
        return '忌';
    }
  }
}
