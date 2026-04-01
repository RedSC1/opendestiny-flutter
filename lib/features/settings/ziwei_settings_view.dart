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
                    ? jsonEncode(_defaultCustomSiHua())
                    : options.customSiHuaJson;
                _updateOptions(
                  ref,
                  options.copyWith(siHuaMode: val, customSiHuaJson: nextJson),
                );
              }
            },
          ),
          if (options.siHuaMode == ZiweiSiHuaMode.custom)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: _CustomSiHuaEditor(
                initialJson: options.customSiHuaJson,
                onChanged: (json) {
                  _updateOptions(ref, options.copyWith(customSiHuaJson: json));
                },
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

class _CustomSiHuaEditor extends StatefulWidget {
  const _CustomSiHuaEditor({
    required this.initialJson,
    required this.onChanged,
  });

  final String initialJson;
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
    return _sihuaKeys.map((key) {
      final type = SiHuaType.fromJson(key);
      final value = (row[key] ?? '').toString();
      return '${type.display} ${value.isEmpty ? '未设置'.tr : value.nodeDisplay}';
    }).join('  ');
  }

  @override
  Widget build(BuildContext context) {
    final defaultRuleset = ConfigLoader.getDefault();
    final starOptions = defaultRuleset.stars
        .where(
          (e) => e.type == StarType.major ||
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
                    starOptions: starOptions,
                    onChanged: (key, value) => _updateGanRule(ganKey, key, value),
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

class _SiHuaGanEditorPage extends StatelessWidget {
  const _SiHuaGanEditorPage({
    required this.title,
    required this.row,
    required this.starOptions,
    required this.onChanged,
  });

  final String title;
  final Map<String, dynamic> row;
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
              onChanged: (next) {
                onChanged(key, next ?? '');
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
