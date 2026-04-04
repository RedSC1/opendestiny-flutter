import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/case_library/case_library_view.dart';

import 'package:flutter/foundation.dart';
import 'core/app_update_service.dart';
import 'core/hive_storage.dart';

const _fontFamily = 'NotoSansSC';
const _fontFallback = ['NotoSansTC'];

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
    ]);
  });
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    );

    final textTheme = _strengthenTextTheme(
      baseTheme.textTheme.apply(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFallback,
      ),
    );

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'OpenDestiny',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        textTheme: textTheme,
        primaryTextTheme: _strengthenTextTheme(
          baseTheme.primaryTextTheme.apply(
            fontFamily: _fontFamily,
            fontFamilyFallback: _fontFallback,
          ),
        ),
      ),
      home: const CaseLibraryView(),
    );
  }
}

TextTheme _strengthenTextTheme(TextTheme theme) {
  return theme.copyWith(
    bodyLarge: _withWeight(theme.bodyLarge, FontWeight.w500),
    bodyMedium: _withWeight(theme.bodyMedium, FontWeight.w500),
    bodySmall: _withWeight(theme.bodySmall, FontWeight.w500),
    labelLarge: _withWeight(theme.labelLarge, FontWeight.w500),
    labelMedium: _withWeight(theme.labelMedium, FontWeight.w500),
    labelSmall: _withWeight(theme.labelSmall, FontWeight.w500),
    titleLarge: _withWeight(theme.titleLarge, FontWeight.w600),
    titleMedium: _withWeight(theme.titleMedium, FontWeight.w600),
    titleSmall: _withWeight(theme.titleSmall, FontWeight.w600),
    headlineLarge: _withWeight(theme.headlineLarge, FontWeight.w600),
    headlineMedium: _withWeight(theme.headlineMedium, FontWeight.w600),
    headlineSmall: _withWeight(theme.headlineSmall, FontWeight.w600),
  );
}

TextStyle? _withWeight(TextStyle? style, FontWeight weight) {
  if (style == null) return null;
  return style.copyWith(fontWeight: style.fontWeight ?? weight);
}
