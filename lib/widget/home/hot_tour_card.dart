import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/model/tour/tour_model.dart';
import '../../common/util.dart';
import '../common/slide_text.dart';

class HotTourCard extends StatelessWidget {
  const HotTourCard({super.key, required this.tour});
  final TourModel tour;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    final cardWidth = screenW * 0.4;
    final imageHeight = cardWidth * 0.65;

    return SizedBox(
      width: cardWidth,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: screenW * 0.02,
          vertical: screenH * 0.01,
        ),
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
                    errorBuilder:
                        (_, __, ___) => Image.asset(
                          'assets/image/logo/logo.png',
                          fit: BoxFit.cover,
                        ),
                  ),
                ),
                if (tour.remainPeople <= 3)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenW * 0.02,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(screenW * 0.02),
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
              padding: EdgeInsets.symmetric(
                horizontal: screenW * 0.03,
                vertical: screenH * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SlideText(title: tour.tourTitle ?? ''),
                  SizedBox(height: screenH * 0.01),
                  Row(
                    children: [
                      const Icon(Icons.place, size: 12, color: Colors.grey),
                      SizedBox(width: screenW * 0.01),
                      Expanded(
                        child: Text(
                          tour.tourLocation ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenH * 0.003),
                  Text(
                    formatPrice(tour.tourPrice!),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: screenH * 0.003),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(
                          fullFileUrl(tour.guideModel?.guideAvatarPath ?? ''),
                        ),
                        onBackgroundImageError: (_, __) {},
                      ),
                      SizedBox(width: screenW * 0.02),
                      Expanded(
                        child: Text(
                          tour.guideModel?.guideName ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
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
