import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziwei_core/ziwei_core.dart'; // 引入 core 里的 Gender 等定义

part 'birth_data.freezed.dart';
part 'birth_data.g.dart';

@freezed
class BirthData with _$BirthData {
  const factory BirthData({
    required DateTime birthTime, // 出生时间（公历）
    @Default(Gender.male) Gender gender, // 性别
    @Default(120.0) double longitude, // 经度
    @Default(30.0) double latitude, // 纬度
    @Default('北京') String locationName, // 出生地点
    @Default(true) bool isLMT, // 是否开启真太阳时
  }) = _BirthData;

  factory BirthData.fromJson(Map<String, dynamic> json) => _$BirthDataFromJson(json);
}
