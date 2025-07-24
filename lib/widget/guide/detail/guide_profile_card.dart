import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/widget/tour/detail/rating.dart';
import 'package:packup/widget/tour/detail/tag.dart';

class GuideProfileCard extends StatelessWidget {
  final GuideModelTemp guide;

  const GuideProfileCard({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(
                  guide.guideAvatarPath?.isNotEmpty == true
                      ? guide.guideAvatarPath!
                      : 'https://i.imgur.com/BoN9kdC.png',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guide.guideName ?? '가이드 이름 없음',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Rating(rating: guide.guideRating ?? 0.0, reviewCount: 37),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            guide.guideIntroduce ?? '',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                guide.languages?.map((lang) => Tag(label: lang)).toList() ?? [],
          ),
        ],
      ),
    );
  }
}
