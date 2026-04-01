import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/destiny_profile.dart';
import 'package:bazi_core/bazi_core.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../core/app_settings_storage.dart';
import '../core/case_repository.dart';
import '../core/case_storage.dart';
import '../core/destiny_profile_storage.dart';
import '../core/l10n.dart'; 

part 'input_provider.g.dart';

@riverpod
AppSettings appSettings(AppSettingsRef ref) {
  ref.watch(inputNotifierProvider);
  return ref.read(inputNotifierProvider.notifier).appSettings;
}

@riverpod
DestinyCase currentCase(CurrentCaseRef ref) {
  ref.watch(inputNotifierProvider);
  return ref.read(inputNotifierProvider.notifier).currentCase;
}

@riverpod
List<CaseSummary> caseSummaries(CaseSummariesRef ref) {
  ref.watch(inputNotifierProvider);
  return ref.read(inputNotifierProvider.notifier).caseSummaries;
}

@Riverpod(keepAlive: true)
class InputNotifier extends _$InputNotifier {
  static const String draftCaseId = 'default';
  final AppSettingsStorage _settingsStorage = AppSettingsStorage();
  final CaseRepository _caseRepository = CaseRepository(
    SharedPreferencesCaseStorage(),
  );
  final DestinyProfileStorage _legacyStorage = DestinyProfileStorage();
  bool _isHydrated = false;
  bool _isHydrating = false;
  int _mutationVersion = 0;
  Future<void> _persistQueue = Future<void>.value();
  AppSettings _settings = const AppSettings();
  DestinyCase _currentCase = DestinyCase.initial();
  List<CaseSummary> _caseSummaries = const <CaseSummary>[];

  AppSettings get appSettings => _settings;

  DestinyCase get currentCase => _currentCase;

  List<CaseSummary> get caseSummaries => _caseSummaries;

  @override
  DestinyProfile build() {
    _settings = const AppSettings();
    _currentCase = DestinyCase.initial();
    final initial = _composeProfile();
    AppL10nSettings.currentLanguage = _settings.language;
    _hydrate();
    return initial;
  }

  void updateBirthInput(BirthInput input) {
    _currentCase = _currentCase.copyWith(
      birthInput: input,
      touchUpdatedAt: true,
    );
    _updateProfile();
  }

  void updateGender(Gender gender) {
    _currentCase = _currentCase.copyWith(
      gender: gender,
      touchUpdatedAt: true,
    );
    _updateProfile();
  }

  void updateCaseName(String name) {
    _currentCase = _currentCase.copyWith(
      name: name,
      touchUpdatedAt: true,
    );
    _updateProfile();
  }

  void updateCalendarType(BirthCalendarType type) {
    _currentCase = _currentCase.copyWith(
      birthInput: state.birthInput.copyWith(calendarType: type),
      touchUpdatedAt: true,
    );
    _updateProfile();
  }

  void updateSolarInput(SolarBirthInput input) {
    final solarTime = input.toAstroDateTime();
    final lunarDate = LunarDate.fromSolar(solarTime);
    final lunarInput = LunarBirthInput(
      year: lunarDate.lunarYear,
      month: lunarDate.monthNameStr,
      day: lunarDate.day,
      hour: input.hour,
      minute: input.minute,
      second: input.second,
      isLeap: lunarDate.isLeap,
    );

    _currentCase = _currentCase.copyWith(
      birthInput: state.birthInput.copyWith(solar: input, lunar: lunarInput),
      touchUpdatedAt: true,
    );
    _updateProfile();
  }

  void updateLunarInput(LunarBirthInput input) {
    final lunarDate = LunarDate.fromString(input.year, input.month, input.day, isLeap: input.isLeap);
    final solarTime = lunarDate.toSolar;
    final solarInput = SolarBirthInput(
      year: solarTime.year,
      month: solarTime.month,
      day: solarTime.day,
      hour: input.hour,
      minute: input.minute,
      second: input.second,
    );

    _currentCase = _currentCase.copyWith(
      birthInput: state.birthInput.copyWith(lunar: input, solar: solarInput),
      touchUpdatedAt: true,
    );
    _updateProfile();
  }

  void updateLocation(double lon, double lat, String name, double tz) {
    _currentCase = _currentCase.copyWith(
      birthInput: state.birthInput.copyWith(
        longitude: lon,
        latitude: lat,
        locationName: name,
        timeZone: tz,
      ),
      touchUpdatedAt: true,
    );
    _updateProfile();
  }

  void updateTimeZone(double value) {
    _currentCase = _currentCase.copyWith(
      birthInput: state.birthInput.copyWith(timeZone: value),
      touchUpdatedAt: true,
    );
    _updateProfile();
  }

  void toggleTrueSolarTime(bool value) {
    _settings = _settings.copyWith(useTrueSolarTime: value);
    _updateProfile();
  }

  void updateRatHourMode(RatHourMode mode) {
    _settings = _settings.copyWith(ratHourMode: mode);
    _updateProfile();
  }

  /// 更新语言并同步翻译引擎
  void updateLanguage(AppLanguage lang) {
    _settings = _settings.copyWith(language: lang);
    _updateProfile();
  }

  void updateBaziOptions(BaziOptions options) {
    _settings = _settings.copyWith(baziOptions: options);
    _updateProfile();
  }

  void updateZiweiOptions(ZiweiOptions options) {
    _settings = _settings.copyWith(ziweiOptions: options);
    _updateProfile();
  }

  Future<void> createNewCase() async {
    final now = DateTime.now();
    _currentCase = DestinyCase(
      id: _buildCaseId(now),
      name: _buildCaseName(now),
      birthInput: BirthInput.now(),
      gender: state.gender,
      createdAt: now,
      updatedAt: now,
    );
    _updateProfile();
    if (_isHydrated) {
      await _persistQueue;
    }
  }

  Future<void> selectCase(String? id) async {
    if (id == null || id.isEmpty || id == draftCaseId) {
      _currentCase = DestinyCase.initial(id: draftCaseId, name: '当前时间');
      _updateProfile();
      return;
    }

    final stored = await _caseRepository.loadCase(id);
    if (stored == null) {
      return;
    }

    _currentCase = stored;
    _updateProfile();
    if (_isHydrated) {
      await _persistQueue;
    }
  }

  Future<void> deleteCase(String id) async {
    await _caseRepository.deleteCase(id);
    await _refreshCaseSummaries();
    if (_currentCase.id == id) {
      _currentCase = DestinyCase.initial(id: draftCaseId, name: '当前时间');
      _updateProfile();
    } else {
      _notifyDerivedDataChanged();
    }
  }

  Future<void> saveCurrentCase() async {
    if (_currentCase.id == draftCaseId) {
      return;
    }
    await _caseRepository.saveCurrentCase(_currentCase);
    await _refreshCaseSummaries();
    _notifyDerivedDataChanged();
  }

  DestinyProfile _composeProfile() {
    return DestinyProfile(
      birthInput: _currentCase.birthInput,
      gender: _currentCase.gender,
      language: _settings.language,
      baziOptions: _settings.baziOptions,
      ziweiOptions: _settings.ziweiOptions,
    );
  }

  void _updateProfile() {
    _mutationVersion++;
    final persistVersion = _mutationVersion;
    state = _composeProfile();
    AppL10nSettings.currentLanguage = _settings.language;
    _persist(
      settingsSnapshot: _settings,
      caseSnapshot: _currentCase,
      mutationVersion: persistVersion,
    );
  }

  Future<void> _hydrate() async {
    if (_isHydrated || _isHydrating) {
      return;
    }

    _isHydrating = true;
    final startVersion = _mutationVersion;
    var didMigrateLegacy = false;

    try {
      final storedSettings = await _settingsStorage.load();
      final storedCase = await _caseRepository.loadCurrentCase();
      var nextSettings = storedSettings ?? _settings;
      var nextCase = storedCase;

      if (storedSettings == null) {
        final legacyJson = await _legacyStorage.loadRawJson();
        if (legacyJson != null) {
          final migrated = _migrateLegacyProfile(
            legacyJson,
            seedCase: nextCase,
          );
          nextSettings = migrated.settings;
          nextCase = migrated.currentCase;
          didMigrateLegacy = true;
        }
      }

      if (startVersion == _mutationVersion) {
        _settings = nextSettings;
        _currentCase = nextCase;
        await _refreshCaseSummaries();
        state = _composeProfile();
        AppL10nSettings.currentLanguage = _settings.language;
      }
    } finally {
      _isHydrated = true;
      _isHydrating = false;
      if (startVersion != _mutationVersion || didMigrateLegacy) {
        await _persist(
          settingsSnapshot: _settings,
          caseSnapshot: _currentCase,
          mutationVersion: _mutationVersion,
        );
        if (didMigrateLegacy) {
          await _legacyStorage.clear();
        }
      }
    }
  }

  Future<void> _persist({
    required AppSettings settingsSnapshot,
    required DestinyCase caseSnapshot,
    required int mutationVersion,
  }) async {
    if (!_isHydrated) {
      return;
    }

    _persistQueue = _persistQueue.then((_) async {
      await _saveSplitState(
        settingsSnapshot: settingsSnapshot,
        caseSnapshot: caseSnapshot,
      );
      if (mutationVersion == _mutationVersion) {
        await _refreshCaseSummaries();
        _notifyDerivedDataChanged();
      }
    });
    await _persistQueue;
  }

  Future<void> _saveSplitState({
    required AppSettings settingsSnapshot,
    required DestinyCase caseSnapshot,
  }) async {
    await _settingsStorage.save(settingsSnapshot);
    if (caseSnapshot.id == draftCaseId) {
      await _caseRepository.setCurrentCaseId(null);
      return;
    }
    await _caseRepository.saveCurrentCase(caseSnapshot);
  }

  ({AppSettings settings, DestinyCase currentCase}) _migrateLegacyProfile(
    Map<String, dynamic> legacyJson, {
    required DestinyCase seedCase,
  }) {
    final legacyProfile = DestinyProfile.fromJson(legacyJson);
    final legacyBirthInputJson =
        legacyJson['birthInput'] is Map
            ? Map<String, dynamic>.from(legacyJson['birthInput'] as Map)
            : null;

    final settings = AppSettings(
      language: legacyProfile.language,
      useTrueSolarTime:
          legacyBirthInputJson?['useTrueSolarTime'] as bool? ?? true,
      ratHourMode: _parseLegacyRatHourMode(
        legacyBirthInputJson?['ratHourMode'],
      ),
      baziOptions: legacyProfile.baziOptions,
      ziweiOptions: legacyProfile.ziweiOptions,
    );

    final currentCase = DestinyCase.fromProfile(
      legacyProfile,
      id: seedCase.id,
      name: seedCase.name,
      createdAt: seedCase.createdAt,
      updatedAt: seedCase.updatedAt,
    );
    return (settings: settings, currentCase: currentCase);
  }

  RatHourMode _parseLegacyRatHourMode(dynamic value) {
    switch (value) {
      case 'todayGan':
        return RatHourMode.todayGan;
      case 'tomorrowGan':
        return RatHourMode.tomorrowGan;
      case 'noSplit':
      default:
        return RatHourMode.noSplit;
    }
  }

  Future<void> _refreshCaseSummaries() async {
    final allCases = await _caseRepository.listCases();
    _caseSummaries = allCases
        .where((caseData) => caseData.id != draftCaseId)
        .toList(growable: false);
  }

  void _notifyDerivedDataChanged() {
    state = _composeProfile();
  }

  String _buildCaseId(DateTime time) {
    return 'case_${time.microsecondsSinceEpoch}';
  }

  String _buildCaseName(DateTime time) {
    final mm = time.month.toString().padLeft(2, '0');
    final dd = time.day.toString().padLeft(2, '0');
    final hh = time.hour.toString().padLeft(2, '0');
    final mi = time.minute.toString().padLeft(2, '0');
    return '案例 $mm-$dd $hh:$mi';
  }
}
