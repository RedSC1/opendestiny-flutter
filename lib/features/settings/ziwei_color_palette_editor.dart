import 'package:flutter/material.dart';
import '../../core/l10n.dart';
import '../../core/ziwei_l10n.dart';
import '../../models/ziwei_color_palette.dart';

class ZiweiColorPaletteEditorPage extends StatefulWidget {
  const ZiweiColorPaletteEditorPage({
    super.key,
    required this.initialPalette,
    required this.brightnessLabels,
    required this.onChanged,
  });

  final ZiweiColorPalette initialPalette;
  final Map<int, String> brightnessLabels;
  final ValueChanged<ZiweiColorPalette> onChanged;

  @override
  State<ZiweiColorPaletteEditorPage> createState() =>
      _ZiweiColorPaletteEditorPageState();
}

class _ZiweiColorPaletteEditorPageState
    extends State<ZiweiColorPaletteEditorPage> {
  late ZiweiColorPalette _palette;

  static const List<int> _presetColors = [
    0xFFC62828,
    0xFFAD1457,
    0xFF6A1B9A,
    0xFF4527A0,
    0xFF283593,
    0xFF1565C0,
    0xFF0277BD,
    0xFF00838F,
    0xFF00695C,
    0xFF2E7D32,
    0xFF558B2F,
    0xFF9E9D24,
    0xFFF9A825,
    0xFFEF6C00,
    0xFFD84315,
    0xFF4E342E,
    0xFF546E7A,
    0xFF616161,
    0xFF212121,
    0xFF111111,
  ];

  @override
  void initState() {
    super.initState();
    _palette = widget.initialPalette;
  }

  void _updatePalette(ZiweiColorPalette next) {
    setState(() {
      _palette = next;
    });
    widget.onChanged(next);
  }

  Future<void> _pickColor({
    required String title,
    required int currentValue,
    required ValueChanged<int> onSelected,
  }) async {
    final selected = await showDialog<int>(
      context: context,
      builder: (context) => _ColorPickerDialog(
        title: title,
        currentValue: currentValue,
        presetColors: _presetColors,
      ),
    );

    if (selected != null) {
      onSelected(selected);
    }
  }

  List<int> get _sortedBrightnessIndexes {
    final keys = widget.brightnessLabels.keys.where((index) => index >= 0).toList()
      ..sort((a, b) => b.compareTo(a));
    return keys;
  }

  String _brightnessLabel(int index) {
    final raw = widget.brightnessLabels[index];
    if (raw == null || raw.isEmpty) {
      return '${'等级'.tr} $index';
    }
    final localized = formatBrightness(raw);
    final display = localized.isEmpty ? raw : localized;
    return '$display ($index)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑自定义配色'.tr),
        actions: [
          TextButton(
            onPressed: () => _updatePalette(const ZiweiColorPalette()),
            child: Text('恢复默认'.tr),
          ),
        ],
      ),
      body: ListView(
        children: [
          _sectionTitle('四化配色'),
          _colorTile(
            label: '化禄'.tr,
            value: _palette.sihuaLu,
            onTap: () => _pickColor(
              title: '化禄'.tr,
              currentValue: _palette.sihuaLu,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(sihuaLu: value)),
            ),
          ),
          _colorTile(
            label: '化权'.tr,
            value: _palette.sihuaQuan,
            onTap: () => _pickColor(
              title: '化权'.tr,
              currentValue: _palette.sihuaQuan,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(sihuaQuan: value)),
            ),
          ),
          _colorTile(
            label: '化科'.tr,
            value: _palette.sihuaKe,
            onTap: () => _pickColor(
              title: '化科'.tr,
              currentValue: _palette.sihuaKe,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(sihuaKe: value)),
            ),
          ),
          _colorTile(
            label: '化忌'.tr,
            value: _palette.sihuaJi,
            onTap: () => _pickColor(
              title: '化忌'.tr,
              currentValue: _palette.sihuaJi,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(sihuaJi: value)),
            ),
          ),
          const Divider(),
          _sectionTitle('亮度配色'),
          ..._sortedBrightnessIndexes.map(
            (index) => _colorTile(
              label: _brightnessLabel(index),
              value: _palette.brightnessColorValue(index),
              onTap: () => _pickColor(
                title: _brightnessLabel(index),
                currentValue: _palette.brightnessColorValue(index),
                onSelected: (value) => _updatePalette(
                  _palette.copyWithBrightnessColor(index, value),
                ),
              ),
            ),
          ),
          if (_sortedBrightnessIndexes.isEmpty)
            ListTile(
              title: Text('当前亮度流派没有可编辑的亮度等级'.tr),
            ),
          const Divider(),
          _sectionTitle('流运配色'),
          _colorTile(
            label: '大限'.tr,
            value: _palette.scopeDecade,
            onTap: () => _pickColor(
              title: '大限'.tr,
              currentValue: _palette.scopeDecade,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(scopeDecade: value)),
            ),
          ),
          _colorTile(
            label: '小限'.tr,
            value: _palette.scopeSmallLimit,
            onTap: () => _pickColor(
              title: '小限'.tr,
              currentValue: _palette.scopeSmallLimit,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(scopeSmallLimit: value)),
            ),
          ),
          _colorTile(
            label: '流年'.tr,
            value: _palette.scopeYear,
            onTap: () => _pickColor(
              title: '流年'.tr,
              currentValue: _palette.scopeYear,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(scopeYear: value)),
            ),
          ),
          _colorTile(
            label: '流月'.tr,
            value: _palette.scopeMonth,
            onTap: () => _pickColor(
              title: '流月'.tr,
              currentValue: _palette.scopeMonth,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(scopeMonth: value)),
            ),
          ),
          _colorTile(
            label: '流日'.tr,
            value: _palette.scopeDay,
            onTap: () => _pickColor(
              title: '流日'.tr,
              currentValue: _palette.scopeDay,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(scopeDay: value)),
            ),
          ),
          _colorTile(
            label: '流时'.tr,
            value: _palette.scopeHour,
            onTap: () => _pickColor(
              title: '流时'.tr,
              currentValue: _palette.scopeHour,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(scopeHour: value)),
            ),
          ),
          const Divider(),
          _sectionTitle('静态星曜配色'),
          _colorTile(
            label: '主星'.tr,
            value: _palette.majorStar,
            onTap: () => _pickColor(
              title: '主星'.tr,
              currentValue: _palette.majorStar,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(majorStar: value)),
            ),
          ),
          _colorTile(
            label: '吉星'.tr,
            value: _palette.luckyStar,
            onTap: () => _pickColor(
              title: '吉星'.tr,
              currentValue: _palette.luckyStar,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(luckyStar: value)),
            ),
          ),
          _colorTile(
            label: '煞星'.tr,
            value: _palette.badStar,
            onTap: () => _pickColor(
              title: '煞星'.tr,
              currentValue: _palette.badStar,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(badStar: value)),
            ),
          ),
          _colorTile(
            label: '杂曜'.tr,
            value: _palette.minorStar,
            onTap: () => _pickColor(
              title: '杂曜'.tr,
              currentValue: _palette.minorStar,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(minorStar: value)),
            ),
          ),
          _colorTile(
            label: '长生十二神'.tr,
            value: _palette.changsheng12,
            onTap: () => _pickColor(
              title: '长生十二神'.tr,
              currentValue: _palette.changsheng12,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(changsheng12: value)),
            ),
          ),
          _colorTile(
            label: '博士十二神'.tr,
            value: _palette.boshi12,
            onTap: () => _pickColor(
              title: '博士十二神'.tr,
              currentValue: _palette.boshi12,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(boshi12: value)),
            ),
          ),
          _colorTile(
            label: '岁建十二神'.tr,
            value: _palette.suijian12,
            onTap: () => _pickColor(
              title: '岁建十二神'.tr,
              currentValue: _palette.suijian12,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(suijian12: value)),
            ),
          ),
          _colorTile(
            label: '将前十二神'.tr,
            value: _palette.jiangqian12,
            onTap: () => _pickColor(
              title: '将前十二神'.tr,
              currentValue: _palette.jiangqian12,
              onSelected: (value) =>
                  _updatePalette(_palette.copyWith(jiangqian12: value)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        title.tr,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _colorTile({
    required String label,
    required int value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(label),
      subtitle: Text(_formatColorHex(value)),
      trailing: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Color(value),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black12),
        ),
      ),
      onTap: onTap,
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  const _ColorPickerDialog({
    required this.title,
    required this.currentValue,
    required this.presetColors,
  });

  final String title;
  final int currentValue;
  final List<int> presetColors;

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late final TextEditingController _controller;
  late int _selectedValue;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.currentValue;
    _controller = TextEditingController(text: _formatColorHex(widget.currentValue));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyHex() {
    final parsed = _parseColorHex(_controller.text);
    if (parsed == null) {
      setState(() {
        _error = '颜色格式无效'.tr;
      });
      return;
    }
    setState(() {
      _selectedValue = parsed;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Color(_selectedValue),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '颜色十六进制'.tr,
                hintText: '#C62828',
                errorText: _error,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _applyHex,
                child: Text('应用'.tr),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.presetColors.map((value) {
                final selected = value == _selectedValue;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedValue = value;
                      _controller.text = _formatColorHex(value);
                      _error = null;
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Color(value),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? Colors.black : Colors.black12,
                        width: selected ? 2 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
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
          onPressed: () => Navigator.of(context).pop(_selectedValue),
          child: Text('确定'.tr),
        ),
      ],
    );
  }
}

String _formatColorHex(int value) =>
    '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

int? _parseColorHex(String input) {
  final normalized = input.trim().replaceAll('#', '').replaceAll('0x', '');
  if (normalized.length != 6 && normalized.length != 8) {
    return null;
  }

  final parsed = int.tryParse(normalized, radix: 16);
  if (parsed == null) {
    return null;
  }
  return normalized.length == 6 ? (0xFF000000 | parsed) : parsed;
}
