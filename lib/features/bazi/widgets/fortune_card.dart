import 'package:flutter/material.dart';
import 'package:bazi_core/bazi_core.dart';
import '../bazi_ui_utils.dart';
import '../../../core/l10n.dart';

class FortuneCard extends StatelessWidget {
  final String shiShen;
  final GanZhi gz;
  final String top;
  final String bottom;
  final bool isSel;
  final bool isCur;
  final VoidCallback onTap;
  final Color activeCol;
  final double width;
  final bool isXiaoYunBlock;

  const FortuneCard({
    super.key,
    required this.shiShen,
    required this.gz,
    required this.top,
    required this.bottom,
    required this.isSel,
    this.isCur = false,
    required this.onTap,
    this.activeCol = Colors.deepPurple,
    this.width = 68,
    this.isXiaoYunBlock = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEn = AppL10nSettings.currentLanguage == AppLanguage.en;
    final finalWidth = isEn ? width + 30 : width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: finalWidth,
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        decoration: BoxDecoration(
          color: isSel ? activeCol.withOpacity(0.05) : (isCur ? Colors.amber.withOpacity(0.1) : Colors.white),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSel ? activeCol : (isCur ? Colors.amber.withOpacity(0.5) : Colors.grey.shade200),
            width: isSel ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isCur) ...[
                    Text('今'.tr, style: const TextStyle(fontSize: 9, color: Colors.amber, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 2),
                  ],
                  SizedBox(
                    height: 18,
                    child: FittedBox(
                      fit: BoxFit.scaleDown, 
                      child: Text(
                        isXiaoYunBlock ? top : shiShen, 
                        style: TextStyle(
                          color: isSel ? activeCol : Colors.blueGrey, 
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                        )
                      )
                    )
                  )
                ],
              ),
            ),
            if (isXiaoYunBlock) ...[
              Text(bottom, style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Text('小', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              const Text('运', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              const Spacer(),
            ] else ...[
              const SizedBox(height: 4),
              Text(
                gz.gan.display, 
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: BaziUIUtils.getWuXingColor(BaziTable.getWuXingOfGan(gz.gan))
                )
              ),
              Text(
                gz.zhi.display, 
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: BaziUIUtils.getWuXingColor(BaziTable.getWuXingOfZhi(gz.zhi))
                )
              ),
              const SizedBox(height: 6),
              Text(top, style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold)),
              Text(bottom, style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w600)),
            ]
          ],
        ),
      ),
    );
  }
}
