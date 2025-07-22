import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';

import '../../../model/ai_recommend/ai_recommend_category_model.dart';
import '../home/category_filter.dart';

class CategoryChip extends StatefulWidget {
  final List<AIRecommendCategoryModel> categories;
  final void Function(AIRecommendCategoryModel category)? onTapCategory;
  const CategoryChip({super.key, required this.categories, this.onTapCategory});

  @override
  State<CategoryChip> createState() => _CategoryChip();
}

class _CategoryChip extends State<CategoryChip> {
  int _selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return CategoryFilter(
      onSelectionChanged: (selectedList) {
        print('선택된 카테고리: $selectedList');
      },
    );
  }
}
