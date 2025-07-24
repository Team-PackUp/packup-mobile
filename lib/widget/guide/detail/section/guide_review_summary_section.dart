import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_rating_model_temp.dart';
import 'package:packup/widget/guide/detail/guide_review_summary.dart';

class GuideReviewSummarySection extends StatelessWidget {
  const GuideReviewSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final GuideRatingModelTemp rating = GuideRatingModelTemp.mock();

    return GuideReviewSummary(rating: rating);
  }
}
