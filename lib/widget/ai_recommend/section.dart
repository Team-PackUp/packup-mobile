import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String icon;
  final String title;
  final String? callBackText;
  final VoidCallback? onSeeMore;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.callBackText,
    this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        if(onSeeMore != null && callBackText != null)
          GestureDetector(
            onTap: onSeeMore,
            child: Text(
              callBackText!,
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
