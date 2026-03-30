import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bazi_core/bazi_core.dart';
import '../../providers/input_provider.dart';
import '../../models/destiny_profile.dart';
import '../../core/l10n.dart';

class BaziSettingsView extends ConsumerWidget {
  const BaziSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(inputNotifierProvider);
    final options = profile.baziOptions;

    return Scaffold(
      appBar: AppBar(title: Text('八字流派与算法设置'.tr)),
      body: ListView(
        children: [
          _buildSectionTitle('起运算法'.tr),
          RadioListTile<DaYunAlgorithm>(
            title: Text('精准 120 倍等比推算法'.tr),
            subtitle: Text('按照“三天折一年”原则精准放大 120 倍 (推荐)'.tr),
            value: DaYunAlgorithm.precise120,
            groupValue: options.daYunAlgorithm,
            onChanged: (val) {
              if (val != null)
                _updateOptions(ref, options.copyWith(daYunAlgorithm: val));
            },
          ),

          const Divider(),
          _buildSectionTitle('人元司令分野'.tr),
          RadioListTile<SiLingVersion>(
            title: Text('三命通会 (原著版)'.tr),
            value: SiLingVersion.sanMingTongHui,
            groupValue: options.siLingVersion,
            onChanged: (val) {
              if (val != null)
                _updateOptions(ref, options.copyWith(siLingVersion: val));
            },
          ),
          RadioListTile<SiLingVersion>(
            title: Text('商业流传版'.tr),
            value: SiLingVersion.common,
            groupValue: options.siLingVersion,
            onChanged: (val) {
              if (val != null)
                _updateOptions(ref, options.copyWith(siLingVersion: val));
            },
          ),

          const Divider(),
          _buildSectionTitle('土同宫算法'.tr),
          RadioListTile<EarthPalaceAlgorithm>(
            title: Text('火土同宫'.tr),
            subtitle: Text('戊随丙，己随丁'.tr),
            value: EarthPalaceAlgorithm.fireEarth,
            groupValue: options.earthPalaceAlgorithm,
            onChanged: (val) {
              if (val != null)
                _updateOptions(
                  ref,
                  options.copyWith(earthPalaceAlgorithm: val),
                );
            },
          ),
          RadioListTile<EarthPalaceAlgorithm>(
            title: Text('水土同宫'.tr),
            subtitle: Text('戊随壬，己随癸'.tr),
            value: EarthPalaceAlgorithm.waterEarth,
            groupValue: options.earthPalaceAlgorithm,
            onChanged: (val) {
              if (val != null)
                _updateOptions(
                  ref,
                  options.copyWith(earthPalaceAlgorithm: val),
                );
            },
          ),
        ],
      ),
    );
  }

  void _updateOptions(WidgetRef ref, BaziOptions newOptions) {
    ref.read(inputNotifierProvider.notifier).updateBaziOptions(newOptions);
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
}
