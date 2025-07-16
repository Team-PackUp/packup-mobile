import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/model/profile/contact_center/faq_category_model.dart';

import '../../../model/ai_recommend/category_model.dart';

class FaqCategory extends StatefulWidget {
  final List<FaqCategoryModel> categories;
  final void Function(FaqCategoryModel category)? onTapCategory;
  const FaqCategory({
    super.key,
    required this.categories,
    this.onTapCategory,
  });

  @override
  State<FaqCategory> createState() => _FaqCategoryState();
}

class _FaqCategoryState extends State<FaqCategory> {
  int _selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.categories.length, (i) {
          final selected = i == _selectedIdx;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(widget.categories[i].codeName!),
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
