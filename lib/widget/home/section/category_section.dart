import 'package:flutter/material.dart';
import 'package:packup/widget/home/category_filter.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CategoryFilter(onSelectionChanged: (_) {}),
    );
  }
}
