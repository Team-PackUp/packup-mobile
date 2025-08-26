import 'package:flutter/material.dart';
import '../../model/reply/reply_model.dart';
import '../../widget/common/custom_appbar.dart';
import '../../widget/reply/section/reply_list_section.dart';

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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppbar(title: '모든 댓글'),
      body: PrimaryScrollController(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.04,
            vertical: screenH * 0.01,
          ),
          child: ReplyListSection(
            targetSeq: widget.targetSeq,
            targetType: widget.targetType,
            scrollController: _scrollController,
          ),
        ),
      ),
    );
  }
}
