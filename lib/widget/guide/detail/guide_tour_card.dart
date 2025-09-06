import 'package:flutter/material.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/common/size_config.dart';
import 'package:packup/common/util.dart';
import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/widget/common/slide_text.dart';

import '../../common/circle_profile_image.dart';

class GuideTourCard extends StatelessWidget {
  const GuideTourCard({super.key, required this.tour});
  final TourModel tour;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final borderRadius = BorderRadius.circular(12);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 10 / 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      fullFileUrl(tour.titleImagePath ?? ''),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/image/logo/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    if ((tour.remainPeople) <= 3)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: PRIMARY_COLOR,
                            borderRadius: BorderRadius.circular(12),
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
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SlideText(title: tour.tourTitle ?? ''),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.place, size: 12, color: Colors.grey),
                          const SizedBox(width: 6),
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
                      const SizedBox(height: 6),

                      Text(
                        formatPrice(tour.tourPrice!),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const Spacer(),

                      Row(
                        children: [
                          CircleProfileImage(
                            radius: context.sY(14),
                            imagePath: tour.guideModel?.guideAvatarPath ?? '',
                          ),
                          const SizedBox(width: 8),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
