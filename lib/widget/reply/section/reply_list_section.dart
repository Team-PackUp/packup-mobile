import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/reply/reply_provider.dart';
import 'package:packup/widget/reply/reply_card.dart';
import 'package:provider/provider.dart';
import '../../../model/reply/reply_model.dart';


class ReplyListSection extends StatelessWidget {

  final int targetSeq;
  final TargetType targetType;

  const ReplyListSection(
      {
        super.key,
        required this.targetSeq,
        required this.targetType,
      }
      );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReplyProvider.create(
          targetSeq: targetSeq,
          targetType: TargetType.replyTour
      ),
      child: const ReplyListContent(),
    );
  }
}

class ReplyListContent extends StatefulWidget {
  const ReplyListContent({super.key});

  @override
  _ReplyListContentState createState() => _ReplyListContentState();
}

class _ReplyListContentState extends State<ReplyListContent> {

  late ScrollController _scrollController;
  late ReplyProvider _replyProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _replyProvider = context.read<ReplyProvider>();
      await _replyProvider.getReplyList();
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _scrollController.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
      print("더 조회하기 있긴 함..");
    }
  }


  Future<void> refreshReplyList() {
    return _replyProvider.getReplyList(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    _replyProvider = context.watch<ReplyProvider>();

    var filteredReplyList = _replyProvider.replyList;

    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: filteredReplyList.length,
      itemBuilder: (context, index) {
        final reply = filteredReplyList[index];

        return Card(
          color: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () async {
              final moved = await context.push<bool>('/reply_write/${reply.seq}');
              if (moved == true) refreshReply();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenH * 0.02),
              child: ReplyCard(
                nickName: reply.nickName!,
                avatarUrl: reply.profileImagePath,
                content: reply.content!,
                point: reply.point!,
                createdAt: reply.createdAt!,
              ),
            ),
          ),
        );
      },
    );

  }

  Future<void> refreshReply() async {
    _replyProvider.getReplyList(reset: true);
  }
}
