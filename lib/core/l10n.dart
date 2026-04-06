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

extension YearL10n on int {
  String formatYear(bool useAstronomical) {
    if (useAstronomical || this > 0) return toString();
    // 历史纪年转换：0 -> 前1, -1 -> 前2, -n -> 前n+1
    final bcYear = 1 - this;
    final lang = AppL10nSettings.currentLanguage;
    if (lang == AppLanguage.en) return '$bcYear BC';
    return '前$bcYear';
  }
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
    '案例库': {AppLanguage.en: 'Case Library', AppLanguage.zhTW: '案例庫'},
    '当前时间': {AppLanguage.en: 'Current Time', AppLanguage.zhTW: '當前時間'},
    '未存档草稿': {AppLanguage.en: 'Unsaved Draft', AppLanguage.zhTW: '未存檔草稿'},
    '新建案例': {AppLanguage.en: 'New Case', AppLanguage.zhTW: '新建案例'},
    '删除案例': {AppLanguage.en: 'Delete Case', AppLanguage.zhTW: '刪除案例'},
    '删除': {AppLanguage.en: 'Delete', AppLanguage.zhTW: '刪除'},
    '确定要删除「': {
      AppLanguage.en: 'Are you sure you want to delete "',
      AppLanguage.zhTW: '確定要刪除「',
    },
    '」吗？': {AppLanguage.en: '"?', AppLanguage.zhTW: '」嗎？'},
    '八字': {AppLanguage.en: 'Bazi', AppLanguage.zhTW: '八字'},
    '个人资料': {AppLanguage.en: 'Profile', AppLanguage.zhTW: '個人資料'},
    '八字排盘': {AppLanguage.en: 'Bazi Chart', AppLanguage.zhTW: '八字排盤'},
    '连线图': {AppLanguage.en: 'Diagram', AppLanguage.zhTW: '連線圖'},
    '设置': {AppLanguage.en: 'Settings', AppLanguage.zhTW: '設置'},
    '关于': {AppLanguage.en: 'About', AppLanguage.zhTW: '關於'},
    '全局主题色': {AppLanguage.en: 'Global Theme Color', AppLanguage.zhTW: '全局主題色'},
    '控制按钮、开关与选中态的全局强调色': {
      AppLanguage.en:
          'Control the global accent color for buttons, switches and selected states',
      AppLanguage.zhTW: '控制按鈕、開關與選中態的全局強調色',
    },
    '经典紫': {AppLanguage.en: 'Classic Purple', AppLanguage.zhTW: '經典紫'},
    '蓝灰': {AppLanguage.en: 'Blue Grey', AppLanguage.zhTW: '藍灰'},
    '青绿': {AppLanguage.en: 'Teal Green', AppLanguage.zhTW: '青綠'},
    '靛蓝': {AppLanguage.en: 'Indigo', AppLanguage.zhTW: '靛藍'},
    '松石': {AppLanguage.en: 'Turquoise', AppLanguage.zhTW: '松石'},
    '墨棕': {AppLanguage.en: 'Ink Brown', AppLanguage.zhTW: '墨棕'},
    '深红': {AppLanguage.en: 'Deep Red', AppLanguage.zhTW: '深紅'},
    '禄': {AppLanguage.en: 'Lu', AppLanguage.zhTW: '祿'},
    '权': {AppLanguage.en: 'Quan', AppLanguage.zhTW: '權'},
    '科': {AppLanguage.en: 'Ke', AppLanguage.zhTW: '科'},
    '忌': {AppLanguage.en: 'Ji', AppLanguage.zhTW: '忌'},
    '乾造': {AppLanguage.en: 'Male', AppLanguage.zhTW: '乾造'},
    '坤造': {AppLanguage.en: 'Female', AppLanguage.zhTW: '坤造'},
    '注：神煞功能暂未进行精确人工校对，结果仅供参考。': {
      AppLanguage.en:
          'Note: Shen Sha results are AI-generated and have not been manually verified. For reference only.',
      AppLanguage.zhTW: '註：神煞功能暫未進行精確人工校對，結果僅供參考。',
      AppLanguage.zhCN: '注：神煞功能暂未进行精确人工校对，结果仅供参考。',
    },

    '真太阳时': {AppLanguage.en: 'True Solar Time', AppLanguage.zhTW: '真太陽時'},
    '专业模式': {AppLanguage.en: 'Pro Mode', AppLanguage.zhTW: '專業模式'},
    '运': {AppLanguage.en: 'Luck', AppLanguage.zhTW: '運'},
    '胎': {AppLanguage.en: 'TMS', AppLanguage.zhTW: '胎'},
    '起运': {AppLanguage.en: 'Luck Start', AppLanguage.zhTW: '起運'},
    '司令': {AppLanguage.en: 'SiLing', AppLanguage.zhTW: '司令'},
    '出生后': {AppLanguage.en: 'After birth', AppLanguage.zhTW: '出生後'},
    '交运': {AppLanguage.en: 'Luck starts', AppLanguage.zhTW: '交運'},
    '小时': {AppLanguage.en: 'hours', AppLanguage.zhTW: '小時'},
    '分钟': {AppLanguage.en: 'minutes', AppLanguage.zhTW: '分鐘'},
    '个月': {AppLanguage.en: 'months', AppLanguage.zhTW: '個月'},
    '复制 AI 命盘 JSON': {
      AppLanguage.en: 'Copy AI chart JSON',
      AppLanguage.zhTW: '複製 AI 命盤 JSON',
      AppLanguage.zhCN: '复制 AI 命盘 JSON',
    },
    '星曜显示预设': {
      AppLanguage.en: 'Star Visibility Presets',
      AppLanguage.zhTW: '星曜顯示預設',
    },
    '三合盘星曜显示': {
      AppLanguage.en: 'Sanhe Star Visibility',
      AppLanguage.zhTW: '三合盤星曜顯示',
    },
    '默认全量显示，适合总览本命结构': {
      AppLanguage.en: 'Defaults to full display for overview reading.',
      AppLanguage.zhTW: '默認全量顯示，適合總覽本命結構',
    },
    '四化盘星曜显示': {
      AppLanguage.en: 'Sihua Star Visibility',
      AppLanguage.zhTW: '四化盤星曜顯示',
    },
    '默认精简显示，减少四化信息干扰': {
      AppLanguage.en: 'Defaults to compact display to reduce Sihua clutter.',
      AppLanguage.zhTW: '默認精簡顯示，減少四化資訊干擾',
    },
    '飞星盘星曜显示': {
      AppLanguage.en: 'Flying Star Visibility',
      AppLanguage.zhTW: '飛星盤星曜顯示',
    },
    '默认精简显示，突出飞化与动态箭头': {
      AppLanguage.en: 'Defaults to compact display to emphasize flying arrows.',
      AppLanguage.zhTW: '默認精簡顯示，突出飛化與動態箭頭',
    },
    '全量显示': {
      AppLanguage.en: 'Full Display',
      AppLanguage.zhTW: '全量顯示',
    },
    '不屏蔽任何静态星曜': {
      AppLanguage.en: 'Do not hide any static stars.',
      AppLanguage.zhTW: '不屏蔽任何靜態星曜',
    },
    '精简显示': {
      AppLanguage.en: 'Compact Display',
      AppLanguage.zhTW: '精簡顯示',
    },
    '默认隐藏杂曜与十二神类静态星曜': {
      AppLanguage.en: 'Hide minor stars and static twelve-spirit groups by default.',
      AppLanguage.zhTW: '默認隱藏雜曜與十二神類靜態星曜',
    },
    '自定义 JSON': {
      AppLanguage.en: 'Custom JSON',
      AppLanguage.zhTW: '自定義 JSON',
    },
    '手动维护 blockedStars 屏蔽名单': {
      AppLanguage.en: 'Maintain the blockedStars list manually.',
      AppLanguage.zhTW: '手動維護 blockedStars 屏蔽名單',
    },
    '编辑自定义星曜显示名单': {
      AppLanguage.en: 'Edit Custom Star Visibility List',
      AppLanguage.zhTW: '編輯自定義星曜顯示名單',
    },
    '通过 blockedStars 数组屏蔽当前盘型的静态星曜': {
      AppLanguage.en: 'Hide static stars for this chart mode via blockedStars.',
      AppLanguage.zhTW: '通過 blockedStars 陣列屏蔽當前盤型的靜態星曜',
    },
    '仅支持通过 blockedStars 数组填写当前盘型要屏蔽的静态星曜 key。': {
      AppLanguage.en:
          'Only blockedStars is supported here, using static star keys for the current chart mode.',
      AppLanguage.zhTW: '僅支援通過 blockedStars 陣列填寫當前盤型要屏蔽的靜態星曜 key。',
    },
    '星曜显示 JSON 格式无效': {
      AppLanguage.en: 'Invalid star visibility JSON format',
      AppLanguage.zhTW: '星曜顯示 JSON 格式無效',
    },
    '已复制 AI 命盘 JSON 到剪贴板': {
      AppLanguage.en: 'AI chart JSON copied to clipboard',
      AppLanguage.zhTW: '已複製 AI 命盤 JSON 到剪貼板',
      AppLanguage.zhCN: '已复制 AI 命盘 JSON 到剪贴板',
    },
    '定盘': {AppLanguage.en: 'Fix Chart', AppLanguage.zhTW: '定盤'},
    '天盘': {AppLanguage.en: 'Heaven', AppLanguage.zhTW: '天盤'},
    '地盘': {AppLanguage.en: 'Earth', AppLanguage.zhTW: '地盤'},
    '人盘': {AppLanguage.en: 'Human', AppLanguage.zhTW: '人盤'},
    '上一日': {AppLanguage.en: 'Previous Day', AppLanguage.zhTW: '上一日'},
    '下一日': {AppLanguage.en: 'Next Day', AppLanguage.zhTW: '下一日'},
    '上一时辰 (2小时)': {
      AppLanguage.en: 'Previous Shichen (2h)',
      AppLanguage.zhTW: '上一時辰 (2小時)',
    },
    '下一时辰 (2小时)': {
      AppLanguage.en: 'Next Shichen (2h)',
      AppLanguage.zhTW: '下一時辰 (2小時)',
    },
    '复原': {AppLanguage.en: 'Reset', AppLanguage.zhTW: '復原'},
    '复制 AI 分析数据': {
      AppLanguage.en: 'Copy AI analysis data',
      AppLanguage.zhTW: '複製 AI 分析資料',
      AppLanguage.zhCN: '复制 AI 分析数据',
    },
    '已复制紫微 AI 分析数据到剪贴板': {
      AppLanguage.en: 'Ziwei AI analysis data copied to clipboard',
      AppLanguage.zhTW: '已複製紫微 AI 分析資料到剪貼板',
      AppLanguage.zhCN: '已复制紫微 AI 分析数据到剪贴板',
    },

    // 资料页
    '出生信息录入': {AppLanguage.en: 'Birth Information', AppLanguage.zhTW: '出生信息錄入'},
    '编辑资料': {AppLanguage.en: 'Edit Profile', AppLanguage.zhTW: '編輯資料'},
    '编辑': {AppLanguage.en: 'Edit', AppLanguage.zhTW: '編輯'},
    '当前正在编辑未存档草稿': {
      AppLanguage.en: 'Editing unsaved draft',
      AppLanguage.zhTW: '當前正在編輯未存檔草稿',
    },
    '当前案例：': {AppLanguage.en: 'Current Case: ', AppLanguage.zhTW: '當前案例：'},
    '自动保存': {AppLanguage.en: 'Auto Save', AppLanguage.zhTW: '自動保存'},
    '编辑姓名': {AppLanguage.en: 'Edit Name', AppLanguage.zhTW: '編輯姓名'},
    '编辑出生地点与时区': {
      AppLanguage.en: 'Edit Location & Timezone',
      AppLanguage.zhTW: '編輯出生地點與時區',
    },
    '选择城市': {AppLanguage.en: 'Choose City', AppLanguage.zhTW: '選擇城市'},
    '地点名称': {AppLanguage.en: 'Location Name', AppLanguage.zhTW: '地點名稱'},
    '经度 (-180 ~ 180)': {
      AppLanguage.en: 'Longitude (-180 ~ 180)',
      AppLanguage.zhTW: '經度 (-180 ~ 180)',
    },
    '纬度 (-90 ~ 90)': {
      AppLanguage.en: 'Latitude (-90 ~ 90)',
      AppLanguage.zhTW: '緯度 (-90 ~ 90)',
    },
    '时区 (UTC+)': {
      AppLanguage.en: 'Timezone (UTC+)',
      AppLanguage.zhTW: '時區 (UTC+)',
    },
    '请输入有效的数字': {
      AppLanguage.en: 'Please enter valid numbers',
      AppLanguage.zhTW: '請輸入有效的數字',
    },
    '经纬度超出范围': {
      AppLanguage.en: 'Longitude or latitude out of range',
      AppLanguage.zhTW: '經緯度超出範圍',
    },
    '输入超出合理范围': {
      AppLanguage.en: 'Input out of valid range',
      AppLanguage.zhTW: '輸入超出合理範圍',
    },
    '日期不合法，请检查输入': {
      AppLanguage.en: 'Invalid date, please check input',
      AppLanguage.zhTW: '日期不合法，請檢查輸入',
    },
    '高级模式（直接输入月份名称）': {
      AppLanguage.en: 'Advanced Mode (enter lunar month name directly)',
      AppLanguage.zhTW: '高級模式（直接輸入月份名稱）',
    },
    '月（如：正、二、后九、十三）': {
      AppLanguage.en: 'Month (e.g. 正, 二, 后九, 十三)',
      AppLanguage.zhTW: '月（如：正、二、後九、十三）',
    },
    '月份必须在 1-12 之间': {
      AppLanguage.en: 'Month must be between 1 and 12',
      AppLanguage.zhTW: '月份必須在 1-12 之間',
    },
    '农历日期不合法：': {
      AppLanguage.en: 'Invalid lunar date: ',
      AppLanguage.zhTW: '農曆日期不合法：',
    },
    '省': {AppLanguage.en: 'Province', AppLanguage.zhTW: '省'},
    '市': {AppLanguage.en: 'City', AppLanguage.zhTW: '市'},
    '区': {AppLanguage.en: 'District', AppLanguage.zhTW: '區'},
    '出生日期与时间': {AppLanguage.en: 'Date & Time', AppLanguage.zhTW: '出生日期與時間'},
    '输入历法': {AppLanguage.en: 'Input Calendar', AppLanguage.zhTW: '輸入曆法'},
    '公历出生时间': {AppLanguage.en: 'Solar Birth Time', AppLanguage.zhTW: '公曆出生時間'},
    '农历出生时间': {AppLanguage.en: 'Lunar Birth Time', AppLanguage.zhTW: '農曆出生時間'},
    '编辑公历出生时间': {
      AppLanguage.en: 'Edit Solar Birth Time',
      AppLanguage.zhTW: '編輯公曆出生時間',
    },
    '编辑农历出生时间': {
      AppLanguage.en: 'Edit Lunar Birth Time',
      AppLanguage.zhTW: '編輯農曆出生時間',
    },
    '出生地点与时区': {
      AppLanguage.en: 'Location & Timezone',
      AppLanguage.zhTW: '出生地點與時區',
    },
    '使用整数输入以支持公元前与农历原始录入': {
      AppLanguage.en:
          'Use integer input to support BCE dates and raw lunar entry',
      AppLanguage.zhTW: '使用整數輸入以支援公元前與農曆原始錄入',
    },
    '性别': {AppLanguage.en: 'Gender', AppLanguage.zhTW: '性別'},
    '乾 (男)': {AppLanguage.en: 'Male', AppLanguage.zhTW: '乾 (男)'},
    '坤 (女)': {AppLanguage.en: 'Female', AppLanguage.zhTW: '坤 (女)'},
    '出生地点': {AppLanguage.en: 'Birth Location', AppLanguage.zhTW: '出生地點'},
    '姓名': {AppLanguage.en: 'Name', AppLanguage.zhTW: '姓名'},
    '案例': {AppLanguage.en: 'Case', AppLanguage.zhTW: '案例'},
    '经度': {AppLanguage.en: 'Longitude', AppLanguage.zhTW: '經度'},
    '纬度': {AppLanguage.en: 'Latitude', AppLanguage.zhTW: '緯度'},
    '时区': {AppLanguage.en: 'Timezone', AppLanguage.zhTW: '時區'},
    '北京': {AppLanguage.en: 'Beijing', AppLanguage.zhTW: '北京'},
    '保存': {AppLanguage.en: 'Save', AppLanguage.zhTW: '保存'},
    '取消': {AppLanguage.en: 'Cancel', AppLanguage.zhTW: '取消'},
    '秒': {AppLanguage.en: 'Second', AppLanguage.zhTW: '秒'},
    '分': {AppLanguage.en: 'Minute', AppLanguage.zhTW: '分'},
    '闰月': {AppLanguage.en: 'Leap Month', AppLanguage.zhTW: '閏月'},
    '导入 JSON': {AppLanguage.en: 'Import JSON', AppLanguage.zhTW: '導入 JSON'},
    '导出全部 JSON': {
      AppLanguage.en: 'Export All JSON',
      AppLanguage.zhTW: '導出全部 JSON',
    },
    '分享全部 JSON': {
      AppLanguage.en: 'Share All JSON',
      AppLanguage.zhTW: '分享全部 JSON',
    },
    '分享 JSON': {AppLanguage.en: 'Share JSON', AppLanguage.zhTW: '分享 JSON'},
    '导出 JSON': {AppLanguage.en: 'Export JSON', AppLanguage.zhTW: '導出 JSON'},
    '已导入': {AppLanguage.en: 'Imported', AppLanguage.zhTW: '已導入'},
    '个命例': {AppLanguage.en: 'cases', AppLanguage.zhTW: '個命例'},
    '导入失败：': {AppLanguage.en: 'Import failed: ', AppLanguage.zhTW: '導入失敗：'},
    '已导入流派': {AppLanguage.en: 'Profile imported', AppLanguage.zhTW: '已導入流派'},
    '导入流派失败：': {
      AppLanguage.en: 'Profile import failed: ',
      AppLanguage.zhTW: '導入流派失敗：',
    },
    '当前没有可分享的命例': {
      AppLanguage.en: 'No cases available for sharing',
      AppLanguage.zhTW: '當前沒有可分享的命例',
    },
    '当前没有可导出的命例': {
      AppLanguage.en: 'No cases available for export',
      AppLanguage.zhTW: '當前沒有可導出的命例',
    },
    '已导出': {AppLanguage.en: 'Exported', AppLanguage.zhTW: '已導出'},
    '已导出命例：': {
      AppLanguage.en: 'Exported case: ',
      AppLanguage.zhTW: '已導出命例：',
    },
    '已导出流派：': {
      AppLanguage.en: 'Exported profile: ',
      AppLanguage.zhTW: '已導出流派：',
    },
    '已打开分享面板': {
      AppLanguage.en: 'Opened share sheet for',
      AppLanguage.zhTW: '已打開分享面板',
    },
    '已打开分享面板：': {
      AppLanguage.en: 'Opened share sheet for: ',
      AppLanguage.zhTW: '已打開分享面板：',
    },
    '检查更新': {AppLanguage.en: 'Check for Updates', AppLanguage.zhTW: '檢查更新'},
    '获取最新版本与下载入口': {
      AppLanguage.en: 'Fetch latest version and download links',
      AppLanguage.zhTW: '獲取最新版本與下載入口',
    },
    '检查网页更新并刷新': {
      AppLanguage.en: 'Check for web updates and refresh',
      AppLanguage.zhTW: '檢查網頁更新並刷新',
    },
    '发现新版本': {AppLanguage.en: 'Update Available', AppLanguage.zhTW: '發現新版本'},
    '发现重大更新': {
      AppLanguage.en: 'Critical Update Available',
      AppLanguage.zhTW: '發現重大更新',
    },
    '发现网页更新': {
      AppLanguage.en: 'Web Update Available',
      AppLanguage.zhTW: '發現網頁更新',
    },
    '当前版本': {AppLanguage.en: 'Current Version', AppLanguage.zhTW: '當前版本'},
    '最新版本': {AppLanguage.en: 'Latest Version', AppLanguage.zhTW: '最新版本'},
    '更新内容': {AppLanguage.en: 'What\'s New', AppLanguage.zhTW: '更新內容'},
    '前往 GitHub Release': {
      AppLanguage.en: 'Open GitHub Release',
      AppLanguage.zhTW: '前往 GitHub Release',
    },
    'Gitee 镜像': {AppLanguage.en: 'Gitee Mirror', AppLanguage.zhTW: 'Gitee 鏡像'},
    'GitCode 镜像': {
      AppLanguage.en: 'GitCode Mirror',
      AppLanguage.zhTW: 'GitCode 鏡像',
    },
    'GitHub 为主发布源，国内访问不稳定时可尝试备用镜像。': {
      AppLanguage.en: 'GitHub is the primary release source. Try mirror links if access is unstable.',
      AppLanguage.zhTW: 'GitHub 為主發布源，訪問不穩定時可嘗試備用鏡像。',
    },
    '已是最新版本': {AppLanguage.en: 'Already up to date', AppLanguage.zhTW: '已是最新版本'},
    '当前已是最新网页版本': {
      AppLanguage.en: 'You already have the latest web version',
      AppLanguage.zhTW: '當前已是最新網頁版本',
    },
    '检查更新失败': {
      AppLanguage.en: 'Failed to check for updates',
      AppLanguage.zhTW: '檢查更新失敗',
    },
    '检测到网页更新，刷新后即可使用最新内容。': {
      AppLanguage.en: 'A web update is ready. Refresh to use the latest content.',
      AppLanguage.zhTW: '檢測到網頁更新，刷新後即可使用最新內容。',
    },
    '立即刷新': {AppLanguage.en: 'Refresh Now', AppLanguage.zhTW: '立即刷新'},
    '无法打开更新链接': {
      AppLanguage.en: 'Unable to open update link',
      AppLanguage.zhTW: '無法打開更新鏈接',
    },
    '稍后': {AppLanguage.en: 'Later', AppLanguage.zhTW: '稍後'},
    '导出失败：': {AppLanguage.en: 'Export failed: ', AppLanguage.zhTW: '導出失敗：'},
    '导出流派失败：': {
      AppLanguage.en: 'Profile export failed: ',
      AppLanguage.zhTW: '導出流派失敗：',
    },
    '分享失败：': {AppLanguage.en: 'Share failed: ', AppLanguage.zhTW: '分享失敗：'},
    '分享流派失败：': {
      AppLanguage.en: 'Profile share failed: ',
      AppLanguage.zhTW: '分享流派失敗：',
    },
    '导入四化流派': {
      AppLanguage.en: 'Imported SiHua Profile',
      AppLanguage.zhTW: '導入四化流派',
    },
    '导入命主身主流派': {
      AppLanguage.en: 'Imported Masters Profile',
      AppLanguage.zhTW: '導入命主身主流派',
    },
    '导入亮度流派': {
      AppLanguage.en: 'Imported Brightness Profile',
      AppLanguage.zhTW: '導入亮度流派',
    },
    '导入星曜流派': {
      AppLanguage.en: 'Imported Stars Profile',
      AppLanguage.zhTW: '導入星曜流派',
    },
    '四化 JSON 根节点必须是对象': {
      AppLanguage.en: 'SiHua JSON root must be an object',
      AppLanguage.zhTW: '四化 JSON 根節點必須是物件',
    },
    '命主/身主 JSON 根节点必须是对象': {
      AppLanguage.en: 'Masters JSON root must be an object',
      AppLanguage.zhTW: '命主/身主 JSON 根節點必須是物件',
    },
    '亮度 JSON 根节点必须是对象': {
      AppLanguage.en: 'Brightness JSON root must be an object',
      AppLanguage.zhTW: '亮度 JSON 根節點必須是物件',
    },
    '星曜 JSON 根节点必须是数组': {
      AppLanguage.en: 'Stars JSON root must be an array',
      AppLanguage.zhTW: '星曜 JSON 根節點必須是陣列',
    },
    '命例不存在或已删除': {
      AppLanguage.en: 'The case does not exist or was deleted',
      AppLanguage.zhTW: '命例不存在或已刪除',
    },
    '请到浏览器下载目录查看': {
      AppLanguage.en: 'Check your browser downloads folder',
      AppLanguage.zhTW: '請到瀏覽器下載目錄查看',
    },
    '请到“文件”App 中查看': {
      AppLanguage.en: 'Check the Files app',
      AppLanguage.zhTW: '請到「檔案」App 中查看',
    },
    '请到系统下载目录查看': {
      AppLanguage.en: 'Check the system Downloads folder',
      AppLanguage.zhTW: '請到系統下載目錄查看',
    },
    '请到下载目录查看': {
      AppLanguage.en: 'Check the Downloads folder',
      AppLanguage.zhTW: '請到下載目錄查看',
    },
    '请检查系统保存位置': {
      AppLanguage.en: 'Check the system save location',
      AppLanguage.zhTW: '請檢查系統保存位置',
    },
    '日期格式': {
      AppLanguage.en: 'MMM dd, yyyy HH:mm',
      AppLanguage.zhTW: 'yyyy年MM月dd日 HH:mm',
      AppLanguage.zhCN: 'yyyy-MM-dd HH:mm',
    },
    '男命': {AppLanguage.zhTW: '男命'},
    '女命': {AppLanguage.zhTW: '女命'},
    '命主': {
      AppLanguage.en: 'Ming Master',
      AppLanguage.zhTW: '命主',
      AppLanguage.zhCN: '命主',
    },
    '身主': {
      AppLanguage.en: 'Shen Master',
      AppLanguage.zhTW: '身主',
      AppLanguage.zhCN: '身主',
    },
    '子年斗君': {
      AppLanguage.en: 'Rat Year DouJun',
      AppLanguage.zhTW: '子年斗君',
      AppLanguage.zhCN: '子年斗君',
    },
    '农': {AppLanguage.zhTW: '農'},
    '年': {AppLanguage.en: 'Year', AppLanguage.zhTW: '年'},
    '时': {AppLanguage.en: 'Hour', AppLanguage.zhTW: '時'},
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
    '公元前年份显示': {
      AppLanguage.en: 'BCE Year Display',
      AppLanguage.zhTW: '公元前年份顯示',
    },
    '天文纪年 (包含0年与负数)': {
      AppLanguage.en: 'Astronomical (with Year 0 & Negatives)',
      AppLanguage.zhTW: '天文紀年 (包含0年與負數)',
    },
    '历史纪年 (如 BC 100)': {
      AppLanguage.en: 'Historical (e.g., BC 100)',
      AppLanguage.zhTW: '歷史紀年 (如 BC 100)',
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
    '童限': {AppLanguage.en: 'Childhood', AppLanguage.zhTW: '童限'},
    '小限': {AppLanguage.en: 'Small Limit', AppLanguage.zhTW: '小限'},
    '回到本命盘': {AppLanguage.en: 'Reset to Origin', AppLanguage.zhTW: '回到本命盤'},
    '流年轨迹': {AppLanguage.en: 'Annual Flow', AppLanguage.zhTW: '流年軌跡'},
    '流月轨迹': {AppLanguage.en: 'Monthly Flow', AppLanguage.zhTW: '流月軌跡'},
    '流日轨迹': {AppLanguage.en: 'Daily Flow', AppLanguage.zhTW: '流日軌跡'},
    '流时轨迹': {AppLanguage.en: 'Hourly Flow', AppLanguage.zhTW: '流時軌跡'},
    '胎元': {AppLanguage.en: 'TaiYuan', AppLanguage.zhTW: '胎元'},
    '命宫': {AppLanguage.en: 'MingGong', AppLanguage.zhTW: '命宮'},
    '身宫': {AppLanguage.en: 'ShenGong', AppLanguage.zhTW: '身宮'},
    '来因': {AppLanguage.en: 'LaiYin', AppLanguage.zhTW: '來因'},
    '身': {AppLanguage.en: 'Body', AppLanguage.zhTW: '身'},
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
    '无亮度': {AppLanguage.en: 'No Brightness', AppLanguage.zhTW: '無亮度'},
    '无': {AppLanguage.en: 'None', AppLanguage.zhTW: '無', AppLanguage.zhCN: '无'},
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

    '甲木': {AppLanguage.en: 'Jia Wood', AppLanguage.zhTW: '甲木'},
    '乙木': {AppLanguage.en: 'Yi Wood', AppLanguage.zhTW: '乙木'},
    '丙火': {AppLanguage.en: 'Bing Fire', AppLanguage.zhTW: '丙火'},
    '丁火': {AppLanguage.en: 'Ding Fire', AppLanguage.zhTW: '丁火'},
    '戊土': {AppLanguage.en: 'Wu Earth', AppLanguage.zhTW: '戊土'},
    '己土': {AppLanguage.en: 'Ji Earth', AppLanguage.zhTW: '己土'},
    '庚金': {AppLanguage.en: 'Geng Metal', AppLanguage.zhTW: '庚金'},
    '辛金': {AppLanguage.en: 'Xin Metal', AppLanguage.zhTW: '辛金'},
    '壬水': {AppLanguage.en: 'Ren Water', AppLanguage.zhTW: '壬水'},
    '癸水': {AppLanguage.en: 'Gui Water', AppLanguage.zhTW: '癸水'},
    '艮土': {AppLanguage.en: 'Gen Earth', AppLanguage.zhTW: '艮土'},
    '坤土': {AppLanguage.en: 'Kun Earth', AppLanguage.zhTW: '坤土'},
    '距节': {AppLanguage.en: 'Since Jie', AppLanguage.zhTW: '距節'},
    '天': {AppLanguage.en: 'days', AppLanguage.zhTW: '天'},

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
    '四化流派': {AppLanguage.en: 'SiHua School', AppLanguage.zhTW: '四化流派'},
    '命主/身主流派': {
      AppLanguage.en: 'Masters School',
      AppLanguage.zhTW: '命主/身主流派',
    },
    '亮度流派': {AppLanguage.en: 'Brightness School', AppLanguage.zhTW: '亮度流派'},
    '使用系统默认命主身主起例': {
      AppLanguage.en: 'Use system default master rules',
      AppLanguage.zhTW: '使用系統默認命主身主起例',
    },
    '手动编辑命主身主起法与身主年支边界': {
      AppLanguage.en: 'Edit master rules and Shen boundary manually',
      AppLanguage.zhTW: '手動編輯命主身主起法與身主年支邊界',
    },
    '使用系统默认星曜亮度表': {
      AppLanguage.en: 'Use system default brightness tables',
      AppLanguage.zhTW: '使用系統默認星曜亮度表',
    },
    '手动编辑星曜亮度表与标签': {
      AppLanguage.en: 'Edit star brightness tables and labels manually',
      AppLanguage.zhTW: '手動編輯星曜亮度表與標籤',
    },
    '自定义亮度 JSON': {
      AppLanguage.en: 'Custom brightness JSON',
      AppLanguage.zhTW: '自定義亮度 JSON',
    },
    '亮度 JSON 格式无效': {
      AppLanguage.en: 'Invalid brightness JSON format',
      AppLanguage.zhTW: '亮度 JSON 格式無效',
    },
    '编辑自定义亮度流派': {
      AppLanguage.en: 'Edit Custom Brightness Profile',
      AppLanguage.zhTW: '編輯自定義亮度流派',
    },
    '编辑自定义四化流派': {
      AppLanguage.en: 'Edit Custom SiHua Profile',
      AppLanguage.zhTW: '編輯自定義四化流派',
    },
    '编辑自定义命主身主流派': {
      AppLanguage.en: 'Edit Custom Masters Profile',
      AppLanguage.zhTW: '編輯自定義命主身主流派',
    },
    '进入三级菜单编辑十天干四化规则': {
      AppLanguage.en: 'Open the nested editor for ten-stem SiHua rules',
      AppLanguage.zhTW: '進入三級菜單編輯十天干四化規則',
    },
    '进入三级菜单编辑命主、身主与年支边界': {
      AppLanguage.en: 'Open the nested editor for master rules and year boundary',
      AppLanguage.zhTW: '進入三級菜單編輯命主、身主與年支邊界',
    },
    '进入三级菜单编辑亮度标签与星曜亮度': {
      AppLanguage.en: 'Open the nested editor for brightness labels and star tables',
      AppLanguage.zhTW: '進入三級菜單編輯亮度標籤與星曜亮度',
    },
    '表格编辑': {AppLanguage.en: 'Table Editor', AppLanguage.zhTW: '表格編輯'},
    'JSON 编辑': {AppLanguage.en: 'JSON Editor', AppLanguage.zhTW: 'JSON 編輯'},
    '四化 JSON 格式无效': {
      AppLanguage.en: 'Invalid SiHua JSON format',
      AppLanguage.zhTW: '四化 JSON 格式無效',
    },
    '命主/身主 JSON 格式无效': {
      AppLanguage.en: 'Invalid masters JSON format',
      AppLanguage.zhTW: '命主/身主 JSON 格式無效',
    },
    '命主/身主起例': {
      AppLanguage.en: 'Master Rules',
      AppLanguage.zhTW: '命主/身主起例',
    },
    '身主年支基准': {
      AppLanguage.en: 'Shen Year Boundary',
      AppLanguage.zhTW: '身主年支基準',
    },
    '身主跟随农历年支': {
      AppLanguage.en: 'Shen follows lunar year branch',
      AppLanguage.zhTW: '身主跟隨農曆年支',
    },
    '身主跟随节气年支': {
      AppLanguage.en: 'Shen follows solar year branch',
      AppLanguage.zhTW: '身主跟隨節氣年支',
    },
    '命主起例': {AppLanguage.en: 'Ming Rule', AppLanguage.zhTW: '命主起例'},
    '身主起例': {AppLanguage.en: 'Shen Rule', AppLanguage.zhTW: '身主起例'},
    '亮度等级': {AppLanguage.en: 'Brightness Levels', AppLanguage.zhTW: '亮度等級'},
    '静态星': {AppLanguage.en: 'Static Stars', AppLanguage.zhTW: '靜態星'},
    '流曜': {AppLanguage.en: 'Flow Stars', AppLanguage.zhTW: '流曜'},
    '静态星亮度': {AppLanguage.en: 'Static Star Brightness', AppLanguage.zhTW: '靜態星亮度'},
    '流曜亮度': {AppLanguage.en: 'Flow Star Brightness', AppLanguage.zhTW: '流曜亮度'},
    '等级': {AppLanguage.en: 'Level', AppLanguage.zhTW: '等級'},
    '亮度名称': {AppLanguage.en: 'Brightness Label', AppLanguage.zhTW: '亮度名稱'},
    '新增亮度等级': {
      AppLanguage.en: 'Add Brightness Level',
      AppLanguage.zhTW: '新增亮度等級',
    },
    '前四宫': {AppLanguage.en: 'First 4 palaces', AppLanguage.zhTW: '前四宮'},
    '共': {AppLanguage.en: 'Total', AppLanguage.zhTW: '共'},
    '项': {AppLanguage.en: 'items', AppLanguage.zhTW: '項'},
    '保留值 -1': {AppLanguage.en: 'Reserved value -1', AppLanguage.zhTW: '保留值 -1'},
    '新建流派': {AppLanguage.en: 'New Profile', AppLanguage.zhTW: '新建流派'},
    '复制流派': {AppLanguage.en: 'Duplicate Profile', AppLanguage.zhTW: '複製流派'},
    '重命名流派': {AppLanguage.en: 'Rename Profile', AppLanguage.zhTW: '重命名流派'},
    '设为当前': {AppLanguage.en: 'Set Active', AppLanguage.zhTW: '設為當前'},
    '当前启用': {AppLanguage.en: 'Active', AppLanguage.zhTW: '當前啟用'},
    '自定义四化流派': {
      AppLanguage.en: 'Custom SiHua Profiles',
      AppLanguage.zhTW: '自定義四化流派',
    },
    '自定义命主身主流派': {
      AppLanguage.en: 'Custom Masters Profiles',
      AppLanguage.zhTW: '自定義命主身主流派',
    },
    '自定义亮度流派': {
      AppLanguage.en: 'Custom Brightness Profiles',
      AppLanguage.zhTW: '自定義亮度流派',
    },
    '更新时间': {AppLanguage.en: 'Updated', AppLanguage.zhTW: '更新時間'},
    '新建四化流派': {AppLanguage.en: 'New SiHua Profile', AppLanguage.zhTW: '新建四化流派'},
    '新建命主身主流派': {
      AppLanguage.en: 'New Masters Profile',
      AppLanguage.zhTW: '新建命主身主流派',
    },
    '新建亮度流派': {AppLanguage.en: 'New Brightness Profile', AppLanguage.zhTW: '新建亮度流派'},
    '默认四化流派': {AppLanguage.en: 'Default SiHua Profile', AppLanguage.zhTW: '默認四化流派'},
    '默认命主身主流派': {
      AppLanguage.en: 'Default Masters Profile',
      AppLanguage.zhTW: '默認命主身主流派',
    },
    '默认亮度流派': {AppLanguage.en: 'Default Brightness Profile', AppLanguage.zhTW: '默認亮度流派'},
    '迁移四化流派': {AppLanguage.en: 'Migrated SiHua Profile', AppLanguage.zhTW: '遷移四化流派'},
    '迁移命主身主流派': {
      AppLanguage.en: 'Migrated Masters Profile',
      AppLanguage.zhTW: '遷移命主身主流派',
    },
    '迁移亮度流派': {
      AppLanguage.en: 'Migrated Brightness Profile',
      AppLanguage.zhTW: '遷移亮度流派',
    },
    '删除流派': {AppLanguage.en: 'Delete Profile', AppLanguage.zhTW: '刪除流派'},
    '内置规则': {AppLanguage.en: 'Built-in Rules', AppLanguage.zhTW: '內置規則'},
    '使用系统默认四化表': {
      AppLanguage.en: 'Use system default SiHua rules',
      AppLanguage.zhTW: '使用系統默認四化表',
    },
    '自定义规则': {AppLanguage.en: 'Custom Rules', AppLanguage.zhTW: '自定義規則'},
    '手动编辑十天干禄权科忌': {
      AppLanguage.en: 'Edit Lu Quan Ke Ji for ten stems manually',
      AppLanguage.zhTW: '手動編輯十天干祿權科忌',
    },
    '四化设置': {AppLanguage.en: ' SiHua Settings', AppLanguage.zhTW: '四化設置'},
    '未设置': {AppLanguage.en: 'Unset', AppLanguage.zhTW: '未設置'},
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
    '流曜显示': {AppLanguage.en: 'Flow Star Display', AppLanguage.zhTW: '流曜顯示'},
    '流曜单独显隐': {
      AppLanguage.en: 'Per-Flow-Star Visibility',
      AppLanguage.zhTW: '流曜單獨顯隱',
    },
    '按单颗流曜控制是否显示，不改变排盘结果。': {
      AppLanguage.en:
          'Control visibility per flow star without changing calculation results.',
      AppLanguage.zhTW: '按單顆流曜控制是否顯示，不改變排盤結果。',
    },
    '基础流曜': {AppLanguage.en: 'Primary Flow Stars', AppLanguage.zhTW: '基礎流曜'},
    '流运博士十二神': {
      AppLanguage.en: 'Flow BoShi 12',
      AppLanguage.zhTW: '流運博士十二神',
    },
    '流运岁建十二神': {
      AppLanguage.en: 'Flow SuiJian 12',
      AppLanguage.zhTW: '流運歲建十二神',
    },
    '流运将前十二神': {
      AppLanguage.en: 'Flow JiangQian 12',
      AppLanguage.zhTW: '流運將前十二神',
    },
    '全部显示': {AppLanguage.en: 'Show All', AppLanguage.zhTW: '全部顯示'},
    '全部隐藏': {AppLanguage.en: 'Hide All', AppLanguage.zhTW: '全部隱藏'},
    '恢复默认': {AppLanguage.en: 'Restore Defaults', AppLanguage.zhTW: '恢復默認'},
    '以下开关仅控制限流十二神是否覆盖原局对应位置，不影响流曜排盘结果。': {
      AppLanguage.en:
          'These switches only control whether flowing 12-star groups override the original chart positions and do not affect flow-star calculation.',
      AppLanguage.zhTW: '以下開關僅控制限流十二神是否覆蓋原局對應位置，不影響流曜排盤結果。',
    },
    '限流博士十二神覆盖原局显示': {
      AppLanguage.en: 'Flow BoShi 12 Override Original Slots',
      AppLanguage.zhTW: '限流博士十二神覆蓋原局顯示',
    },
    '限流岁建十二神覆盖原局显示': {
      AppLanguage.en: 'Flow SuiJian 12 Override Original Slots',
      AppLanguage.zhTW: '限流歲建十二神覆蓋原局顯示',
    },
    '限流将前十二神覆盖原局显示': {
      AppLanguage.en: 'Flow JiangQian 12 Override Original Slots',
      AppLanguage.zhTW: '限流將前十二神覆蓋原局顯示',
    },
    '动效': {AppLanguage.en: 'Animation', AppLanguage.zhTW: '動效'},
    '启用飞星四化框': {
      AppLanguage.en: 'Enable Flying Star Highlight Frame',
      AppLanguage.zhTW: '啟用飛星四化框',
    },
    '启用飞星箭头': {
      AppLanguage.en: 'Enable Flying Star Arrow',
      AppLanguage.zhTW: '啟用飛星箭頭',
    },
    '宫位高亮特效': {
      AppLanguage.en: 'Palace Highlight Effect',
      AppLanguage.zhTW: '宮位高亮特效',
    },
    '控制选中宫位与三方四正的发光和内描边': {
      AppLanguage.en: 'Control glow and inner stroke for selected and related palaces',
      AppLanguage.zhTW: '控制選中宮位與三方四正的發光和內描邊',
    },
    '启用飞星连线动画': {
      AppLanguage.en: 'Enable Flying Star Link Animation',
      AppLanguage.zhTW: '啟用飛星連線動畫',
    },
    '按个人习惯决定是否显示': {
      AppLanguage.en: 'Show or hide based on preference',
      AppLanguage.zhTW: '按個人習慣決定是否顯示',
    },
    '中宫显示八字': {
      AppLanguage.en: 'Show Bazi In Center',
      AppLanguage.zhTW: '中宮顯示八字',
    },
    '显示身宫': {
      AppLanguage.en: 'Show Body Palace',
      AppLanguage.zhTW: '顯示身宮',
    },
    '显示来因宫': {
      AppLanguage.en: 'Show LaiYin',
      AppLanguage.zhTW: '顯示來因宮',
    },
    '三合盘设置': {
      AppLanguage.en: 'Sanhe Chart Settings',
      AppLanguage.zhTW: '三合盤設置',
    },
    '四化盘设置': {
      AppLanguage.en: 'Sihua Chart Settings',
      AppLanguage.zhTW: '四化盤設置',
    },
    '飞星盘设置': {
      AppLanguage.en: 'Flying Chart Settings',
      AppLanguage.zhTW: '飛星盤設置',
    },
    '隐藏生辰信息': {
      AppLanguage.en: 'Hide Birth Info',
      AppLanguage.zhTW: '隱藏生辰信息',
    },
    '隐藏公历、真太阳时、农历': {
      AppLanguage.en: 'Hide solar, true solar time and lunar lines',
      AppLanguage.zhTW: '隱藏公曆、真太陽時、農曆',
    },
    '启用历史历法修正': {
      AppLanguage.en: 'Enable Historical Calendar Correction',
      AppLanguage.zhTW: '啟用歷史曆法修正',
    },
    '关闭后不使用朔月修正表': {
      AppLanguage.en: 'Disable the new moon correction table when turned off',
      AppLanguage.zhTW: '關閉後不使用朔月修正表',
    },
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

    // 紫微中宫与基础信息
    '阳男': {AppLanguage.en: 'Yang Male', AppLanguage.zhTW: '陽男'},
    '阴男': {AppLanguage.en: 'Yin Male', AppLanguage.zhTW: '陰男'},
    '阳女': {AppLanguage.en: 'Yang Female', AppLanguage.zhTW: '陽女'},
    '阴女': {AppLanguage.en: 'Yin Female', AppLanguage.zhTW: '陰女'},
    '木三局': {AppLanguage.en: 'Wood 3', AppLanguage.zhTW: '木三局'},
    '火六局': {AppLanguage.en: 'Fire 6', AppLanguage.zhTW: '火六局'},
    '土五局': {AppLanguage.en: 'Earth 5', AppLanguage.zhTW: '土五局'},
    '金四局': {AppLanguage.en: 'Metal 4', AppLanguage.zhTW: '金四局'},
    '水二局': {AppLanguage.en: 'Water 2', AppLanguage.zhTW: '水二局'},
    '匿名': {AppLanguage.en: 'Anonymous', AppLanguage.zhTW: '匿名'},
  };
}

extension GanZhiL10n on GanZhi {
  String get display => '${gan.display}${zhi.display}';
}
