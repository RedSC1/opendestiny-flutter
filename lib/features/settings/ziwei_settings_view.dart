import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../../core/json_text_transfer.dart';
import '../../providers/input_provider.dart';
import '../../models/destiny_profile.dart';
import '../../core/l10n.dart';
import '../../core/ziwei_l10n.dart';

final JsonTextTransfer _jsonTextTransfer = JsonTextTransfer();

class ZiweiSettingsView extends ConsumerWidget {
  const ZiweiSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(inputNotifierProvider);
    final options = profile.ziweiOptions;

    return Scaffold(
      appBar: AppBar(title: Text('紫微排盘流派设置'.tr)),
      body: ListView(
        children: [
          _buildSectionTitle('闰月排法'.tr),
          RadioListTile<LeapMonthRule>(
            title: Text('十五分割法'.tr),
            subtitle: Text('前十五天归上月，后十五天归下月'.tr),
            value: LeapMonthRule.splitAt15,
            groupValue: options.leapRule,
            onChanged: (val) {
              if (val != null) {
                _updateOptions(ref, options.copyWith(leapRule: val));
              }
            },
          ),
          RadioListTile<LeapMonthRule>(
            title: Text('作下月计算'.tr),
            subtitle: Text('闰月整月直接算作下一个月'.tr),
            value: LeapMonthRule.asNext,
            groupValue: options.leapRule,
            onChanged: (val) {
              if (val != null) {
                _updateOptions(ref, options.copyWith(leapRule: val));
              }
            },
          ),
          RadioListTile<LeapMonthRule>(
            title: Text('作本月计算'.tr),
            subtitle: Text('闰月整月算作当月'.tr),
            value: LeapMonthRule.asPrevious,
            groupValue: options.leapRule,
            onChanged: (val) {
              if (val != null) {
                _updateOptions(ref, options.copyWith(leapRule: val));
              }
            },
          ),

          const Divider(),
          _buildSectionTitle('四化基准点'.tr),
          RadioListTile<Boundary>(
            title: Text('四化天干跟随农历'.tr),
            subtitle: Text('传统排法'.tr),
            value: Boundary.lunar,
            groupValue: options.siHuaBasedOn,
            onChanged: (val) {
              if (val != null) {
                _updateOptions(ref, options.copyWith(siHuaBasedOn: val));
              }
            },
          ),
          RadioListTile<Boundary>(
            title: Text('四化天干跟随节气'.tr),
            value: Boundary.solar,
            groupValue: options.siHuaBasedOn,
            onChanged: (val) {
              if (val != null) {
                _updateOptions(ref, options.copyWith(siHuaBasedOn: val));
              }
            },
          ),

          const Divider(),
          _buildSectionTitle('四化流派'.tr),
          RadioListTile<ZiweiSiHuaMode>(
            title: Text('内置规则'.tr),
            subtitle: Text('使用系统默认四化表'.tr),
            value: ZiweiSiHuaMode.builtin,
            groupValue: options.siHuaMode,
            onChanged: (val) {
              if (val != null) {
                _updateOptions(ref, options.copyWith(siHuaMode: val));
              }
            },
          ),
          RadioListTile<ZiweiSiHuaMode>(
            title: Text('自定义规则'.tr),
            subtitle: Text('手动编辑十天干禄权科忌'.tr),
            value: ZiweiSiHuaMode.custom,
            groupValue: options.siHuaMode,
            onChanged: (val) {
              if (val != null) {
                final nextJson = options.customSiHuaJson.isEmpty
                    ? _defaultCustomSiHuaJson()
                    : options.customSiHuaJson;
                _updateOptions(
                  ref,
                  _ensureSiHuaProfiles(
                    options.copyWith(
                      siHuaMode: val,
                      customSiHuaJson: nextJson,
                    ),
                  ),
                );
              }
            },
          ),
          if (options.siHuaMode == ZiweiSiHuaMode.custom)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.auto_fix_high),
                  title: Text('编辑自定义四化流派'.tr),
                  subtitle: Text('进入三级菜单编辑十天干四化规则'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _ZiweiProfileArchivePage(
                          type: ZiweiCustomProfileType.siHua,
                          title: '自定义四化流派'.tr,
                          createDefaultJson: _defaultCustomSiHuaJson,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          const Divider(),
          _buildSectionTitle('命主/身主流派'.tr),
          RadioListTile<ZiweiMastersMode>(
            title: Text('内置规则'.tr),
            subtitle: Text('使用系统默认命主身主起例'.tr),
            value: ZiweiMastersMode.builtin,
            groupValue: options.mastersMode,
            onChanged: (val) {
              if (val != null) {
                _updateOptions(ref, options.copyWith(mastersMode: val));
              }
            },
          ),
          RadioListTile<ZiweiMastersMode>(
            title: Text('自定义规则'.tr),
            subtitle: Text('手动编辑命主身主起法与身主年支边界'.tr),
            value: ZiweiMastersMode.custom,
            groupValue: options.mastersMode,
            onChanged: (val) {
              if (val != null) {
                final nextJson = options.customMastersJson.isEmpty
                    ? _defaultCustomMastersJson()
                    : options.customMastersJson;
                _updateOptions(
                  ref,
                  _ensureMastersProfiles(
                    options.copyWith(
                      mastersMode: val,
                      customMastersJson: nextJson,
                    ),
                  ),
                );
              }
            },
          ),
          if (options.mastersMode == ZiweiMastersMode.custom)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.account_tree_outlined),
                  title: Text('编辑自定义命主身主流派'.tr),
                  subtitle: Text('进入三级菜单编辑命主、身主与年支边界'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _ZiweiProfileArchivePage(
                          type: ZiweiCustomProfileType.masters,
                          title: '自定义命主身主流派'.tr,
                          createDefaultJson: _defaultCustomMastersJson,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          const Divider(),
          _buildSectionTitle('亮度流派'.tr),
          RadioListTile<ZiweiBrightnessMode>(
            title: Text('内置规则'.tr),
            subtitle: Text('使用系统默认星曜亮度表'.tr),
            value: ZiweiBrightnessMode.builtin,
            groupValue: options.brightnessMode,
            onChanged: (val) {
              if (val != null) {
                _updateOptions(ref, options.copyWith(brightnessMode: val));
              }
            },
          ),
          RadioListTile<ZiweiBrightnessMode>(
            title: Text('自定义规则'.tr),
            subtitle: Text('手动编辑星曜亮度表与标签'.tr),
            value: ZiweiBrightnessMode.custom,
            groupValue: options.brightnessMode,
            onChanged: (val) {
              if (val != null) {
                final nextJson = options.customBrightnessJson.isEmpty
                    ? _defaultCustomBrightnessJson()
                    : options.customBrightnessJson;
                _updateOptions(
                  ref,
                  _ensureBrightnessProfiles(
                    options.copyWith(
                      brightnessMode: val,
                      customBrightnessJson: nextJson,
                    ),
                  ),
                );
              }
            },
          ),
          if (options.brightnessMode == ZiweiBrightnessMode.custom)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.tune),
                  title: Text('编辑自定义亮度流派'.tr),
                  subtitle: Text('进入三级菜单编辑亮度标签与星曜亮度'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _ZiweiProfileArchivePage(
                          type: ZiweiCustomProfileType.brightness,
                          title: '自定义亮度流派'.tr,
                          createDefaultJson: _defaultCustomBrightnessJson,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          const Divider(),
          _buildSectionTitle('星曜流派'.tr),
          RadioListTile<ZiweiStarsMode>(
            title: Text('内置规则'.tr),
            subtitle: Text('使用系统默认星曜安星规则'.tr),
            value: ZiweiStarsMode.builtin,
            groupValue: options.starsMode,
            onChanged: (val) {
              if (val != null) {
                _updateOptions(ref, options.copyWith(starsMode: val));
              }
            },
          ),
          RadioListTile<ZiweiStarsMode>(
            title: Text('自定义规则'.tr),
            subtitle: Text('手动编辑 stars.json 覆盖安星规则'.tr),
            value: ZiweiStarsMode.custom,
            groupValue: options.starsMode,
            onChanged: (val) {
              if (val != null) {
                final nextJson = options.customStarsJson.isEmpty
                    ? _defaultCustomStarsJson()
                    : options.customStarsJson;
                _updateOptions(
                  ref,
                  _ensureStarsProfiles(
                    options.copyWith(
                      starsMode: val,
                      customStarsJson: nextJson,
                    ),
                  ),
                );
              }
            },
          ),
          if (options.starsMode == ZiweiStarsMode.custom)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.auto_awesome),
                  title: Text('编辑自定义星曜流派'.tr),
                  subtitle: Text('进入三级菜单以 JSON 覆盖星曜安星规则'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _ZiweiProfileArchivePage(
                          type: ZiweiCustomProfileType.stars,
                          title: '自定义星曜流派'.tr,
                          createDefaultJson: _defaultCustomStarsJson,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          const Divider(),
          _buildSectionTitle('童限排法'.tr),
          RadioListTile<ChildhoodRole>(
            title: Text('一岁一宫顺行'.tr),
            value: ChildhoodRole.regular,
            groupValue: options.childhoodRule,
            onChanged: (val) {
              if (val != null) {
                _updateOptions(ref, options.copyWith(childhoodRule: val));
              }
            },
          ),
          RadioListTile<ChildhoodRole>(
            title: Text('一命二财三疾厄'.tr),
            value: ChildhoodRole.skip,
            groupValue: options.childhoodRule,
            onChanged: (val) {
              if (val != null) {
                _updateOptions(ref, options.copyWith(childhoodRule: val));
              }
            },
          ),

          const Divider(),
          _buildSectionTitle('三合盘设置'.tr),
          SwitchListTile(
            title: Text('中宫显示八字'.tr),
            value: options.showCenterBazi,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(showCenterBazi: value),
              );
            },
          ),
          SwitchListTile(
            title: Text('显示身宫'.tr),
            value: options.showBodyPalace,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(showBodyPalace: value),
              );
            },
          ),
          SwitchListTile(
            title: Text('显示来因宫'.tr),
            value: options.showLaiYinPalace,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(showLaiYinPalace: value),
              );
            },
          ),
          SwitchListTile(
            title: Text('显示流运博士十二神'.tr),
            value: options.flowStarDisplay.showBoshi12,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(
                  flowStarDisplay: options.flowStarDisplay.copyWith(
                    showBoshi12: value,
                  ),
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text('显示流运岁建十二神'.tr),
            value: options.flowStarDisplay.showSuijian12,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(
                  flowStarDisplay: options.flowStarDisplay.copyWith(
                    showSuijian12: value,
                  ),
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text('显示流运将前十二神'.tr),
            value: options.flowStarDisplay.showJiangqian12,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(
                  flowStarDisplay: options.flowStarDisplay.copyWith(
                    showJiangqian12: value,
                  ),
                ),
              );
            },
          ),

          const Divider(),
          _buildSectionTitle('四化盘设置'.tr),
          SwitchListTile(
            title: Text('中宫显示八字'.tr),
            value: options.sihuaDisplay.showCenterBazi,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(
                  sihuaDisplay: options.sihuaDisplay.copyWith(
                    showCenterBazi: value,
                  ),
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text('显示身宫'.tr),
            value: options.sihuaDisplay.showBodyPalace,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(
                  sihuaDisplay: options.sihuaDisplay.copyWith(
                    showBodyPalace: value,
                  ),
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text('显示来因宫'.tr),
            value: options.sihuaDisplay.showLaiYinPalace,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(
                  sihuaDisplay: options.sihuaDisplay.copyWith(
                    showLaiYinPalace: value,
                  ),
                ),
              );
            },
          ),

          const Divider(),
          _buildSectionTitle('飞星盘设置'.tr),
          SwitchListTile(
            title: Text('中宫显示八字'.tr),
            value: options.flyingDisplay.showCenterBazi,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(
                  flyingDisplay: options.flyingDisplay.copyWith(
                    showCenterBazi: value,
                  ),
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text('显示身宫'.tr),
            value: options.flyingDisplay.showBodyPalace,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(
                  flyingDisplay: options.flyingDisplay.copyWith(
                    showBodyPalace: value,
                  ),
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text('显示来因宫'.tr),
            value: options.flyingDisplay.showLaiYinPalace,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(
                  flyingDisplay: options.flyingDisplay.copyWith(
                    showLaiYinPalace: value,
                  ),
                ),
              );
            },
          ),

          const Divider(),
          _buildSectionTitle('动效'.tr),
          SwitchListTile(
            title: Text('启用飞星四化框'.tr),
            value: options.animation.enableFlyingStarHighlightFrame,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(
                  animation: options.animation.copyWith(
                    enableFlyingStarHighlightFrame: value,
                  ),
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text('启用飞星箭头'.tr),
            value: options.animation.enableFlyingStarArrow,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(
                  animation: options.animation.copyWith(
                    enableFlyingStarArrow: value,
                  ),
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text('宫位高亮特效'.tr),
            subtitle: Text('控制选中宫位与三方四正的发光和内描边'.tr),
            value: options.animation.enablePalaceHighlightEffect,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(
                  animation: options.animation.copyWith(
                    enablePalaceHighlightEffect: value,
                  ),
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text('隐藏生辰信息'.tr),
            subtitle: Text('隐藏公历、真太阳时、农历'.tr),
            value: options.hideCenterBirthInfo,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(hideCenterBirthInfo: value),
              );
            },
          ),

          const Divider(),
          _buildSectionTitle('实验性功能 (谨慎修改)'.tr),

          SwitchListTile(
            title: Text('历史历法保护'.tr),
            subtitle: Text('历史红区时熔断流月及以下层级'.tr),
            value: options.enableHistorical,
            onChanged: (value) {
              _updateOptions(
                ref,
                options.copyWith(enableHistorical: value),
              );
            },
          ),
          ExpansionTile(
            title: Text('更多高级排法设置'.tr),
            leading: const Icon(Icons.science_outlined, color: Colors.orange),
            children: [
              _buildSubsectionTitle('五虎遁基准点'.tr),
              RadioListTile<Boundary>(
                title: Text('十二建星宫干跟随农历'.tr),
                value: Boundary.lunar,
                groupValue: options.wuHuDunBasedOn,
                onChanged: (val) {
                  if (val != null) {
                    _updateOptions(ref, options.copyWith(wuHuDunBasedOn: val));
                  }
                },
              ),
              RadioListTile<Boundary>(
                title: Text('十二建星宫干跟随节气'.tr),
                value: Boundary.solar,
                groupValue: options.wuHuDunBasedOn,
                onChanged: (val) {
                  if (val != null) {
                    _updateOptions(ref, options.copyWith(wuHuDunBasedOn: val));
                  }
                },
              ),
              const Divider(indent: 16, endIndent: 16),
              _buildSubsectionTitle('流运起例基准 (流动线)'.tr),
              RadioListTile<Boundary>(
                title: Text('流运是以农历为界'.tr),
                subtitle: Text('初一换月，正一换年'.tr),
                value: Boundary.lunar,
                groupValue: options.flowLimitBasedOn,
                onChanged: (val) {
                  if (val != null) {
                    _updateOptions(
                      ref,
                      options.copyWith(flowLimitBasedOn: val),
                    );
                  }
                },
              ),
              RadioListTile<Boundary>(
                title: Text('流运是以节气为界'.tr),
                subtitle: Text('交节换月，立春换年'.tr),
                value: Boundary.solar,
                groupValue: options.flowLimitBasedOn,
                onChanged: (val) {
                  if (val != null) {
                    _updateOptions(
                      ref,
                      options.copyWith(flowLimitBasedOn: val),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _defaultCustomSiHua() {
    return {
      for (final gan in TianGan.values)
        gan.name: {'lu': '', 'quan': '', 'ke': '', 'ji': ''},
    };
  }

  String _defaultCustomSiHuaJson() {
    return const JsonEncoder.withIndent('  ').convert(_defaultCustomSiHua());
  }

  String _defaultCustomMastersJson() {
    final defaultRuleset = ConfigLoader.getDefault();
    final payload = {
      'ming_zhu': {
        'boundary': defaultRuleset.mingZhuRule?.boundary.name ?? 'lunar',
        'table': {
          for (final entry in (defaultRuleset.mingZhuRule?.table.entries ?? const <MapEntry<int, String>>[]))
            entry.key.toString(): entry.value,
        },
      },
      'shen_zhu': {
        'boundary': defaultRuleset.shenZhuRule?.boundary.name ?? 'lunar',
        'table': {
          for (final entry in (defaultRuleset.shenZhuRule?.table.entries ?? const <MapEntry<int, String>>[]))
            entry.key.toString(): entry.value,
        },
      },
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  String _defaultCustomBrightnessJson() {
    final defaultRuleset = ConfigLoader.getDefault();
    final payload = {
      'brightness_labels': {
        for (final entry in defaultRuleset.brightnessLabels.entries)
          entry.key.toString(): entry.value,
      },
      'static_stars': {
        for (final star in defaultRuleset.stars) star.key: star.brightnessTable,
      },
      'flow_stars': {
        for (final flow in defaultRuleset.flowDefinitions)
          flow.key: flow.brightness,
      },
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  String _defaultCustomStarsJson() {
    final defaultRuleset = ConfigLoader.getDefault();
    final payload = defaultRuleset.stars.map(_serializeStaticStarConfig).toList();
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  ZiweiOptions _ensureSiHuaProfiles(ZiweiOptions options) {
    if (options.siHuaProfiles.isNotEmpty) return options;
    final now = DateTime.now();
    final profile = ZiweiCustomProfile(
      id: 'sihua_${now.microsecondsSinceEpoch}',
      name: '默认四化流派'.tr,
      json: options.customSiHuaJson,
      createdAt: now,
      updatedAt: now,
    );
    return options.copyWith(
      siHuaProfiles: [profile],
      activeSiHuaProfileId: profile.id,
    );
  }

  ZiweiOptions _ensureBrightnessProfiles(ZiweiOptions options) {
    if (options.brightnessProfiles.isNotEmpty) return options;
    final now = DateTime.now();
    final profile = ZiweiCustomProfile(
      id: 'brightness_${now.microsecondsSinceEpoch}',
      name: '默认亮度流派'.tr,
      json: options.customBrightnessJson,
      createdAt: now,
      updatedAt: now,
    );
    return options.copyWith(
      brightnessProfiles: [profile],
      activeBrightnessProfileId: profile.id,
    );
  }

  ZiweiOptions _ensureMastersProfiles(ZiweiOptions options) {
    if (options.mastersProfiles.isNotEmpty) return options;
    final now = DateTime.now();
    final profile = ZiweiCustomProfile(
      id: 'masters_${now.microsecondsSinceEpoch}',
      name: '默认命主身主流派'.tr,
      json: options.customMastersJson,
      createdAt: now,
      updatedAt: now,
    );
    return options.copyWith(
      mastersProfiles: [profile],
      activeMastersProfileId: profile.id,
    );
  }

  ZiweiOptions _ensureStarsProfiles(ZiweiOptions options) {
    if (options.starsProfiles.isNotEmpty) return options;
    final now = DateTime.now();
    final profile = ZiweiCustomProfile(
      id: 'stars_${now.microsecondsSinceEpoch}',
      name: '默认星曜流派'.tr,
      json: options.customStarsJson,
      createdAt: now,
      updatedAt: now,
    );
    return options.copyWith(
      starsProfiles: [profile],
      activeStarsProfileId: profile.id,
    );
  }

  void _updateOptions(WidgetRef ref, ZiweiOptions newOptions) {
    ref.read(inputNotifierProvider.notifier).updateZiweiOptions(newOptions);
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
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

  Widget _buildSubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

bool _isProtectedZiweiProfile(
  ZiweiCustomProfileType type,
  ZiweiCustomProfile profile,
) {
  return (type == ZiweiCustomProfileType.siHua
          ? const {'默认四化流派', '默認四化流派', 'Default SiHua Profile'}
          : type == ZiweiCustomProfileType.masters
          ? const {
              '默认命主身主流派',
              '默認命主身主流派',
              'Default Masters Profile',
            }
          : type == ZiweiCustomProfileType.brightness
          ? const {
              '默认亮度流派',
              '默認亮度流派',
              'Default Brightness Profile',
            }
          : const {'默认星曜流派', '默認星曜流派', 'Default Stars Profile'})
      .contains(profile.name);
}

String _normalizeZiweiProfileJson(
  ZiweiCustomProfileType type,
  String jsonText,
) {
  const encoder = JsonEncoder.withIndent('  ');
  final baseRuleset = ConfigLoader.getDefault();

  if (type == ZiweiCustomProfileType.siHua) {
    final decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, dynamic>) {
      throw FormatException('四化 JSON 根节点必须是对象'.tr);
    }
    ConfigLoader.overrideWith(baseRuleset, sihuaJson: jsonText);
    return encoder.convert(decoded);
  }

  if (type == ZiweiCustomProfileType.masters) {
    final decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, dynamic>) {
      throw FormatException('命主/身主 JSON 根节点必须是对象'.tr);
    }
    ConfigLoader.overrideWith(baseRuleset, mastersJson: jsonText);
    return encoder.convert(decoded);
  }

  if (type == ZiweiCustomProfileType.brightness) {
    final decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, dynamic>) {
      throw FormatException('亮度 JSON 根节点必须是对象'.tr);
    }
    ConfigLoader.overrideWith(baseRuleset, brightnessJson: jsonText);
    return encoder.convert(decoded);
  }

  final decoded = jsonDecode(jsonText);
  if (decoded is! List) {
    throw FormatException('星曜 JSON 根节点必须是数组'.tr);
  }
  ConfigLoader.overrideWith(baseRuleset, starsJson: jsonText);
  return encoder.convert(decoded);
}

String _ziweiProfileFilePrefix(ZiweiCustomProfileType type) {
  switch (type) {
    case ZiweiCustomProfileType.siHua:
      return 'sihua_profile';
    case ZiweiCustomProfileType.masters:
      return 'masters_profile';
    case ZiweiCustomProfileType.brightness:
      return 'brightness_profile';
    case ZiweiCustomProfileType.stars:
      return 'stars_profile';
  }
}

String _defaultImportedZiweiProfileName(ZiweiCustomProfileType type) {
  switch (type) {
    case ZiweiCustomProfileType.siHua:
      return '导入四化流派'.tr;
    case ZiweiCustomProfileType.masters:
      return '导入命主身主流派'.tr;
    case ZiweiCustomProfileType.brightness:
      return '导入亮度流派'.tr;
    case ZiweiCustomProfileType.stars:
      return '导入星曜流派'.tr;
  }
}

class _ZiweiProfileArchivePage extends ConsumerWidget {
  const _ZiweiProfileArchivePage({
    required this.type,
    required this.title,
    required this.createDefaultJson,
  });

  final ZiweiCustomProfileType type;
  final String title;
  final String Function() createDefaultJson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(appSettingsProvider).ziweiOptions;
    final profiles = type == ZiweiCustomProfileType.siHua
        ? options.siHuaProfiles
        : type == ZiweiCustomProfileType.masters
        ? options.mastersProfiles
        : type == ZiweiCustomProfileType.brightness
        ? options.brightnessProfiles
        : options.starsProfiles;
    final activeId = type == ZiweiCustomProfileType.siHua
        ? options.activeSiHuaProfileId
        : type == ZiweiCustomProfileType.masters
        ? options.activeMastersProfileId
        : type == ZiweiCustomProfileType.brightness
        ? options.activeBrightnessProfileId
        : options.activeStarsProfileId;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: '导入 JSON'.tr,
            icon: const Icon(Icons.file_open_outlined),
            onPressed: () => _importProfileJson(context, ref),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          final selected = profile.id == activeId;
          final locked = _isProtectedZiweiProfile(type, profile);
          return _ZiweiProfileTile(
            title: profile.name,
            subtitle: selected ? '当前启用'.tr : '更新时间'.tr,
            selected: selected,
            onTap: () async {
              ref.read(inputNotifierProvider.notifier).setActiveZiweiCustomProfile(
                type: type,
                id: profile.id,
              );
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => _buildProfileEditorPage(
                    context,
                    ref,
                    profile,
                    locked,
                  ),
                ),
              );
            },
            onRename: locked ? null : () => _showRenameDialog(context, ref, profile),
            onDuplicate: () {
              ref.read(inputNotifierProvider.notifier).duplicateZiweiCustomProfile(
                type: type,
                id: profile.id,
              );
            },
            onDelete: locked ? null : () => _confirmDelete(context, ref, profile),
            onSelect: selected
                ? null
                : () {
                    ref
                        .read(inputNotifierProvider.notifier)
                        .setActiveZiweiCustomProfile(type: type, id: profile.id);
                  },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(inputNotifierProvider.notifier).createZiweiCustomProfile(
            type: type,
            name: type == ZiweiCustomProfileType.siHua
                ? '新建四化流派'.tr
                : type == ZiweiCustomProfileType.masters
                ? '新建命主身主流派'.tr
                : type == ZiweiCustomProfileType.brightness
                ? '新建亮度流派'.tr
                : '新建星曜流派'.tr,
            json: createDefaultJson(),
          );
        },
        icon: const Icon(Icons.add),
        label: Text('新建流派'.tr),
      ),
    );
  }

  Widget _buildProfileEditorPage(
    BuildContext context,
    WidgetRef ref,
    ZiweiCustomProfile profile,
    bool locked,
  ) {
    void onChanged(String json) {
      ref.read(inputNotifierProvider.notifier).saveZiweiCustomProfileJson(
        type: type,
        id: profile.id,
        json: json,
      );
    }

    Future<void> onExport(String json) {
      return _exportProfileJson(context, profile.name, json);
    }

    Future<void> onShare(String json) {
      return _shareProfileJson(context, profile.name, json);
    }

    if (type == ZiweiCustomProfileType.siHua) {
      return _SiHuaProfileEditorPage(
        profileName: profile.name,
        initialJson: profile.json,
        readOnly: locked,
        onChanged: onChanged,
        onExport: onExport,
        onShare: onShare,
      );
    }
    if (type == ZiweiCustomProfileType.masters) {
      return _MastersProfileEditorPage(
        profileName: profile.name,
        initialJson: profile.json,
        readOnly: locked,
        onChanged: onChanged,
        onExport: onExport,
        onShare: onShare,
      );
    }
    if (type == ZiweiCustomProfileType.brightness) {
      return _BrightnessProfileEditorPage(
        profileName: profile.name,
        initialJson: profile.json,
        readOnly: locked,
        onChanged: onChanged,
        onExport: onExport,
        onShare: onShare,
      );
    }
    return _StarsProfileEditorPage(
      profileName: profile.name,
      initialJson: profile.json,
      readOnly: locked,
      onChanged: onChanged,
      onExport: onExport,
      onShare: onShare,
    );
  }

  Future<void> _importProfileJson(BuildContext context, WidgetRef ref) async {
    try {
      final jsonText = await _jsonTextTransfer.pickJsonText();
      if (jsonText == null || jsonText.trim().isEmpty) {
        return;
      }
      final normalized = _normalizeZiweiProfileJson(type, jsonText);
      ref.read(inputNotifierProvider.notifier).createZiweiCustomProfile(
        type: type,
        name: _defaultImportedZiweiProfileName(type),
        json: normalized,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已导入流派'.tr)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'导入流派失败：'.tr}$e')),
        );
      }
    }
  }

  Future<void> _exportProfileJson(
    BuildContext context,
    String profileName,
    String jsonText,
  ) async {
    try {
      await _jsonTextTransfer.exportJsonText(
        fileName:
            '${_ziweiProfileFilePrefix(type)}_${_jsonTextTransfer.sanitizeFileName(profileName)}',
        jsonText: jsonText,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'已导出流派：'.tr}$profileName')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'导出流派失败：'.tr}$e')),
        );
      }
    }
  }

  Future<void> _shareProfileJson(
    BuildContext context,
    String profileName,
    String jsonText,
  ) async {
    try {
      await _jsonTextTransfer.shareJsonText(
        fileName:
            '${_ziweiProfileFilePrefix(type)}_${_jsonTextTransfer.sanitizeFileName(profileName)}',
        jsonText: jsonText,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'已打开分享面板：'.tr}$profileName')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'分享流派失败：'.tr}$e')),
        );
      }
    }
  }

  Future<void> _showRenameDialog(
    BuildContext context,
    WidgetRef ref,
    ZiweiCustomProfile profile,
  ) async {
    final controller = TextEditingController(text: profile.name);
    final next = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('重命名流派'.tr),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text('保存'.tr),
          ),
        ],
      ),
    );
    if (next == null || next.isEmpty) return;
    ref.read(inputNotifierProvider.notifier).renameZiweiCustomProfile(
      type: type,
      id: profile.id,
      name: next,
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ZiweiCustomProfile profile,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('删除流派'.tr),
        content: Text('${'确定要删除「'.tr}${profile.name}${'」吗？'.tr}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('删除'.tr),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    ref.read(inputNotifierProvider.notifier).deleteZiweiCustomProfile(
      type: type,
      id: profile.id,
    );
  }
}

class _ZiweiProfileTile extends StatelessWidget {
  const _ZiweiProfileTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.onRename,
    required this.onDuplicate,
    required this.onDelete,
    required this.onSelect,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onRename;
  final VoidCallback onDuplicate;
  final VoidCallback? onDelete;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: selected ? Colors.deepPurple.withValues(alpha: 0.08) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? Colors.deepPurple : Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      color: selected ? Colors.deepPurple : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.deepPurple : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(subtitle),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (onSelect != null)
                      TextButton(
                        onPressed: onSelect,
                        child: Text('设为当前'.tr),
                      ),
                    if (onRename != null)
                      TextButton(
                        onPressed: onRename,
                        child: Text('重命名流派'.tr),
                      ),
                    TextButton(
                      onPressed: onDuplicate,
                      child: Text('复制流派'.tr),
                    ),
                    const Spacer(),
                    if (onDelete != null)
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline),
                        tooltip: '删除'.tr,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StarsProfileEditorPage extends StatefulWidget {
  const _StarsProfileEditorPage({
    required this.profileName,
    required this.initialJson,
    required this.readOnly,
    required this.onChanged,
    required this.onExport,
    required this.onShare,
  });

  final String profileName;
  final String initialJson;
  final bool readOnly;
  final ValueChanged<String> onChanged;
  final Future<void> Function(String json) onExport;
  final Future<void> Function(String json) onShare;

  @override
  State<_StarsProfileEditorPage> createState() => _StarsProfileEditorPageState();
}

class _StarsProfileEditorPageState extends State<_StarsProfileEditorPage> {
  late String _json;

  @override
  void initState() {
    super.initState();
    _json = widget.initialJson;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑自定义星曜流派'.tr),
        actions: [
          IconButton(
            tooltip: '分享 JSON'.tr,
            icon: const Icon(Icons.share_outlined),
            onPressed: () => widget.onShare(_json),
          ),
          IconButton(
            tooltip: '导出 JSON'.tr,
            icon: const Icon(Icons.download_outlined),
            onPressed: () => widget.onExport(_json),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _CustomStarsJsonEditor(
                initialJson: _json,
                readOnly: widget.readOnly,
                onChanged: (json) {
                  setState(() {
                    _json = json;
                  });
                  widget.onChanged(json);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomStarsJsonEditor extends StatefulWidget {
  const _CustomStarsJsonEditor({
    required this.initialJson,
    required this.readOnly,
    required this.onChanged,
  });

  final String initialJson;
  final bool readOnly;
  final ValueChanged<String> onChanged;

  @override
  State<_CustomStarsJsonEditor> createState() => _CustomStarsJsonEditorState();
}

class _CustomStarsJsonEditorState extends State<_CustomStarsJsonEditor> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialJson);
  }

  @override
  void didUpdateWidget(covariant _CustomStarsJsonEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialJson != oldWidget.initialJson &&
        widget.initialJson != _controller.text) {
      _controller.text = widget.initialJson;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is! List) {
        throw const FormatException('root must be list');
      }
      ConfigLoader.overrideWith(
        ConfigLoader.getDefault(),
        starsJson: value,
      );
      setState(() {
        _error = null;
      });
      widget.onChanged(value);
    } catch (_) {
      setState(() {
        _error = '星曜 JSON 格式无效'.tr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      minLines: 16,
      maxLines: 24,
      readOnly: widget.readOnly,
      onChanged: widget.readOnly ? null : _handleChanged,
      decoration: InputDecoration(
        hintText:
            '[\n  {\n    "key": "ziwei",\n    "type": "major",\n    "rule": {\n      "type": "constant",\n      "value": 0\n    }\n  }\n]',
        border: const OutlineInputBorder(),
        errorText: _error,
        alignLabelWithHint: true,
      ),
      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
    );
  }
}

class _SiHuaProfileEditorPage extends StatefulWidget {
  const _SiHuaProfileEditorPage({
    required this.profileName,
    required this.initialJson,
    required this.readOnly,
    required this.onChanged,
    required this.onExport,
    required this.onShare,
  });

  final String profileName;
  final String initialJson;
  final bool readOnly;
  final ValueChanged<String> onChanged;
  final Future<void> Function(String json) onExport;
  final Future<void> Function(String json) onShare;

  @override
  State<_SiHuaProfileEditorPage> createState() =>
      _SiHuaProfileEditorPageState();
}

class _SiHuaProfileEditorPageState extends State<_SiHuaProfileEditorPage> {
  late String _json;
  bool _jsonMode = false;

  @override
  void initState() {
    super.initState();
    _json = widget.initialJson;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑自定义四化流派'.tr),
        actions: [
          IconButton(
            tooltip: '分享 JSON'.tr,
            icon: const Icon(Icons.share_outlined),
            onPressed: () => widget.onShare(_json),
          ),
          IconButton(
            tooltip: '导出 JSON'.tr,
            icon: const Icon(Icons.download_outlined),
            onPressed: () => widget.onExport(_json),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _jsonMode = !_jsonMode;
              });
            },
            child: Text((_jsonMode ? '表格编辑' : 'JSON 编辑').tr),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _jsonMode
                  ? _CustomSiHuaJsonEditor(
                      initialJson: _json,
                      readOnly: widget.readOnly,
                      onChanged: (json) {
                        setState(() {
                          _json = json;
                        });
                        widget.onChanged(json);
                      },
                    )
                  : _CustomSiHuaEditor(
                      initialJson: _json,
                      readOnly: widget.readOnly,
                      onChanged: (json) {
                        setState(() {
                          _json = json;
                        });
                        widget.onChanged(json);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSiHuaEditor extends StatefulWidget {
  const _CustomSiHuaEditor({
    required this.initialJson,
    required this.readOnly,
    required this.onChanged,
  });

  final String initialJson;
  final bool readOnly;
  final ValueChanged<String> onChanged;

  @override
  State<_CustomSiHuaEditor> createState() => _CustomSiHuaEditorState();
}

class _CustomSiHuaEditorState extends State<_CustomSiHuaEditor> {
  static const _sihuaKeys = ['lu', 'quan', 'ke', 'ji'];
  late Map<String, dynamic> _data;

  @override
  void initState() {
    super.initState();
    _data = widget.initialJson.isEmpty
        ? {
            for (final gan in TianGan.values)
              gan.name: {'lu': '', 'quan': '', 'ke': '', 'ji': ''},
          }
        : Map<String, dynamic>.from(jsonDecode(widget.initialJson));
  }

  Map<String, dynamic> _rowFor(String ganKey) {
    return Map<String, dynamic>.from(
      (_data[ganKey] as Map?) ?? {'lu': '', 'quan': '', 'ke': '', 'ji': ''},
    );
  }

  void _updateGanRule(String ganKey, String key, String value) {
    setState(() {
      final row = _rowFor(ganKey);
      row[key] = value;
      _data[ganKey] = row;
    });
    widget.onChanged(jsonEncode(_data));
  }

  String _summaryFor(Map<String, dynamic> row) {
    return _sihuaKeys
        .map((key) {
          final type = SiHuaType.fromJson(key);
          final value = (row[key] ?? '').toString();
          return '${type.display} ${value.isEmpty ? '未设置'.tr : value.nodeDisplay}';
        })
        .join('  ');
  }

  @override
  Widget build(BuildContext context) {
    final defaultRuleset = ConfigLoader.getDefault();
    final starOptions =
        defaultRuleset.stars
            .where(
              (e) =>
                  e.type == StarType.major ||
                  e.type == StarType.lucky ||
                  e.type == StarType.bad,
            )
            .map((e) => e.key)
            .toList()
          ..sort();

    return Column(
      children: TianGan.values.map((gan) {
        final ganKey = gan.name;
        final row = _rowFor(ganKey);
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(
              gan.display,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(_summaryFor(row)),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => _SiHuaGanEditorPage(
                    title: gan.display,
                    row: row,
                    readOnly: widget.readOnly,
                    starOptions: starOptions,
                    onChanged: (key, value) =>
                        _updateGanRule(ganKey, key, value),
                  ),
                ),
              );
              if (mounted) {
                setState(() {});
              }
            },
          ),
        );
      }).toList(),
    );
  }
}

class _CustomSiHuaJsonEditor extends StatefulWidget {
  const _CustomSiHuaJsonEditor({
    required this.initialJson,
    required this.readOnly,
    required this.onChanged,
  });

  final String initialJson;
  final bool readOnly;
  final ValueChanged<String> onChanged;

  @override
  State<_CustomSiHuaJsonEditor> createState() =>
      _CustomSiHuaJsonEditorState();
}

class _CustomSiHuaJsonEditorState extends State<_CustomSiHuaJsonEditor> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialJson);
  }

  @override
  void didUpdateWidget(covariant _CustomSiHuaJsonEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialJson != oldWidget.initialJson &&
        widget.initialJson != _controller.text) {
      _controller.text = widget.initialJson;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('root must be object');
      }
      for (final gan in TianGan.values) {
        final row = decoded[gan.name];
        if (row is! Map<String, dynamic>) {
          throw const FormatException('gan row missing');
        }
        for (final key in _CustomSiHuaEditorState._sihuaKeys) {
          final next = row[key];
          if (next != null && next is! String) {
            throw const FormatException('sihua value must be string');
          }
        }
      }
      setState(() {
        _error = null;
      });
      widget.onChanged(value);
    } catch (_) {
      setState(() {
        _error = '四化 JSON 格式无效'.tr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      minLines: 12,
      maxLines: 20,
      readOnly: widget.readOnly,
      onChanged: widget.readOnly ? null : _handleChanged,
      decoration: InputDecoration(
        hintText:
            '{\n  "jia": {"lu": "lianzhen", "quan": "pojun", "ke": "wuqu", "ji": "taiyang"}\n}',
        border: const OutlineInputBorder(),
        errorText: _error,
        alignLabelWithHint: true,
      ),
      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
    );
  }
}

Map<String, dynamic> _emptyMastersTable() => {
  for (var i = 0; i < DiZhi.values.length; i++) i.toString(): '',
};

Map<String, dynamic> _defaultMastersEditorData() {
  final defaultRuleset = ConfigLoader.getDefault();
  return {
    'ming_zhu': {
      'boundary': defaultRuleset.mingZhuRule?.boundary.name ?? 'lunar',
      'table': {
        for (final entry in (defaultRuleset.mingZhuRule?.table.entries ??
            const <MapEntry<int, String>>[]))
          entry.key.toString(): entry.value,
      },
    },
    'shen_zhu': {
      'boundary': defaultRuleset.shenZhuRule?.boundary.name ?? 'lunar',
      'table': {
        for (final entry in (defaultRuleset.shenZhuRule?.table.entries ??
            const <MapEntry<int, String>>[]))
          entry.key.toString(): entry.value,
      },
    },
  };
}

Map<String, dynamic> _normalizeMastersEditorData(Map<String, dynamic> raw) {
  Map<String, dynamic> normalizeSection(
    String key, {
    required String defaultBoundary,
  }) {
    final source = Map<String, dynamic>.from((raw[key] as Map?) ?? const {});
    final boundary = (source['boundary'] ?? defaultBoundary).toString();
    final table = Map<String, dynamic>.from((source['table'] as Map?) ?? const {});
    final normalizedTable = <String, dynamic>{
      for (var i = 0; i < DiZhi.values.length; i++)
        i.toString(): (table[i.toString()] ?? '').toString(),
    };
    return {
      'boundary': boundary,
      'table': normalizedTable,
    };
  }

  return {
    'ming_zhu': normalizeSection('ming_zhu', defaultBoundary: 'lunar'),
    'shen_zhu': normalizeSection('shen_zhu', defaultBoundary: 'lunar'),
  };
}

class _MastersProfileEditorPage extends StatefulWidget {
  const _MastersProfileEditorPage({
    required this.profileName,
    required this.initialJson,
    required this.readOnly,
    required this.onChanged,
    required this.onExport,
    required this.onShare,
  });

  final String profileName;
  final String initialJson;
  final bool readOnly;
  final ValueChanged<String> onChanged;
  final Future<void> Function(String json) onExport;
  final Future<void> Function(String json) onShare;

  @override
  State<_MastersProfileEditorPage> createState() =>
      _MastersProfileEditorPageState();
}

class _MastersProfileEditorPageState extends State<_MastersProfileEditorPage> {
  late String _json;
  bool _jsonMode = false;

  @override
  void initState() {
    super.initState();
    _json = widget.initialJson.isEmpty
        ? const JsonEncoder.withIndent('  ').convert(_defaultMastersEditorData())
        : widget.initialJson;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑自定义命主身主流派'.tr),
        actions: [
          IconButton(
            tooltip: '分享 JSON'.tr,
            icon: const Icon(Icons.share_outlined),
            onPressed: () => widget.onShare(_json),
          ),
          IconButton(
            tooltip: '导出 JSON'.tr,
            icon: const Icon(Icons.download_outlined),
            onPressed: () => widget.onExport(_json),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _jsonMode = !_jsonMode;
              });
            },
            child: Text((_jsonMode ? '表格编辑' : 'JSON 编辑').tr),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _jsonMode
                  ? _CustomMastersJsonEditor(
                      initialJson: _json,
                      readOnly: widget.readOnly,
                      onChanged: (json) {
                        setState(() {
                          _json = json;
                        });
                        widget.onChanged(json);
                      },
                    )
                  : _CustomMastersEditor(
                      initialJson: _json,
                      readOnly: widget.readOnly,
                      onChanged: (json) {
                        setState(() {
                          _json = json;
                        });
                        widget.onChanged(json);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomMastersEditor extends StatefulWidget {
  const _CustomMastersEditor({
    required this.initialJson,
    required this.readOnly,
    required this.onChanged,
  });

  final String initialJson;
  final bool readOnly;
  final ValueChanged<String> onChanged;

  @override
  State<_CustomMastersEditor> createState() => _CustomMastersEditorState();
}

class _CustomMastersEditorState extends State<_CustomMastersEditor> {
  late Map<String, dynamic> _data;

  @override
  void initState() {
    super.initState();
    final raw = widget.initialJson.isEmpty
        ? _defaultMastersEditorData()
        : Map<String, dynamic>.from(jsonDecode(widget.initialJson));
    _data = _normalizeMastersEditorData(raw);
  }

  Map<String, dynamic> _sectionFor(String key) {
    return Map<String, dynamic>.from(
      (_data[key] as Map?) ?? const {'boundary': 'lunar', 'table': {}},
    );
  }

  Map<String, dynamic> _tableFor(String key) {
    return Map<String, dynamic>.from(
      (_sectionFor(key)['table'] as Map?) ?? _emptyMastersTable(),
    );
  }

  void _sync() {
    widget.onChanged(const JsonEncoder.withIndent('  ').convert(_data));
  }

  void _updateBoundary(Boundary boundary) {
    setState(() {
      final section = _sectionFor('shen_zhu');
      section['boundary'] = boundary.name;
      section['table'] = _tableFor('shen_zhu');
      _data['shen_zhu'] = section;
    });
    _sync();
  }

  void _updateRule(String sectionKey, int branchIndex, String starKey) {
    setState(() {
      final section = _sectionFor(sectionKey);
      final table = _tableFor(sectionKey);
      table[branchIndex.toString()] = starKey;
      section['table'] = table;
      _data[sectionKey] = section;
    });
    _sync();
  }

  String _summaryFor(String sectionKey) {
    final table = _tableFor(sectionKey);
    return DiZhi.values
        .take(4)
        .map((zhi) {
          final value = (table[zhi.index.toString()] ?? '').toString();
          return '${zhi.display}:${value.isEmpty ? '未设置'.tr : value.nodeDisplay}';
        })
        .join('  ');
  }

  @override
  Widget build(BuildContext context) {
    final defaultRuleset = ConfigLoader.getDefault();
    final starOptions = defaultRuleset.stars.map((star) => star.key).toSet().toList()
      ..sort();
    final shenBoundary = Boundary.values.firstWhere(
      (value) => value.name == _sectionFor('shen_zhu')['boundary'],
      orElse: () => Boundary.lunar,
    );

    Widget buildSection(String sectionKey, String title) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          ...DiZhi.values.map((zhi) {
            final value = (_tableFor(sectionKey)[zhi.index.toString()] ?? '').toString();
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(zhi.display),
                subtitle: Text(value.isEmpty ? '未设置'.tr : value.nodeDisplay),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => _MasterBranchEditorPage(
                        title: '$title ${zhi.display}',
                        currentValue: value,
                        readOnly: widget.readOnly,
                        starOptions: starOptions,
                        onChanged: (next) =>
                            _updateRule(sectionKey, zhi.index, next),
                      ),
                    ),
                  );
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
            );
          }),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '命主/身主起例'.tr,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '身主年支基准'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RadioListTile<Boundary>(
                  contentPadding: EdgeInsets.zero,
                  title: Text('身主跟随农历年支'.tr),
                  value: Boundary.lunar,
                  groupValue: shenBoundary,
                  onChanged: widget.readOnly
                      ? null
                      : (value) {
                          if (value != null) {
                            _updateBoundary(value);
                          }
                        },
                ),
                RadioListTile<Boundary>(
                  contentPadding: EdgeInsets.zero,
                  title: Text('身主跟随节气年支'.tr),
                  value: Boundary.solar,
                  groupValue: shenBoundary,
                  onChanged: widget.readOnly
                      ? null
                      : (value) {
                          if (value != null) {
                            _updateBoundary(value);
                          }
                        },
                ),
              ],
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text('命主起例'.tr),
            subtitle: Text(_summaryFor('ming_zhu')),
          ),
        ),
        buildSection('ming_zhu', '命主起例'.tr),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text('身主起例'.tr),
            subtitle: Text(_summaryFor('shen_zhu')),
          ),
        ),
        buildSection('shen_zhu', '身主起例'.tr),
      ],
    );
  }
}

class _MasterBranchEditorPage extends StatelessWidget {
  const _MasterBranchEditorPage({
    required this.title,
    required this.currentValue,
    required this.readOnly,
    required this.starOptions,
    required this.onChanged,
  });

  final String title;
  final String currentValue;
  final bool readOnly;
  final List<String> starOptions;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          DropdownButtonFormField<String>(
            initialValue: currentValue.isEmpty ? '' : currentValue,
            decoration: InputDecoration(
              labelText: '星曜'.tr,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem<String>(value: '', child: Text('未设置'.tr)),
              ...starOptions.map(
                (starKey) => DropdownMenuItem<String>(
                  value: starKey,
                  child: Text(starKey.nodeDisplay),
                ),
              ),
            ],
            onChanged: readOnly
                ? null
                : (next) {
                    onChanged(next ?? '');
                  },
          ),
        ],
      ),
    );
  }
}

class _CustomMastersJsonEditor extends StatefulWidget {
  const _CustomMastersJsonEditor({
    required this.initialJson,
    required this.readOnly,
    required this.onChanged,
  });

  final String initialJson;
  final bool readOnly;
  final ValueChanged<String> onChanged;

  @override
  State<_CustomMastersJsonEditor> createState() =>
      _CustomMastersJsonEditorState();
}

class _CustomMastersJsonEditorState extends State<_CustomMastersJsonEditor> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialJson);
  }

  @override
  void didUpdateWidget(covariant _CustomMastersJsonEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialJson != oldWidget.initialJson &&
        widget.initialJson != _controller.text) {
      _controller.text = widget.initialJson;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('root must be object');
      }
      final normalized = _normalizeMastersEditorData(decoded);
      ConfigLoader.overrideWith(
        ConfigLoader.getDefault(),
        mastersJson: const JsonEncoder.withIndent('  ').convert(normalized),
      );
      setState(() {
        _error = null;
      });
      widget.onChanged(const JsonEncoder.withIndent('  ').convert(normalized));
    } catch (_) {
      setState(() {
        _error = '命主/身主 JSON 格式无效'.tr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      minLines: 12,
      maxLines: 20,
      readOnly: widget.readOnly,
      onChanged: widget.readOnly ? null : _handleChanged,
      decoration: InputDecoration(
        hintText:
            '{\n  "ming_zhu": {"table": {"0": "tanlang"}},\n  "shen_zhu": {"boundary": "lunar", "table": {"0": "lingxing"}}\n}',
        border: const OutlineInputBorder(),
        errorText: _error,
        alignLabelWithHint: true,
      ),
      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
    );
  }
}

class _BrightnessProfileEditorPage extends StatefulWidget {
  const _BrightnessProfileEditorPage({
    required this.profileName,
    required this.initialJson,
    required this.readOnly,
    required this.onChanged,
    required this.onExport,
    required this.onShare,
  });

  final String profileName;
  final String initialJson;
  final bool readOnly;
  final ValueChanged<String> onChanged;
  final Future<void> Function(String json) onExport;
  final Future<void> Function(String json) onShare;

  @override
  State<_BrightnessProfileEditorPage> createState() =>
      _BrightnessProfileEditorPageState();
}

class _BrightnessProfileEditorPageState
    extends State<_BrightnessProfileEditorPage> {
  late Map<String, dynamic> _data;
  bool _jsonMode = false;

  @override
  void initState() {
    super.initState();
    _data = Map<String, dynamic>.from(jsonDecode(widget.initialJson));
  }

  Map<String, dynamic> get _labels => Map<String, dynamic>.from(
    (_data['brightness_labels'] as Map?) ?? const {},
  );

  List<int> get _labelIndexes {
    final keys = _labels.keys
        .map((key) => int.tryParse(key))
        .whereType<int>()
        .toList()
      ..sort();
    return keys;
  }

  void _sync() {
    widget.onChanged(const JsonEncoder.withIndent('  ').convert(_data));
  }

  void _updateLabel(int index, String value) {
    setState(() {
      final labels = _labels;
      labels[index.toString()] = value;
      _data['brightness_labels'] = labels;
    });
    _sync();
  }

  void _addLevel() {
    final indexes = _labelIndexes.where((index) => index >= 0).toList();
    final next = indexes.isEmpty ? 0 : indexes.last + 1;
    _updateLabel(next, 'level_$next');
  }

  void _removeLevel(int index) {
    setState(() {
      final labels = _labels;
      labels.remove(index.toString());
      _data['brightness_labels'] = labels;
      _replaceLevelUsage(index, -1);
    });
    _sync();
  }

  void _replaceLevelUsage(int from, int to) {
    for (final sectionKey in ['static_stars', 'flow_stars']) {
      final section = Map<String, dynamic>.from(
        (_data[sectionKey] as Map?) ?? const {},
      );
      for (final entry in section.entries) {
        final values = List<dynamic>.from(entry.value as List)
            .map((value) => value == from ? to : value)
            .toList();
        section[entry.key] = values;
      }
      _data[sectionKey] = section;
    }
  }

  String get _currentJson => const JsonEncoder.withIndent('  ').convert(_data);


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('编辑自定义亮度流派'.tr),
          actions: [
            IconButton(
              tooltip: '分享 JSON'.tr,
              icon: const Icon(Icons.share_outlined),
              onPressed: () => widget.onShare(_currentJson),
            ),
            IconButton(
              tooltip: '导出 JSON'.tr,
              icon: const Icon(Icons.download_outlined),
              onPressed: () => widget.onExport(_currentJson),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _jsonMode = !_jsonMode;
                });
              },
              child: Text((_jsonMode ? '表格编辑' : 'JSON 编辑').tr),
            ),
          ],
          bottom: _jsonMode
              ? null
              : TabBar(
                  tabs: [
                    Tab(text: '亮度等级'.tr),
                    Tab(text: '静态星'.tr),
                    Tab(text: '流曜'.tr),
                  ],
                ),
        ),
        body: _jsonMode
            ? _CustomBrightnessEditor(
                initialJson: const JsonEncoder.withIndent('  ').convert(_data),
                readOnly: widget.readOnly,
                onChanged: (json) {
                  setState(() {
                    _data = Map<String, dynamic>.from(jsonDecode(json));
                  });
                  widget.onChanged(json);
                },
              )
            : TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      Card(
                        child: ListTile(
                          title: Text('无亮度'.tr),
                          subtitle: Text('保留值 -1'.tr),
                        ),
                      ),
                      ..._labelIndexes.where((index) => index >= 0).map((index) {
                        final value = (_labels[index.toString()] ?? '').toString();
                        return Card(
                          child: ListTile(
                            title: Text('${'等级'.tr} $index'),
                            subtitle: TextField(
                              controller: TextEditingController(text: value),
                              readOnly: widget.readOnly,
                              onChanged: widget.readOnly
                                  ? null
                                  : (next) => _updateLabel(index, next),
                              decoration: InputDecoration(
                                labelText: '亮度名称'.tr,
                              ),
                            ),
                            trailing: widget.readOnly
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: '删除'.tr,
                                    onPressed: () => _removeLevel(index),
                                  ),
                          ),
                        );
                      }),
                      if (!widget.readOnly)
                        const SizedBox(height: 8),
                      if (!widget.readOnly)
                        FilledButton.icon(
                          onPressed: _addLevel,
                          icon: const Icon(Icons.add),
                          label: Text('新增亮度等级'.tr),
                        ),
                    ],
                  ),
                  _BrightnessSectionList(
                    title: '静态星亮度'.tr,
                    sectionKey: 'static_stars',
                    data: _data,
                    labels: _labels,
                    readOnly: widget.readOnly,
                    onChanged: (next) {
                      setState(() {
                        _data = next;
                      });
                      _sync();
                    },
                  ),
                  _BrightnessSectionList(
                    title: '流曜亮度'.tr,
                    sectionKey: 'flow_stars',
                    data: _data,
                    labels: _labels,
                    readOnly: widget.readOnly,
                    onChanged: (next) {
                      setState(() {
                        _data = next;
                      });
                      _sync();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

String _brightnessEntryDisplay(String key) {
  if (key.startsWith('flow_')) {
    final parts = key.split('_');
    if (parts.length >= 3) {
      final scope = parts[1];
      final target = parts.sublist(2).join('_');
      return '${formatFlowScopePrefixByName(scope)}${formatFlowShortName(target)}';
    }
  }
  return key.nodeDisplay;
}

Map<String, dynamic> _serializeStaticStarConfig(StaticStar star) {
  return {
    'key': star.key,
    'type': star.type.name,
    'rule': _serializeStarRule(star.rule),
  };
}

Map<String, dynamic> _serializeStarRule(StarRule rule) {
  if (rule is AnchorOffsetRule) {
    return {
      'type': 'anchor_offset',
      'anchor': rule.anchorKey,
      'offset': rule.offset,
      'direction': _serializeStarDirection(rule.direction),
      'boundary': rule.boundary.name,
    };
  }
  if (rule is LookupRule) {
    return {
      'type': 'lookup',
      'anchor': rule.anchorKey,
      'table': Map<String, int>.from(rule.table),
      'boundary': rule.boundary.name,
      'offset': rule.offset,
      'direction': _serializeStarDirection(rule.direction),
    };
  }
  if (rule is LookupShiftRule) {
    return {
      'type': 'lookup_offset',
      'anchor': rule.anchorKey,
      'shift_anchor': rule.shiftAnchorKey,
      'table': Map<String, int>.from(rule.table),
      'boundary': rule.boundary.name,
      'direction': _serializeStarDirection(rule.direction),
    };
  }
  if (rule is ConstantRule) {
    return {'type': 'constant', 'value': rule.value};
  }
  if (rule is PipelineRule) {
    return {
      'type': 'pipeline',
      'boundary': rule.boundary.name,
      'steps': rule.steps.map(_serializeStarRule).toList(),
    };
  }
  throw UnsupportedError('Unsupported star rule: ${rule.runtimeType}');
}

String _serializeStarDirection(StarDirection direction) {
  switch (direction) {
    case StarDirection.shun:
      return 'shun';
    case StarDirection.ni:
      return 'ni';
    case StarDirection.genderShunNi:
      return 'gender_shun_ni';
  }
}

class _BrightnessSectionList extends StatelessWidget {
  const _BrightnessSectionList({
    required this.title,
    required this.sectionKey,
    required this.data,
    required this.labels,
    required this.readOnly,
    required this.onChanged,
  });

  final String title;
  final String sectionKey;
  final Map<String, dynamic> data;
  final Map<String, dynamic> labels;
  final bool readOnly;
  final ValueChanged<Map<String, dynamic>> onChanged;

  @override
  Widget build(BuildContext context) {
    final section = Map<String, dynamic>.from((data[sectionKey] as Map?) ?? const {});
    final keys = section.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];
        final values = List<dynamic>.from(section[key] as List);
        final preview = values.take(4).join(', ');
        return Card(
          child: ListTile(
            title: Text(_brightnessEntryDisplay(key)),
            subtitle: Text('${'前四宫'.tr}: $preview    ${'共'.tr} 12 ${'项'.tr}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => _BrightnessStarEditorPage(
                    title: _brightnessEntryDisplay(key),
                    values: values.map((e) => e as int).toList(),
                    labels: labels,
                    readOnly: readOnly,
                    onChanged: (nextValues) {
                      final nextData = Map<String, dynamic>.from(data);
                      final nextSection = Map<String, dynamic>.from(section);
                      nextSection[key] = nextValues;
                      nextData[sectionKey] = nextSection;
                      onChanged(nextData);
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _BrightnessStarEditorPage extends StatelessWidget {
  const _BrightnessStarEditorPage({
    required this.title,
    required this.values,
    required this.labels,
    required this.readOnly,
    required this.onChanged,
  });

  final String title;
  final List<int> values;
  final Map<String, dynamic> labels;
  final bool readOnly;
  final ValueChanged<List<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = labels.keys
        .map((key) => int.tryParse(key))
        .whereType<int>()
        .toList()
      ..sort();
    final branchNames = DiZhi.values.map((e) => e.display).toList();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: values.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DropdownButtonFormField<int>(
              initialValue: values[index],
              decoration: InputDecoration(
                labelText: branchNames[index],
                border: const OutlineInputBorder(),
              ),
              items: options
                  .map(
                    (value) => DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value  ${formatBrightness((labels[value.toString()] ?? '').toString())}'),
                    ),
                  )
                  .toList(),
              onChanged: readOnly ? null : (next) {
                if (next == null) return;
                final nextValues = List<int>.from(values);
                nextValues[index] = next;
                onChanged(nextValues);
              },
            ),
          );
        },
      ),
    );
  }
}

class _CustomBrightnessEditor extends StatefulWidget {
  const _CustomBrightnessEditor({
    required this.initialJson,
    required this.readOnly,
    required this.onChanged,
  });

  final String initialJson;
  final bool readOnly;
  final ValueChanged<String> onChanged;

  @override
  State<_CustomBrightnessEditor> createState() =>
      _CustomBrightnessEditorState();
}

class _CustomBrightnessEditorState extends State<_CustomBrightnessEditor> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialJson);
  }

  @override
  void didUpdateWidget(covariant _CustomBrightnessEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialJson != oldWidget.initialJson &&
        widget.initialJson != _controller.text) {
      _controller.text = widget.initialJson;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('root must be object');
      }
      final labels = decoded['brightness_labels'];
      final staticStars = decoded['static_stars'];
      final flowStars = decoded['flow_stars'];
      if (labels is! Map<String, dynamic>) {
        throw const FormatException('brightness_labels missing');
      }
      if (staticStars is! Map<String, dynamic>) {
        throw const FormatException('static_stars missing');
      }
      if (flowStars is! Map<String, dynamic>) {
        throw const FormatException('flow_stars missing');
      }
      setState(() {
        _error = null;
      });
      widget.onChanged(value);
    } catch (_) {
      setState(() {
        _error = '亮度 JSON 格式无效'.tr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          minLines: 12,
          maxLines: 20,
          readOnly: widget.readOnly,
          onChanged: widget.readOnly ? null : _handleChanged,
          decoration: InputDecoration(
            hintText:
                '{\n  "brightness_labels": {},\n  "static_stars": {},\n  "flow_stars": {}\n}',
            border: const OutlineInputBorder(),
            errorText: _error,
            alignLabelWithHint: true,
          ),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
      ],
    );
  }
}

class _SiHuaGanEditorPage extends StatelessWidget {
  const _SiHuaGanEditorPage({
    required this.title,
    required this.row,
    required this.readOnly,
    required this.starOptions,
    required this.onChanged,
  });

  final String title;
  final Map<String, dynamic> row;
  final bool readOnly;
  final List<String> starOptions;
  final void Function(String key, String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$title${'四化设置'.tr}')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: _CustomSiHuaEditorState._sihuaKeys.map((key) {
          final type = SiHuaType.fromJson(key);
          final value = (row[key] ?? '').toString();
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DropdownButtonFormField<String>(
              initialValue: value.isEmpty ? '' : value,
              decoration: InputDecoration(
                labelText: type.display,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem<String>(value: '', child: Text('未设置'.tr)),
                ...starOptions.map(
                  (starKey) => DropdownMenuItem<String>(
                    value: starKey,
                    child: Text(starKey.nodeDisplay),
                  ),
                ),
              ],
              onChanged: readOnly ? null : (next) {
                onChanged(key, next ?? '');
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
