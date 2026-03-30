import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/profile/profile_view.dart';
import 'features/bazi/bazi_view.dart';
import 'features/settings/settings_view.dart';
import 'providers/input_provider.dart'; // ✅ 补上
import 'core/l10n.dart';
// ✅ 补上

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenDestiny',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainEntryPage(),
    );
  }
}

// 使用一个简单的 StateProvider 来管理当前选中的 Tab 索引
final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainEntryPage extends ConsumerWidget {
  const MainEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    // 🚀 重点：监听 profile 变化（包含语言切换），强制触发 UI 刷新
    ref.watch(inputNotifierProvider);

    final List<Widget> pages = [
      const ProfileView(),
      const BaziView(),
      const SettingsView(),
    ];

    final List<String> titles = ['个人资料'.tr, '八字排盘'.tr, '设置'.tr];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) =>
            ref.read(navigationIndexProvider.notifier).state = index,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: '资料'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_awesome),
            label: '八字'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: '设置'.tr,
          ),
        ],
      ),
    );
  }
}
