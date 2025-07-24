import 'package:flutter/material.dart';
import 'package:packup/model/tour/tour_detail_model.dart';
import 'package:packup/widget/tour/user/rating.dart';
import 'package:packup/widget/tour/user/tag.dart';

class TourMetaCard extends StatelessWidget {
  final TourDetailModel tour;

  const TourMetaCard({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tour.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Rating(rating: tour.rating, reviewCount: tour.reviewCount),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tour.tags.map((tag) => Tag(label: tag)).toList(),
          ),
        ],
      ),
    );
  }
}
