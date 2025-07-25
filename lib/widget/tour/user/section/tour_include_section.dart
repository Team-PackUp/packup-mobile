import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';
import 'package:packup/widget/tour/user/include_item.dart';

class TourIncludeSection extends StatelessWidget {
  const TourIncludeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tour = TourDetailModel.mock();
    final screenH = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '포함 사항',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: screenH * 0.02),
        ...tour.includeItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: IncludeItem(text: item),
          ),
        ),
      ],
    );
  }
}
