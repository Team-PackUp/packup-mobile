import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';
import 'package:packup/widget/tour/user/tour_description.dart';

class TourDescriptionSection extends StatelessWidget {
  const TourDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tour = TourDetailModel(
      title: '인사동 & 북촌 걷기 투어',
      imageUrl: 'assets/image/background/jeonju.jpg',
      rating: 4.8,
      reviewCount: 150,
      tags: ['Culture', 'History', 'Walking Tour', 'Seoul'],
      description:
          '돈벌고싶어? 대기업가고싶어? 뭐해? PACK-UP 안하고? 너 돈 많아? 따라만 오면 된다니까? 내가 길 다 정리해놨다니까?',
      duration: '1년',
      languages: ['영어', '준모어', '중국어'],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TourDescription(tour: tour),
    );
  }
}
