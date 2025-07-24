import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String icon;
  final String title;
  final String? subTitle;
  final String? callBackText;
  final VoidCallback? onSeeMore;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.callBackText,
    this.subTitle,
    this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon),
        SizedBox(width: screenW * 0.01),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (subTitle != null)
                Text(
                  subTitle!,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
            ],
          ),
        ),

        if (onSeeMore != null && callBackText != null)
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
