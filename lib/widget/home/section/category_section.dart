import 'package:flutter/material.dart';
import 'package:packup/widget/common/category_filter.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map 안에 emoji, label 이 들어있는 리스트
    final categories = <Map<String, String>>[
      {'emoji': '🏕', 'label': '팩업'},
      {'emoji': '🧹', 'label': '마무리'},
      {'emoji': '😊', 'label': '음식'},
      {'emoji': '🪂', 'label': '액티비티'},
      {'emoji': '🍲', 'label': '문화'},
      {'emoji': '🏕', 'label': '자연'},
    ];

    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenH * 0.02),
      child: CategoryFilter<Map<String, String>>(
        items: categories,
        labelBuilder: (cat) => cat['label']!,
        emojiBuilder: (cat) => Text(cat['emoji']!),
        mode: SelectionMode.multiple,
        onSelectionChanged: (selectedCats) {
          final labels = selectedCats.map((c) => c['label']!).toList();
          print('선택된 카테고리: $labels');
        },
      ),
    );
  }
}
