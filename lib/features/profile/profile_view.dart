import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bazi_core/bazi_core.dart';

import '../../core/l10n.dart';
import '../../models/destiny_profile.dart';
import '../../providers/input_provider.dart';
import '../bazi/bazi_view.dart';
import '../ziwei/ui/ziwei_view.dart';
import '../settings/settings_view.dart';
import '../../data/cities.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final profile = ref.watch(inputNotifierProvider);
    final currentCase = ref.watch(currentCaseProvider);
    final birthInput = profile.birthInput;

    final List<Widget> pages = [
      _buildEditForm(context, ref, profile, currentCase, birthInput),
      const BaziView(),
      const ZiweiView(),
      const SettingsView(),
    ];

    final List<String> titles = ['编辑资料'.tr, '八字排盘'.tr, '紫微斗数'.tr, '设置'.tr];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        centerTitle: true,
        toolbarHeight: 36,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) =>
            ref.read(navigationIndexProvider.notifier).state = index,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.edit), label: '编辑'.tr),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_awesome),
            label: '八字'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.grid_4x4),
            label: '紫微'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: '设置'.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(
    BuildContext context,
    WidgetRef ref,
    DestinyProfile profile,
    DestinyCase currentCase,
    BirthInput birthInput,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  currentCase.id == InputNotifier.draftCaseId
                      ? '当前正在编辑未存档草稿'.tr
                      : '${'当前案例：'.tr}${currentCase.name}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ),
              if (currentCase.id != InputNotifier.draftCaseId)
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '自动保存'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: Text('姓名'.tr),
              subtitle: Text(
                currentCase.name.isEmpty ? '未设置'.tr : currentCase.name,
                style: TextStyle(
                  fontSize: 16,
                  color: currentCase.name.isEmpty
                      ? Colors.grey
                      : Colors.deepPurple,
                ),
              ),
              trailing: const Icon(Icons.edit_outlined),
              onTap: () => _showNameDialog(context, ref, currentCase.name),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                children: [
                  const Icon(Icons.swap_horiz),
                  const SizedBox(width: 16),
                  Text('输入历法'.tr, style: const TextStyle(fontSize: 16)),
                  const Spacer(),
                  ToggleButtons(
                    isSelected: [
                      birthInput.calendarType == BirthCalendarType.solar,
                      birthInput.calendarType == BirthCalendarType.lunar,
                    ],
                    onPressed: (index) {
                      ref
                          .read(inputNotifierProvider.notifier)
                          .updateCalendarType(
                            index == 0
                                ? BirthCalendarType.solar
                                : BirthCalendarType.lunar,
                          );
                    },
                    borderRadius: BorderRadius.circular(20),
                    constraints: const BoxConstraints(
                      minWidth: 72,
                      minHeight: 36,
                    ),
                    children: [Text('公历'.tr), Text('农历'.tr)],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                birthInput.calendarType == BirthCalendarType.solar
                    ? '公历出生时间'.tr
                    : '农历出生时间'.tr,
              ),
              subtitle: Text(
                _birthInputSummary(birthInput),
                style: const TextStyle(fontSize: 18, color: Colors.deepPurple),
              ),
              trailing: const Icon(Icons.edit_outlined),
              onTap: () => _showBirthInputDialog(context, ref, birthInput),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              '使用整数输入以支持公元前与农历原始录入'.tr,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_outline),
                  const SizedBox(width: 16),
                  Text('性别'.tr, style: const TextStyle(fontSize: 16)),
                  const Spacer(),
                  ToggleButtons(
                    isSelected: [
                      profile.gender == Gender.male,
                      profile.gender == Gender.female,
                    ],
                    onPressed: (index) {
                      ref
                          .read(inputNotifierProvider.notifier)
                          .updateGender(
                            index == 0 ? Gender.male : Gender.female,
                          );
                    },
                    borderRadius: BorderRadius.circular(20),
                    constraints: const BoxConstraints(
                      minWidth: 64,
                      minHeight: 36,
                    ),
                    children: [Text('乾 (男)'.tr), Text('坤 (女)'.tr)],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text('出生地点与时区'.tr),
              subtitle: Text(
                '${birthInput.locationName.tr} (${'经度'.tr}: ${birthInput.longitude}, ${'纬度'.tr}: ${birthInput.latitude}, ${'时区'.tr}: UTC+${birthInput.timeZone})',
              ),
              trailing: const Icon(Icons.edit_outlined),
              onTap: () => _showLocationDialog(context, ref, birthInput),
            ),
          ),
        ],
      ),
    );
  }

  String _birthInputSummary(BirthInput birthInput) {
    if (birthInput.calendarType == BirthCalendarType.lunar) {
      final lunar = birthInput.lunar;
      final leapLabel = lunar.isLeap ? '闰'.tr : '';
      return '${lunar.year}${'年'.tr} $leapLabel${lunar.month}${'月'.tr} ${lunar.day}${'日'.tr} ${_twoDigits(lunar.hour)}:${_twoDigits(lunar.minute)}:${_twoDigits(lunar.second)}';
    }

    final solar = birthInput.solar;
    if (AppL10nSettings.currentLanguage == AppLanguage.en) {
      return '${_englishMonthName(solar.month)} ${_twoDigits(solar.day)}, ${solar.year} ${_twoDigits(solar.hour)}:${_twoDigits(solar.minute)}:${_twoDigits(solar.second)}';
    }
    return '${solar.year}-${_twoDigits(solar.month)}-${_twoDigits(solar.day)} ${_twoDigits(solar.hour)}:${_twoDigits(solar.minute)}:${_twoDigits(solar.second)}';
  }

  String _englishMonthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return month >= 1 && month <= 12 ? months[month] : month.toString();
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  Future<void> _showNameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('编辑姓名'.tr),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: '姓名'.tr,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'.tr),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(inputNotifierProvider.notifier)
                  .updateCaseName(controller.text);
              Navigator.pop(context);
            },
            child: Text('保存'.tr),
          ),
        ],
      ),
    );
  }

  Future<void> _showLocationDialog(
    BuildContext context,
    WidgetRef ref,
    BirthInput current,
  ) async {
    final nameController = TextEditingController(text: current.locationName);
    final lonController = TextEditingController(
      text: current.longitude.toString(),
    );
    final latController = TextEditingController(
      text: current.latitude.toString(),
    );
    final tzController = TextEditingController(
      text: current.timeZone.toString(),
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: Text('编辑出生地点与时区'.tr),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final city = await showDialog<AreaData>(
                          context: dialogContext,
                          builder: (context) => _CityPickerDialog(),
                        );
                        if (city != null) {
                          setState(() {
                            nameController.text = city.name;
                            lonController.text = city.longitude.toStringAsFixed(
                              6,
                            );
                            latController.text = city.latitude.toStringAsFixed(
                              6,
                            );
                          });
                        }
                      },
                      icon: const Icon(Icons.location_city),
                      label: Text('选择城市'.tr),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: '地点名称'.tr,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: lonController,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: '经度 (-180 ~ 180)'.tr,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: latController,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: '纬度 (-90 ~ 90)'.tr,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: tzController,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: '时区 (UTC+)'.tr,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('取消'.tr),
                ),
                TextButton(
                  onPressed: () {
                    final lon = double.tryParse(lonController.text);
                    final lat = double.tryParse(latController.text);
                    final tz = double.tryParse(tzController.text);

                    if (lon == null || lat == null || tz == null) {
                      ScaffoldMessenger.of(
                        dialogContext,
                      ).showSnackBar(SnackBar(content: Text('请输入有效的数字'.tr)));
                      return;
                    }

                    if (lon < -180 || lon > 180 || lat < -90 || lat > 90) {
                      ScaffoldMessenger.of(
                        dialogContext,
                      ).showSnackBar(SnackBar(content: Text('经纬度超出范围'.tr)));
                      return;
                    }

                    ref
                        .read(inputNotifierProvider.notifier)
                        .updateLocation(lon, lat, nameController.text, tz);
                    Navigator.pop(dialogContext);
                  },
                  child: Text('保存'.tr),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showBirthInputDialog(
    BuildContext context,
    WidgetRef ref,
    BirthInput birthInput,
  ) async {
    if (birthInput.calendarType == BirthCalendarType.lunar) {
      await _showLunarInputDialog(context, ref, birthInput.lunar);
    } else {
      await _showSolarInputDialog(context, ref, birthInput.solar);
    }
  }

  Future<void> _showSolarInputDialog(
    BuildContext context,
    WidgetRef ref,
    SolarBirthInput current,
  ) async {
    final yearController = TextEditingController(text: current.year.toString());
    final monthController = TextEditingController(
      text: current.month.toString(),
    );
    final dayController = TextEditingController(text: current.day.toString());
    final hourController = TextEditingController(text: current.hour.toString());
    final minuteController = TextEditingController(
      text: current.minute.toString(),
    );
    final secondController = TextEditingController(
      text: current.second.toString(),
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('编辑公历出生时间'.tr),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNumberField(yearController, '年'.tr),
                _buildNumberField(monthController, '月'.tr),
                _buildNumberField(dayController, '日'.tr),
                _buildNumberField(hourController, '时'.tr),
                _buildNumberField(minuteController, '分'.tr),
                _buildNumberField(secondController, '秒'.tr),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('取消'.tr),
            ),
            TextButton(
              onPressed: () {
                final year = int.tryParse(yearController.text);
                final month = int.tryParse(monthController.text);
                final day = int.tryParse(dayController.text);
                final hour = int.tryParse(hourController.text);
                final minute = int.tryParse(minuteController.text);
                final second = int.tryParse(secondController.text);

                if (year == null ||
                    month == null ||
                    day == null ||
                    hour == null ||
                    minute == null ||
                    second == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('请输入有效的数字'.tr)));
                  return;
                }

                if (month < 1 ||
                    month > 12 ||
                    day < 1 ||
                    day > 31 ||
                    hour < 0 ||
                    hour > 23 ||
                    minute < 0 ||
                    minute > 59 ||
                    second < 0 ||
                    second > 59) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('输入超出合理范围'.tr)));
                  return;
                }

                final test = AstroDateTime(
                  year,
                  month,
                  day,
                  hour,
                  minute,
                  second,
                );
                final roundTrip = AstroDateTime.fromJulianDay(
                  test.toJulianDay(),
                );
                if (test != roundTrip) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('日期不合法，请检查输入'.tr)));
                  return;
                }

                final next = SolarBirthInput(
                  year: year,
                  month: month,
                  day: day,
                  hour: hour,
                  minute: minute,
                  second: second,
                );
                ref.read(inputNotifierProvider.notifier).updateSolarInput(next);
                Navigator.of(context).pop();
              },
              child: Text('保存'.tr),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLunarInputDialog(
    BuildContext context,
    WidgetRef ref,
    LunarBirthInput current,
  ) async {
    final yearController = TextEditingController(text: current.year.toString());
    final monthController = TextEditingController(text: '1');
    final monthNameController = TextEditingController(text: current.month);
    final dayController = TextEditingController(text: current.day.toString());
    final hourController = TextEditingController(text: current.hour.toString());
    final minuteController = TextEditingController(
      text: current.minute.toString(),
    );
    final secondController = TextEditingController(
      text: current.second.toString(),
    );
    var isLeap = current.isLeap;
    var useAdvancedMode = true;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('编辑农历出生时间'.tr),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('高级模式（直接输入月份名称）'.tr),
                      value: useAdvancedMode,
                      onChanged: (value) =>
                          setState(() => useAdvancedMode = value),
                    ),
                    const SizedBox(height: 8),
                    _buildNumberField(yearController, '年'.tr),
                    if (useAdvancedMode)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextField(
                          controller: monthNameController,
                          decoration: InputDecoration(
                            labelText: '月（如：正、二、后九、十三）'.tr,
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      )
                    else
                      _buildNumberField(monthController, '月'.tr),
                    _buildNumberField(dayController, '日'.tr),
                    _buildNumberField(hourController, '时'.tr),
                    _buildNumberField(minuteController, '分'.tr),
                    _buildNumberField(secondController, '秒'.tr),
                    if (!useAdvancedMode)
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('闰月'.tr),
                        value: isLeap,
                        onChanged: (value) => setState(() => isLeap = value),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('取消'.tr),
                ),
                TextButton(
                  onPressed: () {
                    final year = int.tryParse(yearController.text);
                    final day = int.tryParse(dayController.text);
                    final hour = int.tryParse(hourController.text);
                    final minute = int.tryParse(minuteController.text);
                    final second = int.tryParse(secondController.text);

                    if (year == null ||
                        day == null ||
                        hour == null ||
                        minute == null ||
                        second == null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('请输入有效的数字'.tr)));
                      return;
                    }

                    String monthName;
                    bool finalIsLeap;

                    if (useAdvancedMode) {
                      monthName = monthNameController.text.trim();
                      finalIsLeap =
                          monthName.contains('闰') ||
                          monthName == '后九' ||
                          monthName == '十三';
                    } else {
                      final monthInt = int.tryParse(monthController.text);
                      if (monthInt == null || monthInt < 1 || monthInt > 12) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('月份必须在 1-12 之间'.tr)),
                        );
                        return;
                      }
                      const names = [
                        '',
                        '正',
                        '二',
                        '三',
                        '四',
                        '五',
                        '六',
                        '七',
                        '八',
                        '九',
                        '十',
                        '冬',
                        '腊',
                      ];
                      monthName = names[monthInt];
                      finalIsLeap = isLeap;
                    }

                    if (day < 1 ||
                        day > 30 ||
                        hour < 0 ||
                        hour > 23 ||
                        minute < 0 ||
                        minute > 59 ||
                        second < 0 ||
                        second > 59) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('输入超出合理范围'.tr)));
                      return;
                    }

                    try {
                      final testInput = LunarBirthInput(
                        year: year,
                        month: monthName,
                        day: day,
                        hour: hour,
                        minute: minute,
                        second: second,
                        isLeap: finalIsLeap,
                      );
                      final _ = BirthInput(
                        calendarType: BirthCalendarType.lunar,
                        lunar: testInput,
                      ).rawLunarDate;
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${'农历日期不合法：'.tr}${e.toString()}'),
                        ),
                      );
                      return;
                    }

                    final next = LunarBirthInput(
                      year: year,
                      month: monthName,
                      day: day,
                      hour: hour,
                      minute: minute,
                      second: second,
                      isLeap: finalIsLeap,
                    );
                    ref
                        .read(inputNotifierProvider.notifier)
                        .updateLunarInput(next);
                    Navigator.of(context).pop();
                  },
                  child: Text('保存'.tr),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: false,
        ),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}

class _CityPickerDialog extends StatefulWidget {
  @override
  State<_CityPickerDialog> createState() => _CityPickerDialogState();
}

class _CityPickerDialogState extends State<_CityPickerDialog> {
  int? _provinceId;
  int? _cityId;

  List<AreaData> get _provinces => areas.where((e) => e.deep == 0).toList();

  List<AreaData> get _cities {
    if (_provinceId == null) return const [];
    return areas.where((e) => e.deep == 1 && e.pid == _provinceId).toList();
  }

  List<AreaData> get _districts {
    if (_cityId == null) return const [];
    return areas.where((e) => e.deep == 2 && e.pid == _cityId).toList();
  }

  @override
  void initState() {
    super.initState();
    final provinces = _provinces;
    if (provinces.isNotEmpty) {
      _provinceId = provinces.first.id;
      final cities = _cities;
      if (cities.isNotEmpty) {
        _cityId = cities.first.id;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provinces = _provinces;
    final citiesOfProvince = _cities;
    final districtsOfCity = _districts;

    return AlertDialog(
      title: Text('选择城市'.tr),
      content: SizedBox(
        width: 720,
        height: 420,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '省'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provinces.length,
                      itemBuilder: (context, index) {
                        final item = provinces[index];
                        final selected = item.id == _provinceId;
                        return ListTile(
                          dense: true,
                          selected: selected,
                          title: Text(item.name),
                          onTap: () {
                            setState(() {
                              _provinceId = item.id;
                              final nextCities = _cities;
                              _cityId = nextCities.isNotEmpty
                                  ? nextCities.first.id
                                  : null;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '市'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: citiesOfProvince.length,
                      itemBuilder: (context, index) {
                        final item = citiesOfProvince[index];
                        final selected = item.id == _cityId;
                        return ListTile(
                          dense: true,
                          selected: selected,
                          title: Text(item.name),
                          onTap: () {
                            setState(() {
                              _cityId = item.id;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '区'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: districtsOfCity.length,
                      itemBuilder: (context, index) {
                        final item = districtsOfCity[index];
                        return ListTile(
                          dense: true,
                          title: Text(item.name),
                          subtitle: Text(
                            '${item.longitude.toStringAsFixed(2)}, ${item.latitude.toStringAsFixed(2)}',
                          ),
                          onTap: () => Navigator.pop(context, item),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
