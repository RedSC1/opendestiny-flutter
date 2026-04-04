import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../../providers/input_provider.dart';
import '../../core/l10n.dart'; // ✅ 确保引用了语言定义
import 'bazi_settings_view.dart';
import 'ziwei_settings_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_version.dart';
import '../../core/app_update_service.dart';
import '../../core/web_update_bridge_stub.dart'
    if (dart.library.html) '../../core/web_update_bridge_web.dart'
        as web_update;
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(inputNotifierProvider);
    final settings = ref.watch(appSettingsProvider);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle('界面显示 (Language)'.tr),
        RadioListTile<AppLanguage>(
          title: const Text('简体中文'),
          value: AppLanguage.zhCN,
          groupValue: profile.language,
          onChanged: (val) {
            if (val != null)
              ref.read(inputNotifierProvider.notifier).updateLanguage(val);
          },
        ),
        RadioListTile<AppLanguage>(
          title: const Text('繁體中文'),
          value: AppLanguage.zhTW,
          groupValue: profile.language,
          onChanged: (val) {
            if (val != null)
              ref.read(inputNotifierProvider.notifier).updateLanguage(val);
          },
        ),
        RadioListTile<AppLanguage>(
          title: const Text('English'),
          value: AppLanguage.en,
          groupValue: profile.language,
          onChanged: (val) {
            if (val != null)
              ref.read(inputNotifierProvider.notifier).updateLanguage(val);
          },
        ),

        const Divider(),
        _buildSectionTitle('全局历法配置'.tr),

        SwitchListTile(
          title: Text('真太阳时修正'.tr),
          subtitle: Text('基于地理位置计算平太阳时误差'.tr),
          value: settings.useTrueSolarTime,
          onChanged: (val) =>
              ref.read(inputNotifierProvider.notifier).toggleTrueSolarTime(val),
        ),

        ListTile(
          title: Text('公元前年份显示'.tr),
          trailing: DropdownButton<bool>(
            value: settings.useAstronomicalYear,
            underline: const SizedBox(),
            onChanged: (value) {
              if (value != null) {
                ref.read(inputNotifierProvider.notifier).updateAstronomicalYearMode(value);
              }
            },
            items: [
              DropdownMenuItem(
                value: true,
                child: Text('天文纪年 (包含0年与负数)'.tr),
              ),
              DropdownMenuItem(
                value: false,
                child: Text('历史纪年 (如 BC 100)'.tr),
              ),
            ],
          ),
        ),

        const Divider(),
        _buildSectionTitle('子时处理策略 (影响全站)'.tr),
        RadioListTile<RatHourMode>(
          title: Text('不分早晚子 (传统派)'.tr),
          subtitle: Text('23:00 准时换日'.tr),
          value: RatHourMode.noSplit,
          groupValue: settings.ratHourMode,
          onChanged: (val) {
            if (val != null)
              ref.read(inputNotifierProvider.notifier).updateRatHourMode(val);
          },
        ),
        RadioListTile<RatHourMode>(
          title: Text('晚子算当天 + 明天天干 (主流)'.tr),
          subtitle: Text('00:00 换日，23:00-00:00 借用明天天干'.tr),
          value: RatHourMode.tomorrowGan,
          groupValue: settings.ratHourMode,
          onChanged: (val) {
            if (val != null)
              ref.read(inputNotifierProvider.notifier).updateRatHourMode(val);
          },
        ),
        RadioListTile<RatHourMode>(
          title: Text('晚子算当天 + 今天天干 (古法)'.tr),
          subtitle: Text('00:00 换日，23:00-00:00 使用今天天干'.tr),
          value: RatHourMode.todayGan,
          groupValue: settings.ratHourMode,
          onChanged: (val) {
            if (val != null)
              ref.read(inputNotifierProvider.notifier).updateRatHourMode(val);
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
              MaterialPageRoute(
                builder: (context) => const ZiweiSettingsView(),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.system_update_alt_outlined),
          title: Text('检查更新'.tr),
          subtitle: Text(
            kIsWeb ? '检查网页更新并刷新'.tr : '获取最新版本与下载入口'.tr,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            if (kIsWeb) {
              final result = await web_update.checkForWebUpdate();
              if (!context.mounted) return;

              if (result == 'update') {
                await showDialog<void>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text('发现网页更新'.tr),
                    content: Text('检测到网页更新，刷新后即可使用最新内容。'.tr),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text('稍后'.tr),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          await web_update.activateWebUpdate();
                        },
                        child: Text('立即刷新'.tr),
                      ),
                    ],
                  ),
                );
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result == 'latest'
                        ? '当前已是最新网页版本'.tr
                        : '检查更新失败'.tr,
                  ),
                ),
              );
              return;
            }

            await AppUpdateService.checkAndShowDialog(
              context,
              silentIfLatest: false,
              silentIfError: false,
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text('关于'.tr),
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'OpenDestiny',
              applicationVersion: AppVersion.current,
              applicationIcon: SizedBox(
                width: 64,
                height: 64,
                child: SvgPicture.asset(
                  'assets/images/shubanlogo.svg',
                  fit: BoxFit.contain,
                ),
              ),
              applicationLegalese:
                  'Copyright © 2026 RedSC1\nLicensed under MIT',
              children: [
                const SizedBox(height: 20),
                const Text('开源易学排盘工具，支持八字与紫微斗数。更多功能正在开发中。'),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(
                      'https://github.com/RedSC1/opendestiny-flutter',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Text(
                    'GitHub: https://github.com/RedSC1/opendestiny-flutter',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
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
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
