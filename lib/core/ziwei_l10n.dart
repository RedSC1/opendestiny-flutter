import 'package:ziwei_core/ziwei_core.dart';
import 'l10n.dart';

/// 紫微专属国际化辅助外挂
/// 负责处理星曜、宫位、四化、干支、农历日期显示
extension ZiweiNodeL10n on String {
  /// 强制当天干转换
  String get ganDisplay {
    final lower = toLowerCase();
    for (final tg in TianGan.values) {
      if (tg.name.toLowerCase() == lower) return tg.display;
    }
    return this;
  }

  /// 强制当地支转换
  String get zhiDisplay {
    final lower = toLowerCase();
    for (final dz in DiZhi.values) {
      if (dz.name.toLowerCase() == lower) return dz.display;
    }
    return this;
  }

  /// 处理星曜 Key 转换 (解决命主/身主等拼音显示问题)
  /// 注意：不再处理干支拼音转换，以防“戊”与“午”重名冲突
  String get nodeDisplay {
    if (isEmpty) return "";

    final lang = AppL10nSettings.currentLanguage;
    final k = startsWith('star_') ? substring(5) : this;
    final translation =
        _starTranslation[k]?[lang] ?? _starTranslation[k]?[AppLanguage.zhCN];
    if (translation != null) return translation;

    return tr;
  }
}

extension ZiweiIntL10n on int {
  String get lunarDay {
    final lang = AppL10nSettings.currentLanguage;
    if (lang == AppLanguage.en) {
      return 'Day $this';
    }
    if (this <= 0 || this > 30) return toString();

    // 简繁体通用的农历日期
    if (this == 10) return '初十';
    if (this == 20) return '二十';
    if (this == 30) return '三十';
    const units = ['', '一', '二', '三', '四', '五', '六', '七', '八', '九'];
    if (this < 10) return '初${units[this]}';
    if (this < 20) return '十${units[this % 10]}';
    if (this < 30) return '廿${units[this % 10]}';
    return toString();
  }

  String get lunarMonth {
    final lang = AppL10nSettings.currentLanguage;
    if (lang == AppLanguage.en) return 'Month $this';
    if (this <= 0 || this > 12) return toString();

    const months = [
      '',
      '正',
      '二',
      '三',
      '四',
      '五',
      '六',
      '七',
      '八',
      '九',
      '十',
      '十一',
      '十二',
    ];
    final suffix = '月'; // 简繁一致
    return '${months[this]}$suffix';
  }

  String get hourName {
    if (this < 0 || this >= 12) return toString();
    final dz = DiZhi.values[this];
    final lang = AppL10nSettings.currentLanguage;

    // 关键修正：繁体用 '時'，简体用 '时'，英文用 ' Hour'
    late String suffix;
    if (lang == AppLanguage.en) {
      suffix = ' Hour';
    } else if (lang == AppLanguage.zhTW) {
      suffix = '時';
    } else {
      suffix = '时';
    }

    return '${dz.display}$suffix';
  }
}

/// --- 核心星曜与属性翻译映射 ---

extension StarL10n on Star {
  String get display {
    final lang = AppL10nSettings.currentLanguage;
    final k = key.startsWith('star_') ? key.substring(5) : key;

    // 优先匹配星曜特有映射 (包括带后缀的十二神)
    final translation =
        _starTranslation[k]?[lang] ?? _starTranslation[k]?[AppLanguage.zhCN];
    if (translation != null) return translation;

    // 处理流星前缀 (如 flow_year_lucun -> 年禄)
    if (k.contains('flow_')) {
      return _handleFlowStar(k, lang);
    }

    return translation ?? k;
  }

  String _handleFlowStar(String k, AppLanguage lang) {
    final parts = k.split('_');
    if (parts.length < 3) return k;
    final type = parts[parts.length - 3]; // decade, year, month...
    final target = parts[parts.length - 1]; // lucun, tiankui...

    final prefixMap = {
      'decade': {AppLanguage.zhCN: '大', AppLanguage.zhTW: '大'},
      'year': {AppLanguage.zhCN: '年', AppLanguage.zhTW: '年'},
      'month': {AppLanguage.zhCN: '月', AppLanguage.zhTW: '月'},
      'day': {AppLanguage.zhCN: '日', AppLanguage.zhTW: '日'},
      'hour': {AppLanguage.zhCN: '时', AppLanguage.zhTW: '时'},
    };

    final p =
        prefixMap[type]?[lang] ?? prefixMap[type]?[AppLanguage.zhCN] ?? '';
    final base =
        _starTranslation[target]?[lang] ??
        _starTranslation[target]?[AppLanguage.zhCN] ??
        target;

    String shortBase = base;
    if (base.length >= 2) {
      if (base == '天魁')
        shortBase = '魁';
      else if (base == '天钺')
        shortBase = '钺';
      else if (base == '文昌')
        shortBase = '昌';
      else if (base == '文曲')
        shortBase = '曲';
      else if (base == '禄存')
        shortBase = '禄';
      else if (base == '擎羊')
        shortBase = '羊';
      else if (base == '陀罗')
        shortBase = '陀';
      else if (base == '红鸾')
        shortBase = '鸾';
      else if (base == '天喜')
        shortBase = '喜';
      else if (base == '天马')
        shortBase = '马';
    }

    return '$p$shortBase';
  }
}

extension PalaceRoleL10n on PalaceRole {
  String get display {
    final lang = AppL10nSettings.currentLanguage;
    return _palaceTranslation[this]?[lang] ??
        _palaceTranslation[this]?[AppLanguage.zhCN] ??
        name;
  }
}

extension SiHuaTypeL10n on SiHuaType {
  String get display {
    final lang = AppL10nSettings.currentLanguage;
    return _sihuaTranslation[this]?[lang] ??
        _sihuaTranslation[this]?[AppLanguage.zhCN] ??
        name;
  }
}

String formatBrightness(String key) {
  final lang = AppL10nSettings.currentLanguage;
  return _brightnessTranslation[key]?[lang] ??
      _brightnessTranslation[key]?[AppLanguage.zhCN] ??
      '';
}

// --- 全量映射数据库 ---

const _starTranslation = {
  // 14 主星
  'ziwei': {AppLanguage.zhCN: '紫微', AppLanguage.zhTW: '紫微'},
  'tianji': {AppLanguage.zhCN: '天机', AppLanguage.zhTW: '天機'},
  'taiyang': {AppLanguage.zhCN: '太阳', AppLanguage.zhTW: '太陽'},
  'wuqu': {AppLanguage.zhCN: '武曲', AppLanguage.zhTW: '武曲'},
  'tiantong': {AppLanguage.zhCN: '天同', AppLanguage.zhTW: '天同'},
  'lianzhen': {AppLanguage.zhCN: '廉贞', AppLanguage.zhTW: '廉貞'},
  'tianfu': {AppLanguage.zhCN: '天府', AppLanguage.zhTW: '天府'},
  'taiyin': {AppLanguage.zhCN: '太阴', AppLanguage.zhTW: '太陰'},
  'tanlang': {AppLanguage.zhCN: '贪狼', AppLanguage.zhTW: '貪狼'},
  'jumen': {AppLanguage.zhCN: '巨门', AppLanguage.zhTW: '巨門'},
  'tianxiang': {AppLanguage.zhCN: '天相', AppLanguage.zhTW: '天相'},
  'tianliang': {AppLanguage.zhCN: '天梁', AppLanguage.zhTW: '天梁'},
  'qisha': {AppLanguage.zhCN: '七杀', AppLanguage.zhTW: '七殺'},
  'pojun': {AppLanguage.zhCN: '破军', AppLanguage.zhTW: '破軍'},
  // 六吉
  'zuofu': {AppLanguage.zhCN: '左辅', AppLanguage.zhTW: '左輔'},
  'youbi': {AppLanguage.zhCN: '右弼', AppLanguage.zhTW: '右弼'},
  'wenchang': {AppLanguage.zhCN: '文昌', AppLanguage.zhTW: '文昌'},
  'wenqu': {AppLanguage.zhCN: '文曲', AppLanguage.zhTW: '文曲'},
  'tiankui': {AppLanguage.zhCN: '天魁', AppLanguage.zhTW: '天魁'},
  'tianyue': {AppLanguage.zhCN: '天钺', AppLanguage.zhTW: '天鉞'},
  'lucun': {AppLanguage.zhCN: '禄存', AppLanguage.zhTW: '祿存'},
  'tianma': {AppLanguage.zhCN: '天马', AppLanguage.zhTW: '天馬'},
  // 六煞
  'qingyang': {AppLanguage.zhCN: '擎羊', AppLanguage.zhTW: '擎羊'},
  'tuoluo': {AppLanguage.zhCN: '陀罗', AppLanguage.zhTW: '陀羅'},
  'huoxing': {AppLanguage.zhCN: '火星', AppLanguage.zhTW: '火星'},
  'lingxing': {AppLanguage.zhCN: '铃星', AppLanguage.zhTW: '鈴星'},
  'dikong': {AppLanguage.zhCN: '地空', AppLanguage.zhTW: '地空'},
  'dijie': {AppLanguage.zhCN: '地劫', AppLanguage.zhTW: '地劫'},
  // 乙级星 & 杂曜 (已写全)
  'hongluan': {AppLanguage.zhCN: '红鸾', AppLanguage.zhTW: '紅鸞'},
  'tianxi': {AppLanguage.zhCN: '天喜', AppLanguage.zhTW: '天喜'},
  'tianyao': {AppLanguage.zhCN: '天姚', AppLanguage.zhTW: '天姚'},
  'tianxing': {AppLanguage.zhCN: '天刑', AppLanguage.zhTW: '天刑'},
  'xianchi': {AppLanguage.zhCN: '咸池', AppLanguage.zhTW: '咸池'},
  'santai': {AppLanguage.zhCN: '三台', AppLanguage.zhTW: '三台'},
  'bazuo': {AppLanguage.zhCN: '八座', AppLanguage.zhTW: '八座'},
  'enguang': {AppLanguage.zhCN: '恩光', AppLanguage.zhTW: '恩光'},
  'tiangui': {AppLanguage.zhCN: '天贵', AppLanguage.zhTW: '天貴'},
  'taifu': {AppLanguage.zhCN: '台辅', AppLanguage.zhTW: '台輔'},
  'fenggao': {AppLanguage.zhCN: '封诰', AppLanguage.zhTW: '封誥'},
  'tiancai': {AppLanguage.zhCN: '天才', AppLanguage.zhTW: '天才'},
  'tianshou': {AppLanguage.zhCN: '天寿', AppLanguage.zhTW: '天壽'},
  'guchen': {AppLanguage.zhCN: '孤辰', AppLanguage.zhTW: '孤辰'},
  'guasu': {AppLanguage.zhCN: '寡宿', AppLanguage.zhTW: '寡宿'},
  'longchi': {AppLanguage.zhCN: '龙池', AppLanguage.zhTW: '龍池'},
  'fengge': {AppLanguage.zhCN: '凤阁', AppLanguage.zhTW: '鳳閣'},
  'xunkong': {AppLanguage.zhCN: '旬空', AppLanguage.zhTW: '旬空'},
  'fuxun': {AppLanguage.zhCN: '副旬', AppLanguage.zhTW: '副旬'},
  'jiekong': {AppLanguage.zhCN: '截空', AppLanguage.zhTW: '截空'},
  'fujie': {AppLanguage.zhCN: '副截', AppLanguage.zhTW: '副截'},
  'tiankong': {AppLanguage.zhCN: '天空', AppLanguage.zhTW: '天空'},
  'tianshang': {AppLanguage.zhCN: '天伤', AppLanguage.zhTW: '天傷'},
  'tianshi': {AppLanguage.zhCN: '天使', AppLanguage.zhTW: '天使'},
  'tianku': {AppLanguage.zhCN: '天哭', AppLanguage.zhTW: '天哭'},
  'tianxu': {AppLanguage.zhCN: '天虚', AppLanguage.zhTW: '天虛'},
  'tianguan': {AppLanguage.zhCN: '天官', AppLanguage.zhTW: '天官'},
  'tianfu_minor': {AppLanguage.zhCN: '天福', AppLanguage.zhTW: '天福'},
  'yinsha': {AppLanguage.zhCN: '阴煞', AppLanguage.zhTW: '陰煞'},
  'tianwu': {AppLanguage.zhCN: '天巫', AppLanguage.zhTW: '天巫'},
  'tianyue_minor': {AppLanguage.zhCN: '天月', AppLanguage.zhTW: '天月'},
  'posui': {AppLanguage.zhCN: '破碎', AppLanguage.zhTW: '破碎'},
  'feilian': {AppLanguage.zhCN: '蜚廉', AppLanguage.zhTW: '蜚廉'},
  'tianchu': {AppLanguage.zhCN: '天厨', AppLanguage.zhTW: '天廚'},
  'jieshen': {AppLanguage.zhCN: '解神', AppLanguage.zhTW: '解神'},
  'nianjie': {AppLanguage.zhCN: '年解', AppLanguage.zhTW: '年解'},
  'tiande': {AppLanguage.zhCN: '天德', AppLanguage.zhTW: '天德'},
  'yuede': {AppLanguage.zhCN: '月德', AppLanguage.zhTW: '月德'},
  'dahao': {AppLanguage.zhCN: '大耗', AppLanguage.zhTW: '大耗'},
  // 十二神系列
  'changsheng': {AppLanguage.zhCN: '长生', AppLanguage.zhTW: '長生'},
  'muyu': {AppLanguage.zhCN: '沐浴', AppLanguage.zhTW: '沐浴'},
  'guandai': {AppLanguage.zhCN: '冠带', AppLanguage.zhTW: '冠帶'},
  'linguan': {AppLanguage.zhCN: '临官', AppLanguage.zhTW: '臨官'},
  'diwang': {AppLanguage.zhCN: '帝旺', AppLanguage.zhTW: '帝旺'},
  'shuai': {AppLanguage.zhCN: '衰', AppLanguage.zhTW: '衰'},
  'bing': {AppLanguage.zhCN: '病', AppLanguage.zhTW: '病'},
  'si': {AppLanguage.zhCN: '死', AppLanguage.zhTW: '死'},
  'mu': {AppLanguage.zhCN: '墓', AppLanguage.zhTW: '墓'},
  'jue': {AppLanguage.zhCN: '绝', AppLanguage.zhTW: '絕'},
  'tai': {AppLanguage.zhCN: '胎', AppLanguage.zhTW: '胎'},
  'yang': {AppLanguage.zhCN: '养', AppLanguage.zhTW: '養'},
  // 博士十二神
  'boshi_boshi12': {AppLanguage.zhCN: '博士', AppLanguage.zhTW: '博士'},
  'lishi_boshi12': {AppLanguage.zhCN: '力士', AppLanguage.zhTW: '力士'},
  'qinglong_boshi12': {AppLanguage.zhCN: '青龙', AppLanguage.zhTW: '青龍'},
  'xiaohao_boshi12': {AppLanguage.zhCN: '小耗', AppLanguage.zhTW: '小耗'},
  'jiangjun_boshi12': {AppLanguage.zhCN: '将军', AppLanguage.zhTW: '將軍'},
  'zoushu_boshi12': {AppLanguage.zhCN: '奏书', AppLanguage.zhTW: '奏書'},
  'feilian_boshi12': {AppLanguage.zhCN: '飞廉', AppLanguage.zhTW: '飛廉'},
  'xishen_boshi12': {AppLanguage.zhCN: '喜神', AppLanguage.zhTW: '喜神'},
  'bingfu_boshi12': {AppLanguage.zhCN: '病符', AppLanguage.zhTW: '病符'},
  'dahao_boshi12': {AppLanguage.zhCN: '大耗', AppLanguage.zhTW: '大耗'},
  'fubing_boshi12': {AppLanguage.zhCN: '伏兵', AppLanguage.zhTW: '伏兵'},
  'guanfu_boshi12': {AppLanguage.zhCN: '官府', AppLanguage.zhTW: '官府'},
  // 将前十二神
  'jiangxing_jiangqian12': {AppLanguage.zhCN: '将星', AppLanguage.zhTW: '將星'},
  'panan_jiangqian12': {AppLanguage.zhCN: '攀鞍', AppLanguage.zhTW: '攀鞍'},
  'suiyi_jiangqian12': {AppLanguage.zhCN: '岁驿', AppLanguage.zhTW: '歲驛'},
  'xishen_jiangqian12': {AppLanguage.zhCN: '息神', AppLanguage.zhTW: '息神'},
  'huagai_jiangqian12': {AppLanguage.zhCN: '华盖', AppLanguage.zhTW: '華蓋'},
  'jiesha_jiangqian12': {AppLanguage.zhCN: '劫煞', AppLanguage.zhTW: '劫煞'},
  'zaisha_jiangqian12': {AppLanguage.zhCN: '灾煞', AppLanguage.zhTW: '災煞'},
  'tiansha_jiangqian12': {AppLanguage.zhCN: '天煞', AppLanguage.zhTW: '天煞'},
  'zhibei_jiangqian12': {AppLanguage.zhCN: '指背', AppLanguage.zhTW: '指背'},
  'xianchi_jiangqian12': {AppLanguage.zhCN: '咸池', AppLanguage.zhTW: '咸池'},
  'yuesha_jiangqian12': {AppLanguage.zhCN: '月煞', AppLanguage.zhTW: '月煞'},
  'wangshen_jiangqian12': {AppLanguage.zhCN: '亡神', AppLanguage.zhTW: '亡神'},
  // 岁建十二神
  'suijian_suijian12': {AppLanguage.zhCN: '岁建', AppLanguage.zhTW: '歲建'},
  'huiqi_suijian12': {AppLanguage.zhCN: '晦气', AppLanguage.zhTW: '晦氣'},
  'sangmen_suijian12': {AppLanguage.zhCN: '丧门', AppLanguage.zhTW: '喪門'},
  'guansuo_suijian12': {AppLanguage.zhCN: '贯索', AppLanguage.zhTW: '貫索'},
  'guanfu_suijian12': {AppLanguage.zhCN: '官符', AppLanguage.zhTW: '官符'},
  'xiaohao_suijian12': {AppLanguage.zhCN: '小耗', AppLanguage.zhTW: '小耗'},
  'suipo_suijian12': {AppLanguage.zhCN: '岁破', AppLanguage.zhTW: '歲破'},
  'longde_suijian12': {AppLanguage.zhCN: '龙德', AppLanguage.zhTW: '龍德'},
  'baihu_suijian12': {AppLanguage.zhCN: '白虎', AppLanguage.zhTW: '白虎'},
  'tiande_suijian12': {AppLanguage.zhCN: '天德', AppLanguage.zhTW: '天德'},
  'diaoke_suijian12': {AppLanguage.zhCN: '吊客', AppLanguage.zhTW: '吊客'},
  'bingfu_suijian12': {AppLanguage.zhCN: '病符', AppLanguage.zhTW: '病符'},
};

const _palaceTranslation = {
  PalaceRole.life: {AppLanguage.zhCN: '命宫', AppLanguage.zhTW: '命宮'},
  PalaceRole.siblings: {AppLanguage.zhCN: '兄弟', AppLanguage.zhTW: '兄弟'},
  PalaceRole.spouse: {AppLanguage.zhCN: '夫妻', AppLanguage.zhTW: '夫妻'},
  PalaceRole.children: {AppLanguage.zhCN: '子女', AppLanguage.zhTW: '子女'},
  PalaceRole.wealth: {AppLanguage.zhCN: '财帛', AppLanguage.zhTW: '財帛'},
  PalaceRole.health: {AppLanguage.zhCN: '疾厄', AppLanguage.zhTW: '疾厄'},
  PalaceRole.travel: {AppLanguage.zhCN: '迁移', AppLanguage.zhTW: '遷移'},
  PalaceRole.friends: {AppLanguage.zhCN: '交友', AppLanguage.zhTW: '交友'},
  PalaceRole.career: {AppLanguage.zhCN: '官禄', AppLanguage.zhTW: '官祿'},
  PalaceRole.property: {AppLanguage.zhCN: '田宅', AppLanguage.zhTW: '田宅'},
  PalaceRole.mental: {AppLanguage.zhCN: '福德', AppLanguage.zhTW: '福德'},
  PalaceRole.parents: {AppLanguage.zhCN: '父母', AppLanguage.zhTW: '父母'},
};

const _sihuaTranslation = {
  SiHuaType.lu: {AppLanguage.zhCN: '禄', AppLanguage.zhTW: '祿'},
  SiHuaType.quan: {AppLanguage.zhCN: '权', AppLanguage.zhTW: '權'},
  SiHuaType.ke: {AppLanguage.zhCN: '科', AppLanguage.zhTW: '科'},
  SiHuaType.ji: {AppLanguage.zhCN: '忌', AppLanguage.zhTW: '忌'},
};

const _brightnessTranslation = {
  'level_miao': {AppLanguage.zhCN: '庙', AppLanguage.zhTW: '廟'},
  'level_wang': {AppLanguage.zhCN: '旺', AppLanguage.zhTW: '旺'},
  'level_de': {AppLanguage.zhCN: '得', AppLanguage.zhTW: '得'},
  'level_li': {AppLanguage.zhCN: '利', AppLanguage.zhTW: '利'},
  'level_ping': {AppLanguage.zhCN: '平', AppLanguage.zhTW: '平'},
  'level_bu': {AppLanguage.zhCN: '不', AppLanguage.zhTW: '不'},
  'level_xian': {AppLanguage.zhCN: '陷', AppLanguage.zhTW: '陷'},
  'level_none': {AppLanguage.zhCN: '', AppLanguage.zhTW: ''},
};
