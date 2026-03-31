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
    Decade? currentDecade, // 游标：大限 / 童限
    FlowYear? currentYear, // 游标：流年
    FlowMonth? currentMonth, // 游标：流月
    bool? currentMonthIsLeap, // 游标：流月是否闰月
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

    // 初始化默认选中：本命身命宫
    final initialSelectedIndex = _findLifePalaceIndex(
      _cachedOriginPlate!,
      ZiweiScope.origin,
    );

    // 初始化默认展示本命盘
    return ZiweiUIState(
      plate: _cachedOriginPlate!,
      date: date,
      ruleset: ruleset,
      manifest: initialManifest,
      selectedPalaceIndex: initialSelectedIndex,
    );
  }

  /// 辅助方法：寻找指定层级的命宫索引
  int _findLifePalaceIndex(ZiWeiPlate plate, ZiweiScope scope) {
    for (int i = 0; i < 12; i++) {
      if (plate.getRole(scope, i) == PalaceRole.life) {
        return i;
      }
    }
    return 0;
  }

  /// 更新清单快照
  TimelineManifest _refreshManifest({
    Decade? decade,
    FlowYear? year,
    FlowMonth? month,
    FlowDay? day,
    bool? isLeap,
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
      isLeap: isLeap,
      day: day?.day,
    );
  }

  /// 选中宫位 (0-11)，支持再次点击取消选中
  void selectPalace(int? index) {
    if (state.selectedPalaceIndex == index) {
      state = state.copyWith(selectedPalaceIndex: null);
    } else {
      state = state.copyWith(selectedPalaceIndex: index);
    }
  }

  /// 回退到本命盘
  void resetToOrigin() {
    state = state.copyWith(
      plate: _cachedOriginPlate!,
      manifest: _refreshManifest(),
      currentDecade: null,
      currentYear: null,
      currentMonth: null,
      currentMonthIsLeap: null,
      currentDay: null,
      currentHour: null,
      selectedPalaceIndex: _findLifePalaceIndex(
        _cachedOriginPlate!,
        ZiweiScope.origin,
      ),
    );
  }

  /// 1. 选中大限
  void selectDecade(DecadeNode node) {
    if (state.currentDecade?.decadeIndex == node.index) {
      resetToOrigin();
      return;
    }

    if (_cachedOriginPlate == null) return;
    final decade = Decade.fromIndex(node.index, _cachedOriginPlate!);
    _recalculate(decade: decade);
  }

  /// 1.5 选中童限入口（仅展开童限年份，不预选具体流年）
  void selectChildhoodDecade() {
    if (state.currentDecade?.decadeIndex == 0) {
      resetToOrigin();
      return;
    }

    if (_cachedOriginPlate == null || state.manifest.childhoods.isEmpty) return;
    final childhoodYear = state.manifest.childhoods.first.year;
    final decade = Decade.createChildhood(childhoodYear, _cachedOriginPlate!);
    _recalculate(decade: decade);
  }

  /// 2. 选中童限中的某一年
  void selectChildhood(ChildhoodNode node) {
    if (state.currentDecade?.decadeIndex == 0 &&
        state.currentYear?.year == node.year) {
      _recalculate(decade: state.currentDecade);
      return;
    }

    _selectYear(node.year);
  }

  /// 3. 选中流年
  void selectYear(YearNode node) {
    if (state.currentYear?.year == node.year) {
      _recalculate(decade: state.currentDecade);
      return;
    }

    _selectYear(node.year);
  }

  /// 3. 选中流月
  void selectMonth(MonthNode node) {
    if (_cachedOriginPlate == null || state.currentYear == null) return;

    if (state.currentMonth?.month == node.month &&
        state.currentMonthIsLeap == node.isLeap) {
      _recalculate(decade: state.currentDecade, year: state.currentYear);
      return;
    }

    final fm = FlowMonth.create(
      node.month,
      state.currentYear!.year,
      _cachedOriginPlate!,
      sequence: node.sequence,
      isLeap: node.isLeap,
    );
    _recalculate(
      decade: state.currentDecade,
      year: state.currentYear,
      month: fm,
      isLeap: node.isLeap, // 传递 isLeap
    );
  }

  /// 4. 选中流日
  void selectDay(DayNode node) {
    if (_cachedOriginPlate == null || state.currentMonth == null) return;

    if (state.currentDay?.day == node.day) {
      _recalculate(
        decade: state.currentDecade,
        year: state.currentYear,
        month: state.currentMonth,
        isLeap: state.currentMonthIsLeap,
      );
      return;
    }

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
      isLeap: state.currentMonthIsLeap, // 保留 isLeap
    );
  }

  /// 5. 选中流时
  void selectHour(HourNode node) {
    if (_cachedOriginPlate == null || state.currentDay == null) return;

    if (state.currentHour?.hourIndex == node.hourIndex) {
      _recalculate(
        decade: state.currentDecade,
        year: state.currentYear,
        month: state.currentMonth,
        day: state.currentDay,
        isLeap: state.currentMonthIsLeap,
      );
      return;
    }

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
      isLeap: state.currentMonthIsLeap, // 保留 isLeap
    );
  }

  void _selectYear(int physicalYear) {
    if (_cachedOriginPlate == null) return;
    final year = FlowYear.createByYear(physicalYear, _cachedOriginPlate!);
    final decade = Decade.createByYear(physicalYear, _cachedOriginPlate!);
    _recalculate(decade: decade, year: year);
  }

  SmallLimit? _resolveSmallLimit(FlowYear? year) {
    if (_cachedOriginPlate == null || year == null) return null;

    final effectiveBirthYear = Decade.getEffectiveBirthYear(_cachedOriginPlate!);
    final virtualAge = year.year - effectiveBirthYear + 1;
    return SmallLimit.create(virtualAge, _cachedOriginPlate!);
  }

  /// 内部刷新重算核心枢纽
  void _recalculate({
    Decade? decade,
    FlowYear? year,
    FlowMonth? month,
    FlowDay? day,
    FlowHour? hour,
    bool? isLeap,
  }) {
    if (decade == null &&
        year == null &&
        month == null &&
        day == null &&
        hour == null) {
      resetToOrigin();
      return;
    }

    final smallLimit = _resolveSmallLimit(year);

    final limitContext = LimitContext(
      plate: _cachedOriginPlate!,
      decade: decade,
      smallLimit: smallLimit,
      year: year,
      month: month,
      day: day,
      hour: hour,
    );

    final dynamicPlate = ZiweiEngine.calculateDynamic(limitContext);

    // 确定当前最细层级的 Scope
    ZiweiScope targetScope = ZiweiScope.origin;
    if (hour != null)
      targetScope = ZiweiScope.hour;
    else if (day != null)
      targetScope = ZiweiScope.day;
    else if (month != null)
      targetScope = ZiweiScope.month;
    else if (year != null)
      targetScope = ZiweiScope.year;
    else if (decade != null)
      targetScope = ZiweiScope.decade;

    final lifeIndex = _findLifePalaceIndex(dynamicPlate, targetScope);

    state = state.copyWith(
      plate: dynamicPlate,
      manifest: _refreshManifest(
        decade: decade,
        year: year,
        month: month,
        day: day,
        isLeap: isLeap,
      ),
      currentDecade: decade,
      currentYear: year,
      currentMonth: month,
      currentMonthIsLeap: isLeap,
      currentDay: day,
      currentHour: hour,
      selectedPalaceIndex: lifeIndex,
    );
  }
}
