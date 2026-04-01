import '../models/destiny_profile.dart';
import 'case_storage.dart';

class CaseRepository {
  CaseRepository(this._storage);

  final CaseStorage _storage;

  Future<List<CaseSummary>> listCases() => _storage.listCases();

  Future<DestinyCase?> loadCase(String id) => _storage.loadCase(id);

  Future<DestinyCase> loadCurrentCase() async {
    final currentId = await _storage.getCurrentCaseId();
    if (currentId != null) {
      final current = await _storage.loadCase(currentId);
      if (current != null) {
        return current;
      }
    }

    final summaries = await _storage.listCases();
    if (summaries.isNotEmpty) {
      final first = await _storage.loadCase(summaries.first.id);
      if (first != null) {
        await _storage.setCurrentCaseId(first.id);
        return first;
      }
    }

    return DestinyCase.initial();
  }

  Future<void> saveCurrentCase(DestinyCase caseData) async {
    await _storage.saveCase(caseData);
    await _storage.setCurrentCaseId(caseData.id);
  }

  Future<void> deleteCase(String id) => _storage.deleteCase(id);

  Future<String?> getCurrentCaseId() => _storage.getCurrentCaseId();

  Future<void> setCurrentCaseId(String? id) => _storage.setCurrentCaseId(id);
}
