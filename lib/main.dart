import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/case_library/case_library_view.dart';

import 'package:flutter/foundation.dart';
import 'core/app_update_service.dart';
import 'core/hive_storage.dart';
import 'providers/input_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorage.init();
  LicenseRegistry.addLicense(() {
    return Stream<LicenseEntry>.fromIterable([
      const LicenseEntryWithLineBreaks(
        ['OpenDestiny'],
        '''
MIT License

Copyright (c) 2026 RedSC1

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell

copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.''',
      ),
      const LicenseEntryWithLineBreaks(
        ['AreaCity-JsSpider-StatsGov city coordinate data'],
        '''
This product includes reused city coordinate / administrative division data
derived from the following upstream open-source project:

AreaCity-JsSpider-StatsGov
Source: https://github.com/xiangyuecn/AreaCity-JsSpider-StatsGov
Repository owner: xiangyuecn
License: MIT

The upstream repository is marked as MIT licensed on GitHub. Please refer to
the upstream repository for the latest original source files and license
details.''',
      ),
    ]);
  });
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _startupUpdateChecked = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _runStartupUpdateCheck();
      });
    }
  }

  Future<void> _runStartupUpdateCheck() async {
    if (_startupUpdateChecked || kIsWeb) return;
    _startupUpdateChecked = true;
    await Future<void>.delayed(const Duration(seconds: 2));
    final context = _navigatorKey.currentContext;
    if (!mounted || context == null) return;
    await AppUpdateService.checkAndShowDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(appSettingsProvider);
    final seedColor = Color(appSettings.globalThemeSeedColor);

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'OpenDestiny',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Microsoft YaHei',
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        useMaterial3: true,
      ),
      home: const CaseLibraryView(),
    );
  }
}
