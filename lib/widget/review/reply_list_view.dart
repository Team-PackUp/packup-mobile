import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/model/reply/reply_model.dart';
import 'package:packup/widget/review/reply_card.dart';

class ReplyListView extends StatelessWidget {
  final List<ReplyModel> replyList;
  final VoidCallback refreshReply;
  final ScrollController? scrollController;
  final bool useListView;

  const ReplyListView({
    super.key,
    required this.replyList,
    required this.refreshReply,
    this.scrollController,
    this.useListView = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    itemBuilder(BuildContext context, int index) {
      final reply = replyList[index];

      return Padding(
        padding: EdgeInsets.symmetric(vertical: screenH * 0.01),
        child: GestureDetector(
          onTap: () async {
            final moved = await context.push<bool>('/reply_write/${reply.seq}');
            if (moved == true) refreshReply();
          },
          child: ReplyCard(
            nickName: reply.nickName!,
            avatarUrl: reply.profileImagePath,
            content: reply.content!,
            point: reply.point!,
            createdAt: reply.createdAt!,
          ),
        ),
      );

    }

    if (useListView) {
      return ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: replyList.length,
        itemBuilder: itemBuilder,
      );
    } else {
      return Column(
        children: replyList.asMap().entries.map((entry) {
          final index = entry.key;
          final reply = entry.value;
          return itemBuilder(context, index);
        }).toList(),
      );
    }
  }
}
