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

  const BaziPillarWidget({
    super.key,
    required this.label,
    required this.gz,
    required this.dayMaster,
    this.width = 50,
    this.isDayMaster = false,
    this.showCangGan = true,
  });

  @override
  Widget build(BuildContext context) {
    final stemWx = BaziTable.getWuXingOfGan(gz.gan);
    final branchWx = BaziTable.getWuXingOfZhi(gz.zhi);
    
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 顶部标签 (如：年柱) - 放大到 12
          Text(label.tr, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          
          // 2. 主十神 - 增加高度到 18
          SizedBox(
            height: 18, 
            child: FittedBox(
              fit: BoxFit.scaleDown, 
              child: Text(
                isDayMaster ? '日主'.tr : Relationship.getShiShen(dayMaster, gz.gan).display, 
                style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)
              )
            )
          ),
          const SizedBox(height: 4),
          
          // 3. 干支 - 保持 26 挺大气
          Text(
            gz.gan.display, 
            style: TextStyle(
              fontSize: 26, 
              fontWeight: FontWeight.bold, 
              color: BaziUIUtils.getWuXingColor(stemWx)
            )
          ),
          Text(
            gz.zhi.display, 
            style: TextStyle(
              fontSize: 26, 
              fontWeight: FontWeight.bold, 
              color: BaziUIUtils.getWuXingColor(branchWx)
            )
          ),
          
          if (showCangGan) ...[
            const SizedBox(height: 12),
            // 4. 藏干区域
            SizedBox(
              height: 140, // 稍微拉高一点
              child: Column(
                children: BaziTable.getCangGan(gz.zhi).map((gan) => Column(
                  children: [
                    // 藏干天干 - 放大到 14
                    Text(
                      gan.display, 
                      style: TextStyle(
                        fontSize: 14, 
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
                    const SizedBox(height: 6)
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
