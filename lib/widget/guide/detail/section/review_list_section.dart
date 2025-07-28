import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/model/reply/reply_model.dart';
import 'package:packup/provider/reply/reply_provider.dart';
import 'package:packup/widget/common/util_widget.dart';

import '../../../review/reply_list_view.dart';

// 상세보기 페이지의 댓글(리뷰) 일부 보여주는 섹션
class ReviewListSection extends StatefulWidget {
  final int seq;

  const ReviewListSection({super.key, required this.seq});

  @override
  State<ReviewListSection> createState() => _ReviewListSectionState();
}

class _ReviewListSectionState extends State<ReviewListSection> {
  List<ReplyModel> _replyList = [];

  @override
  void initState() {
    super.initState();
    _loadTopReplies();
  }

  Future<void> _loadTopReplies() async {
    final _replyProvider = ReplyProvider.create(
      targetSeq: widget.seq,
      targetType: TargetType.replyTour,
    );

    await _replyProvider.getReplyList();
    setState(() {
      _replyList = _replyProvider.replyList.take(10).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_replyList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('댓글 ${_replyList.length}'),
            CustomButton.textGestureDetector(
              context: context,
              onTap: () {
                context.push('/reply_list/${widget.seq}/REPLY_TOUR');
              },
              label: '모두 보기',
            ),
          ],
        ),
        ReplyListView(
          replyList: _replyList,
          useListView: false,
          refreshReply: _loadTopReplies,
        ),
      ],
    );
  }
}
