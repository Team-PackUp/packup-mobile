import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_model_temp.dart';
import 'package:packup/widget/tour/user/guide_card.dart';

import '../../../../model/guide/guide_model.dart';

class TourGuideSection extends StatelessWidget {
  final GuideModel guide;
  const TourGuideSection({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {


    return GuideCard(guide: guide);
  }
}
