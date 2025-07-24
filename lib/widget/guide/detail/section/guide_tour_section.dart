import 'package:flutter/material.dart';
import 'package:packup/provider/tour/tour_provider.dart';
import 'package:packup/widget/guide/detail/guide_tour_list.dart';
import 'package:packup/widget/guide/detail/section.dart';

import 'package:provider/provider.dart';

class GuideTourSection extends StatelessWidget {
  const GuideTourSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tourList = context.watch<TourProvider>().tourList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: '🌟',
          title: 'Tour Detail',
          subTitle: 'JALIM 가이드가 운영하는 투어입니다!',
        ),
        GuideTourList(tours: tourList, onTap: (_) {}),
      ],
    );
  }
}
