import 'package:flutter/material.dart';
import 'package:packup/widget/reply/reply_card.dart';
import 'package:packup/widget/reply/reply_section_title.dart';
import 'package:packup/widget/reply/reply_star_rating.dart';

class ReplyRatingSection extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const ReplyRatingSection({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ReplySectionTitle('평점 주기'),
        ReplyCard(
          child: ReplyStarRating(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
