import 'package:flutter/material.dart';

import '../../../../Const/color.dart';

class PreferenceCard extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;
  final String imagePath;

  const PreferenceCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? SECONDARY_COLOR : Colors.grey.shade300,
            width: 1.5,
          ),
          color: isSelected
              ? SECONDARY_COLOR.withOpacity(0.15)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              category,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? SECONDARY_COLOR : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
