import '../models/destiny_profile.dart';
import 'hive_storage.dart';

abstract interface class CaseStorage {
  Future<List<CaseSummary>> listCases();
  Future<DestinyCase?> loadCase(String id);
  Future<void> saveCase(DestinyCase data);
  Future<void> deleteCase(String id);
  Future<String?> getCurrentCaseId();
  Future<void> setCurrentCaseId(String? id);
}

class HiveCaseStorage implements CaseStorage {
  @override
  Future<List<CaseSummary>> listCases() async {
    final summaries = HiveStorage.casesBox.values
        .map((caseData) => caseData.summary)
        .toList(growable: false);
    summaries.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return summaries;
  }

  @override
  Future<DestinyCase?> loadCase(String id) async {
    return HiveStorage.casesBox.get(id);
  }

  @override
  Future<void> saveCase(DestinyCase data) async {
    await HiveStorage.casesBox.put(data.id, data);
  }

  @override
  Future<void> deleteCase(String id) async {
    await HiveStorage.casesBox.delete(id);
    final currentCaseId = HiveStorage.metaBox.get(HiveStorage.currentCaseIdKey);
    if (currentCaseId == id) {
      await HiveStorage.metaBox.delete(HiveStorage.currentCaseIdKey);
    }
  }

  @override
  Future<String?> getCurrentCaseId() async {
    return HiveStorage.metaBox.get(HiveStorage.currentCaseIdKey);
  }

  @override
  Future<void> setCurrentCaseId(String? id) async {
    if (id == null || id.isEmpty) {
      await HiveStorage.metaBox.delete(HiveStorage.currentCaseIdKey);
      return;
    }
    await HiveStorage.metaBox.put(HiveStorage.currentCaseIdKey, id);
  }
}
