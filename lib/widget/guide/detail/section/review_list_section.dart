import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/model/guide/guide_review_model_temp.dart';
import 'package:packup/widget/guide/detail/review_list.dart';
import 'package:packup/widget/guide/detail/section.dart';

class ReviewListSection extends StatelessWidget {
  const ReviewListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GuideReviewModelTemp> reviews = [
      GuideReviewModelTemp.mock1(),
      GuideReviewModelTemp.mock2(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ReviewList(reviews: reviews, onTap: (_) {})],
    );
  }
}
