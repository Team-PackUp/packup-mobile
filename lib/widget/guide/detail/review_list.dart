import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_review_model_temp.dart';
import 'package:packup/widget/guide/detail/review_card.dart';

class ReviewList extends StatelessWidget {
  final List<GuideReviewModelTemp> reviews;
  final ValueChanged<GuideReviewModelTemp> onTap;

  const ReviewList({super.key, required this.reviews, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) return const SizedBox.shrink();
    final screenH = MediaQuery.of(context).size.height;

    return Column(
      children: [
        ...reviews.map(
          (review) => GestureDetector(
            onTap: () => onTap(review),
            behavior: HitTestBehavior.opaque,
            child: ReviewCard(review: review),
          ),
        ),
      ],
    );
  }
}
