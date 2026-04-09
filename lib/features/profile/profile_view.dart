import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bazi_core/bazi_core.dart';
import 'package:ziwei_core/ziwei_core.dart';

import '../../core/ui_scale.dart';
import '../../core/l10n.dart';
import '../../models/destiny_profile.dart';
import '../../providers/input_provider.dart';
import '../bazi/responsive_bazi_view.dart';
import '../ziwei/ui/ziwei_view.dart';
import '../ziwei/providers/ziwei_providers.dart';
import '../settings/settings_view.dart';
import '../../data/cities.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UIScale.init(context);

    final currentIndex = ref.watch(navigationIndexProvider);
    final profile = ref.watch(inputNotifierProvider);
    final currentCase = ref.watch(currentCaseProvider);
    final birthInput = profile.birthInput;
    final appBarScale = UIScale.scale.clamp(0.9, 1.0);
    final navScale = UIScale.scale.clamp(0.92, 1.0);

    final List<Widget> pages = [
      _buildEditForm(context, ref, profile, currentCase, birthInput),
      const ResponsiveBaziView(),
      const ZiweiView(),
      const SettingsView(),
    ];

    final List<String> titles = ['编辑资料'.tr, '八字排盘'.tr, '紫微斗数'.tr, '设置'.tr];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
          style: TextStyle(fontSize: 18 * appBarScale),
        ),
        centerTitle: true,
        toolbarHeight: 36 * appBarScale,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 24 * navScale,
        selectedFontSize: 12 * navScale,
        unselectedFontSize: 12 * navScale,
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
    final settings = ref.watch(appSettingsProvider);
    final useTrueSolarTime = birthInput.resolveUseTrueSolarTime(
      settings.useTrueSolarTime,
    );

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
                      : Theme.of(context).colorScheme.primary,
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
                _birthInputSummary(birthInput, ref.watch(appSettingsProvider).useAstronomicalYear),
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    onPressed: () => _showBaziReverseLookupDialog(context, ref),
                    icon: const Icon(Icons.search, size: 20),
                    label: Text('八字反查'.tr),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(80, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showZiweiReverseLookupDialog(context, ref),
                    icon: const Icon(Icons.search, size: 20),
                    label: Text('紫微反查'.tr),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(80, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.edit_outlined),
                ],
              ),
              onTap: () => _showBirthInputDialog(context, ref, birthInput),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.wb_sunny_outlined),
              title: Text('真太阳时修正'.tr),
              subtitle: Text('仅影响当前案例的排盘与反查'.tr),
              value: useTrueSolarTime,
              onChanged: (value) {
                ref
                    .read(inputNotifierProvider.notifier)
                    .updateBirthUseTrueSolarTime(value);
              },
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

  String _birthInputSummary(BirthInput birthInput, bool useAstronomical) {
    if (birthInput.calendarType == BirthCalendarType.lunar) {
      final lunar = birthInput.lunar;
      final leapLabel = lunar.isLeap ? '闰'.tr : '';
      final yearStr = lunar.year.formatYear(useAstronomical);
      return '$yearStr${'年'.tr} $leapLabel${lunar.month}${'月'.tr} ${lunar.day}${'日'.tr} ${_twoDigits(lunar.hour)}:${_twoDigits(lunar.minute)}:${_twoDigits(lunar.second)}';
    }

    final solar = birthInput.solar;
    final yearStr = solar.year.formatYear(useAstronomical);
    if (AppL10nSettings.currentLanguage == AppLanguage.en) {
      return '${_englishMonthName(solar.month)} ${_twoDigits(solar.day)}, $yearStr ${_twoDigits(solar.hour)}:${_twoDigits(solar.minute)}:${_twoDigits(solar.second)}';
    }
    return '$yearStr-${_twoDigits(solar.month)}-${_twoDigits(solar.day)} ${_twoDigits(solar.hour)}:${_twoDigits(solar.minute)}:${_twoDigits(solar.second)}';
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

  Future<void> _showBaziReverseLookupDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // 四柱选择状态
    TianGan? yearGan, monthGan, dayGan, timeGan;
    DiZhi? yearZhi, monthZhi, dayZhi, timeZhi;
    var includeTimePillar = false;

    // 默认搜索范围为当前年份±50年
    final currentYear = DateTime.now().year;
    final startYearController = TextEditingController(text: (currentYear - 50).toString());
    final endYearController = TextEditingController(text: (currentYear + 50).toString());

    // 错误状态
    String? yearError, monthError, dayError, timeError, rangeError, searchError;
    String? noResultsMessage;
    var isSearching = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // 验证函数
            void validateAndSearch() {
              // 重置错误
              yearError = null;
              monthError = null;
              dayError = null;
              timeError = null;
              rangeError = null;
              searchError = null;
              noResultsMessage = null;

              // 验证四柱
              if (yearGan == null || yearZhi == null) {
                yearError = '请选择年柱'.tr;
              }
              if (monthGan == null || monthZhi == null) {
                monthError = '请选择月柱'.tr;
              }
              if (dayGan == null || dayZhi == null) {
                dayError = '请选择日柱'.tr;
              }
              if (includeTimePillar && (timeGan == null || timeZhi == null)) {

                timeError = '请选择时柱'.tr;
              }

              // 验证阴阳配对
              bool isYinYangValid(TianGan? gan, DiZhi? zhi) {
                if (gan == null || zhi == null) return true;
                // 阳干配阳支，阴干配阴支
                return (gan.index % 2) == (zhi.index % 2);
              }

              if (!isYinYangValid(yearGan, yearZhi)) {
                yearError = '天干地支阴阳不匹配'.tr;
              }
              if (!isYinYangValid(monthGan, monthZhi)) {
                monthError = '天干地支阴阳不匹配'.tr;
              }
              if (!isYinYangValid(dayGan, dayZhi)) {
                dayError = '天干地支阴阳不匹配'.tr;
              }
              if (includeTimePillar && !isYinYangValid(timeGan, timeZhi)) {
                timeError = '天干地支阴阳不匹配'.tr;
              }


              final startYear = int.tryParse(startYearController.text);
              final endYear = int.tryParse(endYearController.text);

              if (startYear == null || endYear == null) {
                rangeError = '请输入有效的年份'.tr;
              } else if (startYear > endYear) {
                rangeError = '起始年份不能大于结束年份'.tr;
              }

              if (yearError != null || monthError != null || dayError != null ||
                  timeError != null || rangeError != null) {
                setState(() {});
                return;
              }

              // 开始搜索
              setState(() => isSearching = true);

              try {
                // 读取当前真太阳时设置
                final settings = ref.read(appSettingsProvider);
                final birthInput = ref.read(inputNotifierProvider).birthInput;
                final useTrueSolarTime = birthInput.resolveUseTrueSolarTime(settings.useTrueSolarTime);

                final results = BaziReverseLookup.searchFullBazi(
                  BaziFullSearchQuery(
                    year: GanZhi(yearGan!, yearZhi!),
                    month: GanZhi(monthGan!, monthZhi!),
                    day: GanZhi(dayGan!, dayZhi!),
                    time: includeTimePillar && timeGan != null && timeZhi != null
                        ? GanZhi(timeGan!, timeZhi!)
                        : null,
                    startDate: AstroDateTime(startYear!, 1, 1),
                    endDate: AstroDateTime(endYear!, 12, 31),
                    useTrueSolarTime: useTrueSolarTime,
                  ),
                );

                setState(() => isSearching = false);

                if (results.isEmpty) {
                  noResultsMessage = '未找到匹配结果，请尝试扩大年份搜索范围'.tr;
                  setState(() {});
                  return;
                }

                Navigator.of(context).pop();
                _showBaziSearchResultsDialog(context, ref, results);
              } catch (e) {
                setState(() {
                  isSearching = false;
                  final errorMsg = e.toString();
                  if (errorMsg.contains('WuHuDun')) {
                    searchError = '年柱与月柱不匹配（五虎遁）'.tr;
                  } else if (errorMsg.contains('startDate')) {
                    searchError = '起始日期必须早于或等于结束日期'.tr;
                  } else {
                    searchError = '搜索出错'.tr + ': ' + errorMsg;
                  }
                });
              }
            }

            return AlertDialog(
              title: Text('八字反查'.tr),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 年柱
                    _buildPillarRow(
                      label: '年柱'.tr,
                      gan: yearGan,
                      zhi: yearZhi,
                      onGanChanged: (value) {
                        setState(() {
                          yearGan = value;
                          yearError = null;
                          searchError = null;
                          noResultsMessage = null;
                        });
                      },
                      onZhiChanged: (value) {
                        setState(() {
                          yearZhi = value;
                          yearError = null;
                          searchError = null;
                          noResultsMessage = null;
                        });
                      },
                      errorText: yearError,
                    ),
                    const SizedBox(height: 12),
                    // 月柱
                    _buildPillarRow(
                      label: '月柱'.tr,
                      gan: monthGan,
                      zhi: monthZhi,
                      onGanChanged: (value) {
                        setState(() {
                          monthGan = value;
                          monthError = null;
                          searchError = null;
                          noResultsMessage = null;
                        });
                      },
                      onZhiChanged: (value) {
                        setState(() {
                          monthZhi = value;
                          monthError = null;
                          searchError = null;
                          noResultsMessage = null;
                        });
                      },
                      errorText: monthError,
                    ),
                    const SizedBox(height: 12),
                    // 日柱
                    _buildPillarRow(
                      label: '日柱'.tr,
                      gan: dayGan,
                      zhi: dayZhi,
                      onGanChanged: (value) {
                        setState(() {
                          dayGan = value;
                          dayError = null;
                          searchError = null;
                          noResultsMessage = null;
                        });
                      },
                      onZhiChanged: (value) {
                        setState(() {
                          dayZhi = value;
                          dayError = null;
                          searchError = null;
                          noResultsMessage = null;
                        });
                      },
                      errorText: dayError,
                    ),
                    const SizedBox(height: 12),
                    // 时柱（可选）
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: includeTimePillar,
                              onChanged: (value) => setState(() {
                                includeTimePillar = value ?? false;
                                if (!includeTimePillar) {
                                  timeGan = null;
                                  timeZhi = null;
                                  timeError = null;
                                }
                              }),
                            ),
                            Text('时柱'.tr),
                            if (includeTimePillar) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildGanZhiDropdowns(
                                  gan: timeGan,
                                  zhi: timeZhi,
                                  onGanChanged: (value) {
                                    setState(() {
                                      timeGan = value;
                                      timeError = null;
                                      searchError = null;
                                      noResultsMessage = null;
                                    });
                                  },
                                  onZhiChanged: (value) {
                                    setState(() {
                                      timeZhi = value;
                                      timeError = null;
                                      searchError = null;
                                      noResultsMessage = null;
                                    });
                                  },
                                  errorText: timeError,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (timeError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 48, top: 4),
                            child: Text(
                              timeError!,
                              style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    const Divider(height: 24),
                    // 搜索范围
                    Text('搜索范围'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: startYearController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {
                            rangeError = null;
                            noResultsMessage = null;
                          }),
                            decoration: InputDecoration(
                              labelText: '起始年份'.tr,
                              border: const OutlineInputBorder(),
                              isDense: true,
                              errorText: rangeError,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('~'),
                        ),
                        Expanded(
                          child: TextField(
                            controller: endYearController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {
                              rangeError = null;
                              noResultsMessage = null;
                            }),
                            decoration: InputDecoration(
                              labelText: '结束年份'.tr,
                              border: const OutlineInputBorder(),
                              isDense: true,
                              errorText: rangeError,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 搜索错误提示
                    if (searchError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  searchError!,
                                  style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // 无结果提示
                    if (noResultsMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search_off, color: Colors.orange.shade800, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  noResultsMessage!,
                                  style: TextStyle(color: Colors.orange.shade800, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // 搜索中提示
                    if (isSearching)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSearching ? null : () => Navigator.of(context).pop(),
                  child: Text('取消'.tr),
                ),
                TextButton(
                  onPressed: isSearching ? null : validateAndSearch,
                  child: Text('搜索'.tr),
                ),
              ],
            );
          },
        );
      },
    );
  }
  Widget _buildPillarRow({
    required String label,
    required TianGan? gan,
    required DiZhi? zhi,
    required ValueChanged<TianGan?> onGanChanged,
    required ValueChanged<DiZhi?> onZhiChanged,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SizedBox(width: 48, child: Text(label)),
            Expanded(
              child: _buildGanZhiDropdowns(
                gan: gan,
                zhi: zhi,
                onGanChanged: onGanChanged,
                onZhiChanged: onZhiChanged,
                errorText: errorText,
              ),
            ),
          ],
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 48, top: 4),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red.shade700, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildGanZhiDropdowns({
    required TianGan? gan,
    required DiZhi? zhi,
    required ValueChanged<TianGan?> onGanChanged,
    required ValueChanged<DiZhi?> onZhiChanged,
    String? errorText,
  }) {
    final hasError = errorText != null;
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<TianGan>(
            value: gan,
            isExpanded: true,
            hint: Text('天干'.tr),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey,
                  width: hasError ? 2 : 1,
                ),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            items: TianGan.values.map((g) {
              return DropdownMenuItem(
                value: g,
                child: Text(g.display),
              );
            }).toList(),
            onChanged: onGanChanged,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<DiZhi>(
            value: zhi,
            isExpanded: true,
            hint: Text('地支'.tr),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey,
                  width: hasError ? 2 : 1,
                ),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            items: DiZhi.values.map((z) {
              return DropdownMenuItem(
                value: z,
                child: Text(z.display),
              );
            }).toList(),
            onChanged: onZhiChanged,
          ),
        ),
      ],
    );
  }
  Future<void> _showBaziSearchResultsDialog(
    BuildContext context,
    WidgetRef ref,
    List<BaziFullCandidate> results,
  ) async {
    if (results.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('搜索结果'.tr),
          content: Text('未找到结果'.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('确定'.tr),
            ),
          ],
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('搜索结果'.tr),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                final dateTime = result.timeCandidate?.sampleTime ?? result.dateCandidate.sampleTime;
                final chart = result.chart;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      _applyBaziSearchResult(ref, dateTime);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} '
                                  '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${chart.bazi.year.display} ${chart.bazi.month.display} '
                                  '${chart.bazi.day.display} ${chart.bazi.time.display}',
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _applyBaziSearchResult(ref, dateTime);
                            },
                            child: Text('应用'.tr),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('关闭'.tr),
            ),
          ],
        );
      },
    );
  }

  void _applyBaziSearchResult(WidgetRef ref, AstroDateTime dateTime) {
    final solarInput = SolarBirthInput(
      year: dateTime.year,
      month: dateTime.month,
      day: dateTime.day,
      hour: dateTime.hour,
      minute: dateTime.minute,
      second: dateTime.second,
    );

    final notifier = ref.read(inputNotifierProvider.notifier);
    notifier
      ..updateSolarInput(solarInput)
      ..updateCalendarType(BirthCalendarType.solar)
      ..updateBirthUseTrueSolarTime(false); // 八字反查结果默认关闭真太阳时
  }

  Future<void> _showZiweiReverseLookupDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    int? lucunIndex;
    int? hongluanIndex;
    int? zuofuIndex;
    int? wenchangIndex;
    int? santaiIndex;
    int? ziweiIndex;

    final currentYear = DateTime.now().year;
    final startYearController = TextEditingController(text: (currentYear - 50).toString());
    final endYearController = TextEditingController(text: (currentYear + 50).toString());

    String? lucunError, hongluanError, zuofuError, wenchangError, santaiError, rangeError, searchError;
    String? noResultsMessage;
    var isSearching = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void validateAndSearch() {
              lucunError = null;
              hongluanError = null;
              zuofuError = null;
              wenchangError = null;
              santaiError = null;
              rangeError = null;
              searchError = null;
              noResultsMessage = null;

              if (lucunIndex == null) lucunError = '请选择禄存所在宫位'.tr;
              if (hongluanIndex == null) hongluanError = '请选择红鸾所在宫位'.tr;
              if (zuofuIndex == null) zuofuError = '请选择左辅所在宫位'.tr;
              if (wenchangIndex == null) wenchangError = '请选择文昌所在宫位'.tr;
              if (santaiIndex == null) santaiError = '请选择三台所在宫位'.tr;

              final startYear = int.tryParse(startYearController.text);
              final endYear = int.tryParse(endYearController.text);

              if (startYear == null || endYear == null) {
                rangeError = '请输入有效的年份'.tr;
              } else if (startYear > endYear) {
                rangeError = '起始年份不能大于结束年份'.tr;
              }

              if (lucunError != null || hongluanError != null || zuofuError != null ||
                  wenchangError != null || santaiError != null || rangeError != null) {
                setState(() {});
                return;
              }

              setState(() => isSearching = true);

              try {
                final settings = ref.read(appSettingsProvider);
                final profile = ref.read(inputNotifierProvider);
                final birthInput = profile.birthInput;
                final useTrueSolarTime = birthInput.resolveUseTrueSolarTime(settings.useTrueSolarTime);
                final ruleset = ref.read(ziweiRulesetProvider);

                final results = ZiweiReverseLookup.searchTier1(
                  ZiweiTier1Query(
                    lucunIndex: lucunIndex,
                    hongluanIndex: hongluanIndex,
                    zuofuIndex: zuofuIndex,
                    wenchangIndex: wenchangIndex,
                    santaiIndex: santaiIndex,
                    ziweiIndex: ziweiIndex,
                    startDate: AstroDateTime(startYear!, 1, 1),
                    endDate: AstroDateTime(endYear!, 12, 31),
                    ruleset: ruleset,
                    gender: profile.gender,
                    location: birthInput.location,
                    timeZone: birthInput.timeZone,
                    useTrueSolarTime: useTrueSolarTime,
                  ),
                );

                setState(() => isSearching = false);

                if (results.isEmpty) {
                  noResultsMessage = '未找到匹配结果，请尝试扩大年份搜索范围'.tr;
                  setState(() {});
                  return;
                }

                Navigator.of(context).pop();
                _showZiweiSearchResultsDialog(context, ref, results);
              } catch (e) {
                setState(() {
                  isSearching = false;
                  searchError = '搜索出错'.tr + ': ' + e.toString();
                });
              }
            }

            return AlertDialog(
              title: Text('紫微反查'.tr),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStarPalaceRow(
                      label: '禄存'.tr,
                      value: lucunIndex,
                      errorText: lucunError,
                      hint: '请选择禄存所在宫位'.tr,
                      onChanged: (value) {
                        setState(() {
                          lucunIndex = value;
                          lucunError = null;
                          searchError = null;
                          noResultsMessage = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildStarPalaceRow(
                      label: '红鸾'.tr,
                      value: hongluanIndex,
                      errorText: hongluanError,
                      hint: '请选择红鸾所在宫位'.tr,
                      onChanged: (value) {
                        setState(() {
                          hongluanIndex = value;
                          hongluanError = null;
                          searchError = null;
                          noResultsMessage = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildStarPalaceRow(
                      label: '左辅'.tr,
                      value: zuofuIndex,
                      errorText: zuofuError,
                      hint: '请选择左辅所在宫位'.tr,
                      onChanged: (value) {
                        setState(() {
                          zuofuIndex = value;
                          zuofuError = null;
                          searchError = null;
                          noResultsMessage = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildStarPalaceRow(
                      label: '文昌'.tr,
                      value: wenchangIndex,
                      errorText: wenchangError,
                      hint: '请选择文昌所在宫位'.tr,
                      onChanged: (value) {
                        setState(() {
                          wenchangIndex = value;
                          wenchangError = null;
                          searchError = null;
                          noResultsMessage = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildStarPalaceRow(
                      label: '三台'.tr,
                      value: santaiIndex,
                      errorText: santaiError,
                      hint: '请选择三台所在宫位'.tr,
                      onChanged: (value) {
                        setState(() {
                          santaiIndex = value;
                          santaiError = null;
                          searchError = null;
                          noResultsMessage = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildStarPalaceRow(
                      label: '紫微星'.tr,
                      value: ziweiIndex,
                      hint: '请选择紫微星所在宫位（可选）'.tr,
                      onChanged: (value) {
                        setState(() {
                          ziweiIndex = value;
                          searchError = null;
                          noResultsMessage = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: startYearController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '起始年份'.tr,
                              errorText: rangeError,
                              isDense: true,
                            ),
                            onChanged: (_) {
                              setState(() {
                                rangeError = null;
                                searchError = null;
                                noResultsMessage = null;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: endYearController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '结束年份'.tr,
                              errorText: rangeError,
                              isDense: true,
                            ),
                            onChanged: (_) {
                              setState(() {
                                rangeError = null;
                                searchError = null;
                                noResultsMessage = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (searchError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        searchError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    if (noResultsMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        noResultsMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSearching ? null : () => Navigator.of(context).pop(),
                  child: Text('取消'.tr),
                ),
                ElevatedButton(
                  onPressed: isSearching ? null : validateAndSearch,
                  child: isSearching
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('搜索'.tr),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStarPalaceRow({
    required String label,
    required int? value,
    required ValueChanged<int?> onChanged,
    String? errorText,
    required String hint,
  }) {
    final hasError = errorText != null;
    return Row(
      children: [
        SizedBox(width: 56, child: Text(label)),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<int>(
            value: value,
            isExpanded: true,
            hint: Text(hint),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey,
                  width: hasError ? 2 : 1,
                ),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            items: DiZhi.values.map((z) {
              return DropdownMenuItem(
                value: z.index,
                child: Text(z.display),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Future<void> _showZiweiSearchResultsDialog(
    BuildContext context,
    WidgetRef ref,
    List<ZiweiReverseCandidate> results,
  ) async {
    if (results.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('搜索结果'.tr),
          content: Text('未找到结果'.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('确定'.tr),
            ),
          ],
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('搜索结果'.tr),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                final dt = result.solarDate;
                final hourName = DiZhi.values[result.hourIndex].display;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      _applyZiweiSearchResult(ref, dt);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${dt.year}-${_twoDigits(dt.month)}-${_twoDigits(dt.day)} '
                                  '${_twoDigits(dt.hour)}:${_twoDigits(dt.minute)}:${_twoDigits(dt.second)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${result.lunarYear}年 ${result.lunarMonth}月 ${formatLunarDayLabel(result.lunarDay)} $hourName${result.isLeapMonth ? " (闰月)" : ""}',
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _applyZiweiSearchResult(ref, dt);
                            },
                            child: Text('应用'.tr),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('关闭'.tr),
            ),
          ],
        );
      },
    );
  }

  void _applyZiweiSearchResult(WidgetRef ref, AstroDateTime dateTime) {
    final solarInput = SolarBirthInput(
      year: dateTime.year,
      month: dateTime.month,
      day: dateTime.day,
      hour: dateTime.hour,
      minute: dateTime.minute,
      second: dateTime.second,
    );

    final notifier = ref.read(inputNotifierProvider.notifier);
    notifier
      ..updateSolarInput(solarInput)
      ..updateCalendarType(BirthCalendarType.solar)
      ..updateBirthUseTrueSolarTime(false);
  }
}

class _CityPickerDialog extends StatefulWidget {
  @override
  State<_CityPickerDialog> createState() => _CityPickerDialogState();
}

enum _CityPickerStep { province, city, district }

class _CityPickerDialogState extends State<_CityPickerDialog> {
  int? _provinceId;
  int? _cityId;
  _CityPickerStep _compactStep = _CityPickerStep.province;

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
    final screenSize = MediaQuery.of(context).size;
    final isCompact = screenSize.width < 560;
    final dialogWidth = isCompact
        ? (screenSize.width - 48).clamp(280.0, 380.0).toDouble()
        : 720.0;
    final dialogHeight = isCompact
        ? (screenSize.height * 0.72).clamp(360.0, 520.0).toDouble()
        : 420.0;

    return AlertDialog(
      title: Text('选择城市'.tr),
      content: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: isCompact
            ? _buildCompactPicker(
                context,
                provinces,
                citiesOfProvince,
                districtsOfCity,
              )
            : _buildWidePicker(
                context,
                provinces,
                citiesOfProvince,
                districtsOfCity,
              ),
      ),
    );
  }

  Widget _buildWidePicker(
    BuildContext context,
    List<AreaData> provinces,
    List<AreaData> citiesOfProvince,
    List<AreaData> districtsOfCity,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildSection(
            title: '省'.tr,
            child: ListView.builder(
              itemCount: provinces.length,
              itemBuilder: (context, index) {
                final item = provinces[index];
                final selected = item.id == _provinceId;
                return ListTile(
                  dense: true,
                  selected: selected,
                  title: Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _selectProvince(item.id),
                );
              },
            ),
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: _buildSection(
            title: '市'.tr,
            child: ListView.builder(
              itemCount: citiesOfProvince.length,
              itemBuilder: (context, index) {
                final item = citiesOfProvince[index];
                final selected = item.id == _cityId;
                return ListTile(
                  dense: true,
                  selected: selected,
                  title: Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _selectCity(item.id),
                );
              },
            ),
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: _buildSection(
            title: '区'.tr,
            child: ListView.builder(
              itemCount: districtsOfCity.length,
              itemBuilder: (context, index) {
                final item = districtsOfCity[index];
                return _buildDistrictTile(context, item, dense: true);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactPicker(
    BuildContext context,
    List<AreaData> provinces,
    List<AreaData> citiesOfProvince,
    List<AreaData> districtsOfCity,
  ) {
    Widget currentList;
    switch (_compactStep) {
      case _CityPickerStep.province:
        currentList = ListView.builder(
          itemCount: provinces.length,
          itemBuilder: (context, index) {
            final item = provinces[index];
            final selected = item.id == _provinceId;
            return ListTile(
              selected: selected,
              title: Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _selectProvince(item.id, moveNext: true),
            );
          },
        );
      case _CityPickerStep.city:
        currentList = ListView.builder(
          itemCount: citiesOfProvince.length,
          itemBuilder: (context, index) {
            final item = citiesOfProvince[index];
            final selected = item.id == _cityId;
            return ListTile(
              selected: selected,
              title: Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _selectCity(item.id, moveNext: true),
            );
          },
        );
      case _CityPickerStep.district:
        currentList = ListView.builder(
          itemCount: districtsOfCity.length,
          itemBuilder: (context, index) {
            final item = districtsOfCity[index];
            return _buildDistrictTile(context, item, dense: false);
          },
        );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<_CityPickerStep>(
          segments: [
            ButtonSegment(
              value: _CityPickerStep.province,
              label: Text('省'.tr),
            ),
            ButtonSegment(
              value: _CityPickerStep.city,
              label: Text('市'.tr),
            ),
            ButtonSegment(
              value: _CityPickerStep.district,
              label: Text('区'.tr),
            ),
          ],
          selected: {_compactStep},
          onSelectionChanged: (selection) {
            setState(() {
              _compactStep = selection.first;
            });
          },
        ),
        const SizedBox(height: 12),
        Expanded(child: currentList),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildDistrictTile(
    BuildContext context,
    AreaData item, {
    required bool dense,
  }) {
    return ListTile(
      dense: dense,
      title: Text(
        item.name,
        maxLines: dense ? 2 : 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${item.longitude.toStringAsFixed(2)}, ${item.latitude.toStringAsFixed(2)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => Navigator.pop(context, item),
    );
  }

  void _selectProvince(int provinceId, {bool moveNext = false}) {
    setState(() {
      _provinceId = provinceId;
      final nextCities = _cities;
      _cityId = nextCities.isNotEmpty ? nextCities.first.id : null;
      if (moveNext) {
        _compactStep = _CityPickerStep.city;
      }
    });
  }

  void _selectCity(int cityId, {bool moveNext = false}) {
    setState(() {
      _cityId = cityId;
      if (moveNext) {
        _compactStep = _CityPickerStep.district;
      }
    });
  }
}
