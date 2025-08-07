import 'package:flutter/material.dart';
import 'package:packup/widget/user/preference/preference_card.dart';

class PreferenceList extends StatelessWidget {
  final List<String> categories;
  final Set<String> selected;
  final Function(String) toggleSelect;
  final Map<String, String> categoryImageMap;

  const PreferenceList({
    super.key,
    required this.categories,
    required this.selected,
    required this.toggleSelect,
    required this.categoryImageMap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.8,
        children: categories.map((category) {
          final isSelected = selected.contains(category);
          final imagePath = categoryImageMap[category]!;
          return PreferenceCard(
            category: category,
            isSelected: isSelected,
            imagePath: imagePath,
            onTap: () => toggleSelect(category),
          );
        }).toList(),
      ),
    );
  }
}
