import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/destiny_profile.dart';
import 'package:bazi_core/bazi_core.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../core/app_settings_storage.dart';
import '../core/case_repository.dart';
import '../core/case_storage.dart';
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
    HiveCaseStorage(),
  );
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

void updateAstronomicalYearMode(bool value) {
  _settings = _settings.copyWith(useAstronomicalYear: value);
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

  void createZiweiCustomProfile({
    required ZiweiCustomProfileType type,
    required String name,
    required String json,
  }) {
    final now = DateTime.now();
    final profile = ZiweiCustomProfile(
      id: '${type.name}_${now.microsecondsSinceEpoch}',
      name: name,
      json: json,
      createdAt: now,
      updatedAt: now,
    );
    final options = _settings.ziweiOptions;
    final profiles = [..._profilesForType(options, type), profile];
    _settings = _settings.copyWith(
      ziweiOptions: _updateProfilesForType(
        options,
        type,
        profiles: profiles,
        activeId: profile.id,
      ),
    );
    _updateProfile();
  }

  void renameZiweiCustomProfile({
    required ZiweiCustomProfileType type,
    required String id,
    required String name,
  }) {
    final options = _settings.ziweiOptions;
    final source = _profilesForType(options, type)
        .where((profile) => profile.id == id)
        .firstOrNull;
    if (source == null || _isProtectedZiweiCustomProfile(type, source)) return;
    final profiles = _profilesForType(options, type)
        .map(
          (profile) => profile.id == id
              ? profile.copyWith(name: name, updatedAt: DateTime.now())
              : profile,
        )
        .toList();
    _settings = _settings.copyWith(
      ziweiOptions: _updateProfilesForType(options, type, profiles: profiles),
    );
    _updateProfile();
  }

  void duplicateZiweiCustomProfile({
    required ZiweiCustomProfileType type,
    required String id,
  }) {
    final options = _settings.ziweiOptions;
    final source = _profilesForType(options, type)
        .where((profile) => profile.id == id)
        .firstOrNull;
    if (source == null) return;
    final now = DateTime.now();
    final copy = source.copyWith(
      id: '${type.name}_${now.microsecondsSinceEpoch}',
      name: '${source.name} Copy',
      createdAt: now,
      updatedAt: now,
    );
    final profiles = [..._profilesForType(options, type), copy];
    _settings = _settings.copyWith(
      ziweiOptions: _updateProfilesForType(
        options,
        type,
        profiles: profiles,
        activeId: copy.id,
      ),
    );
    _updateProfile();
  }

  void deleteZiweiCustomProfile({
    required ZiweiCustomProfileType type,
    required String id,
  }) {
    final options = _settings.ziweiOptions;
    final source = _profilesForType(options, type)
        .where((profile) => profile.id == id)
        .firstOrNull;
    if (source == null || _isProtectedZiweiCustomProfile(type, source)) return;
    final profiles = _profilesForType(options, type)
        .where((profile) => profile.id != id)
        .toList();
    final currentActiveId = _activeProfileIdForType(options, type);
    final nextActiveId = currentActiveId == id
        ? (profiles.isEmpty ? '' : profiles.first.id)
        : currentActiveId;
    _settings = _settings.copyWith(
      ziweiOptions: _updateProfilesForType(
        options,
        type,
        profiles: profiles,
        activeId: nextActiveId,
      ),
    );
    _updateProfile();
  }

  void setActiveZiweiCustomProfile({
    required ZiweiCustomProfileType type,
    required String id,
  }) {
    final options = _settings.ziweiOptions;
    _settings = _settings.copyWith(
      ziweiOptions: _updateProfilesForType(options, type, activeId: id),
    );
    _updateProfile();
  }

  void saveZiweiCustomProfileJson({
    required ZiweiCustomProfileType type,
    required String id,
    required String json,
  }) {
    final options = _settings.ziweiOptions;
    final source = _profilesForType(options, type)
        .where((profile) => profile.id == id)
        .firstOrNull;
    if (source == null || _isProtectedZiweiCustomProfile(type, source)) return;
    final profiles = _profilesForType(options, type)
        .map(
          (profile) => profile.id == id
              ? profile.copyWith(json: json, updatedAt: DateTime.now())
              : profile,
        )
        .toList();
    _settings = _settings.copyWith(
      ziweiOptions: _updateProfilesForType(options, type, profiles: profiles),
    );
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

  Future<List<DestinyCase>> getSavedCases() async {
    final summaries = await _caseRepository.listCases();
    final cases = <DestinyCase>[];
    for (final summary in summaries) {
      final item = await _caseRepository.loadCase(summary.id);
      if (item != null) {
        cases.add(item);
      }
    }
    return cases;
  }

  Future<DestinyCase?> getCaseById(String id) {
    return _caseRepository.loadCase(id);
  }

  Future<int> importCases(List<DestinyCase> cases) async {
    if (cases.isEmpty) {
      return 0;
    }

    final existingIds = (await _caseRepository.listCases())
        .map((item) => item.id)
        .toSet();
    if (_currentCase.id != draftCaseId) {
      existingIds.add(_currentCase.id);
    }

    var importedCount = 0;
    for (final item in cases) {
      final normalized = _normalizeImportedCase(item, existingIds);
      await _caseRepository.saveCase(normalized);
      existingIds.add(normalized.id);
      importedCount++;
    }

    await _refreshCaseSummaries();
    _notifyDerivedDataChanged();
    return importedCount;
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

    try {
      final storedSettings = await _settingsStorage.load();
      final storedCase = await _caseRepository.loadCurrentCase();
      final nextSettings = storedSettings ?? _settings;
      final nextCase = storedCase;

      if (startVersion == _mutationVersion) {
        _settings = _normalizeZiweiProfiles(nextSettings);
        _currentCase = nextCase;
        await _refreshCaseSummaries();
        state = _composeProfile();
        AppL10nSettings.currentLanguage = _settings.language;
      }
    } finally {
      _isHydrated = true;
      _isHydrating = false;
      if (startVersion != _mutationVersion) {
        await _persist(
          settingsSnapshot: _settings,
          caseSnapshot: _currentCase,
          mutationVersion: _mutationVersion,
        );
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

  AppSettings _normalizeZiweiProfiles(AppSettings settings) {
    final options = settings.ziweiOptions;
    var siHuaProfiles = options.siHuaProfiles;
    var activeSiHuaProfileId = options.activeSiHuaProfileId;
    var mastersProfiles = options.mastersProfiles;
    var activeMastersProfileId = options.activeMastersProfileId;
    var brightnessProfiles = options.brightnessProfiles;
    var activeBrightnessProfileId = options.activeBrightnessProfileId;
    var starsProfiles = options.starsProfiles;
    var activeStarsProfileId = options.activeStarsProfileId;

    if (siHuaProfiles.isEmpty && options.customSiHuaJson.trim().isNotEmpty) {
      final now = DateTime.now();
      final profile = ZiweiCustomProfile(
        id: 'sihua_migrated_${now.microsecondsSinceEpoch}',
        name: '迁移四化流派',
        json: options.customSiHuaJson,
        createdAt: now,
        updatedAt: now,
      );
      siHuaProfiles = [profile];
      activeSiHuaProfileId = profile.id;
    } else if (siHuaProfiles.isNotEmpty &&
        siHuaProfiles.every((profile) => profile.id != activeSiHuaProfileId)) {
      activeSiHuaProfileId = siHuaProfiles.first.id;
    }

    if (mastersProfiles.isEmpty && options.customMastersJson.trim().isNotEmpty) {
      final now = DateTime.now();
      final profile = ZiweiCustomProfile(
        id: 'masters_migrated_${now.microsecondsSinceEpoch}',
        name: '迁移命主身主流派',
        json: options.customMastersJson,
        createdAt: now,
        updatedAt: now,
      );
      mastersProfiles = [profile];
      activeMastersProfileId = profile.id;
    } else if (mastersProfiles.isNotEmpty &&
        mastersProfiles.every(
          (profile) => profile.id != activeMastersProfileId,
        )) {
      activeMastersProfileId = mastersProfiles.first.id;
    }

    if (brightnessProfiles.isEmpty &&
        options.customBrightnessJson.trim().isNotEmpty) {
      final now = DateTime.now();
      final profile = ZiweiCustomProfile(
        id: 'brightness_migrated_${now.microsecondsSinceEpoch}',
        name: '迁移亮度流派',
        json: options.customBrightnessJson,
        createdAt: now,
        updatedAt: now,
      );
      brightnessProfiles = [profile];
      activeBrightnessProfileId = profile.id;
    } else if (brightnessProfiles.isNotEmpty &&
        brightnessProfiles.every(
          (profile) => profile.id != activeBrightnessProfileId,
        )) {
      activeBrightnessProfileId = brightnessProfiles.first.id;
    }

    if (starsProfiles.isEmpty && options.customStarsJson.trim().isNotEmpty) {
      final now = DateTime.now();
      final profile = ZiweiCustomProfile(
        id: 'stars_migrated_${now.microsecondsSinceEpoch}',
        name: '迁移星曜流派',
        json: options.customStarsJson,
        createdAt: now,
        updatedAt: now,
      );
      starsProfiles = [profile];
      activeStarsProfileId = profile.id;
    } else if (starsProfiles.isNotEmpty &&
        starsProfiles.every((profile) => profile.id != activeStarsProfileId)) {
      activeStarsProfileId = starsProfiles.first.id;
    }

    return settings.copyWith(
      ziweiOptions: options.copyWith(
        siHuaProfiles: siHuaProfiles,
        activeSiHuaProfileId: activeSiHuaProfileId,
        mastersProfiles: mastersProfiles,
        activeMastersProfileId: activeMastersProfileId,
        brightnessProfiles: brightnessProfiles,
        activeBrightnessProfileId: activeBrightnessProfileId,
        starsProfiles: starsProfiles,
        activeStarsProfileId: activeStarsProfileId,
      ),
    );
  }

  List<ZiweiCustomProfile> _profilesForType(
    ZiweiOptions options,
    ZiweiCustomProfileType type,
  ) {
    return type == ZiweiCustomProfileType.siHua
        ? options.siHuaProfiles
        : type == ZiweiCustomProfileType.masters
        ? options.mastersProfiles
        : type == ZiweiCustomProfileType.brightness
        ? options.brightnessProfiles
        : options.starsProfiles;
  }

  String _activeProfileIdForType(
    ZiweiOptions options,
    ZiweiCustomProfileType type,
  ) {
    return type == ZiweiCustomProfileType.siHua
        ? options.activeSiHuaProfileId
        : type == ZiweiCustomProfileType.masters
        ? options.activeMastersProfileId
        : type == ZiweiCustomProfileType.brightness
        ? options.activeBrightnessProfileId
        : options.activeStarsProfileId;
  }

  bool _isProtectedZiweiCustomProfile(
    ZiweiCustomProfileType type,
    ZiweiCustomProfile profile,
  ) {
    return _protectedProfileNamesForType(type).contains(profile.name);
  }

  Set<String> _protectedProfileNamesForType(ZiweiCustomProfileType type) {
    return type == ZiweiCustomProfileType.siHua
        ? const {'默认四化流派', '默認四化流派', 'Default SiHua Profile'}
        : type == ZiweiCustomProfileType.masters
        ? const {
            '默认命主身主流派',
            '默認命主身主流派',
            'Default Masters Profile',
          }
        : type == ZiweiCustomProfileType.brightness
        ? const {
            '默认亮度流派',
            '默認亮度流派',
            'Default Brightness Profile',
          }
        : const {
            '默认星曜流派',
            '默認星曜流派',
            'Default Stars Profile',
          };
  }

  ZiweiOptions _updateProfilesForType(
    ZiweiOptions options,
    ZiweiCustomProfileType type, {
    List<ZiweiCustomProfile>? profiles,
    String? activeId,
  }) {
    if (type == ZiweiCustomProfileType.siHua) {
      return options.copyWith(
        siHuaProfiles: profiles ?? options.siHuaProfiles,
        activeSiHuaProfileId: activeId ?? options.activeSiHuaProfileId,
      );
    }
    if (type == ZiweiCustomProfileType.masters) {
      return options.copyWith(
        mastersProfiles: profiles ?? options.mastersProfiles,
        activeMastersProfileId: activeId ?? options.activeMastersProfileId,
      );
    }
    if (type == ZiweiCustomProfileType.brightness) {
      return options.copyWith(
        brightnessProfiles: profiles ?? options.brightnessProfiles,
        activeBrightnessProfileId:
            activeId ?? options.activeBrightnessProfileId,
      );
    }
    return options.copyWith(
      starsProfiles: profiles ?? options.starsProfiles,
      activeStarsProfileId: activeId ?? options.activeStarsProfileId,
    );
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

  DestinyCase _normalizeImportedCase(DestinyCase source, Set<String> existingIds) {
    final now = DateTime.now();
    final baseName = source.name.trim().isEmpty ? '导入案例' : source.name.trim();
    var nextId = source.id.trim();
    var nextName = baseName;

    if (nextId.isEmpty || nextId == draftCaseId) {
      nextId = _buildCaseId(now);
    }

    if (existingIds.contains(nextId)) {
      do {
        nextId = 'case_import_${DateTime.now().microsecondsSinceEpoch}';
      } while (existingIds.contains(nextId));
      nextName = '$baseName 导入';
    }

    return source.copyWith(id: nextId, name: nextName);
  }

  String _buildCaseId(DateTime time) {
    return 'case_${time.microsecondsSinceEpoch}';
  }

  String _buildCaseName(DateTime time) {
    final yyyy = time.year.toString().padLeft(4, '0');
    final mm = time.month.toString().padLeft(2, '0');
    final dd = time.day.toString().padLeft(2, '0');
    final hh = time.hour.toString().padLeft(2, '0');
    final mi = time.minute.toString().padLeft(2, '0');
    return '案例 $yyyy-$mm-$dd $hh:$mi';
  }
}
