import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:packup/provider/reply/reply_provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';
import 'package:packup/widget/reply/reply_form.dart';

import '../../model/reply/reply_model.dart';

class ReplyWrite extends StatelessWidget {
  const ReplyWrite({
    super.key,
    this.replySeq,
    this.targetSeq,
    this.targetType,
  });

  final int? replySeq;

  // 작성 모드
  final int? targetSeq;
  final TargetType? targetType;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        if (replySeq != null) {
          return ReplyProvider.update(replySeq: replySeq!)..getReply(replySeq!);
        }
        return ReplyProvider.create(
          targetSeq : targetSeq!,
          targetType: targetType!,
        );
      },
      child: const ReplyWriteContent(),
    );
  }
}


class ReplyWriteContent extends StatefulWidget {
  const ReplyWriteContent({super.key});

  @override
  State<ReplyWriteContent> createState() => _ReplyWriteContentState();
}

class _ReplyWriteContentState extends State<ReplyWriteContent> {
  late ReplyProvider _replyProvider;

  @override
  Widget build(BuildContext context) {
    _replyProvider = context.watch<ReplyProvider>();

    final reply = _replyProvider.currentReply;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'AppLocalizations.of(context)!.editReply',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReplyForm(
          initialReply: reply,
          onSubmit: (content) async {
            await _replyProvider.upsertReply(content);
            if (mounted) Navigator.pop(context, true);
          },
        ),
      ),
    );
  }
}
