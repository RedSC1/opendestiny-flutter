import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/destiny_profile.dart';

abstract interface class CaseStorage {
  Future<List<CaseSummary>> listCases();
  Future<DestinyCase?> loadCase(String id);
  Future<void> saveCase(DestinyCase data);
  Future<void> deleteCase(String id);
  Future<String?> getCurrentCaseId();
  Future<void> setCurrentCaseId(String? id);
}

class SharedPreferencesCaseStorage implements CaseStorage {
  static const _caseIdsKey = 'saved_case_ids_v1';
  static const _currentCaseIdKey = 'current_case_id_v1';
  static const _caseKeyPrefix = 'saved_case_v1.';

  String _caseKey(String id) => '$_caseKeyPrefix$id';

  @override
  Future<List<CaseSummary>> listCases() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_caseIdsKey) ?? const <String>[];
    final summaries = <CaseSummary>[];

    for (final id in ids) {
      final raw = prefs.getString(_caseKey(id));
      if (raw == null || raw.isEmpty) {
        continue;
      }

      try {
        final decoded = jsonDecode(raw);
        if (decoded is! Map) {
          continue;
        }
        final caseData = DestinyCase.fromJson(Map<String, dynamic>.from(decoded));
        summaries.add(caseData.summary);
      } catch (_) {
        continue;
      }
    }

    summaries.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return summaries;
  }

  @override
  Future<DestinyCase?> loadCase(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_caseKey(id));
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return null;
      }
      return DestinyCase.fromJson(Map<String, dynamic>.from(decoded));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveCase(DestinyCase data) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_caseIdsKey) ?? const <String>[]).toList();
    if (!ids.contains(data.id)) {
      ids.add(data.id);
      await prefs.setStringList(_caseIdsKey, ids);
    }
    await prefs.setString(_caseKey(data.id), jsonEncode(data.toJson()));
  }

  @override
  Future<void> deleteCase(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_caseIdsKey) ?? const <String>[]).toList()
      ..remove(id);
    await prefs.setStringList(_caseIdsKey, ids);
    await prefs.remove(_caseKey(id));

    final currentCaseId = prefs.getString(_currentCaseIdKey);
    if (currentCaseId == id) {
      await prefs.remove(_currentCaseIdKey);
    }
  }

  @override
  Future<String?> getCurrentCaseId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentCaseIdKey);
  }

  @override
  Future<void> setCurrentCaseId(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null || id.isEmpty) {
      await prefs.remove(_currentCaseIdKey);
      return;
    }
    await prefs.setString(_currentCaseIdKey, id);
  }
}
