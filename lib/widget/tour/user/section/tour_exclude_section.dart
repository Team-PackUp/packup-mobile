import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';
import 'package:packup/widget/tour/user/tour_exclude.dart';

class TourExcludeSection extends StatelessWidget {
  const TourExcludeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tour = TourDetailModel.mock();

    final screenH = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '제외 사항',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: screenH * 0.02),

          ...tour.excludeItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ExcludeItem(text: item),
            ),
          ),
        ],
      ),
    );
  }
}
