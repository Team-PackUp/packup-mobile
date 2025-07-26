import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/Const/color.dart';
import 'package:packup/widget/reply/section/reply_list_section.dart';

import '../../../../model/reply/reply_model.dart';
import '../../../common/util_widget.dart';

class ReviewListSection extends StatelessWidget {
  final int seq;
  const ReviewListSection({Key? key, required this.seq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Column(
      children: [
        ReplyListSection(
          targetSeq: seq,
          targetType: TargetType.replyTour,
        ),

        SizedBox(height: screenH * 0.03),

        CustomButton.textButton(
          context: context,
          backgroundColor: PRIMARY_COLOR,
          label: '모든 댓글 보기',
          onPressed: () {
            context.push('/reply_list/4/REPLY_TOUR');
          },
        ),
      ],
    );
  }
}
