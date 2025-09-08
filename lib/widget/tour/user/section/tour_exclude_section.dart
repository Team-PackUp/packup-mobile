import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';
import 'package:packup/widget/tour/user/tour_exclude.dart';

class TourExcludeSection extends StatelessWidget {
  final TourDetailModel tour;
  const TourExcludeSection({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '제외 사항',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: screenH * 0.02),
        ...tour.excludeItems.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: screenH * 0.01),
            child: ExcludeItem(text: item),
          ),
        ),
      ],
    );
  }
}
