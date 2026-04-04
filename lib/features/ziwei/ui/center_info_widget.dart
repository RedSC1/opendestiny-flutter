import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../../../core/ui_scale.dart';
import '../../../providers/input_provider.dart';
import '../providers/ziwei_providers.dart';
import 'ziwei_classic_theme.dart';
import 'ziwei_connection_painter.dart';
import '../../../core/l10n.dart';
import '../../../core/ziwei_l10n.dart';
import '../../bazi/bazi_provider.dart';
import '../../bazi/bazi_ui_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 中宫信息面板（经典风格）
import '../../../core/app_version.dart';

class CenterInfoWidget extends ConsumerWidget {
  static const double _centerScale = 1.1;

  final ZiweiUIState state;

  const CenterInfoWidget({super.key, required this.state});

  String _formatAstroDate(AstroDateTime dt, bool useAstronomical) {
    final yearStr = dt.year.formatYear(useAstronomical);
    return '$yearStr-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatLunarDay(int day) {
    const names = [
      "",
      "初一",
      "初二",
      "初三",
      "初四",
      "初五",
      "初六",
      "初七",
      "初八",
      "初九",
      "初十",
      "十一",
      "十二",
      "十三",
      "十四",
      "十五",
      "十六",
      "十七",
      "十八",
      "十九",
      "二十",
      "廿一",
      "廿二",
      "廿三",
      "廿四",
      "廿五",
      "廿六",
      "廿七",
      "廿八",
      "廿九",
      "三十",
    ];
    if (day >= 1 && day <= 30) {
      return names[day].tr;
    }
    return '$day${'日'.tr}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 初始化UI缩放
    UIScale.init(context);
    double s(num value) => value * _centerScale;
    final chartMode = ref.watch(ziweiChartModeProvider);

    final plate = state.plate;
    final date = state.date;
    final bazi = date.bazi;

    // 获取输入档案信息（姓名、真太阳时设置等）
    final currentCase = ref.watch(currentCaseProvider);
    final caseName = currentCase.name;
    final displayName = caseName.isNotEmpty && !caseName.startsWith('案例')
        ? caseName
        : '匿名'.tr;
    final appSettings = ref.watch(appSettingsProvider);
    final useTrueSolar = appSettings.useTrueSolarTime;
    final ziweiOptions = appSettings.ziweiOptions;
    final hideCenterBirthInfo = ziweiOptions.hideCenterBirthInfo;
    final showCenterBazi = switch (chartMode) {
      ZiweiChartMode.sanhe => ziweiOptions.showCenterBazi,
      ZiweiChartMode.sihua => ziweiOptions.sihuaDisplay.showCenterBazi,
      ZiweiChartMode.flying => ziweiOptions.flyingDisplay.showCenterBazi,
    };

    final fortuneTable = ref.watch(fortuneTableProvider);

    // 判断阴阳性别 (必须使用排盘引擎认定的有效年份 effectiveYear：偶数为阳，奇数为阴)
    final isYang = plate.effectiveYear % 2 == 0;
    final yinYangGender =
        '${isYang ? "阳" : "阴"}${date.gender == Gender.male ? "男" : "女"}'.tr;

    return Container(
      decoration: BoxDecoration(
        color: ZiweiClassicTheme.cellBgColor,
        border: Border.all(
          color: ZiweiClassicTheme.cellBorderColor,
          width: 0.5,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 连线层：位于文字背景
          if (chartMode == ZiweiChartMode.sanhe &&
              state.selectedPalaceIndex != null)
            Positioned.fill(
              child: CustomPaint(
                painter: ZiweiCenterConnectionPainter(
                  selectedIndex: state.selectedPalaceIndex!,
                ),
              ),
            ),

          // 信息内容层
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: s(4),
              vertical: s(1),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- 顶部个人/时间信息组 (居中) ---
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 顶部留空，让Logo整体下移
                      SizedBox(height: s(16)),
                      // App图片Logo (SVG)
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset(
                            'assets/images/logo.svg',
                            height: s(16),
                          ),
                          // 右下角标注版本号
                          Positioned(
                            right: s(-22),
                            bottom: s(-2),
                            child: Text(
                              AppVersion.current,
                              style: TextStyle(
                                fontSize: s(8.ts),
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: s(4)),
                      // 第一行：姓名 阴阳性别 五行局 (黑色稳重版)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$displayName     $yinYangGender     ${plate.elementBureau.label.tr}',
                          style: TextStyle(
                            fontSize: s(12.ts),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: s(2)),
                      // 时间组
                      Visibility(
                        visible: !hideCenterBirthInfo,
                        maintainState: true,
                        maintainAnimation: true,
                        maintainSize: true,
                        child: Column(
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${'公历'.tr}: ${_formatAstroDate(date.solar, appSettings.useAstronomicalYear)}',
                                style: TextStyle(
                                  fontSize: s(10.8.ts),
                                  fontWeight: FontWeight.w500,
                                  color: ZiweiClassicTheme.metaInfoColor,
                                ),
                              ),
                            ),
                            if (useTrueSolar && date.trueSolarTime != null)
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${'真太阳'.tr}: ${_formatAstroDate(date.trueSolarTime!, appSettings.useAstronomicalYear)}',
                                  style: TextStyle(
                                    fontSize: s(10.8.ts),
                                    fontWeight: FontWeight.w500,
                                    color: ZiweiClassicTheme.metaInfoColor,
                                  ),
                                ),
                              ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${'农历'.tr}: ${bazi.year.display}年 ${plate.effectiveYear.formatYear(appSettings.useAstronomicalYear)} ${date.lunar.monthNameStr}月${_formatLunarDay(date.lunar.day)} ${bazi.time.zhi.display}时',
                                style: TextStyle(
                                  fontSize: s(10.8.ts),
                                  fontWeight: FontWeight.w500,
                                  color: ZiweiClassicTheme.metaInfoColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: s(2)),
                      // 命主身主
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${'命主'.tr}: ${(plate.mingZhu ?? "").nodeDisplay}   ${'身主'.tr}: ${(plate.shenZhu ?? "").nodeDisplay}',
                          style: TextStyle(
                            fontSize: s(10.8.ts),
                            fontWeight: FontWeight.bold,
                            color: ZiweiClassicTheme.decadeAgeColor,
                          ),
                        ),
                      ),
                      SizedBox(height: s(2)),
                      // 子年斗君
                      Builder(builder: (context) {
                        // 使用排盘引擎认定的有效月份 (处理了闰月和十五分割)
                        final birthMonth = plate.effectiveMonth;
                        // 获取生时地支索引 (0=子, 1=丑...)
                        final hourIndex = bazi.time.zhi.index;

                        // 算法：子宫起正月(0)，逆数生月，顺数生时
                        final douJunIndex =
                            (0 - (birthMonth - 1) + hourIndex + 12) % 12;
                        final douJunZhi = DiZhi.values[douJunIndex];

                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${'子年斗君'.tr}: ${douJunZhi.display}',
                            style: TextStyle(
                              fontSize: s(10.8.ts),
                              fontWeight: FontWeight.bold,
                              color: ZiweiClassicTheme.decadeAgeColor,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),

                  Visibility(
                    visible: showCenterBazi,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: s(4)),
                          child: const Divider(height: 1, thickness: 0.5),
                        ),

                        // --- 底部八字展示区 ---
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: _buildProfessionalBazi(
                            bazi,
                            fortuneTable,
                            appSettings.useAstronomicalYear,
                          ),
                        ),
                        SizedBox(height: s(4)),
                        // 作者署名 (极其低调)
                        Text(
                          'Authored by RedSC1',
                          style: TextStyle(
                            fontSize: s(8.ts),
                            color: Colors.black26,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalBazi(
    BaZi bazi,
    FortuneTable table,
    bool useAstronomical,
  ) {
    // 1. 原局四柱 (极其紧凑的自绘逻辑，避免使用大型的 BaziPillarWidget)
    final pillars = [
      (
        label: '年'.tr,
        gz: bazi.year,
        tg: Relationship.getShiShen(bazi.day.gan, bazi.year.gan).display,
        btnTg: Relationship.getShiShen(
          bazi.day.gan,
          BaziTable.getCangGan(bazi.year.zhi).first,
        ).display,
        btnTgWx: BaziTable.getWuXingOfGan(
          BaziTable.getCangGan(bazi.year.zhi).first,
        ),
      ),
      (
        label: '月'.tr,
        gz: bazi.month,
        tg: Relationship.getShiShen(bazi.day.gan, bazi.month.gan).display,
        btnTg: Relationship.getShiShen(
          bazi.day.gan,
          BaziTable.getCangGan(bazi.month.zhi).first,
        ).display,
        btnTgWx: BaziTable.getWuXingOfGan(
          BaziTable.getCangGan(bazi.month.zhi).first,
        ),
      ),
      (
        label: '日'.tr,
        gz: bazi.day,
        tg: '日主'.tr,
        btnTg: Relationship.getShiShen(
          bazi.day.gan,
          BaziTable.getCangGan(bazi.day.zhi).first,
        ).display,
        btnTgWx: BaziTable.getWuXingOfGan(
          BaziTable.getCangGan(bazi.day.zhi).first,
        ),
      ),
      (
        label: '时'.tr,
        gz: bazi.time,
        tg: Relationship.getShiShen(bazi.day.gan, bazi.time.gan).display,
        btnTg: Relationship.getShiShen(
          bazi.day.gan,
          BaziTable.getCangGan(bazi.time.zhi).first,
        ).display,
        btnTgWx: BaziTable.getWuXingOfGan(
          BaziTable.getCangGan(bazi.time.zhi).first,
        ),
      ),
    ];

    final baziRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pillars.map((p) {
        final stemWx = BaziTable.getWuXingOfGan(p.gz.gan);
        final branchWx = BaziTable.getWuXingOfZhi(p.gz.zhi);
        return Container(
          width: 27.5, // 控制柱间距
          margin: const EdgeInsets.symmetric(horizontal: 4.4),
          child: Column(
            children: [
              Text(
                p.tg,
                style: TextStyle(
                  fontSize: 9.35.ts,
                  fontWeight: FontWeight.bold,
                  color: p.label == '日'.tr
                      ? Colors.black54
                      : BaziUIUtils.getWuXingColor(stemWx),
                ),
              ),
              const SizedBox(height: 1.1),
              Text(
                p.gz.gan.display,
                style: TextStyle(
                  fontSize: 15.4.ts,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  color: BaziUIUtils.getWuXingColor(stemWx),
                ),
              ),
              Text(
                p.gz.zhi.display,
                style: TextStyle(
                  fontSize: 15.4.ts,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  color: BaziUIUtils.getWuXingColor(branchWx),
                ),
              ),
              Text(
                p.btnTg,
                style: TextStyle(
                  fontSize: 9.35.ts,
                  fontWeight: FontWeight.bold,
                  color: BaziUIUtils.getWuXingColor(p.btnTgWx),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );

    // 2. 渲染大运 (过滤掉 index 0 的小运，取 1~8 步大运)
    final decades = table.decades.where((d) => d.index > 0).take(8).toList();

    final dayunRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: decades.map((d) {
        final stemWx = BaziTable.getWuXingOfGan(d.ganZhi.gan);
        final branchWx = BaziTable.getWuXingOfZhi(d.ganZhi.zhi);

        return Container(
          width: 24, // 略微加宽以容纳4位数年份
          margin: const EdgeInsets.symmetric(horizontal: 1.65),
          child: Column(
            children: [
              Text(
                '${d.startAge}',
                style: TextStyle(
                  fontSize: 9.9.ts,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 1.1),
              Text(
                d.ganZhi.gan.display,
                style: TextStyle(
                  fontSize: 13.2.ts,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  color: BaziUIUtils.getWuXingColor(stemWx),
                ),
              ),
              Text(
                d.ganZhi.zhi.display,
                style: TextStyle(
                  fontSize: 13.2.ts,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  color: BaziUIUtils.getWuXingColor(branchWx),
                ),
              ),
              const SizedBox(height: 1.1),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  d.startTime.year.formatYear(useAstronomical),
                  softWrap: false,
                  style: TextStyle(fontSize: 8.8.ts, color: Colors.black38),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [baziRow, const SizedBox(height: 6.6), dayunRow],
    );
  }
}
