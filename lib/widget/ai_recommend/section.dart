// lib/pages/ai_recommend/widgets/section_header.dart
// ----------------------------------------------------
import 'package:flutter/material.dart';

/// 공통 섹션 헤더 (🔥/🔍/⭐ ... + "더보기")
class SectionHeader extends StatelessWidget {
  final String icon;        // 이모지 또는 아이콘 텍스트
  final String title;       // 섹션 제목
  final VoidCallback onSeeMore; // "더보기" 탭 콜백

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.onSeeMore,
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
        GestureDetector(
          onTap: onSeeMore,
          child: const Text(
            '더보기',
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
