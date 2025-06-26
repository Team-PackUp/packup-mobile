// lib/pages/ai_recommend/widgets/category_chips.dart
// ----------------------------------------------------
import 'package:flutter/material.dart';

import '../../../model/ai_recommend/category_model.dart';

class CategoryChips extends StatelessWidget {
  final List<CategoryModel> categories;

  const CategoryChips({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: categories
          .map((c) => Chip(label: Text(c.name), avatar: Icon(c.icon, size: 16)))
          .toList(),
    );
  }
}
