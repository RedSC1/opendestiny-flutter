// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ziwei_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ziweiRulesetHash() => r'f8ef439c03dacbb89d15c29852bfd8784c6ba299';

/// 1. 负责把 UI 层的 [ZiweiOptions] 转译为底层的 [ZiweiRuleset]
///
/// Copied from [ziweiRuleset].
@ProviderFor(ziweiRuleset)
final ziweiRulesetProvider = AutoDisposeProvider<ZiweiRuleset>.internal(
  ziweiRuleset,
  name: r'ziweiRulesetProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ziweiRulesetHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ZiweiRulesetRef = AutoDisposeProviderRef<ZiweiRuleset>;
String _$originDateHash() => r'23e12bbfb0b5b1a9bd2cf17b73154caa75f278b8';

/// 2. 负责构建底层基准时间 [ZiweiDate]
///
/// Copied from [originDate].
@ProviderFor(originDate)
final originDateProvider = AutoDisposeProvider<ZiweiDate>.internal(
  originDate,
  name: r'originDateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$originDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OriginDateRef = AutoDisposeProviderRef<ZiweiDate>;
String _$ziweiUIManagerHash() => r'7d295a10256d3f2fb8d3100053649543488d335e';

/// 4. 终极状态管家 Manager
/// 接管底部表格的交互，控制流运变更，并将带有流动星曜的动态盘面推给 UI
///
/// Copied from [ZiweiUIManager].
@ProviderFor(ZiweiUIManager)
final ziweiUIManagerProvider =
    AutoDisposeNotifierProvider<ZiweiUIManager, ZiweiUIState>.internal(
      ZiweiUIManager.new,
      name: r'ziweiUIManagerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ziweiUIManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ZiweiUIManager = AutoDisposeNotifier<ZiweiUIState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
