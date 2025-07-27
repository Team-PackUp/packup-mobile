import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/widget/tour/user/rating.dart';
import 'package:packup/widget/tour/user/tag.dart';

class GuideProfileCard extends StatelessWidget {
  final GuideModelTemp guide;

  const GuideProfileCard({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(screenH * 0.02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: screenH * 0.035,
                backgroundImage: NetworkImage(
                  guide.guideAvatarPath?.isNotEmpty == true
                      ? guide.guideAvatarPath!
                      : 'https://i.imgur.com/BoN9kdC.png',
                ),
              ),
              SizedBox(width: screenW * 0.04),
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
                    Rating(rating: guide.guideRating ?? 0.0, reviewCount: 37),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: screenH * 0.02),

          Text(
            guide.guideIntroduce ?? '',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),

          SizedBox(height: screenH * 0.02),

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
