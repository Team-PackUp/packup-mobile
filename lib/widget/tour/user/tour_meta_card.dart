import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';
import 'package:packup/widget/tour/user/rating.dart';
import 'package:packup/widget/tour/user/tag.dart';

class TourMetaCard extends StatelessWidget {
  final TourDetailModel tour;

  const TourMetaCard({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tour.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: screenH * 0.01),
          Rating(rating: tour.rating, reviewCount: tour.reviewCount),
          SizedBox(height: screenH * 0.02),
          Wrap(
            spacing: 4,
            runSpacing: 8,
            children: tour.tags.map((tag) => Tag(label: tag)).toList(),
          ),
        ],
      ),
    );
  }
}
