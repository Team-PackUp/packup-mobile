import 'package:flutter/material.dart';
import 'package:packup/widget/guide/guide_card.dart';

class GuideSection extends StatelessWidget {
  const GuideSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시 가이드 데이터
    final guides = [
      {
        'name': '임준아',
        'desc': '플러터의신. 다음직장은 어디로갈것인가',
        'tours': 15,
        'image': 'https://i.pravatar.cc/150?img=3',
      },
      {
        'name': '박민석',
        'desc': '미국 거주 PRO 가이드 - 과제 따오는법도 알려줌',
        'tours': 12,
        'image': 'https://i.pravatar.cc/150?img=5',
      },
      {
        'name': '정준모',
        'desc': '행복해지고싶다',
        'tours': 10,
        'image': 'https://i.pravatar.cc/150?img=8',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🌟 전문 가이드를 만나보세요',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: guides.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final guide = guides[index];
                return GuideCard(
                  name: guide['name'] as String,
                  desc: guide['desc'] as String,
                  tourCount: guide['tours'] as int,
                  imageUrl: guide['image'] as String,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
