import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';
import 'package:packup/widget/tour/user/tour_image_card.dart';
import 'package:packup/widget/tour/user/tour_meta_card.dart';

class TourHeaderSection extends StatelessWidget {
  const TourHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tour = TourDetailModel(
      title: '인사동 & 북촌 걷기 투어',
      imageUrl: 'assets/image/background/jeonju.jpg',
      rating: 4.8,
      reviewCount: 150,
      tags: ['Culture', 'History', 'Walking Tour', 'Seoul'],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TourImageCard(tour: tour),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: TourMetaCard(tour: tour),
        ),
      ],
    );
  }
}
