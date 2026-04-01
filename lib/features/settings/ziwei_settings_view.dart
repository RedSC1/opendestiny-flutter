import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../../providers/input_provider.dart';
import '../../models/destiny_profile.dart';
import '../../core/l10n.dart';
import '../../core/ziwei_l10n.dart';

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
          _buildSectionTitle('流曜显示'.tr),
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

          const Divider(),
          _buildSectionTitle('实验性功能 (谨慎修改)'.tr),

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
          : const {
              '默认亮度流派',
              '默認亮度流派',
              'Default Brightness Profile',
            })
      .contains(profile.name);
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
        : options.brightnessProfiles;
    final activeId = type == ZiweiCustomProfileType.siHua
        ? options.activeSiHuaProfileId
        : options.activeBrightnessProfileId;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
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
                  builder: (_) => type == ZiweiCustomProfileType.siHua
                      ? _SiHuaProfileEditorPage(
                          initialJson: profile.json,
                          readOnly: locked,
                          onChanged: (json) {
                            ref
                                .read(inputNotifierProvider.notifier)
                                .saveZiweiCustomProfileJson(
                                  type: type,
                                  id: profile.id,
                                  json: json,
                                );
                          },
                        )
                      : _BrightnessProfileEditorPage(
                          initialJson: profile.json,
                          readOnly: locked,
                          onChanged: (json) {
                            ref
                                .read(inputNotifierProvider.notifier)
                                .saveZiweiCustomProfileJson(
                                  type: type,
                                  id: profile.id,
                                  json: json,
                                );
                          },
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
                : '新建亮度流派'.tr,
            json: createDefaultJson(),
          );
        },
        icon: const Icon(Icons.add),
        label: Text('新建流派'.tr),
      ),
    );
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

class _SiHuaProfileEditorPage extends StatefulWidget {
  const _SiHuaProfileEditorPage({
    required this.initialJson,
    required this.readOnly,
    required this.onChanged,
  });

  final String initialJson;
  final bool readOnly;
  final ValueChanged<String> onChanged;

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

class _BrightnessProfileEditorPage extends StatefulWidget {
  const _BrightnessProfileEditorPage({
    required this.initialJson,
    required this.readOnly,
    required this.onChanged,
  });

  final String initialJson;
  final bool readOnly;
  final ValueChanged<String> onChanged;

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


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('编辑自定义亮度流派'.tr),
          actions: [
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
