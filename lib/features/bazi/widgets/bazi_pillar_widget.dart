import 'package:flutter/material.dart';
import 'package:bazi_core/bazi_core.dart';
import '../bazi_ui_utils.dart';
import '../../../core/l10n.dart';

/// 统一的八字柱组件（年、月、日、时、胎命身、流年大运等）
class BaziPillarWidget extends StatelessWidget {
  final String label;
  final GanZhi gz;
  final TianGan dayMaster;
  final double width;
  final bool isDayMaster;
  final bool showCangGan;
  final bool showProfessional;
  final bool showInteraction;
  final List<String> shenShas;

  const BaziPillarWidget({
    super.key,
    required this.label,
    required this.gz,
    required this.dayMaster,
    this.width = 50,
    this.isDayMaster = false,
    this.showCangGan = true,
    this.showProfessional = false,
    this.showInteraction = false,
    this.shenShas = const [],
  });

  @override
  Widget build(BuildContext context) {
    final stemWx = BaziTable.getWuXingOfGan(gz.gan);
    final branchWx = BaziTable.getWuXingOfZhi(gz.zhi);

    // 星运: 日干在当前地支十二长生
    final xingYun = BaziTable.getLifeStage(dayMaster, gz.zhi);
    // 自坐: 本柱天干在本柱地支十二长生
    final ziZuo = BaziTable.getLifeStage(gz.gan, gz.zhi);
    // 纳音
    final nayin = gz.naYin;
    // 空亡 (本柱所在旬查空亡)
    final kwList = gz.getKongWang();

    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 顶部标签 (如：年柱) - 移到最顶部
          SizedBox(
            height: 20,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                label.tr,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // 2. 主十神
          SizedBox(
            height: 20,
            child: Align(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  isDayMaster
                      ? '日主'.tr
                      : Relationship.getShiShen(dayMaster, gz.gan).display,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),

          // 3. 交互图顶部留白 (60px) - 【核心修改：挪到标题下方】
          if (showInteraction) const SizedBox(height: 60),

          // 3. 干支大字行 - 增加行高到 75
          SizedBox(
            height: 75,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      gz.gan.display,
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.0,
                        fontWeight: FontWeight.bold,
                        color: BaziUIUtils.getWuXingColor(stemWx),
                      ),
                    ),
                    const SizedBox(height: 5), // 拉开干支间距
                    Text(
                      gz.zhi.display,
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.0,
                        fontWeight: FontWeight.bold,
                        color: BaziUIUtils.getWuXingColor(branchWx),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 4. 交互图中部留白 (80px)
          if (showInteraction) const SizedBox(height: 80),

          // 5. 藏干区域 (固定 3 个高度为 32 的槽位 = 96px，确保下方绝对对齐)
          if (showCangGan) ...[
            SizedBox(
              height: 96,
              child: Column(
                children: List.generate(3, (index) {
                  final cgs = BaziTable.getCangGan(gz.zhi);
                  if (index >= cgs.length) {
                    return const SizedBox(height: 32); // 空槽位占位
                  }
                  final gan = cgs[index];
                  return SizedBox(
                    height: 32,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          gan.display,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.1,
                            fontWeight: FontWeight.w600,
                            color: BaziUIUtils.getWuXingColor(
                              BaziTable.getWuXingOfGan(gan),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 14,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              Relationship.getShiShen(dayMaster, gan).display,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],

          // --- 专业模块 (星运、自坐、空亡、纳音) ---
          if (showProfessional) ...[
            SizedBox(
              height: 20,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  xingYun.display,
                  style: TextStyle(
                    fontSize: 12,
                    color: BaziUIUtils.getWuXingColor(branchWx),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  ziZuo.display,
                  style: TextStyle(
                    fontSize: 12,
                    color: BaziUIUtils.getWuXingColor(branchWx),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: kwList
                      .map(
                        (zhi) => Text(
                          zhi.display,
                          style: TextStyle(
                            fontSize: 12,
                            color: BaziUIUtils.getWuXingColor(
                              BaziTable.getWuXingOfZhi(zhi),
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
              child: Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    nayin.tr,
                    style: TextStyle(
                      fontSize: 12,
                      color: BaziUIUtils.getWuXingColor(
                        NayinHelper.getNayinWuXing(gz),
                      ),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 神煞列表 (底部无限延伸块)
            if (shenShas.isNotEmpty) ...[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: shenShas.map((ss) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: SizedBox(
                      width: width - 4, // 留一点边距
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          ss.tr,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ],
      ),
    );
  }
}
