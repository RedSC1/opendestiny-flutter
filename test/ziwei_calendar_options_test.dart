import 'package:flutter_test/flutter_test.dart';
import 'package:opendestiny/features/ziwei/providers/ziwei_providers.dart';
import 'package:opendestiny/models/destiny_profile.dart';
import 'package:ziwei_core/ziwei_core.dart';

void main() {
  test('buildZiweiCalendarOptions keeps rat hour mode in sync', () {
    const baseOptions = CalendarOptions(
      leapRule: LeapMonthRule.splitAt15,
      wuHuDunBasedOn: Boundary.lunar,
      siHuaBasedOn: Boundary.solar,
      childhoodRule: ChildhoodRole.skip,
      flowLimitBasedOn: Boundary.lunar,
      enableHistorical: true,
    );

    final tomorrowSettings = AppSettings(
      ratHourMode: RatHourMode.tomorrowGan,
    );
    final todaySettings = AppSettings(
      ratHourMode: RatHourMode.todayGan,
    );

    final tomorrowOptions = buildZiweiCalendarOptions(
      settings: tomorrowSettings,
      baseOptions: baseOptions,
    );
    final todayOptions = buildZiweiCalendarOptions(
      settings: todaySettings,
      baseOptions: baseOptions,
    );

    expect(tomorrowOptions.ratHourMode, RatHourMode.tomorrowGan);
    expect(todayOptions.ratHourMode, RatHourMode.todayGan);
    expect(tomorrowOptions.leapRule, baseOptions.leapRule);
    expect(tomorrowOptions.siHuaBasedOn, baseOptions.siHuaBasedOn);
    expect(todayOptions.enableHistorical, isTrue);
  });
}
