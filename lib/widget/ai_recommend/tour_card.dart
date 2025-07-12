import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';
import '../../../model/ai_recommend/recommend_tour_model.dart';
import '../../common/util.dart';
import 'package:marquee/marquee.dart';

import '../common/slide_text.dart';

class TourCard extends StatelessWidget {
  const TourCard({super.key, required this.tour});
  final RecommendTourModel tour;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final cardWidth   = screenW * 0.4;
    final imageHeight = cardWidth * 0.65;

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Image.network(
                    fullFileUrl(tour.titleImagePath ?? ''),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Image.asset('assets/image/logo/logo.png',
                            fit: BoxFit.cover),
                  ),
                ),
                if (tour.remainPeople <= 3)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '마감 임박! (${tour.remainPeople}자리 남음)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SlideText(
                    title: tour.tourTitle ?? '',
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.place, size: 12, color: Colors.grey),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          tour.tourLocation ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₩${tour.tourPrice?.toStringAsFixed(0) ?? ''}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(
                          fullFileUrl(tour.guideModel?.guideAvatarPath ?? ''),
                        ),
                        onBackgroundImageError: (_, __) {},
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          tour.guideModel?.guideName ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey),
                        ),
                      ),
                    ],
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
