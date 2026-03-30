import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/input_provider.dart';
import 'package:bazi_core/bazi_core.dart';
import '../../core/l10n.dart'; // ✅ 补上

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final birthData = ref.watch(inputNotifierProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '出生信息录入'.tr,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('出生日期与时间'.tr),
              subtitle: Text(
                DateFormat('日期格式'.tr).format(birthData.birthTime),
                style: const TextStyle(fontSize: 18, color: Colors.deepPurple),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: birthData.birthTime,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(birthData.birthTime),
                  );
                  if (time != null) {
                    final newDateTime = DateTime(
                      date.year, date.month, date.day, time.hour, time.minute,
                    );
                    ref.read(inputNotifierProvider.notifier).updateBirthTime(newDateTime);
                  }
                }
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.person_outline),
                  const SizedBox(width: 16),
                  Text('性别'.tr, style: const TextStyle(fontSize: 16)),
                  const Spacer(),
                  ToggleButtons(
                    isSelected: [
                      birthData.gender == Gender.male,
                      birthData.gender == Gender.female,
                    ],
                    onPressed: (index) {
                      ref.read(inputNotifierProvider.notifier).updateGender(
                        index == 0 ? Gender.male : Gender.female,
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    constraints: const BoxConstraints(minWidth: 64, minHeight: 36),
                    children: [
                      Text('乾 (男)'.tr),
                      Text('坤 (女)'.tr),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text('出生地点'.tr),
              subtitle: Text('${birthData.locationName.tr} (${'经度'.tr}: ${birthData.longitude})'),
              onTap: () {
                // TODO: 弹出经纬度编辑对话框
              },
            ),
          ),
        ],
      ),
    );
  }
}
