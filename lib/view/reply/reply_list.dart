import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/reply/reply_model.dart';
import '../../provider/reply/reply_provider.dart';
import '../../widget/common/custom_appbar.dart';
import '../../widget/review/section/reply_list_section.dart';

// 이 위젯은 댓글(리뷰) 전체 보기용
class ReplyList extends StatefulWidget {
  final int targetSeq;
  final TargetType targetType;

  const ReplyList({
    super.key,
    required this.targetSeq,
    required this.targetType,
  });

  @override
  State<ReplyList> createState() => _ReplyListState();
}

class _ReplyListState extends State<ReplyList> {
  late final ScrollController _scrollController;
  late ReplyProvider _replyProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      _replyProvider.getReplyList();
    }
  }

  Future<void> _onRefresh() async {
    await _replyProvider.getReplyList(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReplyProvider>(
      create: (_) => ReplyProvider.create(
        targetSeq: widget.targetSeq,
        targetType: widget.targetType,
      )..getReplyList(),
      builder: (context, child) {
        _replyProvider = context.read<ReplyProvider>();

        return Scaffold(
          appBar: CustomAppbar(title: '모든 댓글'),
          body: PrimaryScrollController(
            controller: _scrollController,
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ReplyListSection(),
            ),
          ),
        );
      },
    );
  }

}
