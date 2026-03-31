import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/destiny_profile.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import 'package:bazi_core/bazi_core.dart';
import '../core/l10n.dart'; 

part 'input_provider.g.dart';

@Riverpod(keepAlive: true)
class InputNotifier extends _$InputNotifier {
  @override
  DestinyProfile build() {
    return DestinyProfile(birthTime: DateTime.now());
  }

  void updateBirthTime(DateTime time) {
    state = state.copyWith(birthTime: time);
  }

  void updateGender(Gender gender) {
    state = state.copyWith(gender: gender);
  }

  void updateLocation(double lon, double lat, String name) {
    state = state.copyWith(longitude: lon, latitude: lat, locationName: name);
  }

  void toggleTrueSolarTime(bool value) {
    state = state.copyWith(useTrueSolarTime: value);
  }

  void updateRatHourMode(RatHourMode mode) {
    state = state.copyWith(ratHourMode: mode);
  }

  /// 更新语言并同步翻译引擎
  void updateLanguage(AppLanguage lang) {
    state = state.copyWith(language: lang);
    AppL10nSettings.currentLanguage = lang; // 同步静态变量
  }

  void updateBaziOptions(BaziOptions options) {
    state = state.copyWith(baziOptions: options);
  }

  void updateZiweiOptions(ZiweiOptions options) {
    state = state.copyWith(ziweiOptions: options);
  }
}
