import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/model/reply/reply_model.dart';
import 'package:packup/widget/review/reply_card.dart';

class ReplyListView extends StatelessWidget {
  final List<ReplyModel> replyList;
  final bool useListView;
  final ScrollController? scrollController;

  const ReplyListView({
    super.key,
    required this.replyList,
    this.useListView = true,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    itemBuilder(ReplyModel reply) => Padding(
      padding: EdgeInsets.symmetric(vertical: screenH * 0.02),
      child: InkWell(
        onTap: () async {
          await context.push('/reply_write/${reply.seq}');
        },
        child: ReplyCard(
          nickName: reply.nickName ?? '',
          avatarUrl: reply.profileImagePath,
          content: reply.content ?? '',
          point: reply.point ?? 0,
          createdAt: reply.createdAt!,
        ),
      ),
    );

    if (useListView) {
      return ListView.builder(
        controller: scrollController,
        shrinkWrap: false,
        itemCount: replyList.length,
        itemBuilder: (context, index) => itemBuilder(replyList[index]),
      );
    } else {
      return Column(
        children: replyList.map(itemBuilder).toList(),
      );
    }
  }
}
