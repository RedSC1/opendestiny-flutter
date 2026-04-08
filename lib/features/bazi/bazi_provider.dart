import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bazi_core/bazi_core.dart';
import '../../models/destiny_profile.dart';
import '../../providers/input_provider.dart';

part 'bazi_provider.g.dart';

@riverpod
BaziChart baziChart(BaziChartRef ref) {
  final profile = ref.watch(inputNotifierProvider);
  final settings = ref.watch(appSettingsProvider);
  final birthInput = profile.birthInput;
  final useTrueSolarTime = birthInput.resolveUseTrueSolarTime(
    settings.useTrueSolarTime,
  );

  if (birthInput.calendarType == BirthCalendarType.lunar) {
    final lunar = birthInput.lunar;
    return BaziChart.createByLunarDate(
      year: lunar.year,
      monthName: lunar.month,
      day: lunar.day,
      hour: lunar.hour,
      minute: lunar.minute,
      second: lunar.second,
      isleap: lunar.isLeap,
      location: birthInput.location,
      timeZone: birthInput.timeZone,
      useTrueSolarTime: useTrueSolarTime,
      ratHourMode: settings.ratHourMode,
      gender: profile.gender,
      siLingVersion: profile.baziOptions.siLingVersion,
    );
  }

  return BaziChart.createBySolarDate(
    clockTime: birthInput.solar.toAstroDateTime(),
    location: birthInput.location,
    timeZone: birthInput.timeZone,
    useTrueSolarTime: useTrueSolarTime,
    ratHourMode: settings.ratHourMode,
    gender: profile.gender,
    siLingVersion: profile.baziOptions.siLingVersion,
  );
}

@riverpod
FortuneTable fortuneTable(FortuneTableRef ref) {
  final chart = ref.watch(baziChartProvider);
  
  final fortune = Fortune.createByBaziChart(chart);
  return FortuneTable.build(
    fortune, 
    decadeCount: 12, 
    ratHourMode: ref.watch(appSettingsProvider).ratHourMode,
  );
}
