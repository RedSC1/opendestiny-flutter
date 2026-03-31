import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ziwei_chart_widget.dart';
import 'ziwei_time_flow_table.dart';

class ZiweiView extends ConsumerWidget {
  const ZiweiView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 4),
          const ZiweiChartWidget(),
          const SizedBox(height: 8),
          // 底部流运控制台
          const ZiweiTimeFlowTable(),
          const SizedBox(height: 10), // 留出一点底部空隙
        ],
      ),
    );
  }
}
