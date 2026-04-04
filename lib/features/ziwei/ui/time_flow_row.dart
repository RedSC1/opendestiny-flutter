import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'ziwei_classic_theme.dart';

/// 通用的时间轴行组件
class TimeFlowRow<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? selectedItem;
  final String Function(T) itemLabelBuilder;
  final String Function(T)? itemSubLabelBuilder;
  final Function(T) onItemSelected;
  final Color activeColor;

  /// 自定义选中判断（解决对象引用不等的问题）
  final bool Function(T item, T? selected)? isSelectedBuilder;
  final double adaptiveScale;

  const TimeFlowRow({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItem,
    required this.itemLabelBuilder,
    required this.onItemSelected,
    required this.activeColor,
    this.itemSubLabelBuilder,
    this.isSelectedBuilder,
    this.adaptiveScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    double s(num value) => value * adaptiveScale;

    return Container(
      height: s(62),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ZiweiClassicTheme.cellBorderColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // 左侧标签
          Container(
            width: s(38),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ZiweiClassicTheme.timeRowLabelBg,
              border: Border(
                right: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: s(10),
                fontWeight: FontWeight.w900,
                color: Colors.grey,
              ),
            ),
          ),
          // 右侧卡片滚动流
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.stylus,
                },
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: s(8),
                  vertical: s(6),
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = isSelectedBuilder != null
                      ? isSelectedBuilder!(item, selectedItem)
                      : item == selectedItem;

                  return GestureDetector(
                    onTap: () => onItemSelected(item),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: s(60),
                      margin: EdgeInsets.only(right: s(6)),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? activeColor.withOpacity(0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(s(6)),
                        border: Border.all(
                          color: isSelected
                              ? activeColor
                              : Colors.grey.withOpacity(0.15),
                          width: isSelected ? s(1.6) : s(1.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              itemLabelBuilder(item),
                              style: TextStyle(
                                fontSize: s(13),
                                fontWeight: isSelected
                                    ? FontWeight.w900
                                    : FontWeight.w700,
                                color: isSelected
                                    ? activeColor
                                    : Colors.black87,
                                height: 1.1,
                              ),
                            ),
                          ),
                          if (itemSubLabelBuilder != null)
                            Text(
                              itemSubLabelBuilder!(item),
                              style: TextStyle(
                                fontSize: s(9),
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? activeColor
                                    : ZiweiClassicTheme.subLabelColor,
                                height: 1.1,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
