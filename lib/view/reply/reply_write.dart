import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:packup/provider/reply/reply_provider.dart';
import 'package:packup/widget/common/custom_appbar.dart';

import '../../model/reply/reply_model.dart';
import '../../widget/reply/section/reply_form_section.dart';
import '../../widget/reply/section/reply_greeting_section.dart';

class ReplyWrite extends StatelessWidget {
  const ReplyWrite({
    super.key,
    this.seq,
    this.targetSeq,
    this.targetType,
  });

  final int? seq;               // 편집 모드
  final int? targetSeq;         // 작성 모드
  final TargetType? targetType; // 작성 모드

  @override
  Widget build(BuildContext context) {
    final isEdit = seq != null;

    return ChangeNotifierProvider<ReplyProvider>(
      create: (_) {
        final p = ReplyProvider();
        if (isEdit) {
          p.setEditMode(seq: seq!);
        } else {
          p.setTarget(
            targetSeq : targetSeq!,
            targetType: targetType!,
          );
        }
        return p;
      },
      child: Scaffold(
        appBar: CustomAppbar(title: isEdit ? '리뷰 수정' : '투어 리뷰'),
        body: const ReplyWriteContent(),
      ),
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
      if (prov.replySeq != null) prov.getReply(prov.replySeq!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final replyProvider = context.watch<ReplyProvider>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            const ReplyGreetingSection(),
            ReplyFormSection(replyProvider: replyProvider),
          ],
        )
      ),
    );
  }
}
