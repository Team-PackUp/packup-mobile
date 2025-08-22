import 'package:flutter/material.dart';

class GuideIntroCard extends StatelessWidget {
  const GuideIntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '가이드가 처음이신가요?',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '지금 바로 가이드가 되어서\n님의 지역과 도시를 소개해주세요!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B7280),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
