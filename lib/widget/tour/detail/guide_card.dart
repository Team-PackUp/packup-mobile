import 'package:flutter/material.dart';
import 'package:packup/widget/tour/detail/%08rating.dart';
import 'package:packup/widget/tour/detail/tour_tag.dart';

class GuideCard extends StatelessWidget {
  const GuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 가이드 사진
          const CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
            radius: 30,
          ),
          const SizedBox(width: 12),

          /// 텍스트 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ji-hoon Kim',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Rating(rating: 4.1, reviewCount: 12),
                const SizedBox(height: 8),
                const Text(
                  "Experienced local guide specializing in Seoul's hidden culinary gems and traditional tea houses. Fluent in English and Japanese.",
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: const [
                    TourTag(label: 'English'),
                    TourTag(label: 'Japanese'),
                    TourTag(label: 'Korean'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
