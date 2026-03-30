import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bazi_core/bazi_core.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import 'bazi_provider.dart';
import '../../core/l10n.dart'; // ✅ 引入翻译层

// 1. 状态管理
enum BaziBottomTab { taiMingShen, fortune }
final baziBottomTabProvider = StateProvider<BaziBottomTab>((ref) => BaziBottomTab.fortune);
final selDecadeIdxProvider = StateProvider<int?>((ref) => null);
final selYearIdxProvider = StateProvider<int?>((ref) => null);
final selMonthIdxProvider = StateProvider<int?>((ref) => null);
final selDayIdxProvider = StateProvider<int?>((ref) => null);
final selHourIdxProvider = StateProvider<int?>((ref) => null);

class BaziView extends ConsumerStatefulWidget {
  const BaziView({super.key});

  @override
  ConsumerState<BaziView> createState() => _BaziViewState();
}

class _BaziViewState extends ConsumerState<BaziView> {
  final _controllers = List.generate(5, (i) => ScrollController(debugLabel: 'sc_$i'));

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Color _getWuXingColor(WuXing wx) {
    switch (wx) {
      case WuXing.wood: return const Color(0xFF2E7D32);
      case WuXing.fire: return const Color(0xFFC62828);
      case WuXing.earth: return const Color(0xFF8D6E63);
      case WuXing.metal: return const Color(0xFFFBC02D);
      case WuXing.water: return const Color(0xFF1565C0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final baziChart = ref.watch(baziChartProvider);
    final fortuneTable = ref.watch(fortuneTableProvider);
    final currentTab = ref.watch(baziBottomTabProvider);
    final bazi = baziChart.bazi;
    final dayGan = bazi.day.gan;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildHeader(baziChart)),
            const SizedBox(height: 24),
            _buildMainPillars(bazi, dayGan),
            const SizedBox(height: 24),
            _buildTabSwitcher(currentTab),
            const SizedBox(height: 16),
            if (currentTab == BaziBottomTab.taiMingShen)
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildTaiMingShenRow(baziChart, dayGan))
            else
              _buildFortuneFlow(fortuneTable, dayGan),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFortuneFlow(FortuneTable table, TianGan dayMaster) {
    final selD = ref.watch(selDecadeIdxProvider);
    final selY = ref.watch(selYearIdxProvider);
    final selM = ref.watch(selMonthIdxProvider);
    final selDay = ref.watch(selDayIdxProvider);

    final now = AstroDateTime.fromDateTime(DateTime.now());
    final currentLichunJD = getSpecificJieQi(now.year, 21);
    final currentBaziYear = now.toJ2000() < currentLichunJD ? now.year - 1 : now.year;

    return Column(
      children: [
        _buildHList(
          controller: _controllers[0],
          label: '大运',
          itemCount: table.decades.length,
          itemBuilder: (context, i) {
            final d = table.decades[i];
            final bool isCurrentDecade = now.isAfter(d.startTime) && now.isBefore(d.endTime);
            return _buildCard(shiShen: Relationship.getShiShen(dayMaster, d.ganZhi.gan).display, gz: d.ganZhi, top: '${d.startTime.year}', bottom: '${d.startAge}虚岁', isSel: selD == i, isCur: isCurrentDecade, activeCol: Colors.deepPurple, onTap: () {
              ref.read(selDecadeIdxProvider.notifier).state = i;
              _resetFrom(1);
            });
          },
        ),
        if (selD != null)
          _buildHList(controller: _controllers[1], label: '流年', itemCount: table.decades[selD].years.length, itemBuilder: (context, i) {
            final y = table.decades[selD].years[i];
            final bool isCurrentYear = y.year == currentBaziYear;
            return _buildCard(shiShen: Relationship.getShiShen(dayMaster, y.ganZhi.gan).display, gz: y.ganZhi, top: '${y.year}', bottom: '流年', isSel: selY == i, isCur: isCurrentYear, activeCol: Colors.orange, onTap: () {
              ref.read(selYearIdxProvider.notifier).state = i;
              _resetFrom(2);
            });
          }),
        if (selD != null && selY != null)
          _buildHList(controller: _controllers[2], label: '流月', itemCount: table.decades[selD].years[selY].months.length, itemBuilder: (context, i) {
            final m = table.decades[selD].years[selY].months[i];
            final bool isCurrentMonth = now.isAfter(m.startTime) && now.isBefore(m.endTime);
            return _buildCard(shiShen: Relationship.getShiShen(dayMaster, m.ganZhi.gan).display, gz: m.ganZhi, top: '${i + 1}月', bottom: '流月', isSel: selM == i, isCur: isCurrentMonth, activeCol: Colors.teal, onTap: () {
              ref.read(selMonthIdxProvider.notifier).state = i;
              _resetFrom(3);
            });
          }),
        if (selD != null && selY != null && selM != null)
          _buildHList(controller: _controllers[3], label: '流日', itemCount: table.decades[selD].years[selY].months[selM].days.length, itemBuilder: (context, i) {
            final d = table.decades[selD].years[selY].months[selM].days[i];
            final bool isToday = d.date.year == now.year && d.date.month == now.month && d.date.day == now.day;
            return _buildCard(shiShen: Relationship.getShiShen(dayMaster, d.ganZhi.gan).display, gz: d.ganZhi, top: '${d.date.day}日', bottom: '流日', isSel: selDay == i, isCur: isToday, activeCol: Colors.blueAccent, onTap: () {
              ref.read(selDayIdxProvider.notifier).state = i;
              _resetFrom(4);
            });
          }),
        if (selD != null && selY != null && selM != null && selDay != null)
          _buildHList(controller: _controllers[4], label: '流时', itemCount: table.decades[selD].years[selY].months[selM].days[selDay].hours.length, itemBuilder: (context, i) {
            final h = table.decades[selD].years[selY].months[selM].days[selDay].hours[i];
            final currentHourIdx = (now.hour + 1) ~/ 2 % 12;
            final bool isCurrentHour = h.hourIndex == currentHourIdx;
            return _buildCard(shiShen: Relationship.getShiShen(dayMaster, h.ganZhi.gan).display, gz: h.ganZhi, top: h.name.display, bottom: '时辰', isSel: ref.watch(selHourIdxProvider) == i, isCur: isCurrentHour, activeCol: Colors.brown, onTap: () => ref.read(selHourIdxProvider.notifier).state = i);
          }),
      ],
    );
  }

  void _resetFrom(int level) {
    if (level <= 1) ref.read(selYearIdxProvider.notifier).state = null;
    if (level <= 2) ref.read(selMonthIdxProvider.notifier).state = null;
    if (level <= 3) ref.read(selDayIdxProvider.notifier).state = null;
    if (level <= 4) ref.read(selHourIdxProvider.notifier).state = null;
  }

  Widget _buildHList({required ScrollController controller, required String label, required int itemCount, required Widget Function(BuildContext, int) itemBuilder}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))),
      Container(height: 130, padding: const EdgeInsets.only(bottom: 4), child: Scrollbar(controller: controller, thumbVisibility: true, interactive: true, thickness: 6, radius: const Radius.circular(10), child: ListView.builder(key: ValueKey('${label}_list'), controller: controller, scrollDirection: Axis.horizontal, physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()), padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: itemCount, itemBuilder: itemBuilder))),
    ]);
  }

  Widget _buildCard({required String shiShen, required GanZhi gz, required String top, required String bottom, required bool isSel, bool isCur = false, required VoidCallback onTap, Color activeCol = Colors.deepPurple, double width = 60}) {
    return GestureDetector(onTap: onTap, child: Container(width: width, margin: const EdgeInsets.only(right: 8, bottom: 12), decoration: BoxDecoration(color: isSel ? activeCol.withOpacity(0.05) : (isCur ? Colors.amber.withOpacity(0.1) : Colors.white), borderRadius: BorderRadius.circular(6), border: Border.all(color: isSel ? activeCol : (isCur ? Colors.amber.withOpacity(0.5) : Colors.grey.shade200), width: isSel ? 1.5 : 1)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [if (isCur) ...[const Text('今', style: TextStyle(fontSize: 8, color: Colors.amber, fontWeight: FontWeight.bold)), const SizedBox(width: 2)], Text(shiShen, style: TextStyle(fontSize: 9, color: isSel ? activeCol : Colors.grey))]), const SizedBox(height: 2), Text(gz.gan.display, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _getWuXingColor(BaziTable.getWuXingOfGan(gz.gan)))), Text(gz.zhi.display, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _getWuXingColor(BaziTable.getWuXingOfZhi(gz.zhi)))), const SizedBox(height: 2), Text(top, style: const TextStyle(fontSize: 8, color: Colors.grey)), Text(bottom, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w400))])));
  }

  Widget _buildPillar(TianGan dayGan, String label, GanZhi gz, {bool isDayMaster = false}) {
    final stemWx = BaziTable.getWuXingOfGan(gz.gan);
    final branchWx = BaziTable.getWuXingOfZhi(gz.zhi);
    return Column(children: [Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)), const SizedBox(height: 8), Text(isDayMaster ? '日主' : Relationship.getShiShen(dayGan, gz.gan).display, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)), const SizedBox(height: 4), Text(gz.gan.display, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _getWuXingColor(stemWx))), Text(gz.zhi.display, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _getWuXingColor(branchWx))), const SizedBox(height: 12), SizedBox(height: 120, child: Column(children: BaziTable.getCangGan(gz.zhi).map((gan) => Column(children: [Text(gan.display, style: TextStyle(fontSize: 13, color: _getWuXingColor(BaziTable.getWuXingOfGan(gan)))), Text(Relationship.getShiShen(dayGan, gan).display, style: const TextStyle(fontSize: 9, color: Colors.grey)), const SizedBox(height: 4)])).toList()))]);
  }

  Widget _buildMainPillars(BaZi bazi, TianGan dayGan) {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: const Color(0xFFFBFBFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildPillar(dayGan, '年柱', bazi.year), _buildPillar(dayGan, '月柱', bazi.month), _buildPillar(dayGan, '日柱', bazi.day, isDayMaster: true), _buildPillar(dayGan, '时柱', bazi.time)]));
  }

  Widget _buildTabSwitcher(BaziBottomTab currentTab) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: SegmentedButton<BaziBottomTab>(segments: const [ButtonSegment(value: BaziBottomTab.fortune, label: Text('大运流年'), icon: Icon(Icons.trending_up)), ButtonSegment(value: BaziBottomTab.taiMingShen, label: Text('胎命身'), icon: Icon(Icons.hub))], selected: {currentTab}, onSelectionChanged: (val) => ref.read(baziBottomTabProvider.notifier).state = val.first));
  }

  Widget _buildTaiMingShenRow(BaziChart chart, TianGan dayGan) {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildSmallPillar(dayGan, '胎元', chart.taiYuan), _buildSmallPillar(dayGan, '命宫', chart.mingGong), _buildSmallPillar(dayGan, '身宫', chart.shenGong)]));
  }

  Widget _buildSmallPillar(TianGan dayGan, String label, GanZhi gz) {
    return Column(children: [Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)), const SizedBox(height: 4), Text(gz.gan.display, style: TextStyle(fontSize: 18, color: _getWuXingColor(BaziTable.getWuXingOfGan(gz.gan)))), Text(gz.zhi.display, style: TextStyle(fontSize: 18, color: _getWuXingColor(BaziTable.getWuXingOfZhi(gz.zhi))))]);
  }

  Widget _buildHeader(BaziChart chart) {
    final isMale = chart.gender == Gender.male;
    return Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isMale ? Colors.blue : Colors.red, borderRadius: BorderRadius.circular(4)), child: Text(isMale ? '乾造' : '坤造', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))), const SizedBox(width: 16), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('公历：${chart.time.bjClt}', style: const TextStyle(fontSize: 14)), Text('农历：${chart.lunarDate}', style: const TextStyle(fontSize: 14, color: Colors.black54))])]);
  }
}
