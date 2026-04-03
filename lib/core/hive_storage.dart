import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../models/destiny_profile.dart';
import 'hive_adapters.dart';

class HiveStorage {
  static const String settingsBoxName = 'settings_v2';
  static const String casesBoxName = 'cases_v2';
  static const String metaBoxName = 'meta_v2';

  static const String appSettingsKey = 'app_settings';
  static const String currentCaseIdKey = 'current_case_id';

  static Future<void> init() async {
    await Hive.initFlutter();
    registerOpenDestinyHiveAdapters();
    await Future.wait([
      Hive.openBox<String>(settingsBoxName),
      Hive.openBox<DestinyCase>(casesBoxName),
      Hive.openBox<String>(metaBoxName),
    ]);
  }

  static Box<String> get settingsBox => Hive.box<String>(settingsBoxName);

  static Box<DestinyCase> get casesBox => Hive.box<DestinyCase>(casesBoxName);

  static Box<String> get metaBox => Hive.box<String>(metaBoxName);
}
