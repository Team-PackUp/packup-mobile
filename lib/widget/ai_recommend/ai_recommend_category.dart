import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';

import '../../../model/ai_recommend/ai_recommend_category_model.dart';

class AIRecommendCategory extends StatefulWidget {
  final List<AIRecommendCategoryModel> categories;
  final void Function(AIRecommendCategoryModel category)? onTapCategory;
  const AIRecommendCategory({
    super.key,
    required this.categories,
    this.onTapCategory,
  });

  @override
  State<AIRecommendCategory> createState() => _AIRecommendCategory();
}

class _AIRecommendCategory extends State<AIRecommendCategory> {
  int _selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.categories.length, (i) {
          final selected = i == _selectedIdx;
          return Padding(
            padding: EdgeInsets.only(right: screenW * 0.02),
            child: ChoiceChip(
              label: Text(widget.categories[i].name),
              selected: selected,
              onSelected: (bool value) {
                setState(() => _selectedIdx = i);

                if (value && widget.onTapCategory != null) {
                  widget.onTapCategory!(widget.categories[i]);
                }
              },
              selectedColor: PRIMARY_COLOR,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          );
        }),
      ),
    );
  }
}
