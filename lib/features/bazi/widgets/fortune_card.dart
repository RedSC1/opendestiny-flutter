import 'package:flutter/material.dart';
import 'package:bazi_core/bazi_core.dart';
import '../bazi_ui_utils.dart';
import '../../../core/ui_scale.dart';
import '../../../core/l10n.dart';

class FortuneCard extends StatelessWidget {
  static const double _cardScale = 0.88;

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
    this.width = 62,
    this.isXiaoYunBlock = false,
  });

  @override
  Widget build(BuildContext context) {
    double s(num value) => value * _cardScale;

    final isEn = AppL10nSettings.currentLanguage == AppLanguage.en;
    final scaledWidth = s(width.ws);
    final finalWidth = isEn ? scaledWidth + s(30.ws) : scaledWidth;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: finalWidth,
        margin: EdgeInsets.only(right: s(8.ws), bottom: s(8.hs)),
        decoration: BoxDecoration(
          color: isSel ? activeCol.withOpacity(0.05) : (isCur ? Colors.amber.withOpacity(0.1) : Colors.white),
          borderRadius: BorderRadius.circular(s(6.ws)),
          border: Border.all(
            color: isSel ? activeCol : (isCur ? Colors.amber.withOpacity(0.5) : Colors.grey.shade200),
            width: isSel ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: s(4.ws)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isCur) ...[
                    Text('今'.tr, style: TextStyle(fontSize: s(9.ts), color: Colors.amber, fontWeight: FontWeight.bold)),
                    SizedBox(width: s(2.ws)),
                  ],
                  SizedBox(
                    height: s(16.hs),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        isXiaoYunBlock ? top : shiShen,
                        style: TextStyle(
                          color: isSel ? activeCol : Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: s(13.ts)
                        )
                      )
                    )
                  )
                ],
              ),
            ),
            SizedBox(height: s(2.hs)),
            if (isXiaoYunBlock) ...[
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: s(4.ws)),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '小运'.tr,
                    style: TextStyle(fontSize: s(16.ts), fontWeight: FontWeight.bold, color: Colors.black87)
                  ),
                ),
              ),
              const Spacer(),
            ] else ...[
              Text(
                gz.gan.display,
                style: TextStyle(
                  fontSize: s(20.ts),
                  fontWeight: FontWeight.bold,
                  color: BaziUIUtils.getWuXingColor(BaziTable.getWuXingOfGan(gz.gan))
                )
              ),
              Text(
                gz.zhi.display,
                style: TextStyle(
                  fontSize: s(20.ts),
                  fontWeight: FontWeight.bold,
                  color: BaziUIUtils.getWuXingColor(BaziTable.getWuXingOfZhi(gz.zhi))
                )
              ),
              SizedBox(height: s(2.hs)),
              Text(top, style: TextStyle(fontSize: s(10.ts), color: Colors.black87, fontWeight: FontWeight.bold)),
              Text(bottom, style: TextStyle(fontSize: s(9.ts), color: Colors.black54, fontWeight: FontWeight.w600)),
            ]
          ],
        ),
      ),
    );
  }
}
