import 'dart:convert';

enum ZiweiStarVisibilityMode { full, compact, custom }

enum ZiweiStarVisibilityTarget { sanhe, sihua, flying }

class ZiweiStarVisibilityConfig {
  final List<String> blockedStars;

  const ZiweiStarVisibilityConfig({
    this.blockedStars = const <String>[],
  });

  factory ZiweiStarVisibilityConfig.fromJson(Map<String, dynamic> json) {
    final raw = json['blockedStars'];
    final blockedStars = raw is List
        ? raw.map((item) => item.toString().trim()).where((item) => item.isNotEmpty).toSet().toList()
        : const <String>[];
    blockedStars.sort();
    return ZiweiStarVisibilityConfig(blockedStars: blockedStars);
  }

  Map<String, dynamic> toJson() => {
    'blockedStars': blockedStars,
  };

  Set<String> get blockedStarSet => blockedStars.toSet();

  static String normalizeJson(String jsonText) {
    final decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('root must be object');
    }
    final normalized = ZiweiStarVisibilityConfig.fromJson(decoded);
    return const JsonEncoder.withIndent('  ').convert(normalized.toJson());
  }
}

class ZiweiStarVisibilitySettings {
  final ZiweiStarVisibilityMode sanheMode;
  final ZiweiStarVisibilityMode sihuaMode;
  final ZiweiStarVisibilityMode flyingMode;
  final String customSanheJson;
  final String customSihuaJson;
  final String customFlyingJson;

  const ZiweiStarVisibilitySettings({
    this.sanheMode = ZiweiStarVisibilityMode.full,
    this.sihuaMode = ZiweiStarVisibilityMode.compact,
    this.flyingMode = ZiweiStarVisibilityMode.compact,
    this.customSanheJson = '',
    this.customSihuaJson = '',
    this.customFlyingJson = '',
  });

  ZiweiStarVisibilitySettings copyWith({
    ZiweiStarVisibilityMode? sanheMode,
    ZiweiStarVisibilityMode? sihuaMode,
    ZiweiStarVisibilityMode? flyingMode,
    String? customSanheJson,
    String? customSihuaJson,
    String? customFlyingJson,
  }) {
    return ZiweiStarVisibilitySettings(
      sanheMode: sanheMode ?? this.sanheMode,
      sihuaMode: sihuaMode ?? this.sihuaMode,
      flyingMode: flyingMode ?? this.flyingMode,
      customSanheJson: customSanheJson ?? this.customSanheJson,
      customSihuaJson: customSihuaJson ?? this.customSihuaJson,
      customFlyingJson: customFlyingJson ?? this.customFlyingJson,
    );
  }

  factory ZiweiStarVisibilitySettings.fromJson(Map<String, dynamic> json) {
    return ZiweiStarVisibilitySettings(
      sanheMode: _modeFromJson(json['sanheMode']) ?? ZiweiStarVisibilityMode.full,
      sihuaMode:
          _modeFromJson(json['sihuaMode']) ?? ZiweiStarVisibilityMode.compact,
      flyingMode:
          _modeFromJson(json['flyingMode']) ?? ZiweiStarVisibilityMode.compact,
      customSanheJson: json['customSanheJson'] as String? ?? '',
      customSihuaJson: json['customSihuaJson'] as String? ?? '',
      customFlyingJson: json['customFlyingJson'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'sanheMode': sanheMode.name,
    'sihuaMode': sihuaMode.name,
    'flyingMode': flyingMode.name,
    'customSanheJson': customSanheJson,
    'customSihuaJson': customSihuaJson,
    'customFlyingJson': customFlyingJson,
  };

  ZiweiStarVisibilityMode modeFor(ZiweiStarVisibilityTarget target) {
    switch (target) {
      case ZiweiStarVisibilityTarget.sanhe:
        return sanheMode;
      case ZiweiStarVisibilityTarget.sihua:
        return sihuaMode;
      case ZiweiStarVisibilityTarget.flying:
        return flyingMode;
    }
  }

  String customJsonFor(ZiweiStarVisibilityTarget target) {
    switch (target) {
      case ZiweiStarVisibilityTarget.sanhe:
        return customSanheJson;
      case ZiweiStarVisibilityTarget.sihua:
        return customSihuaJson;
      case ZiweiStarVisibilityTarget.flying:
        return customFlyingJson;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZiweiStarVisibilitySettings &&
          other.sanheMode == sanheMode &&
          other.sihuaMode == sihuaMode &&
          other.flyingMode == flyingMode &&
          other.customSanheJson == customSanheJson &&
          other.customSihuaJson == customSihuaJson &&
          other.customFlyingJson == customFlyingJson;

  @override
  int get hashCode => Object.hash(
    sanheMode,
    sihuaMode,
    flyingMode,
    customSanheJson,
    customSihuaJson,
    customFlyingJson,
  );
}

ZiweiStarVisibilityMode? _modeFromJson(Object? value) {
  switch (value) {
    case 'full':
      return ZiweiStarVisibilityMode.full;
    case 'compact':
      return ZiweiStarVisibilityMode.compact;
    case 'custom':
      return ZiweiStarVisibilityMode.custom;
    default:
      return null;
  }
}
