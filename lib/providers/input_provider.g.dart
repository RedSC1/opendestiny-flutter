// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appSettingsHash() => r'dd92da0b6c877fec51da4b98ef5c004ccbd34845';

/// See also [appSettings].
@ProviderFor(appSettings)
final appSettingsProvider = AutoDisposeProvider<AppSettings>.internal(
  appSettings,
  name: r'appSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppSettingsRef = AutoDisposeProviderRef<AppSettings>;
String _$currentCaseHash() => r'490f1b8fc93d0ae789724eb3a7b96a102bace978';

/// See also [currentCase].
@ProviderFor(currentCase)
final currentCaseProvider = AutoDisposeProvider<DestinyCase>.internal(
  currentCase,
  name: r'currentCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentCaseRef = AutoDisposeProviderRef<DestinyCase>;
String _$caseSummariesHash() => r'314369c1fdfe13ebcb03394fb4fdb6ad05a55170';

/// See also [caseSummaries].
@ProviderFor(caseSummaries)
final caseSummariesProvider = AutoDisposeProvider<List<CaseSummary>>.internal(
  caseSummaries,
  name: r'caseSummariesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$caseSummariesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CaseSummariesRef = AutoDisposeProviderRef<List<CaseSummary>>;
String _$inputNotifierHash() => r'ebf4770cfb10ee532ee6357ff1961afc9b8a5cf3';

/// See also [InputNotifier].
@ProviderFor(InputNotifier)
final inputNotifierProvider =
    NotifierProvider<InputNotifier, DestinyProfile>.internal(
      InputNotifier.new,
      name: r'inputNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$inputNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$InputNotifier = Notifier<DestinyProfile>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
