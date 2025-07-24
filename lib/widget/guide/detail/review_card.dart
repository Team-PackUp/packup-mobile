import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_review_model_temp.dart';

class ReviewCard extends StatelessWidget {
  final GuideReviewModelTemp review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: screenW * 0.02),
                    const Text("•", style: TextStyle(color: Colors.grey)),
                    SizedBox(width: screenW * 0.02),
                    Text(
                      review.date,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 14,
                    color:
                        index < review.rating
                            ? Colors.orange
                            : Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: screenH * 0.02),

          Text(
            review.content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
