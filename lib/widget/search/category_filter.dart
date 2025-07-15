import 'package:flutter/material.dart';
import 'package:packup/const/color.dart';

class CategoryFilter extends StatefulWidget {
  final void Function(List<String> selectedCategories) onSelectionChanged;

  const CategoryFilter({super.key, required this.onSelectionChanged});

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  final List<Map<String, String>> categories = const [
    {'emoji': '🏕', 'label': '팩업'},
    {'emoji': '🏕', 'label': '끝내자제발'},
    {'emoji': '😊', 'label': '음식'},
    {'emoji': '🪂', 'label': '액티비티'},
    {'emoji': '🍲', 'label': '문화'},
    {'emoji': '🏕', 'label': '자연'},
  ];

  final Set<String> _selectedLabels = {};

  void _toggleCategory(String label) {
    setState(() {
      if (_selectedLabels.contains(label)) {
        _selectedLabels.remove(label);
      } else {
        _selectedLabels.add(label);
      }
    });

    widget.onSelectionChanged(_selectedLabels.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.search, size: 18),
            SizedBox(width: 6),
            Text(
              '종류별로 탐색하기',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 12),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                categories.map((category) {
                  final label = category['label']!;
                  final emoji = category['emoji']!;
                  final isSelected = _selectedLabels.contains(label);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text('$emoji $label'),
                      selected: isSelected,
                      onSelected: (_) => _toggleCategory(label),
                      selectedColor: PRIMARY_COLOR.withOpacity(0.2),
                      backgroundColor: BACK_GROUND_COLOR_W,
                      side: BorderSide(
                        color: isSelected ? PRIMARY_COLOR : LIGHT_GREY_COLOR,
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? PRIMARY_COLOR : TEXT_COLOR_B,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      checkmarkColor: PRIMARY_COLOR,
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
