import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:packup/provider/reply/reply_provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/reply/reply_list_card.dart';
import 'package:provider/provider.dart';
import '../../model/reply/reply_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReplyList extends StatelessWidget {

  final int targetSeq;
  final TargetType targetType;

  const ReplyList(
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
      getNoticeListMore();
    }
  }

  getNoticeListMore() async {
    _replyProvider.getReplyList();
  }

  Future<void> refreshReplyList() {
    return _replyProvider.getReplyList(reset: true);
  }

  @override
  Widget build(BuildContext context) {

    _replyProvider = context.watch<ReplyProvider>();

    var filteredReplyList = _replyProvider.replyList;

    return Scaffold(
      appBar: CustomAppbar(title: 'AppLocalizations.of(context)!.reply'),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshReplyList,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredReplyList.length,
                  itemBuilder: (context, index) {
                    final reply = filteredReplyList[index];

                    return InkWell(
                        onTap: () async {
                          final moved = await context.push<bool>('/reply_write/${reply.seq}');

                          if (moved == true) refreshReply();
                        },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ReplyCard(
                                  author: '美梨',
                                  content: reply.content!,
                                  // targetType: reply.targetType!,
                                  createdAt: reply.createdAt!,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ),
            ),
        ],
      ),
    );
  }

  Future<void> refreshReply() async {
    _replyProvider.getReplyList(reset: true);
  }
}
