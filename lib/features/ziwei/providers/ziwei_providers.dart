import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ziwei_core/ziwei_core.dart';
import 'package:ziwei_core/src/core/timeline_provider.dart';
import 'package:ziwei_core/src/models/timeline_node.dart';
import '../../../models/destiny_profile.dart';
import '../../../providers/input_provider.dart';

part 'ziwei_providers.g.dart';
part 'ziwei_providers.freezed.dart';

/// 1. 负责把 UI 层的 [ZiweiOptions] 转译为底层的 [ZiweiRuleset]
@riverpod
ZiweiRuleset ziweiRuleset(ZiweiRulesetRef ref) {
  final profile = ref.watch(inputNotifierProvider);
  final defaultRuleset = ConfigLoader.getDefault();

  return ZiweiRuleset(
    stars: defaultRuleset.stars,
    flowDefinitions: defaultRuleset.flowDefinitions,
    brightnessLabels: defaultRuleset.brightnessLabels,
    siHuaRules: defaultRuleset.siHuaRules,
    mingZhuRule: defaultRuleset.mingZhuRule,
    shenZhuRule: defaultRuleset.shenZhuRule,
    calendarOptions: CalendarOptions(
      leapRule: profile.ziweiOptions.leapRule,
      wuHuDunBasedOn: profile.ziweiOptions.wuHuDunBasedOn,
      siHuaBasedOn: profile.ziweiOptions.siHuaBasedOn,
      flowLimitBasedOn: profile.ziweiOptions.flowLimitBasedOn,
    ),
  );
}

/// 2. 负责构建底层基准时间 [ZiweiDate]
@riverpod
ZiweiDate originDate(OriginDateRef ref) {
  final profile = ref.watch(inputNotifierProvider);
  final calendarOptions = ref.watch(ziweiRulesetProvider).calendarOptions;

  return ZiweiDate.fromSolar(
    profile.birthTime,
    gender: profile.gender,
    options: calendarOptions,
  );
}

/// 3. 管理游标与盘面状态的容器
@freezed
class ZiweiUIState with _$ZiweiUIState {
  const factory ZiweiUIState({
    required ZiWeiPlate plate, // 当前最终渲染盘 (本命 or 包含流星的盘)
    required ZiweiDate date, // 基础日期
    required ZiweiRuleset ruleset, // 基础规则
    required TimelineManifest manifest, // 当前流运清单快照
    Decade? currentDecade, // 游标：大限
    FlowYear? currentYear, // 游标：流年
    FlowMonth? currentMonth, // 游标：流月
    FlowDay? currentDay, // 游标：流日
    FlowHour? currentHour, // 游标：流时
    int? selectedPalaceIndex, // 当前选中的宫格索引 (0-11)
  }) = _ZiweiUIState;
}

/// 4. 终极状态管家 Manager
/// 接管底部表格的交互，控制流运变更，并将带有流动星曜的动态盘面推给 UI
@riverpod
class ZiweiUIManager extends _$ZiweiUIManager {
  ZiWeiPlate? _cachedOriginPlate;
  TimelineProvider? _timelineProvider;

  @override
  ZiweiUIState build() {
    final ruleset = ref.watch(ziweiRulesetProvider);
    final date = ref.watch(originDateProvider);

    // 1. 计算本命盘
    _cachedOriginPlate = ZiweiEngine.calculate(date, ruleset);
    _timelineProvider = TimelineProvider(_cachedOriginPlate!);

    // 2. 生成初始清单
    final initialManifest = _timelineProvider!.getManifest();

    // 初始化默认展示本命盘
    return ZiweiUIState(
      plate: _cachedOriginPlate!,
      date: date,
      ruleset: ruleset,
      manifest: initialManifest,
      selectedPalaceIndex: null,
    );
  }

  /// 更新清单快照
  TimelineManifest _refreshManifest({
    Decade? decade,
    FlowYear? year,
    FlowMonth? month,
    FlowDay? day,
  }) {
    if (_timelineProvider == null) {
      return TimelineManifest(
        childhoods: [],
        decades: [],
        status: ManifestStatus(isHistoricalRedZone: false, note: "未初始化"),
      );
    }
    return _timelineProvider!.getManifest(
      year: year?.year,
      decadeIndex: decade?.decadeIndex,
      month: month?.month,
      day: day?.day,
    );
  }

  /// 选中宫位 (0-11)
  void selectPalace(int? index) {
    state = state.copyWith(selectedPalaceIndex: index);
  }

  /// 回退到本命盘
  void resetToOrigin() {
    state = state.copyWith(
      plate: _cachedOriginPlate!,
      manifest: _refreshManifest(),
      currentDecade: null,
      currentYear: null,
      currentMonth: null,
      currentDay: null,
      currentHour: null,
      selectedPalaceIndex: null,
    );
  }

  /// 1. 选中大限
  void selectDecade(DecadeNode node) {
    if (_cachedOriginPlate == null) return;
    final decade = Decade.fromIndex(node.index, _cachedOriginPlate!);
    _recalculate(decade: decade);
  }

  /// 2. 选中流年
  void selectYear(YearNode node) {
    if (_cachedOriginPlate == null) return;
    final fy = FlowYear.createByYear(node.year, _cachedOriginPlate!);
    final decade = Decade.createByYear(node.year, _cachedOriginPlate!);
    _recalculate(decade: decade, year: fy);
  }

  /// 3. 选中流月
  void selectMonth(MonthNode node) {
    if (_cachedOriginPlate == null || state.currentYear == null) return;
    final fm = FlowMonth.create(
      node.month,
      state.currentYear!.year,
      _cachedOriginPlate!,
    );
    _recalculate(
      decade: state.currentDecade,
      year: state.currentYear,
      month: fm,
    );
  }

  /// 4. 选中流日
  void selectDay(DayNode node) {
    if (_cachedOriginPlate == null || state.currentMonth == null) return;
    final dayGZ = GanZhi(
      TianGan.fromName(node.stem),
      DiZhi.fromName(node.branch),
    );
    final fd = FlowDay.create(
      node.day,
      dayGZ,
      state.currentMonth!,
      _cachedOriginPlate!,
    );
    _recalculate(
      decade: state.currentDecade,
      year: state.currentYear,
      month: state.currentMonth,
      day: fd,
    );
  }

  /// 5. 选中流时
  void selectHour(HourNode node) {
    if (_cachedOriginPlate == null || state.currentDay == null) return;
    final fh = FlowHour.create(
      node.hourIndex,
      state.currentDay!,
      _cachedOriginPlate!,
    );
    _recalculate(
      decade: state.currentDecade,
      year: state.currentYear,
      month: state.currentMonth,
      day: state.currentDay,
      hour: fh,
    );
  }

  /// 内部刷新重算核心枢纽
  void _recalculate({
    Decade? decade,
    FlowYear? year,
    FlowMonth? month,
    FlowDay? day,
    FlowHour? hour,
  }) {
    if (decade == null &&
        year == null &&
        month == null &&
        day == null &&
        hour == null) {
      resetToOrigin();
      return;
    }

    final limitContext = LimitContext(
      plate: _cachedOriginPlate!,
      decade: decade,
      year: year,
      month: month,
      day: day,
      hour: hour,
    );

    final dynamicPlate = ZiweiEngine.calculateDynamic(limitContext);

    state = state.copyWith(
      plate: dynamicPlate,
      manifest: _refreshManifest(
        decade: decade,
        year: year,
        month: month,
        day: day,
      ),
      currentDecade: decade,
      currentYear: year,
      currentMonth: month,
      currentDay: day,
      currentHour: hour,
    );
  }
}
