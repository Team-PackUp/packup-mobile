import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/widget/guide/detail/guide_profile_card.dart';

class GuideProfileSection extends StatelessWidget {
  const GuideProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final guide = GuideModelTemp(
      guideName: 'Joona Lim',
      guideRating: 4.8,
      guideIntroduce: '전주 플러터1등 운전1등 PHP1등 임준아입니다. 고려샹크스라는 별명으로 활동하고 있습니다.',
      guideAvatarPath: 'https://i.imgur.com/2qLxayi.jpeg',
      languages: ['English', 'Japanese', 'Flutter'],
    );

    return GuideProfileCard(guide: guide);
  }
}
