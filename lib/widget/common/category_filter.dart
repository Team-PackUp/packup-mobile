import 'package:flutter/material.dart';
import 'package:packup/const/color.dart';

enum SelectionMode { single, multiple }

class CategoryFilter<T> extends StatefulWidget {
  final List<T> items;
  final List<T>? initialSelectedItems;
  final String Function(T item) labelBuilder;
  final Widget? Function(T item)? emojiBuilder;
  final SelectionMode mode;
  final void Function(List<T> selectedItems) onSelectionChanged;
  final bool allowDeselectInSingle;

  final bool readOnly;

  const CategoryFilter({
    super.key,
    required this.items,
    required this.labelBuilder,
    this.emojiBuilder,
    this.mode = SelectionMode.multiple,
    required this.onSelectionChanged,
    this.initialSelectedItems,
    this.readOnly = false,
    this.allowDeselectInSingle = true,
  });

  @override
  State<CategoryFilter<T>> createState() => _CategoryFilterState<T>();
}

class _CategoryFilterState<T> extends State<CategoryFilter<T>> {
  final Set<int> _selected = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedItems != null) {
      for (var item in widget.initialSelectedItems!) {
        final idx = widget.items.indexOf(item);
        if (idx != -1) {
          _selected.add(idx);
        }
      }
    }
  }

  void _onTap(int idx, bool nextSelected) {
    if (widget.readOnly) return;

    // 싱글 모드 로직
    if (widget.mode == SelectionMode.single) {
      final isCurrentlySelected = _selected.contains(idx);

      if (!widget.allowDeselectInSingle && !nextSelected && isCurrentlySelected) {
        return;
      }

      setState(() {
        if (nextSelected) {
          _selected
            ..clear()
            ..add(idx);
        } else {
          _selected.clear();
        }
      });

      final chosen = _selected.map((i) => widget.items[i]).toList();
      widget.onSelectionChanged(chosen);
      return;
    }

    setState(() {
      if (nextSelected) {
        _selected.add(idx);
      } else {
        _selected.remove(idx);
      }
    });

    final chosen = _selected.map((i) => widget.items[i]).toList();
    widget.onSelectionChanged(chosen);
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

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
            SizedBox(width: screenW * 0.02),
            Text(label),
          ])
              : Text(label);

          final isSelected = _selected.contains(i);

          return Padding(
            padding: EdgeInsets.only(right: screenW * 0.015),
            child: widget.mode == SelectionMode.single
                ? ChoiceChip(
              label: chipLabel,
              selected: isSelected,
              onSelected: (sel) {
                if (widget.readOnly) return;
                _onTap(i, sel);
              },
              selectedColor: PRIMARY_COLOR,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            )
                : FilterChip(
              label: chipLabel,
              selected: isSelected,
              onSelected: (sel) {
                if (widget.readOnly) return;
                _onTap(i, sel);
              },
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
