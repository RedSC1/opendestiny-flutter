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
      if (this is TianGan)
        return _tianGanMap[lang]?[this] ?? (this as TianGan).name;
      if (this is DiZhi) return _diZhiMap[lang]?[this] ?? (this as DiZhi).name;
      if (this is ShiShen)
        return _shiShenMap[lang]?[this] ?? (this as ShiShen).name;
      if (this is TwelveLifeStage)
        return _lifeStageMap[lang]?[this] ?? (this as TwelveLifeStage).name;
    } catch (e) {
      return toString();
    }
    return toString();
  }

  static const _tianGanMap = {
    AppLanguage.zhCN: {
      TianGan.jia: '甲',
      TianGan.yi: '乙',
      TianGan.bing: '丙',
      TianGan.ding: '丁',
      TianGan.wu: '戊',
      TianGan.ji: '己',
      TianGan.geng: '庚',
      TianGan.xin: '辛',
      TianGan.ren: '壬',
      TianGan.gui: '癸',
    },
    AppLanguage.zhTW: {
      TianGan.jia: '甲',
      TianGan.yi: '乙',
      TianGan.bing: '丙',
      TianGan.ding: '丁',
      TianGan.wu: '戊',
      TianGan.ji: '己',
      TianGan.geng: '庚',
      TianGan.xin: '辛',
      TianGan.ren: '壬',
      TianGan.gui: '癸',
    },
    AppLanguage.en: {
      TianGan.jia: 'Jia',
      TianGan.yi: 'Yi',
      TianGan.bing: 'Bing',
      TianGan.ding: 'Ding',
      TianGan.wu: 'Wu',
      TianGan.ji: 'Ji',
      TianGan.geng: 'Geng',
      TianGan.xin: 'Xin',
      TianGan.ren: 'Ren',
      TianGan.gui: 'Gui',
    },
  };

  static const _diZhiMap = {
    AppLanguage.zhCN: {
      DiZhi.zi: '子',
      DiZhi.chou: '丑',
      DiZhi.yin: '寅',
      DiZhi.mao: '卯',
      DiZhi.chen: '辰',
      DiZhi.si: '巳',
      DiZhi.wu: '午',
      DiZhi.wei: '未',
      DiZhi.shen: '申',
      DiZhi.you: '酉',
      DiZhi.xu: '戌',
      DiZhi.hai: '亥',
    },
    AppLanguage.zhTW: {
      DiZhi.zi: '子',
      DiZhi.chou: '丑',
      DiZhi.yin: '寅',
      DiZhi.mao: '卯',
      DiZhi.chen: '辰',
      DiZhi.si: '巳',
      DiZhi.wu: '午',
      DiZhi.wei: '未',
      DiZhi.shen: '申',
      DiZhi.you: '酉',
      DiZhi.xu: '戌',
      DiZhi.hai: '亥',
    },
    AppLanguage.en: {
      DiZhi.zi: 'Zi',
      DiZhi.chou: 'Chou',
      DiZhi.yin: 'Yin',
      DiZhi.mao: 'Mao',
      DiZhi.chen: 'Chen',
      DiZhi.si: 'Si',
      DiZhi.wu: 'Wu',
      DiZhi.wei: 'Wei',
      DiZhi.shen: 'Shen',
      DiZhi.you: 'You',
      DiZhi.xu: 'Xu',
      DiZhi.hai: 'Hai',
    },
  };

  static const _shiShenMap = {
    AppLanguage.zhCN: {
      ShiShen.biJian: '比肩',
      ShiShen.jieCai: '劫财',
      ShiShen.shiShen: '食神',
      ShiShen.shangGuan: '伤官',
      ShiShen.pianCai: '偏财',
      ShiShen.zhengCai: '正财',
      ShiShen.qiSha: '七杀',
      ShiShen.zhengGuan: '正官',
      ShiShen.pianYin: '偏印',
      ShiShen.zhengYin: '正印',
    },
    AppLanguage.zhTW: {
      ShiShen.biJian: '比肩',
      ShiShen.jieCai: '劫財',
      ShiShen.shiShen: '食神',
      ShiShen.shangGuan: '傷官',
      ShiShen.pianCai: '偏財',
      ShiShen.zhengCai: '正財',
      ShiShen.qiSha: '七殺',
      ShiShen.zhengGuan: '正官',
      ShiShen.pianYin: '偏印',
      ShiShen.zhengYin: '正印',
    },
    AppLanguage.en: {
      ShiShen.biJian: 'Friend',
      ShiShen.jieCai: 'Robber',
      ShiShen.shiShen: 'Eating',
      ShiShen.shangGuan: 'Hurting',
      ShiShen.pianCai: 'I-Wealth',
      ShiShen.zhengCai: 'D-Wealth',
      ShiShen.qiSha: '7-Kills',
      ShiShen.zhengGuan: 'Officer',
      ShiShen.pianYin: 'I-Resource',
      ShiShen.zhengYin: 'D-Resource',
    },
  };

  static const _lifeStageMap = {
    AppLanguage.zhCN: {
      TwelveLifeStage.zhangSheng: '长生',
      TwelveLifeStage.muYu: '沐浴',
      TwelveLifeStage.guanDai: '冠带',
      TwelveLifeStage.linGuan: '临官',
      TwelveLifeStage.diWang: '帝旺',
      TwelveLifeStage.shuai: '衰',
      TwelveLifeStage.bing: '病',
      TwelveLifeStage.si: '死',
      TwelveLifeStage.mu: '墓',
      TwelveLifeStage.jue: '绝',
      TwelveLifeStage.tai: '胎',
      TwelveLifeStage.yang: '养',
    },
    AppLanguage.zhTW: {
      TwelveLifeStage.zhangSheng: '長生',
      TwelveLifeStage.muYu: '沐浴',
      TwelveLifeStage.guanDai: '冠帶',
      TwelveLifeStage.linGuan: '臨官',
      TwelveLifeStage.diWang: '帝旺',
      TwelveLifeStage.shuai: '衰',
      TwelveLifeStage.bing: '病',
      TwelveLifeStage.si: '死',
      TwelveLifeStage.mu: '墓',
      TwelveLifeStage.jue: '絕',
      TwelveLifeStage.tai: '胎',
      TwelveLifeStage.yang: '養',
    },
    AppLanguage.en: {
      TwelveLifeStage.zhangSheng: 'Birth',
      TwelveLifeStage.muYu: 'Bath',
      TwelveLifeStage.guanDai: 'Youth',
      TwelveLifeStage.linGuan: 'Prosperity',
      TwelveLifeStage.diWang: 'Peak',
      TwelveLifeStage.shuai: 'Weak',
      TwelveLifeStage.bing: 'Sickness',
      TwelveLifeStage.si: 'Death',
      TwelveLifeStage.mu: 'Grave',
      TwelveLifeStage.jue: 'Vanished',
      TwelveLifeStage.tai: 'Embryo',
      TwelveLifeStage.yang: 'Nourish',
    },
  };
}

/// 2. 针对静态 UI 字符串的翻译
extension StringL10n on String {
  String get tr {
    final lang = AppL10nSettings.currentLanguage;
    return _uiMap[this]?[lang] ?? this;
  }

  static const _uiMap = {
    // 导航与基础
    '资料': {AppLanguage.en: 'Profile', AppLanguage.zhTW: '資料'},
    '八字': {AppLanguage.en: 'Bazi', AppLanguage.zhTW: '八字'},
    '个人资料': {AppLanguage.en: 'Profile', AppLanguage.zhTW: '個人資料'},
    '八字排盘': {AppLanguage.en: 'Bazi Chart', AppLanguage.zhTW: '八字排盤'},
    '连线图': {AppLanguage.en: 'Diagram', AppLanguage.zhTW: '連線圖'},
    '设置': {AppLanguage.en: 'Settings', AppLanguage.zhTW: '設置'},
    '乾造': {AppLanguage.en: 'Male', AppLanguage.zhTW: '乾造'},
    '坤造': {AppLanguage.en: 'Female', AppLanguage.zhTW: '坤造'},
    '注：神煞功能暂未进行精确人工校对，结果仅供参考。': {
      AppLanguage.en:
          'Note: Shen Sha results are AI-generated and have not been manually verified. For reference only.',
      AppLanguage.zhTW: '註：神煞功能暫未進行精確人工校對，結果僅供參考。',
      AppLanguage.zhCN: '注：神煞功能暂未进行精确人工校对，结果仅供参考。',
    },

    // 资料页
    '出生信息录入': {AppLanguage.en: 'Birth Information', AppLanguage.zhTW: '出生信息錄入'},
    '出生日期与时间': {AppLanguage.en: 'Date & Time', AppLanguage.zhTW: '出生日期與時間'},
    '性别': {AppLanguage.en: 'Gender', AppLanguage.zhTW: '性別'},
    '乾 (男)': {AppLanguage.en: 'Male', AppLanguage.zhTW: '乾 (男)'},
    '坤 (女)': {AppLanguage.en: 'Female', AppLanguage.zhTW: '坤 (女)'},
    '出生地点': {AppLanguage.en: 'Birth Location', AppLanguage.zhTW: '出生地點'},
    '经度': {AppLanguage.en: 'Longitude', AppLanguage.zhTW: '經度'},
    '北京': {AppLanguage.en: 'Beijing', AppLanguage.zhTW: '北京'},
    '日期格式': {
      AppLanguage.en: 'MMM dd, yyyy HH:mm',
      AppLanguage.zhTW: 'yyyy年MM月dd日 HH:mm',
    },
    '男命': {AppLanguage.zhTW: '男命'},
    '女命': {AppLanguage.zhTW: '女命'},
    '命主': {AppLanguage.zhTW: '命主'},
    '身主': {AppLanguage.zhTW: '身主'},
    '农': {AppLanguage.zhTW: '農'},
    '年': {AppLanguage.zhTW: '年'},
    '闰': {AppLanguage.zhTW: '閏'},

    // 设置主页
    '界面显示 (Language)': {
      AppLanguage.en: 'Language',
      AppLanguage.zhTW: '界面顯示 (Language)',
    },
    '全局历法配置': {AppLanguage.en: 'Global Calendar', AppLanguage.zhTW: '全局曆法配置'},
    '真太阳时修正': {AppLanguage.en: 'True Solar Time', AppLanguage.zhTW: '真太陽時修正'},
    '基于地理位置计算平太阳时误差': {
      AppLanguage.en: 'Calculate deviation based on location',
      AppLanguage.zhTW: '基於地理位置計算平太陽時誤差',
    },
    '子时处理策略 (影响全站)': {
      AppLanguage.en: 'Rat Hour Strategy',
      AppLanguage.zhTW: '子時處理策略 (影響全站)',
    },
    '不分早晚子 (传统派)': {
      AppLanguage.en: 'No Split (Traditional)',
      AppLanguage.zhTW: '不分早晚子 (傳統派)',
    },
    '23:00 准时换日': {
      AppLanguage.en: 'Day change at 23:00',
      AppLanguage.zhTW: '23:00 準時換日',
    },
    '晚子算当天 + 明天天干 (主流)': {
      AppLanguage.en: 'Late Rat belongs to Today (Next Stem)',
      AppLanguage.zhTW: '晚子算當天 + 明天天干 (主流)',
    },
    '00:00 换日，23:00-00:00 借用明天天干': {
      AppLanguage.en: 'Day change at 00:00, 23:00-00:00 uses next day\'s stem',
      AppLanguage.zhTW: '00:00 換日，23:00-00:00 借用明天天干',
    },
    '晚子算当天 + 今天天干 (古法)': {
      AppLanguage.en: 'Late Rat belongs to Today (Current Stem)',
      AppLanguage.zhTW: '晚子算當天 + 今天天干 (古法)',
    },
    '00:00 换日，23:00-00:00 使用今天天干': {
      AppLanguage.en: 'Day change at 00:00, 23:00-00:00 uses today\'s stem',
      AppLanguage.zhTW: '00:00 換日，23:00-00:00 使用今天天干',
    },
    '八字流派设置': {AppLanguage.en: 'Bazi Settings', AppLanguage.zhTW: '八字流派設置'},
    '起运算法、司令分野、土同宫等': {
      AppLanguage.en: 'DaYun, SiLing, Earth Palace, etc.',
      AppLanguage.zhTW: '起運算法、司令分野、土同宮等',
    },
    '紫微流派设置': {AppLanguage.en: 'Ziwei Settings', AppLanguage.zhTW: '紫微流派設置'},
    '闰月处理、起例基准等': {
      AppLanguage.en: 'Leap months, standards, etc.',
      AppLanguage.zhTW: '閏月處理、起例基準等',
    },

    // 八字二级设置页 (全补齐)
    '八字流派与算法设置': {
      AppLanguage.en: 'Bazi Advanced Settings',
      AppLanguage.zhTW: '八字流派與算法設置',
    },
    '起运算法': {AppLanguage.en: 'Luck Start Algorithm', AppLanguage.zhTW: '起運算法'},
    '精准 120 倍等比推算法': {
      AppLanguage.en: 'Precise 120x Scaling',
      AppLanguage.zhTW: '精準 120 倍等比推算法',
    },
    '按照“三天折一年”原则精准放大 120 倍 (推荐)': {
      AppLanguage.en: 'Accurate 1:120 ratio projection (Recommended)',
      AppLanguage.zhTW: '按照“三天折一年”原則精準放大 120 倍 (推薦)',
    },
    '人元司令分野': {
      AppLanguage.en: 'Hidden Stem Command',
      AppLanguage.zhTW: '人元司令分野',
    },
    '三命通会 (原著版)': {
      AppLanguage.en: 'San Ming Tong Hui (Original)',
      AppLanguage.zhTW: '三命通會 (原著版)',
    },
    '商业流传版': {AppLanguage.en: 'Commercial Version', AppLanguage.zhTW: '商業流傳版'},
    '土同宫算法': {AppLanguage.en: 'Earth Palace Rule', AppLanguage.zhTW: '土同宮算法'},
    '火土同宫': {
      AppLanguage.en: 'Fire-Earth Same Palace',
      AppLanguage.zhTW: '火土同宮',
    },
    '戊随丙，己随丁': {
      AppLanguage.en: 'Wu follows Bing, Ji follows Ding',
      AppLanguage.zhTW: '戊隨丙，己隨丁',
    },
    '水土同宫': {
      AppLanguage.en: 'Water-Earth Same Palace',
      AppLanguage.zhTW: '水土同宮',
    },
    '戊随壬，己随癸': {
      AppLanguage.en: 'Wu follows Ren, Ji follows Gui',
      AppLanguage.zhTW: '戊隨壬，己隨癸',
    },

    // 排盘页标签
    '年柱': {AppLanguage.en: 'Year', AppLanguage.zhTW: '年柱'},
    '月柱': {AppLanguage.en: 'Month', AppLanguage.zhTW: '月柱'},
    '日柱': {AppLanguage.en: 'Day', AppLanguage.zhTW: '日柱'},
    '时柱': {AppLanguage.en: 'Hour', AppLanguage.zhTW: '時柱'},
    '日主': {AppLanguage.en: 'Master', AppLanguage.zhTW: '日主'},
    '大运': {AppLanguage.en: 'Decade', AppLanguage.zhTW: '大運'},
    '流年': {AppLanguage.en: 'Year', AppLanguage.zhTW: '流年'},
    '流月': {AppLanguage.en: 'Month', AppLanguage.zhTW: '流月'},
    '流日': {AppLanguage.en: 'Day', AppLanguage.zhTW: '流日'},
    '流时': {AppLanguage.en: 'Hour', AppLanguage.zhTW: '流時'},
    '大运列表': {AppLanguage.en: 'Decades', AppLanguage.zhTW: '大運列表'},
    '大限': {AppLanguage.en: 'Decade', AppLanguage.zhTW: '大限'},
    '小限': {AppLanguage.en: 'Small Limit', AppLanguage.zhTW: '小限'},
    '回到本命盘': {AppLanguage.en: 'Reset to Origin', AppLanguage.zhTW: '回到本命盤'},
    '流年轨迹': {AppLanguage.en: 'Annual Flow', AppLanguage.zhTW: '流年軌跡'},
    '流月轨迹': {AppLanguage.en: 'Monthly Flow', AppLanguage.zhTW: '流月軌跡'},
    '流日轨迹': {AppLanguage.en: 'Daily Flow', AppLanguage.zhTW: '流日軌跡'},
    '流时轨迹': {AppLanguage.en: 'Hourly Flow', AppLanguage.zhTW: '流時軌跡'},
    '胎元': {AppLanguage.en: 'TaiYuan', AppLanguage.zhTW: '胎元'},
    '命宫': {AppLanguage.en: 'MingGong', AppLanguage.zhTW: '命宮'},
    '身宫': {AppLanguage.en: 'ShenGong', AppLanguage.zhTW: '身宮'},
    '胎息': {AppLanguage.en: 'TaiXi', AppLanguage.zhTW: '胎息'},
    '公历': {AppLanguage.en: 'Solar', AppLanguage.zhTW: '公曆'},
    '农历': {AppLanguage.en: 'Lunar', AppLanguage.zhTW: '農曆'},
    '虚岁': {AppLanguage.en: 'yo', AppLanguage.zhTW: '虛歲'},
    '今': {AppLanguage.en: 'Now', AppLanguage.zhTW: '今'},
    '大运流年': {AppLanguage.en: 'Luck', AppLanguage.zhTW: '大運流年'},
    '胎命身': {AppLanguage.en: 'TMS', AppLanguage.zhTW: '胎命身'},
    '时辰': {AppLanguage.en: 'Hour', AppLanguage.zhTW: '時辰'},
    '星运': {AppLanguage.en: 'Star Luck', AppLanguage.zhTW: '星運'},
    '自坐': {AppLanguage.en: 'Self Stage', AppLanguage.zhTW: '自坐'},
    '纳音': {AppLanguage.en: 'Melody', AppLanguage.zhTW: '納音'},
    '空': {AppLanguage.en: 'Void', AppLanguage.zhTW: '空'},
    '小运': {AppLanguage.en: 'Minor', AppLanguage.zhTW: '小運'},
    '流年小运': {AppLanguage.en: 'Annual Minor', AppLanguage.zhTW: '流年小運'},
    '起运前': {AppLanguage.en: 'Pre-Luck', AppLanguage.zhTW: '起運前'},

    // 纳音 30 组 (紧凑版英文翻译)
    '海中金': {AppLanguage.en: 'Sea Gold', AppLanguage.zhTW: '海中金'},
    '炉中火': {AppLanguage.en: 'Furnace Fire', AppLanguage.zhTW: '爐中火'},
    '大林木': {AppLanguage.en: 'Great Forest Wood', AppLanguage.zhTW: '大林木'},
    '路旁土': {AppLanguage.en: 'Roadside Earth', AppLanguage.zhTW: '路旁土'},
    '剑锋金': {AppLanguage.en: 'Sword Gold', AppLanguage.zhTW: '劍鋒金'},
    '山头火': {AppLanguage.en: 'Hilltop Fire', AppLanguage.zhTW: '山頭火'},
    '涧下水': {AppLanguage.en: 'Stream Water', AppLanguage.zhTW: '澗下水'},
    '城头土': {AppLanguage.en: 'City Wall Earth', AppLanguage.zhTW: '城頭土'},
    '白蜡金': {AppLanguage.en: 'White Wax Gold', AppLanguage.zhTW: '白蠟金'},
    '杨柳木': {AppLanguage.en: 'Willow Wood', AppLanguage.zhTW: '楊柳木'},
    '泉中水': {AppLanguage.en: 'Spring Water', AppLanguage.zhTW: '泉中水'},
    '屋上土': {AppLanguage.en: 'Rooftop Earth', AppLanguage.zhTW: '屋上土'},
    '霹雳火': {AppLanguage.en: 'Thunder Fire', AppLanguage.zhTW: '霹靂火'},
    '松柏木': {AppLanguage.en: 'Pine Cypress Wood', AppLanguage.zhTW: '松柏木'},
    '长流水': {AppLanguage.en: 'Long River Water', AppLanguage.zhTW: '長流水'},
    '沙中金': {AppLanguage.en: 'Sand Gold', AppLanguage.zhTW: '沙中金'},
    '山下火': {AppLanguage.en: 'Under Hill Fire', AppLanguage.zhTW: '山下火'},
    '平地木': {AppLanguage.en: 'Plains Wood', AppLanguage.zhTW: '平地木'},
    '壁上土': {AppLanguage.en: 'Wall Earth', AppLanguage.zhTW: '壁上土'},
    '金箔金': {AppLanguage.en: 'Gold Foil', AppLanguage.zhTW: '金箔金'},
    '覆灯火': {AppLanguage.en: 'Lamp Fire', AppLanguage.zhTW: '覆燈火'},
    '天河水': {AppLanguage.en: 'Heavenly River Water', AppLanguage.zhTW: '天河水'},
    '大驿土': {AppLanguage.en: 'Highway Earth', AppLanguage.zhTW: '大驛土'},
    '钗钏金': {AppLanguage.en: 'Bracelet Gold', AppLanguage.zhTW: '釵釧金'},
    '桑柘木': {AppLanguage.en: 'Mulberry Wood', AppLanguage.zhTW: '桑柘木'},
    '大溪水': {AppLanguage.en: 'Brook Water', AppLanguage.zhTW: '大溪水'},
    '沙中土': {AppLanguage.en: 'Sand Earth', AppLanguage.zhTW: '沙中土'},
    '天上火': {AppLanguage.en: 'Heavenly Fire', AppLanguage.zhTW: '天上火'},
    '石榴木': {AppLanguage.en: 'Pomegranate Wood', AppLanguage.zhTW: '石榴木'},
    '大海水': {AppLanguage.en: 'Ocean Water', AppLanguage.zhTW: '大海水'},

    // 24 节气
    '立春': {AppLanguage.en: 'Lichun', AppLanguage.zhTW: '立春'},
    '雨水': {AppLanguage.en: 'Yushui', AppLanguage.zhTW: '雨水'},
    '惊蛰': {AppLanguage.en: 'Jingzhe', AppLanguage.zhTW: '驚蟄'},
    '春分': {AppLanguage.en: 'Chunfen', AppLanguage.zhTW: '春分'},
    '清明': {AppLanguage.en: 'Qingming', AppLanguage.zhTW: '清明'},
    '谷雨': {AppLanguage.en: 'Guyu', AppLanguage.zhTW: '穀雨'},
    '立夏': {AppLanguage.en: 'Lixia', AppLanguage.zhTW: '立夏'},
    '小满': {AppLanguage.en: 'Xiaoman', AppLanguage.zhTW: '小滿'},
    '芒种': {AppLanguage.en: 'Mangzhong', AppLanguage.zhTW: '芒種'},
    '夏至': {AppLanguage.en: 'Xiazhi', AppLanguage.zhTW: '夏至'},
    '小暑': {AppLanguage.en: 'Xiaoshu', AppLanguage.zhTW: '小暑'},
    '大暑': {AppLanguage.en: 'Dashu', AppLanguage.zhTW: '大暑'},
    '立秋': {AppLanguage.en: 'Liqiu', AppLanguage.zhTW: '立秋'},
    '处暑': {AppLanguage.en: 'Chushu', AppLanguage.zhTW: '處暑'},
    '白露': {AppLanguage.en: 'Bailu', AppLanguage.zhTW: '白露'},
    '秋分': {AppLanguage.en: 'Qiufen', AppLanguage.zhTW: '秋分'},
    '寒露': {AppLanguage.en: 'Hanlu', AppLanguage.zhTW: '寒露'},
    '霜降': {AppLanguage.en: 'Shuangjiang', AppLanguage.zhTW: '霜降'},
    '立冬': {AppLanguage.en: 'Lidong', AppLanguage.zhTW: '立冬'},
    '小雪': {AppLanguage.en: 'Xiaoxue', AppLanguage.zhTW: '小雪'},
    '大雪': {AppLanguage.en: 'Daxue', AppLanguage.zhTW: '大雪'},
    '冬至': {AppLanguage.en: 'Dongzhi', AppLanguage.zhTW: '冬至'},
    '小寒': {AppLanguage.en: 'Xiaohan', AppLanguage.zhTW: '小寒'},
    '大寒': {AppLanguage.en: 'Dahan', AppLanguage.zhTW: '大寒'},

    // 月份与日期
    '1月': {AppLanguage.en: 'Jan', AppLanguage.zhTW: '1月'},
    '2月': {AppLanguage.en: 'Feb', AppLanguage.zhTW: '2月'},
    '3月': {AppLanguage.en: 'Mar', AppLanguage.zhTW: '3月'},
    '4月': {AppLanguage.en: 'Apr', AppLanguage.zhTW: '4月'},
    '5月': {AppLanguage.en: 'May', AppLanguage.zhTW: '5月'},
    '6月': {AppLanguage.en: 'Jun', AppLanguage.zhTW: '6月'},
    '7月': {AppLanguage.en: 'Jul', AppLanguage.zhTW: '7月'},
    '8月': {AppLanguage.en: 'Aug', AppLanguage.zhTW: '8月'},
    '9月': {AppLanguage.en: 'Sep', AppLanguage.zhTW: '9月'},
    '10月': {AppLanguage.en: 'Oct', AppLanguage.zhTW: '10月'},
    '11月': {AppLanguage.en: 'Nov', AppLanguage.zhTW: '11月'},
    '12月': {AppLanguage.en: 'Dec', AppLanguage.zhTW: '12月'},
    '月': {AppLanguage.en: 'Month', AppLanguage.zhTW: '月'},
    '日': {AppLanguage.en: 'Day', AppLanguage.zhTW: '日'},
    '岁': {AppLanguage.en: 'yo', AppLanguage.zhTW: '歲'},

    // 神煞 (全量精密对照表 - 确保全量 4 字以内精简显示)
    '天乙贵人': {
      AppLanguage.en: 'Noble',
      AppLanguage.zhTW: '天乙貴人',
      AppLanguage.zhCN: '天乙贵人',
    },
    '驿马': {
      AppLanguage.en: 'Horse',
      AppLanguage.zhTW: '驛馬',
      AppLanguage.zhCN: '驿马',
    },
    '咸池(桃花)': {
      AppLanguage.en: 'PB',
      AppLanguage.zhTW: '咸池',
      AppLanguage.zhCN: '咸池',
    },
    '红鸾': {
      AppLanguage.en: 'R-Phx',
      AppLanguage.zhTW: '紅鸞',
      AppLanguage.zhCN: '红鸾',
    },
    '天喜': {
      AppLanguage.en: 'Sky-H',
      AppLanguage.zhTW: '天喜',
      AppLanguage.zhCN: '天喜',
    },
    '羊刃': {
      AppLanguage.en: 'Blade',
      AppLanguage.zhTW: '羊刃',
      AppLanguage.zhCN: '羊刃',
    },
    '飞刃': {
      AppLanguage.en: 'F-Blade',
      AppLanguage.zhTW: '飛刃',
      AppLanguage.zhCN: '飞刃',
    },
    '福星贵人': {
      AppLanguage.en: 'Lucky-S',
      AppLanguage.zhTW: '福星貴人',
      AppLanguage.zhCN: '福星贵人',
    },
    '灾煞': {
      AppLanguage.en: 'Calamity',
      AppLanguage.zhTW: '災煞',
      AppLanguage.zhCN: '灾煞',
    },
    '劫煞': {
      AppLanguage.en: 'Robbery',
      AppLanguage.zhTW: '劫煞',
      AppLanguage.zhCN: '劫煞',
    },
    '亡神': {
      AppLanguage.en: 'Down-G',
      AppLanguage.zhTW: '亡神',
      AppLanguage.zhCN: '亡神',
    },
    '空亡': {
      AppLanguage.en: 'KongWang',
      AppLanguage.zhTW: '空亡',
      AppLanguage.zhCN: '空亡',
    },
    '天厨贵人(本旬)': {
      AppLanguage.en: 'Food(旬)',
      AppLanguage.zhTW: '天厨(旬)',
      AppLanguage.zhCN: '天厨(旬)',
    },
    '天厨贵人': {
      AppLanguage.en: 'Food-S',
      AppLanguage.zhTW: '天厨貴人',
      AppLanguage.zhCN: '天厨贵人',
    },
    '德秀贵人': {
      AppLanguage.en: 'DeXiu',
      AppLanguage.zhTW: '德秀貴人',
      AppLanguage.zhCN: '德秀贵人',
    },
    '天医': {
      AppLanguage.en: 'Sky-Dr',
      AppLanguage.zhTW: '天醫',
      AppLanguage.zhCN: '天医',
    },
    '血刃': {
      AppLanguage.en: 'B-Blade',
      AppLanguage.zhTW: '血刃',
      AppLanguage.zhCN: '血刃',
    },
    '月德合': {
      AppLanguage.en: 'M-DeHe',
      AppLanguage.zhTW: '月德合',
      AppLanguage.zhCN: '月德合',
    },
    '勾煞': {
      AppLanguage.en: 'Gou',
      AppLanguage.zhTW: '勾煞',
      AppLanguage.zhCN: '勾煞',
    },
    '绞煞': {
      AppLanguage.en: 'Jiao',
      AppLanguage.zhTW: '絞煞',
      AppLanguage.zhCN: '绞煞',
    },
    '元辰': {
      AppLanguage.en: 'YuanC',
      AppLanguage.zhTW: '元辰',
      AppLanguage.zhCN: '元辰',
    },
    '孤辰': {
      AppLanguage.en: 'L-Gua',
      AppLanguage.zhTW: '孤辰',
      AppLanguage.zhCN: '孤辰',
    },
    '寡宿': {
      AppLanguage.en: 'G-Su',
      AppLanguage.zhTW: '寡宿',
      AppLanguage.zhCN: '寡宿',
    },
    '红艳煞': {
      AppLanguage.en: 'Red-Y',
      AppLanguage.zhTW: '紅艷煞',
      AppLanguage.zhCN: '红艳煞',
    },
    '金舆': {
      AppLanguage.en: 'G-Cart',
      AppLanguage.zhTW: '金輿',
      AppLanguage.zhCN: '金舆',
    },
    '金神': {
      AppLanguage.en: 'G-God',
      AppLanguage.zhTW: '金神',
      AppLanguage.zhCN: '金神',
    },
    '天赦日': {
      AppLanguage.en: 'T-She',
      AppLanguage.zhTW: '天赦日',
      AppLanguage.zhCN: '天赦日',
    },
    '流霞': {
      AppLanguage.en: 'LXia',
      AppLanguage.zhTW: '流霞',
      AppLanguage.zhCN: '流霞',
    },
    '丧门': {
      AppLanguage.en: 'SMen',
      AppLanguage.zhTW: '喪門',
      AppLanguage.zhCN: '丧门',
    },
    '吊客': {
      AppLanguage.en: 'DKe',
      AppLanguage.zhTW: '吊客',
      AppLanguage.zhCN: '吊客',
    },
    '披麻': {
      AppLanguage.en: 'PMa',
      AppLanguage.zhTW: '披麻',
      AppLanguage.zhCN: '披麻',
    },
    '童子': {
      AppLanguage.en: 'Tzi',
      AppLanguage.zhTW: '童子',
      AppLanguage.zhCN: '童子',
    },
    '天德合': {
      AppLanguage.en: 'TDe-He',
      AppLanguage.zhTW: '天德合',
      AppLanguage.zhCN: '天德合',
    },
    '三奇贵人(天)': {
      AppLanguage.en: 'S-Qi(T)',
      AppLanguage.zhTW: '天三奇',
      AppLanguage.zhCN: '天三奇',
    },
    '三奇贵人(地)': {
      AppLanguage.en: 'S-Qi(D)',
      AppLanguage.zhTW: '地三奇',
      AppLanguage.zhCN: '地三奇',
    },
    '三奇贵人(人)': {
      AppLanguage.en: 'S-Qi(P)',
      AppLanguage.zhTW: '人三奇',
      AppLanguage.zhCN: '人三奇',
    },
    '将星': {
      AppLanguage.en: 'Gen-S',
      AppLanguage.zhTW: '將星',
      AppLanguage.zhCN: '将星',
    },
    '华盖': {
      AppLanguage.en: 'Canopy',
      AppLanguage.zhTW: '華蓋',
      AppLanguage.zhCN: '华盖',
    },
    '魁罡': {
      AppLanguage.en: 'KuiG',
      AppLanguage.zhTW: '魁罡',
      AppLanguage.zhCN: '魁罡',
    },
    '十灵日': {
      AppLanguage.en: '10S-D',
      AppLanguage.zhTW: '十靈日',
      AppLanguage.zhCN: '十灵日',
    },
    '八专日': {
      AppLanguage.en: '8Z-D',
      AppLanguage.zhTW: '八專日',
      AppLanguage.zhCN: '八专日',
    },
    '六秀日': {
      AppLanguage.en: '6X-D',
      AppLanguage.zhTW: '六秀日',
      AppLanguage.zhCN: '六秀日',
    },
    '九丑日': {
      AppLanguage.en: '9C-D',
      AppLanguage.zhTW: '九丑日',
      AppLanguage.zhCN: '九丑日',
    },
    '四废日': {
      AppLanguage.en: '4F-D',
      AppLanguage.zhTW: '四廢日',
      AppLanguage.zhCN: '四废日',
    },
    '十恶大败': {
      AppLanguage.en: '10-Evil',
      AppLanguage.zhTW: '十惡大敗',
      AppLanguage.zhCN: '十恶大败',
    },
    '天罗地网': {
      AppLanguage.en: 'T-Luo',
      AppLanguage.zhTW: '天羅地網',
      AppLanguage.zhCN: '天罗地网',
    },
    '阴差阳错': {
      AppLanguage.en: 'YinYang-E',
      AppLanguage.zhTW: '陰差阳錯',
      AppLanguage.zhCN: '阴差阳错',
    },
    '孤鸾煞': {
      AppLanguage.en: 'GuaL-S',
      AppLanguage.zhTW: '孤鸞煞',
      AppLanguage.zhCN: '孤鸾煞',
    },
    '拱禄': {
      AppLanguage.en: 'G-Lu',
      AppLanguage.zhTW: '拱祿',
      AppLanguage.zhCN: '拱禄',
    },
    '拱贵': {
      AppLanguage.en: 'G-Noble',
      AppLanguage.zhTW: '拱貴',
      AppLanguage.zhCN: '拱贵',
    },
    '地转': {
      AppLanguage.en: 'E-Turn',
      AppLanguage.zhTW: '地轉',
      AppLanguage.zhCN: '地转',
    },
    '天转': {
      AppLanguage.en: 'T-Turn',
      AppLanguage.zhTW: '天轉',
      AppLanguage.zhCN: '天转',
    },
    '太极贵人': {
      AppLanguage.en: 'Taiji-N',
      AppLanguage.zhTW: '太極貴人',
      AppLanguage.zhCN: '太极贵人',
    },
    '文昌贵人': {
      AppLanguage.en: 'Literary',
      AppLanguage.zhTW: '文昌貴人',
      AppLanguage.zhCN: '文昌贵人',
    },
    '国印贵人': {
      AppLanguage.en: 'S-Seal',
      AppLanguage.zhTW: '國印貴人',
      AppLanguage.zhCN: '国印贵人',
    },
    '天德贵人': {
      AppLanguage.en: 'Heaven-N',
      AppLanguage.zhTW: '天德貴人',
      AppLanguage.zhCN: '天德贵人',
    },
    '月德贵人': {
      AppLanguage.en: 'Moon-N',
      AppLanguage.zhTW: '月德貴人',
      AppLanguage.zhCN: '月德贵人',
    },
    '禄神': {
      AppLanguage.en: 'Luck-G',
      AppLanguage.zhTW: '祿神',
      AppLanguage.zhCN: '禄神',
    },
    '日干学堂': {
      AppLanguage.en: 'D-Study',
      AppLanguage.zhTW: '日干學堂',
      AppLanguage.zhCN: '日干学堂',
    },
    '日干词馆': {
      AppLanguage.en: 'D-Hall',
      AppLanguage.zhTW: '日干詞館',
      AppLanguage.zhCN: '日干词馆',
    },
    '正学堂': {
      AppLanguage.en: 'P-Study',
      AppLanguage.zhTW: '正學堂',
      AppLanguage.zhCN: '正学堂',
    },
    '正词馆': {
      AppLanguage.en: 'P-Hall',
      AppLanguage.zhTW: '正詞館',
      AppLanguage.zhCN: '正词馆',
    },
    '官贵学堂': {
      AppLanguage.en: 'O-Study',
      AppLanguage.zhTW: '官貴學堂',
      AppLanguage.zhCN: '官贵学堂',
    },
    '官贵词馆': {
      AppLanguage.en: 'O-Hall',
      AppLanguage.zhTW: '官貴詞館',
      AppLanguage.zhCN: '官贵词馆',
    },
    '官星学堂': {
      AppLanguage.en: 'S-Study',
      AppLanguage.zhTW: '官星學堂',
      AppLanguage.zhCN: '官星学堂',
    },
    '学堂会贵': {
      AppLanguage.en: 'Study-Noble',
      AppLanguage.zhTW: '學堂會貴',
      AppLanguage.zhCN: '学堂会贵',
    },

    // 1-31 日 (支持流日卡片)
    '1日': {AppLanguage.en: '1st', AppLanguage.zhTW: '1日'},
    '2日': {AppLanguage.en: '2nd', AppLanguage.zhTW: '2日'},
    '3日': {AppLanguage.en: '3rd', AppLanguage.zhTW: '3日'},
    '4日': {AppLanguage.en: '4th', AppLanguage.zhTW: '4日'},
    '5日': {AppLanguage.en: '5th', AppLanguage.zhTW: '5日'},
    '6日': {AppLanguage.en: '6th', AppLanguage.zhTW: '6日'},
    '7日': {AppLanguage.en: '7th', AppLanguage.zhTW: '7日'},
    '8日': {AppLanguage.en: '8th', AppLanguage.zhTW: '8日'},
    '9日': {AppLanguage.en: '9th', AppLanguage.zhTW: '9日'},
    '10日': {AppLanguage.en: '10th', AppLanguage.zhTW: '10日'},
    '11日': {AppLanguage.en: '11th', AppLanguage.zhTW: '11日'},
    '12日': {AppLanguage.en: '12th', AppLanguage.zhTW: '12日'},
    '13日': {AppLanguage.en: '13th', AppLanguage.zhTW: '13日'},
    '14日': {AppLanguage.en: '14th', AppLanguage.zhTW: '14日'},
    '15日': {AppLanguage.en: '15th', AppLanguage.zhTW: '15日'},
    '16日': {AppLanguage.en: '16th', AppLanguage.zhTW: '16日'},
    '17日': {AppLanguage.en: '17th', AppLanguage.zhTW: '17日'},
    '18日': {AppLanguage.en: '18th', AppLanguage.zhTW: '18日'},
    '19日': {AppLanguage.en: '19th', AppLanguage.zhTW: '19日'},
    '20日': {AppLanguage.en: '20th', AppLanguage.zhTW: '20日'},
    '21日': {AppLanguage.en: '21st', AppLanguage.zhTW: '21日'},
    '22日': {AppLanguage.en: '22nd', AppLanguage.zhTW: '21日'},
    '23日': {AppLanguage.en: '23rd', AppLanguage.zhTW: '21日'},
    '24日': {AppLanguage.en: '24th', AppLanguage.zhTW: '21日'},
    '25日': {AppLanguage.en: '25th', AppLanguage.zhTW: '21日'},
    '26日': {AppLanguage.en: '26th', AppLanguage.zhTW: '21日'},
    '27日': {AppLanguage.en: '27th', AppLanguage.zhTW: '21日'},
    '28日': {AppLanguage.en: '28th', AppLanguage.zhTW: '21日'},
    '29日': {AppLanguage.en: '29th', AppLanguage.zhTW: '21日'},
    '30日': {AppLanguage.en: '30th', AppLanguage.zhTW: '21日'},
    '31日': {AppLanguage.en: '31st', AppLanguage.zhTW: '21日'},

    // 地支名称 (作为字符串匹配)
    '子': {AppLanguage.en: 'Zi', AppLanguage.zhTW: '子'},
    '丑': {AppLanguage.en: 'Chou', AppLanguage.zhTW: '丑'},
    '寅': {AppLanguage.en: 'Yin', AppLanguage.zhTW: '寅'},
    '卯': {AppLanguage.en: 'Mao', AppLanguage.zhTW: '卯'},
    '辰': {AppLanguage.en: 'Chen', AppLanguage.zhTW: '辰'},
    '巳': {AppLanguage.en: 'Si', AppLanguage.zhTW: '巳'},
    '午': {AppLanguage.en: 'Wu', AppLanguage.zhTW: '午'},
    '未': {AppLanguage.en: 'Wei', AppLanguage.zhTW: '未'},
    '申': {AppLanguage.en: 'Shen', AppLanguage.zhTW: '申'},
    '酉': {AppLanguage.en: 'You', AppLanguage.zhTW: '酉'},
    '戌': {AppLanguage.en: 'Xu', AppLanguage.zhTW: '戌'},
    '亥': {AppLanguage.en: 'Hai', AppLanguage.zhTW: '亥'},

    '紫微斗数': {AppLanguage.en: 'Ziwei Doushu', AppLanguage.zhTW: '紫微斗數'},
    '紫微': {AppLanguage.en: 'Ziwei', AppLanguage.zhTW: '紫微'},
    // 紫微二级设置
    '紫微排盘流派设置': {
      AppLanguage.en: 'Ziwei Calculation Settings',
      AppLanguage.zhTW: '紫微排盤流派設置',
    },
    '闰月排法': {AppLanguage.en: 'Leap Month Rule', AppLanguage.zhTW: '閏月排法'},
    '十五分割法': {AppLanguage.en: 'Split at 15th', AppLanguage.zhTW: '十五分割法'},
    '前十五天归上月，后十五天归下月': {
      AppLanguage.en: 'Before 15th is prev month, after is next',
      AppLanguage.zhTW: '前十五天歸上月，後十五天歸下月',
    },
    '作下月计算': {AppLanguage.en: 'As Next Month', AppLanguage.zhTW: '作下月計算'},
    '闰月整月直接算作下一个月': {
      AppLanguage.en: 'Leap month is treated as the next month',
      AppLanguage.zhTW: '閏月整月直接算作下一個月',
    },
    '作本月计算': {AppLanguage.en: 'As Current Month', AppLanguage.zhTW: '作本月計算'},
    '闰月整月算作当月': {
      AppLanguage.en: 'Leap month is treated as the current month',
      AppLanguage.zhTW: '閏月整月算作當月',
    },
    '四化基准点': {AppLanguage.en: 'SiHua Standard', AppLanguage.zhTW: '四化基準點'},
    '四化天干跟随农历': {
      AppLanguage.en: 'SiHua follows Lunar stem',
      AppLanguage.zhTW: '四化天干跟隨農曆',
    },
    '传统排法': {AppLanguage.en: 'Traditional Method', AppLanguage.zhTW: '傳統排法'},
    '四化天干跟随节气': {
      AppLanguage.en: 'SiHua follows Solar stem',
      AppLanguage.zhTW: '四化天干跟隨節氣',
    },
    '童限排法': {AppLanguage.en: 'Childhood Luck Rule', AppLanguage.zhTW: '童限排法'},
    '一岁一宫顺行': {
      AppLanguage.en: 'One palace per year (Forward)',
      AppLanguage.zhTW: '一歲一宮順行',
    },
    '一命二财三疾厄': {
      AppLanguage.en: 'Life -> Wealth -> Health',
      AppLanguage.zhTW: '一命二財三疾厄',
    },
    '实验性功能': {AppLanguage.en: 'Experimental', AppLanguage.zhTW: '實驗性功能'},
    '实验性功能 (谨慎修改)': {
      AppLanguage.en: 'Experimental Features (Handle with care)',
      AppLanguage.zhTW: '實驗性功能 (謹慎修改)',
    },
    '更多高级排法设置': {
      AppLanguage.en: 'Advanced Calculation Settings',
      AppLanguage.zhTW: '更多高級排法設置',
    },
    '五虎遁基准点': {AppLanguage.en: 'WuHuDun Standard', AppLanguage.zhTW: '五虎遁基準點'},
    '十二建星宫干跟随农历': {
      AppLanguage.en: 'Stems follow Lunar calendar',
      AppLanguage.zhTW: '十二建星宮干跟隨農曆',
    },
    '十二建星宫干跟随节气': {
      AppLanguage.en: 'Stems follow Solar terms',
      AppLanguage.zhTW: '十二建星宮干跟隨節氣',
    },
    '流运起例基准 (流动线)': {
      AppLanguage.en: 'Flow Limit Standard',
      AppLanguage.zhTW: '流運起例基準 (流動線)',
    },
    '流运是以农历为界': {
      AppLanguage.en: 'Flow limit based on Lunar',
      AppLanguage.zhTW: '流運是以農曆為界',
    },
    '初一换月，正一换年': {
      AppLanguage.en: '1st for month, Lunar Year for year',
      AppLanguage.zhTW: '初一換月，正一換年',
    },
    '流运是以节气为界': {
      AppLanguage.en: 'Flow limit based on Solar',
      AppLanguage.zhTW: '流運是以節氣為界',
    },
    '交节换月，立春换年': {
      AppLanguage.en: 'Solar terms for month, LiChun for year',
      AppLanguage.zhTW: '交節換月，立春換年',
    },
  };
}

extension GanZhiL10n on GanZhi {
  String get display => '${gan.display}${zhi.display}';
}
