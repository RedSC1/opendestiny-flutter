import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/destiny_profile.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import 'package:bazi_core/bazi_core.dart'; // ✅ 补上

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

  /// 更新子时处理模式
  void updateRatHourMode(RatHourMode mode) {
    state = state.copyWith(ratHourMode: mode);
  }

  void updateBaziOptions(BaziOptions options) {
    state = state.copyWith(baziOptions: options);
  }
}
