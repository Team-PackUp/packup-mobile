import 'package:flutter/material.dart';
import 'package:packup/model/guide/guide_review_model_temp.dart';
import 'package:packup/model/reply/reply_model.dart';
import 'package:packup/widget/guide/detail/review_list.dart';

import '../../../../Const/color.dart';
import '../../../../view/reply/reply_list.dart';
import '../../../common/util_widget.dart';

class ReviewListSection extends StatelessWidget {
  final int seq;
  const ReviewListSection({super.key, required this.seq});

  @override
  Widget build(BuildContext context) {
    final List<GuideReviewModelTemp> reviews = [
      GuideReviewModelTemp.mock1(),
      GuideReviewModelTemp.mock2(),
    ];

    final screenH = MediaQuery.of(context).size.height;

    return Column(
      children: [
        ReplyList(
          targetSeq: seq,
          targetType: TargetType.replyTour,
        ),
        SizedBox(
          height: screenH * 0.03,
        ),
        CustomButton.textButton(
            context: context,
            onPressed: _getAllReply,
            backgroundColor: PRIMARY_COLOR,
            label: '모든 댓글 보기'
        )
      ]
    );
  }

  void _getAllReply() {

  }
}
