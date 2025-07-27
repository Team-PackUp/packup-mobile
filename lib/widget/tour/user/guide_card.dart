import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/widget/tour/user/rating.dart';
import 'package:packup/widget/tour/user/tag.dart';

class GuideCard extends StatelessWidget {
  final GuideModelTemp guide;

  const GuideCard({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        context.push('/guide/${guide.seq}');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(screenH * 0.015),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(screenW * 0.02),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(guide.image ?? ''),
              radius: 30,
            ),
            SizedBox(width: screenW * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guide.name ?? '이름 없음',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: screenH * 0.01),
                  Rating(
                    rating: guide.guideRating ?? 0.0,
                    reviewCount: guide.tours ?? 0,
                  ),
                  SizedBox(height: screenH * 0.01),
                  Text(guide.desc ?? '', style: const TextStyle(fontSize: 13)),
                  SizedBox(height: screenH * 0.02),
                  Wrap(
                    spacing: screenW * 0.01,
                    children:
                        guide.languages
                            ?.map((lang) => Tag(label: lang))
                            .toList() ??
                        [],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
