import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/reply/reply_provider.dart';
import 'package:provider/provider.dart';
import '../../../model/reply/reply_model.dart';
import '../../common/util_widget.dart';
import '../reply_list_view.dart';

// 댓글(리뷰) 전체 보기 섹션
class ReplyListSection extends StatelessWidget {

  const ReplyListSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final replyProvider = context.watch<ReplyProvider>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('댓글 ${replyProvider.replyList.length}'),
          ],
        ),
        Expanded(
          child: ReplyListView(
            replyList: replyProvider.replyList,
            scrollController: PrimaryScrollController.of(context),
            useListView: true,
          ),
        ),
      ],
    );
  }

}
