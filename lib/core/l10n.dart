import 'package:bazi_core/bazi_core.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';

/// 1. 定义支持的语言
enum AppLanguage { zhCN, zhTW, en }

/// 2. 全局语言管理器 (简易版)
class AppL10nSettings {
  static AppLanguage currentLanguage = AppLanguage.zhCN;
}

/// 3. 万能翻译扩展
extension BaziL10n on dynamic {
  String get display {
    final lang = AppL10nSettings.currentLanguage;
    
    if (this is TianGan) return _tianGanMap[lang]?[this] ?? (this as TianGan).name;
    if (this is DiZhi) return _diZhiMap[lang]?[this] ?? (this as DiZhi).name;
    if (this is ShiShen) return _shiShenMap[lang]?[this] ?? (this as ShiShen).name;
    if (this is TwelveLifeStage) return _lifeStageMap[lang]?[this] ?? (this as TwelveLifeStage).name;
    
    return toString();
  }

  // --- 翻译字典库 ---

  static const _tianGanMap = {
    AppLanguage.zhCN: { TianGan.jia: '甲', TianGan.yi: '乙', TianGan.bing: '丙', TianGan.ding: '丁', TianGan.wu: '戊', TianGan.ji: '己', TianGan.geng: '庚', TianGan.xin: '辛', TianGan.ren: '壬', TianGan.gui: '癸' },
    AppLanguage.zhTW: { TianGan.jia: '甲', TianGan.yi: '乙', TianGan.bing: '丙', TianGan.ding: '丁', TianGan.wu: '戊', TianGan.ji: '己', TianGan.geng: '庚', TianGan.xin: '辛', TianGan.ren: '壬', TianGan.gui: '癸' },
    AppLanguage.en: { TianGan.jia: 'Jia', TianGan.yi: 'Yi', TianGan.bing: 'Bing', TianGan.ding: 'Ding', TianGan.wu: 'Wu', TianGan.ji: 'Ji', TianGan.geng: 'Geng', TianGan.xin: 'Xin', TianGan.ren: 'Ren', TianGan.gui: 'Gui' },
  };

  static const _diZhiMap = {
    AppLanguage.zhCN: { DiZhi.zi: '子', DiZhi.chou: '丑', DiZhi.yin: '寅', DiZhi.mao: '卯', DiZhi.chen: '辰', DiZhi.si: '巳', DiZhi.wu: '午', DiZhi.wei: '未', DiZhi.shen: '申', DiZhi.you: '酉', DiZhi.xu: '戌', DiZhi.hai: '亥' },
    AppLanguage.zhTW: { DiZhi.zi: '子', DiZhi.chou: '丑', DiZhi.yin: '寅', DiZhi.mao: '卯', DiZhi.chen: '辰', DiZhi.si: '巳', DiZhi.wu: '午', DiZhi.wei: '未', DiZhi.shen: '申', DiZhi.you: '酉', DiZhi.xu: '戌', DiZhi.hai: '亥' },
    AppLanguage.en: { DiZhi.zi: 'Zi', DiZhi.chou: 'Chou', DiZhi.yin: 'Yin', DiZhi.mao: 'Mao', DiZhi.chen: 'Chen', DiZhi.si: 'Si', DiZhi.wu: 'Wu', DiZhi.wei: 'Wei', DiZhi.shen: 'Shen', DiZhi.you: 'You', DiZhi.xu: 'Xu', DiZhi.hai: 'Hai' },
  };

  static const _shiShenMap = {
    AppLanguage.zhCN: { ShiShen.biJian: '比肩', ShiShen.jieCai: '劫财', ShiShen.shiShen: '食神', ShiShen.shangGuan: '伤官', ShiShen.pianCai: '偏财', ShiShen.zhengCai: '正财', ShiShen.qiSha: '七杀', ShiShen.zhengGuan: '正官', ShiShen.pianYin: '偏印', ShiShen.zhengYin: '正印' },
    AppLanguage.zhTW: { ShiShen.biJian: '比肩', ShiShen.jieCai: '劫财', ShiShen.shiShen: '食神', ShiShen.shangGuan: '伤官', ShiShen.pianCai: '偏财', ShiShen.zhengCai: '正财', ShiShen.qiSha: '七杀', ShiShen.zhengGuan: '正官', ShiShen.pianYin: '偏印', ShiShen.zhengYin: '正印' },
    AppLanguage.en: { ShiShen.biJian: 'Friend', ShiShen.jieCai: 'Robber', ShiShen.shiShen: 'Eating', ShiShen.shangGuan: 'Hurting', ShiShen.pianCai: 'Indirect Wealth', ShiShen.zhengCai: 'Direct Wealth', ShiShen.qiSha: 'Seven Killings', ShiShen.zhengGuan: 'Direct Officer', ShiShen.pianYin: 'Indirect Resource', ShiShen.zhengYin: 'Direct Resource' },
  };

  static const _lifeStageMap = {
    AppLanguage.zhCN: { TwelveLifeStage.zhangSheng: '长生', TwelveLifeStage.muYu: '沐浴', TwelveLifeStage.guanDai: '冠带', TwelveLifeStage.linGuan: '临官', TwelveLifeStage.diWang: '帝旺', TwelveLifeStage.shuai: '衰', TwelveLifeStage.bing: '病', TwelveLifeStage.si: '死', TwelveLifeStage.mu: '墓', TwelveLifeStage.jue: '绝', TwelveLifeStage.tai: '胎', TwelveLifeStage.yang: '养' },
    AppLanguage.en: { TwelveLifeStage.zhangSheng: 'Birth', TwelveLifeStage.muYu: 'Bath', TwelveLifeStage.guanDai: 'Youth', TwelveLifeStage.linGuan: 'Prosperity', TwelveLifeStage.diWang: 'Peak', TwelveLifeStage.shuai: 'Weak', TwelveLifeStage.bing: 'Sickness', TwelveLifeStage.si: 'Death', TwelveLifeStage.mu: 'Grave', TwelveLifeStage.jue: 'Vanished', TwelveLifeStage.tai: 'Embryo', TwelveLifeStage.yang: 'Nourish' },
  };
}

// 针对 GanZhi 对象的便捷翻译
extension GanZhiL10n on GanZhi {
  String get display => '${gan.display}${zhi.display}';
}
