import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziwei_core/ziwei_core.dart';
import '../../providers/input_provider.dart';
import '../../models/destiny_profile.dart';
import '../../core/l10n.dart';

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
