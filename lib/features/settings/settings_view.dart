import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart'; 
import '../../providers/input_provider.dart';
import '../../core/l10n.dart'; // ✅ 确保引用了语言定义
import 'bazi_settings_view.dart';
import 'ziwei_settings_view.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final birthData = ref.watch(inputNotifierProvider);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle('界面显示 (Language)'.tr),
        RadioListTile<AppLanguage>(
          title: const Text('简体中文'),
          value: AppLanguage.zhCN,
          groupValue: birthData.language,
          onChanged: (val) {
            if (val != null) ref.read(inputNotifierProvider.notifier).updateLanguage(val);
          },
        ),
        RadioListTile<AppLanguage>(
          title: const Text('繁體中文'),
          value: AppLanguage.zhTW,
          groupValue: birthData.language,
          onChanged: (val) {
            if (val != null) ref.read(inputNotifierProvider.notifier).updateLanguage(val);
          },
        ),
        RadioListTile<AppLanguage>(
          title: const Text('English'),
          value: AppLanguage.en,
          groupValue: birthData.language,
          onChanged: (val) {
            if (val != null) ref.read(inputNotifierProvider.notifier).updateLanguage(val);
          },
        ),

        const Divider(),
        _buildSectionTitle('全局历法配置'.tr),
        
        SwitchListTile(
          title: Text('真太阳时修正'.tr),
          subtitle: Text('基于地理位置计算平太阳时误差'.tr),
          value: birthData.useTrueSolarTime,
          onChanged: (val) => ref.read(inputNotifierProvider.notifier).toggleTrueSolarTime(val),
        ),

        const Divider(),
        _buildSectionTitle('子时处理策略 (影响全站)'.tr),
        RadioListTile<RatHourMode>(
          title: Text('不分早晚子 (传统派)'.tr),
          subtitle: Text('23:00 准时换日'.tr),
          value: RatHourMode.noSplit,
          groupValue: birthData.ratHourMode,
          onChanged: (val) {
            if (val != null) ref.read(inputNotifierProvider.notifier).updateRatHourMode(val);
          },
        ),
        RadioListTile<RatHourMode>(
          title: Text('晚子算当天 + 明天天干 (主流)'.tr),
          subtitle: Text('00:00 换日，23:00-00:00 借用明天天干'.tr),
          value: RatHourMode.tomorrowGan,
          groupValue: birthData.ratHourMode,
          onChanged: (val) {
            if (val != null) ref.read(inputNotifierProvider.notifier).updateRatHourMode(val);
          },
        ),
        RadioListTile<RatHourMode>(
          title: Text('晚子算当天 + 今天天干 (古法)'.tr),
          subtitle: Text('00:00 换日，23:00-00:00 使用今天天干'.tr),
          value: RatHourMode.todayGan,
          groupValue: birthData.ratHourMode,
          onChanged: (val) {
            if (val != null) ref.read(inputNotifierProvider.notifier).updateRatHourMode(val);
          },
        ),

        const Divider(),
        ListTile(
          title: Text('八字流派设置'.tr),
          subtitle: Text('起运算法、司令分野、土同宫等'.tr),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BaziSettingsView()),
            );
          },
        ),
        ListTile(
          title: Text('紫微流派设置'.tr),
          subtitle: Text('闰月处理、起例基准等'.tr),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ZiweiSettingsView()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }
}
