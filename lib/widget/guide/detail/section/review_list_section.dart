import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:packup/model/reply/reply_model.dart';
import 'package:packup/provider/reply/reply_provider.dart';
import 'package:packup/widget/common/util_widget.dart';
import '../../../reply/reply_list_view.dart';

class ReviewListSection extends StatefulWidget {
  final int tourSeq;
  const ReviewListSection({super.key, required this.tourSeq});

  @override
  State<ReviewListSection> createState() => _ReviewListSectionState();
}

class _ReviewListSectionState extends State<ReviewListSection> {
  late final ReplyProvider _provider;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _provider = ReplyProvider();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _loaded) return;
      _loaded = true;

      await _provider.getReplyList(
        targetSeq: widget.tourSeq,
        targetType: TargetType.replyTour,
      );

      if (!mounted) return;
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReplyProvider>.value(
      value: _provider,
      child: Consumer<ReplyProvider>(
        builder: (_, p, __) {
          final List<ReplyModel> replies = p.replyList;

          if (p.isLoading && replies.isEmpty) {
            return const SizedBox.shrink();
          }
          if (replies.isEmpty) {
            return const SizedBox.shrink();
          }

          final countLabel = '댓글 ${replies.length}';

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(countLabel),
                  CustomButton.textGestureDetector(
                    context: context,
                    onTap: () {
                      context.push('/reply_list/${widget.tourSeq}/REPLY_TOUR');
                    },
                    label: '모두 보기',
                  ),
                ],
              ),
              ReplyListView(
                replyList: replies,     // 미리보기 10개
                useListView: false,
                refreshReply: () => _provider.getReplyList(
                  targetSeq: widget.tourSeq,
                  targetType: TargetType.replyTour,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
