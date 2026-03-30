import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bazi_core/bazi_core.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../../providers/input_provider.dart';
import '../../models/destiny_profile.dart';

class BaziSettingsView extends ConsumerWidget {
  const BaziSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(inputNotifierProvider);
    final options = profile.baziOptions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('八字流派与算法设置'),
      ),
      body: ListView(
        children: [
          _buildSectionTitle('起运算法'),
          RadioListTile<DaYunAlgorithm>(
            title: const Text('精准 120 天算法'),
            subtitle: const Text('按照一年 360 天等比推算 (推荐)'),
            value: DaYunAlgorithm.precise120,
            groupValue: options.daYunAlgorithm,
            onChanged: (val) => _updateOptions(ref, options.copyWith(daYunAlgorithm: val!)),
          ),

          const Divider(),
          _buildSectionTitle('人元司令分野'),
          RadioListTile<SiLingVersion>(
            title: const Text('三命通会 (原著版)'),
            value: SiLingVersion.sanMingTongHui,
            groupValue: options.siLingVersion,
            onChanged: (val) => _updateOptions(ref, options.copyWith(siLingVersion: val!)),
          ),
          RadioListTile<SiLingVersion>(
            title: const Text('商业流传版'),
            value: SiLingVersion.common,
            groupValue: options.siLingVersion,
            onChanged: (val) => _updateOptions(ref, options.copyWith(siLingVersion: val!)),
          ),

          const Divider(),
          _buildSectionTitle('土同宫算法'),
          RadioListTile<EarthPalaceAlgorithm>(
            title: const Text('火土同宫'),
            subtitle: const Text('戊随丙，己随丁'),
            value: EarthPalaceAlgorithm.fireEarth,
            groupValue: options.earthPalaceAlgorithm,
            onChanged: (val) => _updateOptions(ref, options.copyWith(earthPalaceAlgorithm: val!)),
          ),
          RadioListTile<EarthPalaceAlgorithm>(
            title: const Text('水土同宫'),
            subtitle: const Text('戊随壬，己随癸'),
            value: EarthPalaceAlgorithm.waterEarth,
            groupValue: options.earthPalaceAlgorithm,
            onChanged: (val) => _updateOptions(ref, options.copyWith(earthPalaceAlgorithm: val!)),
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
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }
}
