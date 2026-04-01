import 'dart:convert';
import 'package:bazi_core/bazi_core.dart';
import '../models/destiny_profile.dart';
import 'l10n.dart';

class BaziAiExporter {
  static String exportToAiJson({
    required BaziChart chart,
    required DestinyCase destinyCase,
    required AppSettings settings,
    required FortuneTable fortuneTable,
  }) {
    final birthInput = destinyCase.birthInput;

    final result = <String, dynamic>{
      'schema_version': 'bazi_ai_v2',
      'input': {
        'calendar_type': birthInput.calendarType.name,
        'solar_input': _solarInput(birthInput.solar),
        'lunar_input': _lunarInput(birthInput.lunar),
        'location': {
          'longitude': birthInput.longitude,
          'latitude': birthInput.latitude,
        },
        'timezone': birthInput.timeZone,
        'gender': _gender(chart.gender),
      },
      'calc_settings': {
        'use_true_solar_time': settings.useTrueSolarTime,
        'rat_hour_mode': settings.ratHourMode.name,
        'si_ling_version': settings.baziOptions.siLingVersion.name,
        'da_yun_algorithm': settings.baziOptions.daYunAlgorithm.name,
        'earth_palace_algorithm': settings.baziOptions.earthPalaceAlgorithm.name,
      },
      'natal_chart': {
        'year_pillar': _pillar(chart.bazi.year),
        'month_pillar': _pillar(chart.bazi.month),
        'day_pillar': _pillar(chart.bazi.day),
        'hour_pillar': _pillar(chart.bazi.time),
        'day_master': _gan(chart.bazi.day.gan),
      },
      'extra_pillars': {
        'ming_gong': _ganZhi(chart.mingGong),
        'shen_gong': _ganZhi(chart.shenGong),
        'tai_yuan': _ganZhi(chart.taiYuan),
        'tai_xi': _ganZhi(chart.taiXi),
        if (chart.siLing != null) 'si_ling': _siLing(chart.siLing!),
      },
      'fortune': {
        'qi_yun': _qiYun(fortuneTable.fortune.qiYunDt),
        'direction': fortuneTable.fortune.direction == 1 ? 'forward' : 'backward',
        'decades': fortuneTable.decades
            .where((decade) => decade.index > 0)
            .take(12)
            .map(_decade)
            .toList(),
      },
    };

    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(result);
  }

  static Map<String, dynamic> _solarInput(SolarBirthInput solar) {
    return {
      'year': solar.year,
      'month': solar.month,
      'day': solar.day,
      'hour': solar.hour,
      'minute': solar.minute,
      'second': solar.second,
    };
  }

  static Map<String, dynamic> _lunarInput(LunarBirthInput lunar) {
    return {
      'year': lunar.year,
      'month': lunar.month,
      'day': lunar.day,
      'hour': lunar.hour,
      'minute': lunar.minute,
      'second': lunar.second,
      'is_leap': lunar.isLeap,
    };
  }

  static Map<String, dynamic> _pillar(GanZhi pillar) {
    return {
      'display': pillar.display,
      'gan': _gan(pillar.gan),
      'zhi': _zhi(pillar.zhi),
      'na_yin': _naYin(pillar.naYin),
    };
  }

  static Map<String, dynamic> _ganZhi(GanZhi value) {
    return {
      'display': value.display,
      'gan': _gan(value.gan),
      'zhi': _zhi(value.zhi),
    };
  }

  static Map<String, dynamic> _siLing(SiLingResult value) {
    return {
      'display': _siLingDisplay(value),
      'gan': _gan(value.gan),
      'origin': value.origin.tr,
      'days_since_jie': value.daysSinceJie,
      'month_zhi': _zhi(value.monthZhi),
    };
  }

  static Map<String, dynamic> _qiYun(QiYunDt value) {
    return {
      'display': _qiYunDisplay(value),
      'year': value.year,
      'month': value.month,
      'day': value.day,
      'hour': value.hour,
      'minute': value.minute,
      'second': value.second,
    };
  }

  static Map<String, dynamic> _decade(FlowDecade value) {
    return {
      'index': value.index,
      'pillar': _pillar(value.ganZhi),
      'start_age': value.startAge,
      'end_age': value.endAge,
      'start_time': value.startTime.toString(),
      'end_time': value.endTime.toString(),
    };
  }

  static Map<String, String> _naYin(String value) {
    return {
      'code': value,
      'label': value.tr,
    };
  }

  static String _siLingDisplay(SiLingResult value) {
    final days = value.daysSinceJie.toStringAsFixed(2);
    if (AppL10nSettings.currentLanguage == AppLanguage.en) {
      return '${value.origin.tr}(${value.gan.display}) [${'距节'.tr} $days ${'天'.tr}]';
    }
    return '${value.origin.tr}(${value.gan.display}) [${'距节'.tr}$days${'天'.tr}]';
  }

  static String _qiYunDisplay(QiYunDt value) {
    if (AppL10nSettings.currentLanguage == AppLanguage.en) {
      return 'After birth ${value.year} years ${value.month} months ${value.day} days ${value.hour} hours ${value.minute} minutes ${value.second} seconds, luck cycle begins';
    }
    return '出生后 ${value.year}年 ${value.month}个月 ${value.day}天 ${value.hour}小时 ${value.minute}分钟 ${value.second}秒 交运';
  }

  static Map<String, String> _gan(TianGan gan) {
    return {
      'code': gan.name,
      'label': gan.display,
    };
  }

  static Map<String, String> _zhi(DiZhi zhi) {
    return {
      'code': zhi.name,
      'label': zhi.display,
    };
  }

  static String _gender(Gender gender) {
    return gender == Gender.male ? 'male' : 'female';
  }
}
