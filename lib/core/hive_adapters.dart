import 'package:bazi_core/bazi_core.dart';
import 'package:hive_ce/hive.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart' show RatHourMode;

import '../core/l10n.dart';
import '../models/destiny_profile.dart';

const int _birthCalendarTypeTypeId = 0;
const int _genderTypeId = 1;
const int _appLanguageTypeId = 2;
const int _ratHourModeTypeId = 3;
const int _timePackConfigTypeId = 10;
const int _solarBirthInputTypeId = 11;
const int _lunarBirthInputTypeId = 12;
const int _birthInputTypeId = 13;
const int _destinyCaseTypeId = 14;

void registerOpenDestinyHiveAdapters() {
  if (!Hive.isAdapterRegistered(_birthCalendarTypeTypeId)) {
    Hive.registerAdapter(BirthCalendarTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(_genderTypeId)) {
    Hive.registerAdapter(GenderAdapter());
  }
  if (!Hive.isAdapterRegistered(_appLanguageTypeId)) {
    Hive.registerAdapter(AppLanguageAdapter());
  }
  if (!Hive.isAdapterRegistered(_ratHourModeTypeId)) {
    Hive.registerAdapter(RatHourModeAdapter());
  }
  if (!Hive.isAdapterRegistered(_timePackConfigTypeId)) {
    Hive.registerAdapter(TimePackConfigAdapter());
  }
  if (!Hive.isAdapterRegistered(_solarBirthInputTypeId)) {
    Hive.registerAdapter(SolarBirthInputAdapter());
  }
  if (!Hive.isAdapterRegistered(_lunarBirthInputTypeId)) {
    Hive.registerAdapter(LunarBirthInputAdapter());
  }
  if (!Hive.isAdapterRegistered(_birthInputTypeId)) {
    Hive.registerAdapter(BirthInputAdapter());
  }
  if (!Hive.isAdapterRegistered(_destinyCaseTypeId)) {
    Hive.registerAdapter(DestinyCaseAdapter());
  }
}

class BirthCalendarTypeAdapter extends TypeAdapter<BirthCalendarType> {
  @override
  final int typeId = _birthCalendarTypeTypeId;

  @override
  BirthCalendarType read(BinaryReader reader) {
    final raw = reader.read() as String?;
    return BirthCalendarType.values.firstWhere(
      (value) => value.name == raw,
      orElse: () => BirthCalendarType.solar,
    );
  }

  @override
  void write(BinaryWriter writer, BirthCalendarType obj) {
    writer.write(obj.name);
  }
}

class GenderAdapter extends TypeAdapter<Gender> {
  @override
  final int typeId = _genderTypeId;

  @override
  Gender read(BinaryReader reader) {
    final raw = reader.read() as String?;
    return Gender.values.firstWhere(
      (value) => value.name == raw,
      orElse: () => Gender.male,
    );
  }

  @override
  void write(BinaryWriter writer, Gender obj) {
    writer.write(obj.name);
  }
}

class AppLanguageAdapter extends TypeAdapter<AppLanguage> {
  @override
  final int typeId = _appLanguageTypeId;

  @override
  AppLanguage read(BinaryReader reader) {
    final raw = reader.read() as String?;
    return AppLanguage.values.firstWhere(
      (value) => value.name == raw,
      orElse: () => AppLanguage.zhCN,
    );
  }

  @override
  void write(BinaryWriter writer, AppLanguage obj) {
    writer.write(obj.name);
  }
}

class RatHourModeAdapter extends TypeAdapter<RatHourMode> {
  @override
  final int typeId = _ratHourModeTypeId;

  @override
  RatHourMode read(BinaryReader reader) {
    final raw = reader.read() as String?;
    return RatHourMode.values.firstWhere(
      (value) => value.name == raw,
      orElse: () => RatHourMode.noSplit,
    );
  }

  @override
  void write(BinaryWriter writer, RatHourMode obj) {
    writer.write(obj.name);
  }
}

class TimePackConfigAdapter extends TypeAdapter<TimePackConfig> {
  @override
  final int typeId = _timePackConfigTypeId;

  @override
  TimePackConfig read(BinaryReader reader) {
    final fields = _readFields(reader);
    return TimePackConfig(
      longitude: (fields[0] as num?)?.toDouble() ?? 120.0,
      latitude: (fields[1] as num?)?.toDouble() ?? 30.0,
      locationName: fields[2] as String? ?? '中国标准时间',
      timeZone: (fields[3] as num?)?.toDouble() ?? 8.0,
    );
  }

  @override
  void write(BinaryWriter writer, TimePackConfig obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.longitude)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.locationName)
      ..writeByte(3)
      ..write(obj.timeZone);
  }
}

class SolarBirthInputAdapter extends TypeAdapter<SolarBirthInput> {
  @override
  final int typeId = _solarBirthInputTypeId;

  @override
  SolarBirthInput read(BinaryReader reader) {
    final fields = _readFields(reader);
    final now = DateTime.now();
    return SolarBirthInput(
      year: fields[0] as int? ?? now.year,
      month: fields[1] as int? ?? now.month,
      day: fields[2] as int? ?? now.day,
      hour: fields[3] as int? ?? 0,
      minute: fields[4] as int? ?? 0,
      second: fields[5] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, SolarBirthInput obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.hour)
      ..writeByte(4)
      ..write(obj.minute)
      ..writeByte(5)
      ..write(obj.second);
  }
}

class LunarBirthInputAdapter extends TypeAdapter<LunarBirthInput> {
  @override
  final int typeId = _lunarBirthInputTypeId;

  @override
  LunarBirthInput read(BinaryReader reader) {
    final fields = _readFields(reader);
    final now = DateTime.now();
    return LunarBirthInput(
      year: fields[0] as int? ?? now.year,
      month: fields[1] as String? ?? '正',
      day: fields[2] as int? ?? 1,
      hour: fields[3] as int? ?? 0,
      minute: fields[4] as int? ?? 0,
      second: fields[5] as int? ?? 0,
      isLeap: fields[6] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, LunarBirthInput obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.hour)
      ..writeByte(4)
      ..write(obj.minute)
      ..writeByte(5)
      ..write(obj.second)
      ..writeByte(6)
      ..write(obj.isLeap);
  }
}

class BirthInputAdapter extends TypeAdapter<BirthInput> {
  @override
  final int typeId = _birthInputTypeId;

  @override
  BirthInput read(BinaryReader reader) {
    final fields = _readFields(reader);
    return BirthInput(
      calendarType: fields[0] as BirthCalendarType? ?? BirthCalendarType.solar,
      solar: fields[1] as SolarBirthInput? ?? BirthInput.now().solar,
      lunar:
          fields[2] as LunarBirthInput? ??
          const LunarBirthInput(year: 2000, month: '正', day: 1, hour: 12),
      timeConfig: fields[3] as TimePackConfig? ?? const TimePackConfig(),
    );
  }

  @override
  void write(BinaryWriter writer, BirthInput obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.calendarType)
      ..writeByte(1)
      ..write(obj.solar)
      ..writeByte(2)
      ..write(obj.lunar)
      ..writeByte(3)
      ..write(obj.timeConfig);
  }
}

class DestinyCaseAdapter extends TypeAdapter<DestinyCase> {
  @override
  final int typeId = _destinyCaseTypeId;

  @override
  DestinyCase read(BinaryReader reader) {
    final fields = _readFields(reader);
    final now = DateTime.now();
    return DestinyCase(
      id: fields[0] as String? ?? 'default',
      name: fields[1] as String? ?? '未命名案例',
      birthInput: fields[2] as BirthInput? ?? BirthInput.now(),
      gender: fields[3] as Gender? ?? Gender.male,
      note: fields[4] as String? ?? '',
      createdAt: _readDateTime(fields[5], now),
      updatedAt: _readDateTime(fields[6], now),
    );
  }

  @override
  void write(BinaryWriter writer, DestinyCase obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.birthInput)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.createdAt.millisecondsSinceEpoch)
      ..writeByte(6)
      ..write(obj.updatedAt.millisecondsSinceEpoch);
  }
}

Map<int, dynamic> _readFields(BinaryReader reader) {
  final fieldCount = reader.readByte();
  return <int, dynamic>{
    for (var i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
  };
}

DateTime _readDateTime(dynamic value, DateTime fallback) {
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  if (value is String) {
    return DateTime.tryParse(value) ?? fallback;
  }
  return fallback;
}
