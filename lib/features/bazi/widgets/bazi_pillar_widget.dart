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

  const BaziPillarWidget({
    super.key,
    required this.label,
    required this.gz,
    required this.dayMaster,
    this.width = 50,
    this.isDayMaster = false,
    this.showCangGan = true,
    this.showProfessional = false,
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
          // 1. 顶部标签 (如：年柱) - 固定行高 20
          SizedBox(
            height: 20,
            child: Align(
              alignment: Alignment.center,
              child: Text(label.tr, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
            ),
          ),
          
          // 2. 主十神 - 固定行高 20
          SizedBox(
            height: 20, 
            child: Align(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown, 
                child: Text(
                  isDayMaster ? '日主'.tr : Relationship.getShiShen(dayMaster, gz.gan).display, 
                  style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)
                )
              ),
            )
          ),
          
          // 3. 干支大字行 - 固定行高 65
          SizedBox(
            height: 65,
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
                        fontSize: 26, height: 1.0,
                        fontWeight: FontWeight.bold, 
                        color: BaziUIUtils.getWuXingColor(stemWx)
                      )
                    ),
                    const SizedBox(height: 5), // 拉开干支间距
                    Text(
                      gz.zhi.display, 
                      style: TextStyle(
                        fontSize: 26, height: 1.0,
                        fontWeight: FontWeight.bold, 
                        color: BaziUIUtils.getWuXingColor(branchWx)
                      )
                    ),
                  ],
                ),
                // 无空亡悬浮标记
              ],
            ),
          ),
          
          const SizedBox(height: 8),

          // --- 专业模块 (星运、自坐、空亡、纳音) ---
          if (showProfessional) ...[
            SizedBox(
              height: 18,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  xingYun.display,
                  style: TextStyle(fontSize: 11, color: BaziUIUtils.getWuXingColor(branchWx)),
                ),
              ),
            ),
            SizedBox(
              height: 18,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  ziZuo.display,
                  style: TextStyle(fontSize: 11, color: BaziUIUtils.getWuXingColor(branchWx)),
                ),
              ),
            ),
            SizedBox(
              height: 18,
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: kwList.map((zhi) => Text(
                    zhi.display,
                    style: TextStyle(fontSize: 11, color: BaziUIUtils.getWuXingColor(BaziTable.getWuXingOfZhi(zhi))),
                  )).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 18,
              child: Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    nayin.tr,
                    style: TextStyle(fontSize: 11, color: BaziUIUtils.getWuXingColor(NayinHelper.getNayinWuXing(gz))), 
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],

          if (showCangGan) ...[
            // 4. 藏干区域 - 固定行高 120
            SizedBox(
              height: 120,
              child: Column(
                children: BaziTable.getCangGan(gz.zhi).map((gan) => Column(
                  children: [
                    // 藏干天干 - 放大到 14
                    Text(
                      gan.display, 
                      style: TextStyle(
                        fontSize: 14, height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: BaziUIUtils.getWuXingColor(BaziTable.getWuXingOfGan(gan))
                      )
                    ),
                    // 藏干十神 - 增加高度到 16
                    SizedBox(
                      height: 16, 
                      child: FittedBox(
                        fit: BoxFit.scaleDown, 
                        child: Text(
                          Relationship.getShiShen(dayMaster, gan).display, 
                          style: const TextStyle(color: Colors.grey, fontSize: 11)
                        )
                      )
                    ),
                    const SizedBox(height: 4)
                  ],
                )).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
