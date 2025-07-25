import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/widget/tour/user/guide_card.dart';

class TourGuideSection extends StatelessWidget {
  const TourGuideSection({super.key});

  @override
  Widget build(BuildContext context) {
    final guide = GuideModelTemp(
      seq: 123,
      name: 'Juna Jeong',
      image: 'https://i.imgur.com/uE67908.jpeg',
      guideRating: 4.1,
      tours: 12,
      desc: 'The King of the Daejeon. The God of the Chungnam University.',
      languages: ['Java', '준모어', 'Python'],
    );

    return GuideCard(guide: guide);
  }
}
