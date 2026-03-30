import 'package:bazi_core/bazi_core.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';

enum AppLanguage { zhCN, zhTW, en }

class AppL10nSettings {
  static AppLanguage currentLanguage = AppLanguage.zhCN;
}

/// 1. 针对动态数据的翻译 (干支、十神)
extension BaziL10n on dynamic {
  String get display {
    final lang = AppL10nSettings.currentLanguage;
    try {
      if (this is TianGan) return _tianGanMap[lang]?[this] ?? (this as TianGan).name;
      if (this is DiZhi) return _diZhiMap[lang]?[this] ?? (this as DiZhi).name;
      if (this is ShiShen) return _shiShenMap[lang]?[this] ?? (this as ShiShen).name;
      if (this is TwelveLifeStage) return _lifeStageMap[lang]?[this] ?? (this as TwelveLifeStage).name;
    } catch (e) {
      return toString();
    }
    return toString();
  }

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
    AppLanguage.zhTW: { ShiShen.biJian: '比肩', ShiShen.jieCai: '劫財', ShiShen.shiShen: '食神', ShiShen.shangGuan: '傷官', ShiShen.pianCai: '偏財', ShiShen.zhengCai: '正財', ShiShen.qiSha: '七殺', ShiShen.zhengGuan: '正官', ShiShen.pianYin: '偏印', ShiShen.zhengYin: '正印' },
    AppLanguage.en: { ShiShen.biJian: 'Friend', ShiShen.jieCai: 'Robber', ShiShen.shiShen: 'Eating', ShiShen.shangGuan: 'Hurting', ShiShen.pianCai: 'I-Wealth', ShiShen.zhengCai: 'D-Wealth', ShiShen.qiSha: '7-Kills', ShiShen.zhengGuan: 'Officer', ShiShen.pianYin: 'I-Resource', ShiShen.zhengYin: 'D-Resource' },
  };

  static const _lifeStageMap = {
    AppLanguage.zhCN: { TwelveLifeStage.zhangSheng: '长生', TwelveLifeStage.muYu: '沐浴', TwelveLifeStage.guanDai: '冠带', TwelveLifeStage.linGuan: '临官', TwelveLifeStage.diWang: '帝旺', TwelveLifeStage.shuai: '衰', TwelveLifeStage.bing: '病', TwelveLifeStage.si: '死', TwelveLifeStage.mu: '墓', TwelveLifeStage.jue: '绝', TwelveLifeStage.tai: '胎', TwelveLifeStage.yang: '养' },
    AppLanguage.zhTW: { TwelveLifeStage.zhangSheng: '長生', TwelveLifeStage.muYu: '沐浴', TwelveLifeStage.guanDai: '冠帶', TwelveLifeStage.linGuan: '臨官', TwelveLifeStage.diWang: '帝旺', TwelveLifeStage.shuai: '衰', TwelveLifeStage.bing: '病', TwelveLifeStage.si: '死', TwelveLifeStage.mu: '墓', TwelveLifeStage.jue: '絕', TwelveLifeStage.tai: '胎', TwelveLifeStage.yang: '養' },
    AppLanguage.en: { TwelveLifeStage.zhangSheng: 'Birth', TwelveLifeStage.muYu: 'Bath', TwelveLifeStage.guanDai: 'Youth', TwelveLifeStage.linGuan: 'Prosperity', TwelveLifeStage.diWang: 'Peak', TwelveLifeStage.shuai: 'Weak', TwelveLifeStage.bing: 'Sickness', TwelveLifeStage.si: 'Death', TwelveLifeStage.mu: 'Grave', TwelveLifeStage.jue: 'Vanished', TwelveLifeStage.tai: 'Embryo', TwelveLifeStage.yang: 'Nourish' },
  };
}

/// 2. 针对静态 UI 字符串的翻译
extension StringL10n on String {
  String get tr {
    final lang = AppL10nSettings.currentLanguage;
    if (lang == AppLanguage.zhCN) return this;
    return _uiMap[this]?[lang] ?? this;
  }

  static const _uiMap = {
    // 导航与基础
    '资料': { AppLanguage.en: 'Profile', AppLanguage.zhTW: '資料' },
    '八字': { AppLanguage.en: 'Bazi', AppLanguage.zhTW: '八字' },
    '个人资料': { AppLanguage.en: 'Profile', AppLanguage.zhTW: '個人資料' },
    '八字排盘': { AppLanguage.en: 'Bazi Chart', AppLanguage.zhTW: '八字排盤' },
    '设置': { AppLanguage.en: 'Settings', AppLanguage.zhTW: '設置' },
    '乾造': { AppLanguage.en: 'Male', AppLanguage.zhTW: '乾造' },
    '坤造': { AppLanguage.en: 'Female', AppLanguage.zhTW: '坤造' },
    
    // 资料页
    '出生信息录入': { AppLanguage.en: 'Birth Information', AppLanguage.zhTW: '出生信息錄入' },
    '出生日期与时间': { AppLanguage.en: 'Date & Time', AppLanguage.zhTW: '出生日期與時間' },
    '性别': { AppLanguage.en: 'Gender', AppLanguage.zhTW: '性別' },
    '乾 (男)': { AppLanguage.en: 'Male', AppLanguage.zhTW: '乾 (男)' },
    '坤 (女)': { AppLanguage.en: 'Female', AppLanguage.zhTW: '坤 (女)' },
    '出生地点': { AppLanguage.en: 'Birth Location', AppLanguage.zhTW: '出生地點' },
    '经度': { AppLanguage.en: 'Longitude', AppLanguage.zhTW: '經度' },
    '北京': { AppLanguage.en: 'Beijing', AppLanguage.zhTW: '北京' },
    '日期格式': { AppLanguage.en: 'MMM dd, yyyy HH:mm', AppLanguage.zhTW: 'yyyy年MM月dd日 HH:mm' },

    // 设置主页
    '界面显示 (Language)': { AppLanguage.en: 'Language', AppLanguage.zhTW: '界面顯示 (Language)' },
    '全局历法配置': { AppLanguage.en: 'Global Calendar', AppLanguage.zhTW: '全局曆法配置' },
    '真太阳时修正': { AppLanguage.en: 'True Solar Time', AppLanguage.zhTW: '真太陽時修正' },
    '基于地理位置计算平太阳时误差': { AppLanguage.en: 'Calculate deviation based on location', AppLanguage.zhTW: '基於地理位置計算平太陽時誤差' },
    '子时处理策略 (影响全站)': { AppLanguage.en: 'Rat Hour Strategy', AppLanguage.zhTW: '子時處理策略 (影響全站)' },
    '不分早晚子 (传统派)': { AppLanguage.en: 'No Split (Traditional)', AppLanguage.zhTW: '不分早晚子 (傳統派)' },
    '23:00 准时换日': { AppLanguage.en: 'Day change at 23:00', AppLanguage.zhTW: '23:00 準時換日' },
    '晚子算当天 + 明天天干 (主流)': { AppLanguage.en: 'Late Rat belongs to Today (Next Stem)', AppLanguage.zhTW: '晚子算當天 + 明天天干 (主流)' },
    '00:00 换日，23:00-00:00 借用明天天干': { AppLanguage.en: 'Day change at 00:00, 23:00-00:00 uses next day\'s stem', AppLanguage.zhTW: '00:00 換日，23:00-00:00 借用明天天干' },
    '晚子算当天 + 今天天干 (古法)': { AppLanguage.en: 'Late Rat belongs to Today (Current Stem)', AppLanguage.zhTW: '晚子算當天 + 今天天干 (古法)' },
    '00:00 换日，23:00-00:00 使用今天天干': { AppLanguage.en: 'Day change at 00:00, 23:00-00:00 uses today\'s stem', AppLanguage.zhTW: '00:00 換日，23:00-00:00 使用今天天干' },
    '八字流派设置': { AppLanguage.en: 'Bazi Settings', AppLanguage.zhTW: '八字流派設置' },
    '起运算法、司令分野、土同宫等': { AppLanguage.en: 'DaYun, SiLing, Earth Palace, etc.', AppLanguage.zhTW: '起運算法、司令分野、土同宮等' },
    '紫微流派设置': { AppLanguage.en: 'Ziwei Settings', AppLanguage.zhTW: '紫微流派設置' },
    '闰月处理、起例基准等': { AppLanguage.en: 'Leap months, standards, etc.', AppLanguage.zhTW: '閏月處理、起例基準等' },

    // 八字二级设置页 (全补齐)
    '八字流派与算法设置': { AppLanguage.en: 'Bazi Advanced Settings', AppLanguage.zhTW: '八字流派與算法設置' },
    '起运算法': { AppLanguage.en: 'Luck Start Algorithm', AppLanguage.zhTW: '起運算法' },
    '精准 120 倍等比推算法': { AppLanguage.en: 'Precise 120x Scaling', AppLanguage.zhTW: '精準 120 倍等比推算法' },
    '按照“三天折一年”原则精准放大 120 倍 (推荐)': { AppLanguage.en: 'Accurate 1:120 ratio projection (Recommended)', AppLanguage.zhTW: '按照“三天折一年”原則精準放大 120 倍 (推薦)' },
    '人元司令分野': { AppLanguage.en: 'Hidden Stem Command', AppLanguage.zhTW: '人元司令分野' },
    '三命通会 (原著版)': { AppLanguage.en: 'San Ming Tong Hui (Original)', AppLanguage.zhTW: '三命通會 (原著版)' },
    '商业流传版': { AppLanguage.en: 'Commercial Version', AppLanguage.zhTW: '商業流傳版' },
    '土同宫算法': { AppLanguage.en: 'Earth Palace Rule', AppLanguage.zhTW: '土同宮算法' },
    '火土同宫': { AppLanguage.en: 'Fire-Earth Same Palace', AppLanguage.zhTW: '火土同宮' },
    '戊随丙，己随丁': { AppLanguage.en: 'Wu follows Bing, Ji follows Ding', AppLanguage.zhTW: '戊隨丙，己隨丁' },
    '水土同宫': { AppLanguage.en: 'Water-Earth Same Palace', AppLanguage.zhTW: '水土同宮' },
    '戊随壬，己随癸': { AppLanguage.en: 'Wu follows Ren, Ji follows Gui', AppLanguage.zhTW: '戊隨壬，己隨癸' },

    // 排盘页标签
    '年柱': { AppLanguage.en: 'Year', AppLanguage.zhTW: '年柱' },
    '月柱': { AppLanguage.en: 'Month', AppLanguage.zhTW: '月柱' },
    '日柱': { AppLanguage.en: 'Day', AppLanguage.zhTW: '日柱' },
    '时柱': { AppLanguage.en: 'Hour', AppLanguage.zhTW: '時柱' },
    '日主': { AppLanguage.en: 'Master', AppLanguage.zhTW: '日主' },
    '大运': { AppLanguage.en: 'Decade', AppLanguage.zhTW: '大運' },
    '流年': { AppLanguage.en: 'Year', AppLanguage.zhTW: '流年' },
    '流月': { AppLanguage.en: 'Month', AppLanguage.zhTW: '流月' },
    '流日': { AppLanguage.en: 'Day', AppLanguage.zhTW: '流日' },
    '流时': { AppLanguage.en: 'Hour', AppLanguage.zhTW: '流時' },
    '大运列表': { AppLanguage.en: 'Decades', AppLanguage.zhTW: '大運列表' },
    '流年轨迹': { AppLanguage.en: 'Annual Flow', AppLanguage.zhTW: '流年軌跡' },
    '流月轨迹': { AppLanguage.en: 'Monthly Flow', AppLanguage.zhTW: '流月軌跡' },
    '流日轨迹': { AppLanguage.en: 'Daily Flow', AppLanguage.zhTW: '流日軌跡' },
    '流时轨迹': { AppLanguage.en: 'Hourly Flow', AppLanguage.zhTW: '流時軌跡' },
    '胎元': { AppLanguage.en: 'TaiYuan', AppLanguage.zhTW: '胎元' },
    '命宫': { AppLanguage.en: 'MingGong', AppLanguage.zhTW: '命宮' },
    '身宫': { AppLanguage.en: 'ShenGong', AppLanguage.zhTW: '身宮' },
    '胎息': { AppLanguage.en: 'TaiXi', AppLanguage.zhTW: '胎息' },
    '公历': { AppLanguage.en: 'Solar', AppLanguage.zhTW: '公曆' },
    '农历': { AppLanguage.en: 'Lunar', AppLanguage.zhTW: '農曆' },
    '虚岁': { AppLanguage.en: 'yo', AppLanguage.zhTW: '虛歲' },
    '今': { AppLanguage.en: 'Now', AppLanguage.zhTW: '今' },
    '大运流年': { AppLanguage.en: 'Luck', AppLanguage.zhTW: '大運流年' },
    '胎命身': { AppLanguage.en: 'TMS', AppLanguage.zhTW: '胎命身' },
    '时辰': { AppLanguage.en: 'Hour', AppLanguage.zhTW: '時辰' },
    '星运': { AppLanguage.en: 'Star Luck', AppLanguage.zhTW: '星運' },
    '自坐': { AppLanguage.en: 'Self Stage', AppLanguage.zhTW: '自坐' },
    '空亡': { AppLanguage.en: 'Void', AppLanguage.zhTW: '空亡' },
    '纳音': { AppLanguage.en: 'Melody', AppLanguage.zhTW: '納音' },
    '空': { AppLanguage.en: 'Void', AppLanguage.zhTW: '空' },

    // 纳音 30 组 (紧凑版英文翻译)
    '海中金': { AppLanguage.en: 'Sea Gold', AppLanguage.zhTW: '海中金' },
    '炉中火': { AppLanguage.en: 'Furnace Fire', AppLanguage.zhTW: '爐中火' },
    '大林木': { AppLanguage.en: 'Great Forest Wood', AppLanguage.zhTW: '大林木' },
    '路旁土': { AppLanguage.en: 'Roadside Earth', AppLanguage.zhTW: '路旁土' },
    '剑锋金': { AppLanguage.en: 'Sword Gold', AppLanguage.zhTW: '劍鋒金' },
    '山头火': { AppLanguage.en: 'Hilltop Fire', AppLanguage.zhTW: '山頭火' },
    '涧下水': { AppLanguage.en: 'Stream Water', AppLanguage.zhTW: '澗下水' },
    '城头土': { AppLanguage.en: 'City Wall Earth', AppLanguage.zhTW: '城頭土' },
    '白蜡金': { AppLanguage.en: 'White Wax Gold', AppLanguage.zhTW: '白蠟金' },
    '杨柳木': { AppLanguage.en: 'Willow Wood', AppLanguage.zhTW: '楊柳木' },
    '泉中水': { AppLanguage.en: 'Spring Water', AppLanguage.zhTW: '泉中水' },
    '屋上土': { AppLanguage.en: 'Rooftop Earth', AppLanguage.zhTW: '屋上土' },
    '霹雳火': { AppLanguage.en: 'Thunder Fire', AppLanguage.zhTW: '霹靂火' },
    '松柏木': { AppLanguage.en: 'Pine Cypress Wood', AppLanguage.zhTW: '松柏木' },
    '长流水': { AppLanguage.en: 'Long River Water', AppLanguage.zhTW: '長流水' },
    '沙中金': { AppLanguage.en: 'Sand Gold', AppLanguage.zhTW: '沙中金' },
    '山下火': { AppLanguage.en: 'Under Hill Fire', AppLanguage.zhTW: '山下火' },
    '平地木': { AppLanguage.en: 'Plains Wood', AppLanguage.zhTW: '平地木' },
    '壁上土': { AppLanguage.en: 'Wall Earth', AppLanguage.zhTW: '壁上土' },
    '金箔金': { AppLanguage.en: 'Gold Foil', AppLanguage.zhTW: '金箔金' },
    '覆灯火': { AppLanguage.en: 'Lamp Fire', AppLanguage.zhTW: '覆燈火' },
    '天河水': { AppLanguage.en: 'Heavenly River Water', AppLanguage.zhTW: '天河水' },
    '大驿土': { AppLanguage.en: 'Highway Earth', AppLanguage.zhTW: '大驛土' },
    '钗钏金': { AppLanguage.en: 'Bracelet Gold', AppLanguage.zhTW: '釵釧金' },
    '桑柘木': { AppLanguage.en: 'Mulberry Wood', AppLanguage.zhTW: '桑柘木' },
    '大溪水': { AppLanguage.en: 'Brook Water', AppLanguage.zhTW: '大溪水' },
    '沙中土': { AppLanguage.en: 'Sand Earth', AppLanguage.zhTW: '沙中土' },
    '天上火': { AppLanguage.en: 'Heavenly Fire', AppLanguage.zhTW: '天上火' },
    '石榴木': { AppLanguage.en: 'Pomegranate Wood', AppLanguage.zhTW: '石榴木' },
    '大海水': { AppLanguage.en: 'Ocean Water', AppLanguage.zhTW: '大海水' },
  };
}

extension GanZhiL10n on GanZhi {
  String get display => '${gan.display}${zhi.display}';
}
