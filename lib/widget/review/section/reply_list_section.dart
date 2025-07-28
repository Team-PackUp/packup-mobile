import 'package:flutter/material.dart';
import 'package:packup/provider/reply/reply_provider.dart';
import 'package:provider/provider.dart';
import '../reply_list_view.dart';
import '../../../model/reply/reply_model.dart';

// 댓글(리뷰) 전체 보기 섹션
class ReplyListSection extends StatefulWidget {
  final int targetSeq;
  final TargetType targetType;
  final ScrollController? scrollController;

  const ReplyListSection({
    super.key,
    required this.targetSeq,
    required this.targetType,
    this.scrollController,
  });

  @override
  State<ReplyListSection> createState() => _ReplyListSectionState();
}

class _ReplyListSectionState extends State<ReplyListSection> {
  late final ReplyProvider _replyProvider;

  @override
  void initState() {
    super.initState();
    _replyProvider = ReplyProvider.create(
      targetSeq: widget.targetSeq,
      targetType: widget.targetType,
    );
    _replyProvider.getReplyList();

    widget.scrollController?.addListener(_onScroll);
  }

  void _onScroll() async {
    final controller = widget.scrollController;
    if (controller == null) return;

    if (controller.position.pixels >= controller.position.maxScrollExtent - 100) {
      await _replyProvider.getReplyList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReplyProvider>.value(
      value: _replyProvider,
      child: Consumer<ReplyProvider>(
        builder: (context, replyProvider, _) {
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
                    scrollController: widget.scrollController,
                    useListView: true,
                    refreshReply: () async {
                      await replyProvider.getReplyList(reset: true);
                    },
                  ),
                ),
              ],
          );
        },
      ),
    );
  }
}
