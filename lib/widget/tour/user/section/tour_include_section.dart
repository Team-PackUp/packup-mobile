import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';
import 'package:packup/model/tour/tour_model.dart';
import 'package:packup/widget/tour/user/include_item.dart';

class TourIncludeSection extends StatelessWidget {
  final TourDetailModel tour;
  const TourIncludeSection({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '포함 사항',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: screenH * 0.02),

          if (tour.includeItems.isEmpty)
            Text('등록된 포함 사항이 없습니다.',
                style: TextStyle(color: Colors.grey.shade600))
          else
            ...tour.includeItems.map(
                  (item) => Padding(
                padding: EdgeInsets.only(bottom: screenH * 0.01),
                child: IncludeItem(text: item),
              ),
            ),
        ],
      ),
    );
  }
}
