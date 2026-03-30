import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/profile/profile_view.dart';
import 'features/bazi/bazi_view.dart';
import 'features/settings/settings_view.dart';

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

    final List<Widget> pages = [
      const ProfileView(),
      const BaziView(),
      const SettingsView(),
    ];

    final List<String> titles = ['个人资料', '八字排盘', '系统设置'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(navigationIndexProvider.notifier).state = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '资料',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: '八字',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
