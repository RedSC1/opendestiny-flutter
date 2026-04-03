import 'dart:convert';

import '../models/destiny_profile.dart';
import 'hive_storage.dart';

class AppSettingsStorage {
  Future<AppSettings?> load() async {
    final raw = HiveStorage.settingsBox.get(HiveStorage.appSettingsKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return null;
      }
      return AppSettings.fromJson(Map<String, dynamic>.from(decoded));
    } catch (_) {
      return null;
    }
  }

  Future<void> save(AppSettings settings) async {
    await HiveStorage.settingsBox.put(
      HiveStorage.appSettingsKey,
      jsonEncode(settings.toJson()),
    );
  }
}
