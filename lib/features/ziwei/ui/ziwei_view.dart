import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ziwei_chart_widget.dart';
import 'ziwei_time_flow_table.dart';
import 'ziwei_toolbar_widget.dart';

class ZiweiView extends ConsumerWidget {
  const ZiweiView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 850,
          ), // 限制 PC 端最大宽度，防止横向拉伸
          child: Column(
            children: [
              const ZiweiChartWidget(),
              const ZiweiToolbarWidget(),
              const ZiweiTimeFlowTable(),
              const SizedBox(height: 10), // 留出一点底部空隙
            ],
          ),
        ),
      ),
    );
  }
}
