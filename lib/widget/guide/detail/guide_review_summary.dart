import 'package:flutter/material.dart';
import 'package:packup/const/color.dart';
import 'package:packup/model/guide/guide_rating_model_temp.dart';

class GuideReviewSummary extends StatelessWidget {
  final GuideRatingModelTemp rating;

  const GuideReviewSummary({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reviews (5)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: screenH * 0.02),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  rating.average.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenH * 0.01),
                const Text("out of 5", style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(width: screenW * 0.05),
            Expanded(
              child: Column(
                children: List.generate(5, (index) {
                  final star = 5 - index;
                  final value = rating.ratingDistribution[star] ?? 0.0;
                  final hasRating = value > 0;

                  return _RatingBarRow(
                    star: star,
                    value: value,
                    hasRating: hasRating,
                    highlight: star == 5,
                  );
                }),
              ),
            ),
          ],
        ),

        SizedBox(height: screenH * 0.02),
        Text(
          "${rating.totalCount} Ratings",
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),

        SizedBox(height: screenH * 0.02),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: Text(
              "Write a Review",
              style: TextStyle(fontWeight: FontWeight.w500, color: SELECTED),
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingBarRow extends StatelessWidget {
  final int star;
  final double value;
  final bool hasRating;
  final bool highlight;

  const _RatingBarRow({
    required this.star,
    required this.value,
    required this.hasRating,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = highlight ? Colors.indigo : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Row(
              children: [
                Text('$star', style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 2),
                const Icon(Icons.star, size: 12, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                if (hasRating)
                  FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
