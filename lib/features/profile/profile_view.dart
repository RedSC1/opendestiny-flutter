import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/input_provider.dart';
import 'package:bazi_core/bazi_core.dart';

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
          const Text(
            '出生信息录入',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('出生日期与时间'),
              subtitle: Text(
                DateFormat('yyyy年MM月dd日 HH:mm').format(birthData.birthTime),
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
                  const Text('性别', style: TextStyle(fontSize: 16)),
                  const Spacer(),
                  ChoiceChip(
                    label: const Text('乾 (男)'),
                    selected: birthData.gender == Gender.male,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(inputNotifierProvider.notifier).updateGender(Gender.male);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('坤 (女)'),
                    selected: birthData.gender == Gender.female,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(inputNotifierProvider.notifier).updateGender(Gender.female);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text('出生地点'),
              subtitle: Text('${birthData.locationName} (经度: ${birthData.longitude})'),
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
