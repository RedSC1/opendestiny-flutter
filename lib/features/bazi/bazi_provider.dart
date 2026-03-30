import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bazi_core/bazi_core.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../../providers/input_provider.dart';

part 'bazi_provider.g.dart';

@riverpod
BaziChart baziChart(BaziChartRef ref) {
  final profile = ref.watch(inputNotifierProvider);
  
  final solarTime = AstroDateTime(
    profile.birthTime.year,
    profile.birthTime.month,
    profile.birthTime.day,
    profile.birthTime.hour,
    profile.birthTime.minute,
  );
  
  return BaziChart.createBySolarDate(
    clockTime: solarTime,
    location: Location(profile.longitude, profile.latitude),
    useTrueSolarTime: profile.useTrueSolarTime,
    ratHourMode: profile.ratHourMode, // ✅ 传入新的枚举模式
    gender: profile.gender,
  );
}

@riverpod
FortuneTable fortuneTable(FortuneTableRef ref) {
  final chart = ref.watch(baziChartProvider);
  final profile = ref.watch(inputNotifierProvider);
  
  final fortune = Fortune.createByBaziChart(chart);
  return FortuneTable.build(
    fortune, 
    decadeCount: 12, 
    ratHourMode: profile.ratHourMode, // ✅ 传入新的枚举模式
  );
}
