import 'package:flutter/material.dart';
import 'package:packup/const/color.dart';

enum SelectionMode { single, multiple }

class CategoryFilter<T> extends StatefulWidget {
  final List<T> items;

  // 라벨 뽑는 함수
  final String Function(T item) labelBuilder;

  // 이모지 뽑는 함수
  final Widget? Function(T item)? emojiBuilder;

  // single: ChoiceChip (하나만 선택)
  // multiple: FilterChip (다중 선택)
  final SelectionMode mode;

  final void Function(List<T> selectedItems) onSelectionChanged;

  const CategoryFilter({
    super.key,
    required this.items,
    required this.labelBuilder,
    this.emojiBuilder,
    this.mode = SelectionMode.multiple,
    required this.onSelectionChanged,
  });

  @override
  State<CategoryFilter<T>> createState() => _CategoryFilterState<T>();
}

class _CategoryFilterState<T> extends State<CategoryFilter<T>> {
  final Set<int> _selected = {};

  void _onTap(int idx, bool selected) {
    setState(() {
      if (widget.mode == SelectionMode.single) {
        _selected
          ..clear()
          ..addAll(selected ? {idx} : {});
      } else {
        if (selected) {
          _selected.add(idx);
        } else {
          _selected.remove(idx);
        }
      }
    });

    final chosen = _selected.map((i) => widget.items[i]).toList();
    widget.onSelectionChanged(chosen);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.items.length, (i) {
          final item = widget.items[i];
          final label = widget.labelBuilder(item);
          final avatar = widget.emojiBuilder?.call(item);
          final chipLabel = avatar != null
              ? Row(mainAxisSize: MainAxisSize.min, children: [
            avatar,
            const SizedBox(width: 4),
            Text(label),
          ]) : Text(label);

          final isSelected = _selected.contains(i);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: widget.mode == SelectionMode.single
                ? ChoiceChip(
              label: chipLabel,
              selected: isSelected,
              onSelected: (sel) => _onTap(i, sel),
              selectedColor: PRIMARY_COLOR,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ) : FilterChip(
              label: chipLabel,
              selected: isSelected,
              onSelected: (sel) => _onTap(i, sel),
              selectedColor: PRIMARY_COLOR.withOpacity(0.2),
              backgroundColor: BACK_GROUND_COLOR_W,
              side: BorderSide(
                color: isSelected ? PRIMARY_COLOR : LIGHT_GREY_COLOR,
              ),
              labelStyle: TextStyle(
                color: isSelected ? PRIMARY_COLOR : TEXT_COLOR_B,
              ),
              checkmarkColor: PRIMARY_COLOR,
            ),
          );
        }),
      ),
    );
  }
}

