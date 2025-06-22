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
    this.seq,
    this.targetSeq,
    this.targetType,
  });

  final int? seq;

  // 작성 모드
  final int? targetSeq;
  final TargetType? targetType;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        if (seq != null) {
          return ReplyProvider.update(seq: seq!);
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = context.read<ReplyProvider>();
      if (prov.seq != null) prov.getReply(prov.seq!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final replyProvider = context.watch<ReplyProvider>();

    final bool waiting =
        replyProvider.isLoading || (replyProvider.seq != null && replyProvider.replyModel == null);

    if (waiting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CustomAppbar(title: 'Edit Reply'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ReplyForm(
          replyProvider: replyProvider,
        ),
      ),
    );
  }
}
