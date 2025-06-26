// lib/pages/ai_recommend/widgets/tour_card.dart
// ----------------------------------------------------
import 'package:flutter/material.dart';
import 'package:packup/Common/util.dart';

import '../../../model/ai_recommend/recommend_tour_model.dart';

class TourCard extends StatelessWidget {
  final RecommendTourModel tour;

  const TourCard({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              fullFileUrl(tour.titleImagePath!) ?? '',
              height: MediaQuery.of(context).size.height * 0.1,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour.tourTitle ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  tour.tourIntroduce ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                // Row(
                //   children: [
                //     const Icon(Icons.star, size: 14, color: Colors.amber),
                //     const SizedBox(width: 2),
                //     Text(
                //       tour.title,
                //       style: const TextStyle(fontSize: 12),
                //     ),
                //     const SizedBox(width: 4),
                //     Text(
                //       '(${tour.title} 리뷰)',
                //       style: const TextStyle(fontSize: 12, color: Colors.grey),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 6),
                // Text(
                //   tour.title,
                //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
