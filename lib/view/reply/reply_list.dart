import 'package:flutter/material.dart';
import 'package:packup/provider/reply/reply_provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/reply/reply_list_card.dart';
import 'package:provider/provider.dart';
import '../../model/reply/reply_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReplyList extends StatelessWidget {
  const ReplyList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReplyProvider.create(
          targetSeq: 1,
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

  @override
  Widget build(BuildContext context) {

    _replyProvider = context.watch<ReplyProvider>();

    var filteredReplyList = _replyProvider.replyList;

    return Scaffold(
      appBar: CustomAppbar(title: AppLocalizations.of(context)!.notice),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: filteredReplyList.length,
              itemBuilder: (context, index) {
                final reply = filteredReplyList[index];

                return InkWell(
                  onTap: () async {
                    print("펼치기 or 더보기");
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
                              index: index,
                              content: reply.content,
                              targetType: reply.targetType,
                              createdAt: reply.createdAt,
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
        ],
      ),
    );
  }
}
